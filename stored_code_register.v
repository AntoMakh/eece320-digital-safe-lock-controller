`include "team_params_202500415_202502112.vh"

module stored_code_register (
    input clk, // reserved for Part 3 (ignored in Part 2)
    input rst_n, // reserved for Part 3 (ignored in Part 2)
    input load, // reserved for Part 3 (ignored in Part 2)
    input [15:0] datain, // reserved for Part 3 (ignored in Part 2)
    output [15:0] dataout // scrambled passcode
);

    assign dataout = 16'h0790; // hardcoded scrambled passcode

endmodule