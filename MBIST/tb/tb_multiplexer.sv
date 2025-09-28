module tb_multiplexer;
    parameter WIDTH = 8;
    
    logic [WIDTH-1:0] normal_in;
    logic [WIDTH-1:0] bist_in;
    logic             NbarT;
    logic [WIDTH-1:0] out;
    
    logic error_detected;
    int   test_count;
    int   error_count;
    
    multiplexer #(
        .WIDTH(WIDTH)
    ) DUT (
        .normal_in(normal_in),
        .bist_in(bist_in),
        .NbarT(NbarT),
        .out(out)
    );
    
    task check_mux_output(input [WIDTH-1:0] expected_value);
        test_count++;
        error_detected = 0;
        
        if (out !== expected_value) begin
            $display("ERROR: Expected out=%h, but got out=%h", expected_value, out);
            error_detected = 1;
        end
        
        if (error_detected) begin
            error_count++;
        end
    endtask
    
    initial begin
        normal_in = 0;
        bist_in = 0;
        NbarT = 0;
        error_count = 0;
        test_count = 0;
        
        $display("Starting multiplexer testbench...");
        
        normal_in = 8'hAA;
        bist_in = 8'h55;
        NbarT = 0;
        #1;
        check_mux_output(8'hAA);
        
        normal_in = 8'hAA;
        bist_in = 8'h55;
        NbarT = 1;
        #1;
        check_mux_output(8'h55);
        
        normal_in = 8'hFF;
        bist_in = 8'h00;
        NbarT = 0;
        #1;
        check_mux_output(8'hFF);
        
        normal_in = 8'hFF;
        bist_in = 8'h00;
        NbarT = 1;
        #1;
        check_mux_output(8'h00);
        
        normal_in = 8'h33;
        bist_in = 8'h33;
        NbarT = 0;
        #1;
        check_mux_output(8'h33);
        
        normal_in = 8'h33;
        bist_in = 8'h33;
        NbarT = 1;
        #1;
        check_mux_output(8'h33);
        
        normal_in = 8'b10101010;
        bist_in = 8'b01010101;
        NbarT = 0;
        #1;
        check_mux_output(8'b10101010);
        
        NbarT = 1;
        #1;
        check_mux_output(8'b01010101);
        
        $display("Testbench completed: %0d tests, %0d errors", test_count, error_count);
        
        if (error_count == 0) begin
            $display("**PASS**");
        end else begin
            $display("**FAIL**");
        end
        
        $finish;
    end
    
endmodule