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

    safe_top dut (
        .clk(clk),
        .rst_n(rst_n),
        .key(key),
        .seg0(seg0),
        .seg1(seg1),
        .seg2(seg2),
        .seg3(seg3),
        .lock(lock)
    );

    always #5 clk = ~clk;

    
    // debugged using ai, hadto use @posedge clk to ensure proper timing
    task press_key(input integer i);
        begin
            key = 12'b0;
            if (i >= 0 && i < 12)
                key[i] = 1'b1;
            @(posedge clk);
            @(posedge clk);
            key = 12'b0;
            @(posedge clk);
        end
    endtask

    task enter_code(
        input [3:0] d3,
        input [3:0] d2,
        input [3:0] d1,
        input [3:0] d0
    );
        begin
            press_key(d3);
            press_key(d2);
            press_key(d1);
            press_key(d0);
        end
    endtask

    initial begin
        $display("[%0t] Starting safe_top_tb", $time);
        rst_n = 1'b0;
        #30;
        rst_n = 1'b1;
        $display("[%0t] Reset released -> safe unlocked, no stored code", $time);

        // Scenario 1: Initial locking after reset
        $display("[%0t] Programming initial code 1-2-3-4", $time);
        enter_code(4'd1, 4'd2, 4'd3, 4'd4);
        #40;
        $display("[%0t] Initial code stored; lock = %0b (expect 1)", $time, lock);

        // Scenario 2: Incorrect code attempt while locked
        $display("[%0t] Trying incorrect code 9-9-9-9", $time);
        enter_code(4'd9, 4'd9, 4'd9, 4'd9);
        #20;
        $display("[%0t] Error message should display 'Err'; lock = %0b", $time, lock);
        #150;
        $display("[%0t] Error timer expired; lock still = %0b", $time, lock);

        // Scenario 3: Unlock with correct passcode
        $display("[%0t] Entering correct code 1-2-3-4", $time);
        enter_code(4'd1, 4'd2, 4'd3, 4'd4);
        #20;
        $display("[%0t] Success timer running (lock should remain 1); lock = %0b", $time, lock);
        $display("[%0t] Edge case: pressing digit 5 during success timer (should be ignored)", $time);
        press_key(4'd5);
        #150;
        #20;  // Extra cycles for state transition
        $display("[%0t] Success timer expired; safe should be unlocked -> lock = %0b", $time, lock);

        // Scenario 4: Locking again with new code while unlocked
        $display("[%0t] Re-locking with new code 4-3-2-1", $time);
        enter_code(4'd4, 4'd3, 4'd2, 4'd1);
        #40;
        $display("[%0t] New code stored; lock = %0b (expect 1)", $time, lock);

        // Scenario 5: Unlock using new passcode
        $display("[%0t] Unlocking with new code 4-3-2-1", $time);
        enter_code(4'd4, 4'd3, 4'd2, 4'd1);
        #150;
        #20;  // Extra cycles for state transition
        $display("[%0t] After timer, lock = %0b (expect 0)", $time, lock);

        // Scenario 6: Reset behavior
        $display("[%0t] Applying reset to clear stored code", $time);
        rst_n = 1'b0;
        #20;
        rst_n = 1'b1;
        #20;
        $display("[%0t] After reset lock should be 0 -> %0b", $time, lock);
        $display("[%0t] Programming new code 0-0-0-1 after reset", $time);
        enter_code(4'd0, 4'd0, 4'd0, 4'd1);
        #40;
        $display("[%0t] Safe locked with reprogrammed code; lock = %0b", $time, lock);

        $display("[%0t] Testbench complete", $time);
        $finish;
    end

endmodule
