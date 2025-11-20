`timescale 1ns/1ps
`include "team_params_202500415_202502112.vh"

module tb_display_mux;

    reg [15:0] entered_code;
    reg [2:0] display_mode;
    wire [15:0] display_code;

    // Instantiate the display_mux
    display_mux uut (
        .entered_code(entered_code),
        .display_mode(display_mode),
        .display_code(display_code)
    );

    initial begin
        $display("Time\tMode\tEntered\t\t\tDisplay");
        $monitor("%0t\t%b\t%b\t%b", $time, display_mode, entered_code, display_code);

        // 1. Reset / default behavior
        display_mode = 3'b000; // undefined/default mode
        entered_code = 16'h1234;
        #10;

        // 2. Normal operation: display entered code
        display_mode = 3'b010;
        entered_code = 16'h9070; // example passcode
        #10;

        // 3. Edge case: showing error message
        display_mode = 3'b001;
        entered_code = 16'b0000000000000000; // irrelevant, should show Err
        #10;

        // 4. Edge case: blank display
        display_mode = 3'b100;
        entered_code = 16'b1111111111111111; // irrelevant, should show blank
        #10;

        // 5. Unexpected mode (invalid input)
        display_mode = 3'b111;
        entered_code = 16'hAAAA; // i don't care here, 111 is invalid
        #10;

        $finish;
    end
endmodule
