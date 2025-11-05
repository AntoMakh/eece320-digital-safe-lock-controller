`include "team_params_202500415_202502112.vh"

module sevenseg (
    input [3:0] code,
    output reg [6:0] seg
);
    reg [6:0] segPreMask; // before xoring with mask
    always @(*) begin
        case(code) // literal implementation of table
            4'b0000: segPreMask = 7'b1111110; // 0
            4'b0001: segPreMask = 7'b0110000; // 1
            4'b0010: segPreMask = 7'b1101101; // 2
            4'b0011: segPreMask = 7'b1111001; // 3
            4'b0100: segPreMask = 7'b0110011; // 4
            4'b0101: segPreMask = 7'b1011011; // 5
            4'b0110: segPreMask = 7'b1011111; // 6
            4'b0111: segPreMask = 7'b1110000; // 7
            4'b1000: segPreMask = 7'b1111111; // 8
            4'b1001: segPreMask = 7'b1111011; // 9
            // nothing for *
            // nothing for #
            4'b1100: segPreMask = 7'b1001111; // E
            4'b1101: segPreMask = 7'b0000101; // r
            default: segPreMask = 7'b0000000; // implicitly 1110 (same thing as having 1110, but handles invalid cases too if they arise)
        endcase
        // this only happens when the activated segment corresponds to the glyph target (4)
        if(segPreMask == 7'b0110011) begin
            segPreMask = segPreMask ^ `GLYPH_MASK;
        end
        // polarity is set to 1 -> need to invert result
        seg = ~segPreMask;
    end
endmodule