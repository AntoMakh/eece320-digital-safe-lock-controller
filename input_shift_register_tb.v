`timescale 1ns/1ps

module tb_input_shift_register;

    reg clk;
    reg rst_n;
    reg clear_entry;
    reg [3:0] code;
    reg valid;
    wire [15:0] entered_code;
    wire done;

    // Instantiate the module
    input_shift_register uut (
        .clk(clk),
        .rst_n(rst_n),
        .clear_entry(clear_entry),
        .code(code),
        .valid(valid),
        .entered_code(entered_code),
        .done(done)
    );

    initial begin
        clk = 0;
    end
    always #5 clk = ~clk; 

    // Test sequence
    initial begin
        // Initialize inputs
        rst_n = 0;
        clear_entry = 0;
        code = 4'd0;
        valid = 0;

        // reset behavior test
        #10;
        rst_n = 1;
        #10;

        // normal operations
        // Enter 4 valid digits: 3,7,2,9
        code = 4'd3; valid = 1; #10; valid = 0; #10;
        code = 4'd7; valid = 1; #10; valid = 0; #10;
        code = 4'd2; valid = 1; #10; valid = 0; #10;
        code = 4'd9; valid = 1; #10; valid = 0; #10;

        // wait t oobserve signal
        #20;

        // clear entry
        clear_entry = 1; #10;
        clear_entry = 0; #10;

        // enter another sequence: 1,0,4,5
        code = 4'd1; valid = 1; #10; valid = 0; #10;
        code = 4'd0; valid = 1; #10; valid = 0; #10;
        code = 4'd4; valid = 1; #10; valid = 0; #10;
        code = 4'd5; valid = 1; #10; valid = 0; #10;
        
        #20;

        // testing more (edge cases)
        // Try entering more than 4 digits
        code = 4'd6; valid = 1; #10; valid = 0; #10;
        code = 4'd7; valid = 1; #10; valid = 0; #10;
        code = 4'd8; valid = 1; #10; valid = 0; #10;
        code = 4'd9; valid = 1; #10; valid = 0; #10;
        code = 4'd0; valid = 1; #10; valid = 0; #10;  // extra digit ignored

        #20;

        // incorrect input
        // Send valid = 0 with some code (should be ignored)
        code = 4'd3; valid = 0; #10;
        code = 4'd7; valid = 0; #10;

        // Finish simulation
        #20;
        $finish;
    end

    // Optional: monitor outputs
    initial begin
        $monitor("Time=%0t | rst_n=%b clear=%b valid=%b code=%d | entered_code=%h done=%b",
                 $time, rst_n, clear_entry, valid, code, entered_code, done);
    end

endmodule