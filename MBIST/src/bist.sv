module bist #(
	parameter size = 6,
	parameter length = 8
) (
	input logic start,
	input logic rst,
	input logic clk,
	input logic csin,
	input logic rwbarin,
	input logic opr,
	input logic [size-1:0] address,
	input logic [length-1:0] datain,
	output logic [length-1:0] dataout,
	output logic fail
);

logic [9:0] q;
logic NbarT;
logic rwbar;
assign rwbar = (NbarT) ? q[6]: rwbarin;
logic cs;
assign cs = (NbarT) ? 1'b1 : csin;

logic [5:0] mux_a_6bit;

multiplexer #(.WIDTH(6)) MUX_A (
	.normal_in(address),
	.bist_in(q[5:0]),
	.NbarT(NbarT),
	.out(mux_a_6bit)
);

logic [7:0] data_t;

decoder dcdr_inst1 (
	.q(q[9:7]),
	.data_t(data_t)
);

logic ld;
logic counter_cout;

counter #(.length(10)) cntr_inst1 (
	.d_in(10'b0),
	.clk(clk),
	.ld(ld),
	.u_d(1'b1),
	.cen(NbarT),
	.q(q),
	.cout(counter_cout)
);

logic [7:0] mux_d_8bit;
multiplexer #(.WIDTH(8)) MUX_D (
	.normal_in(datain),
	.bist_in(data_t),
	.NbarT(NbarT),
	.out(mux_d_8bit)
);

controller cont_inst1l(
	.start(start),
	.rst(rst),
	.clk(clk),
	.cout(counter_cout),
	.NbarT(NbarT),
	.ld(ld)
);

sram sram_inst1(
	.ramin(mux_d_8bit),
	.ramaddr(mux_a_6bit),
	.rwbar(rwbar),
	.cs(cs),
	.clk(clk),
	.ramout(dataout)
);

logic gt,eq, lt;

comparator comp_init1 (
	.data_t(data_t),
	.ramout(dataout),
	.gt(gt),
	.eq(eq),
	.lt(lt)
	);

	always_comb begin
		if(NbarT && opr) begin
			if((rwbarin && ~eq) || (q[6] && ~eq)) fail = 1;
			else fail = 0;
		end
	else fail = 0;
end

endmodule
