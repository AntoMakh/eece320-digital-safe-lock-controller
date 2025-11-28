`timescale 1ns/1ps
`include "team_params_202500415_202502112.vh"

module safe_top_tb;

    reg clk = 1'b0;
    reg rst_n = 1'b0;
    reg [11:0] key = 12'b0;

    wire [6:0] seg0;
    wire [6:0] seg1;
    wire [6:0] seg2;
    wire [6:0] seg3;
    wire lock;

    safe_top uut (
        .clk(clk),
        .rst_n(rst_n),
        .key(key),
        .seg0(seg0),
        .seg1(seg1),
        .seg2(seg2),
        .seg3(seg3),
        .lock(lock)
    );

    // 100 MHz clock (10 ns period)
    always #5 clk = ~clk;

    task automatic wait_cycles(input integer cycles);
        integer i;
        begin
            for (i = 0; i < cycles; i = i + 1) begin
                @(posedge clk);
            end
        end
    endtask

    task automatic press_digit(input integer digit);
        begin
            key = 12'b0;
            if (digit >= 0 && digit < 12) begin
                key[digit] = 1'b1;
            end
            @(posedge clk);
            @(posedge clk);
            key = 12'b0;
            @(posedge clk);
        end
    endtask

    task automatic enter_code(
        input [3:0] d3,
        input [3:0] d2,
        input [3:0] d1,
        input [3:0] d0
    );
        begin
            press_digit(d3);
            press_digit(d2);
            press_digit(d1);
            press_digit(d0);
        end
    endtask

    initial begin
        $display("[%0t] Starting safe_top_tb", $time);
        wait_cycles(2);
        rst_n = 1'b1;
        $display("[%0t] Released reset; safe should be unlocked with no passcode", $time);

        // Scenario 1: Initial locking after reset.
        $display("[%0t] Locking safe with initial code 1-2-3-4", $time);
        enter_code(4'd1, 4'd2, 4'd3, 4'd4);
        wait_cycles(4);
        $display("[%0t] Lock output after initial programming = %0b", $time, lock);

        // Scenario 2: Incorrect passcode attempt while locked.
        $display("[%0t] Attempting incorrect code 9-9-9-9 (should stay locked, show Err)", $time);
        enter_code(4'd9, 4'd9, 4'd9, 4'd9);
        wait_cycles(2);
        $display("[%0t] Error timer running; lock = %0b", $time, lock);
        wait_cycles(15);
        $display("[%0t] Error message done; lock still = %0b", $time, lock);

        // Scenario 3: Correct unlock attempt (includes edge case where keys are pressed during timer).
        $display("[%0t] Entering correct code 1-2-3-4 to unlock", $time);
        enter_code(4'd1, 4'd2, 4'd3, 4'd4);
        wait_cycles(2);
        $display("[%0t] Success timer active; pressing extra digits should be ignored", $time);
        press_digit(4'd5); // edge case: ignore digits during timer display
        wait_cycles(15);
        $display("[%0t] Timer expired; lock should be 0 (unlocked) -> %0b", $time, lock);

        // Scenario 4: Lock again with a new passcode.
        $display("[%0t] Locking again with new code 4-3-2-1", $time);
        enter_code(4'd4, 4'd3, 4'd2, 4'd1);
        wait_cycles(4);
        $display("[%0t] Safe re-locked; lock = %0b", $time, lock);

        // Scenario 5: Unlock using the new passcode to confirm overwrite.
        $display("[%0t] Unlocking with the new code 4-3-2-1", $time);
        enter_code(4'd4, 4'd3, 4'd2, 4'd1);
        wait_cycles(15);
        $display("[%0t] After timer, lock = %0b", $time, lock);

        // Scenario 6: Reset behavior and re-programming.
        $display("[%0t] Applying reset to clear stored code", $time);
        rst_n = 1'b0;
        wait_cycles(2);
        rst_n = 1'b1;
        wait_cycles(2);
        $display("[%0t] After reset, lock should be 0 -> %0b", $time, lock);
        $display("[%0t] Programming new code 0-0-0-1 after reset", $time);
        enter_code(4'd0, 4'd0, 4'd0, 4'd1);
        wait_cycles(4);
        $display("[%0t] Safe locked again with new code; lock = %0b", $time, lock);

        $display("[%0t] Testbench complete", $time);
        $finish;
    end

endmodule
