`include "team_params_202500415_202502112.vh"

module sevenseg_tb;
    reg [3:0] code_TB;
    wire [6:0] seg_TB;

    integer passed = 0;
    integer failed = 0;
    reg [6:0] expected_seg;

    // instantiate DUT
    sevenseg dut (
        .code(code_TB),
        .seg(seg_TB)
    );

    initial begin
        $display("Starting Seven Segment Display Testbench...");

        $display("--- Testing all supported glyphs ---");

        for (integer i = 0; i < 16; i = i + 1) begin
            code_TB = i[3:0];
            #10;
            case (i)
                4'b0000: expected_seg = ~7'b1111110; // 0
                4'b0001: expected_seg = ~7'b0110000; // 1
                4'b0010: expected_seg = ~7'b1101101; // 2
                4'b0011: expected_seg = ~7'b1111001; // 3
                4'b0100: expected_seg = ~7'b0110011; // 4
                4'b0101: expected_seg = ~7'b1011011; // 5
                4'b0110: expected_seg = ~7'b1011111; // 6
                4'b0111: expected_seg = ~7'b1110000; // 7
                4'b1000: expected_seg = ~7'b1111111; // 8
                4'b1001: expected_seg = ~7'b1111011; // 9
                4'b1100: expected_seg = ~7'b1001111; // E
                4'b1101: expected_seg = ~7'b0000101; // r
                default: expected_seg = ~7'b0000000; // blank
            endcase

            // if glyph corresponds to 4, apply mask
            if (i == 4) begin
                expected_seg = ~(7'b0110011 ^ `GLYPH_MASK);
            end
            #10;
            if (seg_TB === expected_seg) begin
                passed = passed + 1;
                $display("PASS: Code %b -> Segments %b", code_TB, seg_TB);
            end else begin
                failed = failed + 1;
                $display("FAIL: Code %b --- Expected: %b --- Actual: %b", code_TB, expected_seg, seg_TB);
            end
        end

        $display("\n======= SUMMARY =======");
        $display("Tests completed. Results:");
        $display("Passed tests: %0d | Failed tests: %0d", passed, failed);

        $finish;
    end
endmodule
