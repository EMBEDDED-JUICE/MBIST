module tb_comparator();
    logic [7:0] data_t;
    logic [7:0] ramout;
    logic       gt;
    logic       eq;
    logic       lt;
    
    logic test_failed = 0;
    
    comparator dut (
        .data_t(data_t),
        .ramout(ramout),
        .gt(gt),
        .eq(eq),
        .lt(lt)
    );
    
    initial begin
        $display("Starting comparator testbench");
        
        // Test case 1: data_t equal to ramout
        data_t = 8'h55;
        ramout = 8'h55;
        #10;
        if (eq !== 1'b1 || gt !== 1'b0 || lt !== 1'b0) begin
            $display("Error: Equal values test failed. Expected eq=1, gt=0, lt=0, Got eq=%b, gt=%b, lt=%b", eq, gt, lt);
            test_failed = 1;
        end
        
        // Test case 2: data_t greater than ramout
        data_t = 8'hAA;
        ramout = 8'h55;
        #10;
        if (eq !== 1'b0 || gt !== 1'b1 || lt !== 1'b0) begin
            $display("Error: Greater than test failed. Expected eq=0, gt=1, lt=0, Got eq=%b, gt=%b, lt=%b", eq, gt, lt);
            test_failed = 1;
        end
        
        // Test case 3: data_t less than ramout
        data_t = 8'h55;
        ramout = 8'hAA;
        #10;
        if (eq !== 1'b0 || gt !== 1'b0 || lt !== 1'b1) begin
            $display("Error: Less than test failed. Expected eq=0, gt=0, lt=1, Got eq=%b, gt=%b, lt=%b", eq, gt, lt);
            test_failed = 1;
        end
        
        // Test case 4: Both values zero
        data_t = 8'h00;
        ramout = 8'h00;
        #10;
        if (eq !== 1'b1 || gt !== 1'b0 || lt !== 1'b0) begin
            $display("Error: Both zero test failed. Expected eq=1, gt=0, lt=0, Got eq=%b, gt=%b, lt=%b", eq, gt, lt);
            test_failed = 1;
        end
        
        // Test case 5: Both values max (0xFF)
        data_t = 8'hFF;
        ramout = 8'hFF;
        #10;
        if (eq !== 1'b1 || gt !== 1'b0 || lt !== 1'b0) begin
            $display("Error: Both max test failed. Expected eq=1, gt=0, lt=0, Got eq=%b, gt=%b, lt=%b", eq, gt, lt);
            test_failed = 1;
        end
        
        // Test case 6: data_t max, ramout min
        data_t = 8'hFF;
        ramout = 8'h00;
        #10;
        if (eq !== 1'b0 || gt !== 1'b1 || lt !== 1'b0) begin
            $display("Error: Max-min test failed. Expected eq=0, gt=1, lt=0, Got eq=%b, gt=%b, lt=%b", eq, gt, lt);
            test_failed = 1;
        end
        
        // Test case 7: data_t min, ramout max
        data_t = 8'h00;
        ramout = 8'hFF;
        #10;
        if (eq !== 1'b0 || gt !== 1'b0 || lt !== 1'b1) begin
            $display("Error: Min-max test failed. Expected eq=0, gt=0, lt=1, Got eq=%b, gt=%b, lt=%b", eq, gt, lt);
            test_failed = 1;
        end
        
        // Test case 8: One bit difference
        data_t = 8'h01;
        ramout = 8'h00;
        #10;
        if (eq !== 1'b0 || gt !== 1'b1 || lt !== 1'b0) begin
            $display("Error: One bit difference test failed. Expected eq=0, gt=1, lt=0, Got eq=%b, gt=%b, lt=%b", eq, gt, lt);
            test_failed = 1;
        end
        
        // Final result
        if (test_failed)
            $display("**FAIL**");
        else
            $display("**PASS**");
            
        $finish;
    end
endmodule