module sram (
    input logic [5:0] ramaddr,
    input logic [7:0] ramin,
    input logic rwbar,
    input logic clk,
    input logic cs,
    output logic [7:0] ramout
);

logic [7:0] ram [63:0]; //64x8bit memory block

logic [5:0] addr_reg; //temp address register

always_ff @(posedge clk) begin

    if (cs) begin
        addr_reg <= ramaddr;
        if (!rwbar) begin
            ram[ramaddr] <= ramin;
        end
    end

end

assign ramout = (cs && rwbar) ? ram[addr_reg] : 0;

endmodule