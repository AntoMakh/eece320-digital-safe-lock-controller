`include "team_params_202500415_202502112.vh"

module safe_top (
    input clk,
    input rst_n,
    input [11:0] key,
    output [6:0] seg0,
    output [6:0] seg1,
    output [6:0] seg2,
    output [6:0] seg3,
    output lock
);

    wire [3:0] digit_code;
    wire keypad_valid;
    wire [15:0] entered_code;
    wire [15:0] stored_code;
    wire [15:0] display_code;
    wire done;
    wire match;
    wire timer_done;

    wire clear_entry;
    wire accept_digit;
    wire load_code;
    wire start_timer;
    wire [2:0] display_mode;
    wire lock_int;

    // Gate valid signal to input shift register
    wire gated_valid = keypad_valid & accept_digit;

    keypad_encoder u_keypad_encoder (
        .key(key),
        .code(digit_code),
        .valid(keypad_valid)
    );

    input_shift_register u_input_shift_register (
        .clk(clk),
        .rst_n(rst_n),
        .clear_entry(clear_entry),
        .code(digit_code),
        .valid(gated_valid),
        .entered_code(entered_code),
        .done(done)
    );

    stored_code_register u_stored_code_register (
        .clk(clk),
        .rst_n(rst_n),
        .load(load_code),
        .datain(entered_code),
        .dataout(stored_code)
    );

    compare_codes u_compare_codes (
        .input_code(entered_code),
        .stored_code(stored_code),
        .match(match)
    );

    display_mux u_display_mux (
        .entered_code(entered_code),
        .display_mode(display_mode),
        .display_code(display_code)
    );

    sevenseg_driver u_sevenseg_driver0 (
        .code(display_code[3:0]),
        .seg(seg0)
    );

    sevenseg_driver u_sevenseg_driver1 (
        .code(display_code[7:4]),
        .seg(seg1)
    );

    sevenseg_driver u_sevenseg_driver2 (
        .code(display_code[11:8]),
        .seg(seg2)
    );

    sevenseg_driver u_sevenseg_driver3 (
        .code(display_code[15:12]),
        .seg(seg3)
    );

    interval_timer u_interval_timer (
        .clk(clk),
        .rst_n(rst_n),
        .start(start_timer),
        .done(timer_done)
    );

    safe_controller_fsm u_safe_controller (
        .clk(clk),
        .rst_n(rst_n),
        .done(done),
        .match(match),
        .timer_done(timer_done),
        .clear_entry(clear_entry),
        .accept_digit(accept_digit),
        .load_code(load_code),
        .start_timer(start_timer),
        .display_mode(display_mode),
        .lock(lock_int)
    );

    assign lock = lock_int;

endmodule
