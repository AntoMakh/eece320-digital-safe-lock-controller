`include "team_params_202500415_202502112.vh"

module stored_code_register (
    input clk,
    input rst_n,
    input load,
    input [15:0] datain,
    output [15:0] dataout
);

    reg [15:0] stored_value;

    // Helper: returns the nibble selected by STORED_MASK.
    function [3:0] select_nibble;
        input [15:0] value;
        input [3:0] index;
        begin
            case (index[1:0])
                2'd0: select_nibble = value[3:0];
                2'd1: select_nibble = value[7:4];
                2'd2: select_nibble = value[11:8];
                2'd3: select_nibble = value[15:12];
                default: select_nibble = 4'h0;
            endcase
        end
    endfunction

    // Scramble passcode according to STORED_MASK (nibble permutation).
    function [15:0] scramble_code;
        input [15:0] passcode;
        begin
            scramble_code = {
                select_nibble(passcode, 4'h2),
                select_nibble(passcode, 4'h1),
                select_nibble(passcode, 4'h0),
                select_nibble(passcode, 4'h3)
            };
        end
    endfunction

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            stored_value <= 16'b0;
        end
        else if (load) begin
            stored_value <= scramble_code(datain);
        end
    end

    assign dataout = stored_value;

endmodule