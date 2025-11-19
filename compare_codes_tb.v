`timescale 1ns/1ps

module tb_compare_codes;

    reg [15:0] input_code;
    reg [15:0] stored_code;
    wire match;

    // Instantiate the compare_codes module
    compare_codes uut (
        .input_code(input_code),
        .stored_code(stored_code),
        .match(match)
    );

    initial begin
        // Scrambled stored code according to STORED_MASK = 16'h2130
        // Logical PASSCODE = 16'h9070 -> D3=9,D2=0,D1=7,D0=0
        // Scrambled stored code = {D2,D1,D3,D0} = {0,7,9,0} = 16'h0790
        stored_code = 16'h0790; // no other choice in part 2

        // Test 1: Correct input code
        input_code = 16'h9070; // logical passcode
        #10;
        $display("Time=%0t | input=%h stored=%h match=%b", $time, input_code, stored_code, match);

        // Test 2: Incorrect input code
        input_code = 16'h1234;
        #10;
        $display("Time=%0t | input=%h stored=%h match=%b", $time, input_code, stored_code, match);

        // Test 3: Another correct input code
        input_code = 16'h9070;
        #10;
        $display("Time=%0t | input=%h stored=%h match=%b", $time, input_code, stored_code, match);

        // Test 4: Slightly wrong input
        input_code = 16'h9071; // last digit off
        #10;
        $display("Time=%0t | input=%h stored=%h match=%b", $time, input_code, stored_code, match);

        $finish;
    end

endmodule
