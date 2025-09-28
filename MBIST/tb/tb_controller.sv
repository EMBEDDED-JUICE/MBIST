module tb_controller();
    // Signal declarations
    logic start, rst, clk, cout;
    logic NbarT, ld;
    
    // Instance of the controller
    controller DUT (
        .start(start),
        .rst(rst),
        .clk(clk),
        .cout(cout),
        .NbarT(NbarT),
        .ld(ld)
    );
    
    // Clock generation
    always #5 clk = ~clk;
    
    // Test variables
    int error_count = 0;
    
    // Verification tasks
    task check_outputs(input logic exp_NbarT, input logic exp_ld);
        if (NbarT !== exp_NbarT) begin
            $display("ERROR: NbarT = %b, expected %b at time %0t", NbarT, exp_NbarT, $time);
            error_count++;
        end
        
        if (ld !== exp_ld) begin
            $display("ERROR: ld = %b, expected %b at time %0t", ld, exp_ld, $time);
            error_count++;
        end
    endtask
    
    task reset_controller();
        rst = 1;
        @(posedge clk);
        #1 check_outputs(0, 1); // In RESET state, NbarT=0, ld=1
        rst = 0;
    endtask
    
    // Main test sequence
    initial begin
        // Initialize signals
        clk = 0;
        rst = 0;
        start = 0;
        cout = 0;
        
        // Apply reset
        reset_controller();
        
        // Test case 1: Verify reset state outputs
        $display("Test case 1: Initial state after reset");
        #1 check_outputs(0, 1); // In RESET state, NbarT=0, ld=1
        
        // Test case 2: RESET → TEST transition (start=1)
        $display("Test case 2: RESET to TEST transition");
        start = 1;
        @(posedge clk);
        #1 check_outputs(1, 0); // In TEST state, NbarT=1, ld=0
        
        // Test case 3: Remain in TEST when start=0
        $display("Test case 3: Remain in TEST when start=0");
        start = 0;
        @(posedge clk);
        #1 check_outputs(1, 0); // Still in TEST state
        
        // Test case 4: TEST → RESET transition (cout=1)
        $display("Test case 4: TEST to RESET transition");
        cout = 1;
        @(posedge clk);
        #1 check_outputs(0, 1); // Back to RESET state
        
        // Test case 5: Remain in RESET when cout=1, start=0
        $display("Test case 5: Remain in RESET when cout=1, start=0");
        cout = 1;
        start = 0;
        @(posedge clk);
        #1 check_outputs(0, 1); // Still in RESET state
        
        // Test case 6: Priority of reset over state transitions
        $display("Test case 6: Priority of reset over state transitions");
        start = 1; // Would normally cause a transition to TEST
        cout = 0;
        @(posedge clk);
        #1 check_outputs(1, 0); // In TEST state
        
        rst = 1; // Assert reset
        @(posedge clk);
        #1 check_outputs(0, 1); // Should return to RESET state
        
        // Test case 7: Multiple transitions
        $display("Test case 7: Multiple transitions");
        rst = 0;
        start = 1;
        @(posedge clk); // RESET → TEST
        #1 check_outputs(1, 0);
        
        start = 0;
        cout = 1;
        @(posedge clk); // TEST → RESET
        #1 check_outputs(0, 1);
        
        cout = 0;
        start = 1;
        @(posedge clk); // RESET → TEST
        #1 check_outputs(1, 0);
        
        // Test complete - check results
        if (error_count == 0)
            $display("**PASS**");
        else
            $display("**FAIL** with %0d errors", error_count);
            
        $finish;
    end
    
endmodule