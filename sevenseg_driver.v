`include "team_params_202500415_202502112.vh"

module sevenseg (
    input [3:0] code,
    output reg [6:0] seg
);
    reg [6:0] segPreMask; // before xoring with mask
    always @(*) begin
        case(code) // literal implementation of table
            4'b0000: segPreMask = 7'b1111110;
            4'b0001: segPreMask = 7'b0110000;
            4'b0010: segPreMask = 7'b1101101;
            4'b0011: segPreMask = 7'b1111001;
            4'b0100: segPreMask = 7'b0110011;
            4'b0101: segPreMask = 7'b1011011;
            4'b0110: segPreMask = 7'b1011111;
            4'b0111: segPreMask = 7'b1110000;
            4'b1000: segPreMask = 7'b1111111;
            4'b1001: segPreMask = 7'b1111011; // 9
            4'b1100: segPreMask = 7'b1001111; // E
            4'b1101: segPreMask = 7'b0000101; // r
            4'b1110: segPreMask = 7'b0000000;
        endcase
    end // if mask is of digit 4 then xor
    if(segPreMask == 7'b0110011) begin
        segPreMask = segPreMask ^ GLYPH_MASK;
    end
    seg = ~segPreMask; // common-anode so invert result
endmodule