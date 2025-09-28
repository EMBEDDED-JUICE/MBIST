module tb_counter;
    parameter length = 10;
    
    logic [length-1:0] d_in;
    logic              clk;
    logic              ld;
    logic              u_d;
    logic              cen;
    logic [length-1:0] q;
    logic              cout;
    
    logic error_detected;
    int   test_count;
    int   error_count;
    
    counter #(
        .length(length)
    ) DUT (
        .d_in(d_in),
        .clk(clk),
        .ld(ld),
        .u_d(u_d),
        .cen(cen),
        .q(q),
        .cout(cout)
    );
    
    always #5 clk = ~clk;
    
    task check_counter_value(input [length-1:0] expected_value, input expected_cout);
        test_count++;
        error_detected = 0;
        
        if (q !== expected_value) begin
            $display("ERROR: Expected q=%0d, but got q=%0d", expected_value, q);
            error_detected = 1;
        end
        
        if (cout !== expected_cout) begin
            $display("ERROR: Expected cout=%0b, but got cout=%0b", expected_cout, cout);
            error_detected = 1;
        end
        
        if (error_detected) begin
            error_count++;
        end
    endtask
    
    initial begin
        clk = 0;
        d_in = 0;
        ld = 0;
        u_d = 0;
        cen = 0;
        error_count = 0;
        test_count = 0;
        
        $display("Starting counter testbench...");
        
        @(posedge clk);
        d_in = 0;
        ld = 1;
        cen = 1;
        @(posedge clk);
        #1;
        check_counter_value(0, 0);
        
        ld = 0;
        u_d = 1;
        @(posedge clk);
        #1;
        check_counter_value(1, 0);
        
        @(posedge clk);
        #1;
        check_counter_value(2, 0);
        
        d_in = 10'h005;
        ld = 1;
        @(posedge clk);
        #1;
        check_counter_value(5, 0);
        
        ld = 0;
        u_d = 0;
        @(posedge clk);
        #1;
        check_counter_value(4, 0);
        
        @(posedge clk);
        #1;
        check_counter_value(3, 0);
        
        d_in = {length{1'b1}};
        ld = 1;
        @(posedge clk);
        #1;
        check_counter_value({length{1'b1}}, 0);
        
        ld = 0;
        u_d = 1;
        @(posedge clk);
        #1;
        check_counter_value(0, 1);
        
        d_in = 0;
        ld = 1;
        @(posedge clk);
        #1;
        check_counter_value(0, 0);
        
        ld = 0;
        u_d = 0;
        @(posedge clk);
        #1;
        check_counter_value({length{1'b1}}, 1);
        
        $display("Testbench completed: %0d tests, %0d errors", test_count, error_count);
        
        if (error_count == 0) begin
            $display("**PASS**");
        end else begin
            $display("**FAIL**");
        end
        
        $finish;
    end
    
endmodule