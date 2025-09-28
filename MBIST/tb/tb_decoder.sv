module tb_decoder();
    // Signal declarations
    reg [2:0] q;
    wire [7:0] data_t;
    
    // Instance of the decoder
    decoder DUT (
        .q(q),
        .data_t(data_t)
    );
    
    // Test variables
    integer error_count = 0;
    
    // Main test sequence
    initial begin
        // Initialize inputs
        q = 3'b000;
        
        // Test all defined patterns
        $display("Testing all defined decoder patterns...");
        
        // Case 3'b000
        q = 3'b000;
        #1; // Allow for combinational logic to settle
        if (data_t !== 8'b10101010) begin
            $display("ERROR: q = %b, data_t = %b, expected 8'b10101010", q, data_t);
            error_count = error_count + 1;
        end
        
        // Case 3'b001
        q = 3'b001;
        #1;
        if (data_t !== 8'b01010101) begin
            $display("ERROR: q = %b, data_t = %b, expected 8'b01010101", q, data_t);
            error_count = error_count + 1;
        end
        
        // Case 3'b010
        q = 3'b010;
        #1;
        if (data_t !== 8'b11110000) begin
            $display("ERROR: q = %b, data_t = %b, expected 8'b11110000", q, data_t);
            error_count = error_count + 1;
        end
        
        // Case 3'b011
        q = 3'b011;
        #1;
        if (data_t !== 8'b00001111) begin
            $display("ERROR: q = %b, data_t = %b, expected 8'b00001111", q, data_t);
            error_count = error_count + 1;
        end
        
        // Case 3'b100
        q = 3'b100;
        #1;
        if (data_t !== 8'b00000000) begin
            $display("ERROR: q = %b, data_t = %b, expected 8'b00000000", q, data_t);
            error_count = error_count + 1;
        end
        
        // Case 3'b101
        q = 3'b101;
        #1;
        if (data_t !== 8'b11111111) begin
            $display("ERROR: q = %b, data_t = %b, expected 8'b11111111", q, data_t);
            error_count = error_count + 1;
        end
        
        // Test default case (undefined patterns)
        $display("Testing undefined patterns...");
        
        // Case 3'b110 (should return 'x)
        q = 3'b110;
        #1;
        if (data_t !== 8'bx) begin
            $display("ERROR: q = %b, data_t = %b, expected 8'bx", q, data_t);
            error_count = error_count + 1;
        end
        
        // Case 3'b111 (should return 'x)
        q = 3'b111;
        #1;
        if (data_t !== 8'bx) begin
            $display("ERROR: q = %b, data_t = %b, expected 8'bx", q, data_t);
            error_count = error_count + 1;
        end
        
        // Test for behavior during input transitions
        $display("Testing transition behavior...");
        
        // Rapidly change through all inputs
        q = 3'b000;
        #1;
        if (data_t !== 8'b10101010) begin
            $display("ERROR during transition: q = %b, data_t = %b, expected 8'b10101010", q, data_t);
            error_count = error_count + 1;
        end
        
        q = 3'b001;
        #1;
        if (data_t !== 8'b01010101) begin
            $display("ERROR during transition: q = %b, data_t = %b, expected 8'b01010101", q, data_t);
            error_count = error_count + 1;
        end
        
        q = 3'b010;
        #1;
        if (data_t !== 8'b11110000) begin
            $display("ERROR during transition: q = %b, data_t = %b, expected 8'b11110000", q, data_t);
            error_count = error_count + 1;
        end
        
        q = 3'b011;
        #1;
        if (data_t !== 8'b00001111) begin
            $display("ERROR during transition: q = %b, data_t = %b, expected 8'b00001111", q, data_t);
            error_count = error_count + 1;
        end
        
        q = 3'b100;
        #1;
        if (data_t !== 8'b00000000) begin
            $display("ERROR during transition: q = %b, data_t = %b, expected 8'b00000000", q, data_t);
            error_count = error_count + 1;
        end
        
        q = 3'b101;
        #1;
        if (data_t !== 8'b11111111) begin
            $display("ERROR during transition: q = %b, data_t = %b, expected 8'b11111111", q, data_t);
            error_count = error_count + 1;
        end
        
        q = 3'b110;
        #1;
        if (data_t !== 8'bx) begin
            $display("ERROR during transition: q = %b, data_t = %b, expected 8'bx", q, data_t);
            error_count = error_count + 1;
        end
        
        q = 3'b111;
        #1;
        if (data_t !== 8'bx) begin
            $display("ERROR during transition: q = %b, data_t = %b, expected 8'bx", q, data_t);
            error_count = error_count + 1;
        end
        
        // Test complete - check results
        if (error_count == 0)
            $display("**PASS**");
        else
            $display("**FAIL** with %0d errors", error_count);
            
        $finish;
    end
    
endmodule