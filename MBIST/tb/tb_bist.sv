module tb_bist;
logic start, rst, clk, csin, rwbarin, opr;
logic [5:0] address;
logic [7:0] datain;
logic [7:0] dataout;
logic fail;

bist uut (
	.start(start),
	.rst(rst),
	.clk(clk),
	.csin(csin),
	.rwbarin(rwbarin),
	.opr(opr),
	.address(address),
	.datain(datain),
	.dataout(dataout),
	.fail(fail)
);

initial clk = 0;

always #5 clk = ~clk;

int f = 0;
logic [7:0] tmep;

task reset_bist();
	@(posedge clk);
	rst = 1;
	start = 0;
	opr = 0;
	csin = 0;
	rwbarin = 1; 
	address = 6'b0;
	datain = 8'h00;	
	@(posedge clk);
	rst = 0;
endtask

task normal_mode_write_read();
	@(posedge clk);
	csin = 1;
	opr = 0;
	rwbarin = 0;
	address =6'd10;
	datain = 8'hA5;
	@(posedge clk);
	rwbarin = 1;
	@(posedge clk);
	assert(dataout == 8'hA5) else begin
		f = 1;
		$display("FAIL: Normal mode read wrong! dataout=%h", dataout);
	end
endtask

task bist_test_run();
	@(posedge clk);
	start = 1;
	opr = 1;
	@(posedge clk);
	start = 0;
	repeat(100) @(posedge clk);
	if (fail) begin
		f = 1;
		 $display("FAIL: BIST failed with fail=%0b!", fail);
	 end
	 else begin
		 $display("PASS:BIST completed wihtout failure!");
	 end
 endtask

 task fail_injection_test();
	 @(posedge clk);
	 csin = 1;
	 opr = 0;
	 rwbarin = 0;
	 address = 6'd0;
	 datain = 8'hFF;
	 @(posedge clk);
	 rwbarin = 1;

	 @(posedge clk);
	 start = 1;
	 opr = 1;
	 @(posedge clk);
	 start = 0;
	 repeat(100) @(posedge clk);

	 if (fail) begin
		 $display("PASS: FAIL injection detected correctly by BIST.");
	 end
	 else begin
		 f = 1;
		 $display("FAIL: Fail injection was not detected");
	 end
 endtask

 initial begin
	 rst = 1;
	 start = 0;
	 opr = 0;
	 csin = 0;
	 rwbarin = 1;
	 datain = 0;
	 address = 0;
	 @(posedge clk);
	 rst = 0;

	 reset_bist();
	 normal_mode_write_read();
	 bist_test_run();
	 fail_injection_test();

	 if(~f)
		 $display("PASS: ALL Bist tests passed successfully");
	 else
		 $display("FAIL: there were test failures");
	 $finish;
 end

 initial begin
	 $dumpfile("bist_tb.vcd");
	 $dumpvars(0, tb_bist);
 end
 endmodule
