`include "team_params_202500415_202502112.vh"

module display_mux (
    input [15:0] entered_code, // user-entered digits
    input [2:0] display_mode, // selects between "code", "error", or "blank"
    output reg [15:0] display_code // 4-digit value presented to the display driver
);
        
    always @(*) begin
        case(display_mode)
            3'b010: display_code = entered_code; // display entered code
            3'b001: display_code = 16'b1110110011011101; // display "Err" (blank E r r)
            3'b100: display_code = 16'b1110111011101110; // blank display
            default: display_code = 16'b1110111011101110; // default to blank
        endcase
    end

endmodule