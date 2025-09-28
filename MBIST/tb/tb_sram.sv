module tb_sram;
    // Parameters
    parameter CLK_PERIOD = 10; // Clock period in ns
    
    // Test signals
    logic [5:0]  ramaddr;  // Address for memory access
    logic [7:0]  ramin;    // Data to be written into memory
    logic        rwbar;    // Read/Write control (0 = write, 1 = read)
    logic        clk;      // Clock signal
    logic        cs;       // Chip select
    logic [7:0]  ramout;   // Data read from memory
    
    // Test status variables
    integer test_count = 0;
    integer pass_count = 0;
    logic test_result = 1'b1; // Overall test result (1 = pass, 0 = fail)
    
    // Instantiate the SRAM module
    sram DUT (
        .ramaddr(ramaddr),
        .ramin(ramin),
        .rwbar(rwbar),
        .clk(clk),
        .cs(cs),
        .ramout(ramout)
    );
    
    // Clock generation
    initial begin
        clk = 0;
        forever #(CLK_PERIOD/2) clk = ~clk;
    end
    
    // Test task for writing to memory
    task write_mem(input logic [5:0] addr, input logic [7:0] data);
        @(negedge clk);
        cs = 1;
        rwbar = 0;
        ramaddr = addr;
        ramin = data;
        @(posedge clk);
        #1; // Small delay to stabilize signals
    endtask
    
    // Test task for reading from memory
    task read_mem(input logic [5:0] addr, output logic [7:0] data);
        @(negedge clk);
        cs = 1;
        rwbar = 1;
        ramaddr = addr;
        @(posedge clk);
        #1; // Small delay to stabilize signals
        data = ramout;
    endtask
    
    // Test checker task
    task check_test(input string test_name, input logic condition);
        test_count++;
        if (condition) begin
            pass_count++;
            $display("Test %0d (%s): PASS", test_count, test_name);
        end
        else begin
            test_result = 1'b0; // Fail the overall test
            $display("Test %0d (%s): FAIL", test_count, test_name);
        end
    endtask
    
    // Test sequence
    initial begin
        // Initialize signals
        cs = 0;
        rwbar = 1;
        ramaddr = 0;
        ramin = 0;
        
        // Wait a few clock cycles before starting
        repeat(3) @(posedge clk);
        
        $display("\n=== SRAM Test Suite Started ===\n");
        
        // Test 1: Basic write and read to a single address
        begin
            logic [7:0] read_data;
            write_mem(6'h0A, 8'h55);
            read_mem(6'h0A, read_data);
            check_test("Basic write/read", read_data === 8'h55);
        end
        
        // Test 2: Write and read to multiple addresses
        begin
            logic [7:0] read_data;
            logic all_pass = 1'b1;
            
            for (int i = 0; i < 16; i++) begin
                write_mem(i, i * 2);
            end
            
            for (int i = 0; i < 16; i++) begin
                read_mem(i, read_data);
                if (read_data !== i * 2) begin
                    all_pass = 1'b0;
                    $display("  Subtest failed at address 0x%h: Expected 0x%h, Got 0x%h", i, i * 2, read_data);
                end
            end
            
            check_test("Multiple address write/read", all_pass);
        end
        
        // Test 3: Read with chip select disabled
        begin
            logic [7:0] read_data;
            
            // First write a known value with chip select enabled
            write_mem(6'h0F, 8'hAA);
            
            // Read with chip select disabled
            @(negedge clk);
            cs = 0;
            rwbar = 1;
            ramaddr = 6'h0F;
            @(posedge clk);
            #1;
            read_data = ramout;
            
            check_test("Read with chip select disabled", read_data === 8'h00);
        end
        
        // Test 4: Boundary addresses (lowest and highest)
        begin
            logic [7:0] read_data_low, read_data_high;
            logic boundary_pass = 1'b1;
            
            // Test lowest address
            write_mem(6'h00, 8'h01);
            read_mem(6'h00, read_data_low);
            if (read_data_low !== 8'h01) begin
                boundary_pass = 1'b0;
                $display("  Lowest address test failed: Expected 0x01, Got 0x%h", read_data_low);
            end
            
            // Test highest address
            write_mem(6'h3F, 8'hFF);
            read_mem(6'h3F, read_data_high);
            if (read_data_high !== 8'hFF) begin
                boundary_pass = 1'b0;
                $display("  Highest address test failed: Expected 0xFF, Got 0x%h", read_data_high);
            end
            
            check_test("Boundary addresses", boundary_pass);
        end
        
        // Test 5: Data retention
        begin
            logic [7:0] read_data;
            
            // Write value to address
            write_mem(6'h15, 8'h42);
            
            // Perform some other operations
            write_mem(6'h16, 8'h43);
            write_mem(6'h17, 8'h44);
            
            // Read back the original address
            read_mem(6'h15, read_data);
            check_test("Data retention", read_data === 8'h42);
        end
        
        // Test 6: Overwrite operation
        begin
            logic [7:0] read_data;
            
            // Write initial value
            write_mem(6'h20, 8'h10);
            
            // Overwrite with new value
            write_mem(6'h20, 8'h20);
            
            // Read back
            read_mem(6'h20, read_data);
            check_test("Overwrite operation", read_data === 8'h20);
        end
        
        // Test 7: Sequential read after write
        begin
            logic [7:0] read_data;
            
            // Write then immediately read
            write_mem(6'h25, 8'h25);
            // Change to read mode in next cycle
            rwbar = 1;
            @(posedge clk);
            #1;
            read_data = ramout;
            
            check_test("Sequential read after write", read_data === 8'h25);
        end
        
        // Test 8: Read-modify-write
        begin
            logic [7:0] read_data1, read_data2;
            
            // Write initial data
            write_mem(6'h30, 8'h30);
            
            // Read the data
            read_mem(6'h30, read_data1);
            
            // Modify and write back
            write_mem(6'h30, read_data1 + 8'h05);
            
            // Read again
            read_mem(6'h30, read_data2);
            
            check_test("Read-modify-write", read_data2 === (8'h30 + 8'h05));
        end
        
        // Final test result
        $display("\n=== SRAM Test Suite Completed ===");
        $display("Passed %0d out of %0d tests", pass_count, test_count);
        
        if (test_result)
            $display("\n*** OVERALL RESULT: PASS ***\n");
        else
            $display("\n*** OVERALL RESULT: FAIL ***\n");
        
        // End simulation
        #(CLK_PERIOD*5);
        $finish;
    end

endmodule