`include "team_params_202500415_202502112.vh"

// commented using ai and human imagination
module safe_controller_fsm (
    input clk,              // clock input
    input rst_n,            // active low reset
    input done,             // input to indicate code entry done
    input match,            // input to indicate entered code matches stored code
    input timer_done,       // input to indicate success/error timer finished
    output reg clear_entry, // output to clear entry register
    output reg accept_digit,// output to allow digit entry
    output reg load_code,   // output to load new code
    output reg start_timer, // output to start success/error timer
    output reg [2:0] display_mode, // output to select display mode
    output reg lock         // output to indicate lock status
);

    // fsm states
    parameter [3:0]
        S_UNLOCK_CLR     = 4'd0, // clear entry when unlocked
        S_UNLOCK_ENTRY   = 4'd1, // accept code digits when unlocked
        S_STORE_LOCK     = 4'd2, // store new code and lock
        S_LOCKED_CLR     = 4'd3, // clear entry when locked
        S_LOCKED_ENTRY   = 4'd4, // accept code digits when locked
        S_SUCCESS_START  = 4'd5, // start success timer
        S_SUCCESS_WAIT   = 4'd6, // wait for success timer
        S_ERROR_START    = 4'd7, // start error timer
        S_ERROR_WAIT     = 4'd8, // wait for error timer
        S_STORE_PREP     = 4'd9; // prepare to store code

    reg [4:0] currentState, nextState; // registers for current and next states

    // state register, triggered on clock or reset
    always @(posedge clk, negedge rst_n) begin
        if (!rst_n)
            currentState <= S_UNLOCK_CLR; // reset to unlock clear
        else
            currentState <= nextState;    // move to next state
    end

    // next-state logic
    always @(*) begin
        case (currentState)
            S_UNLOCK_CLR:
                nextState <= S_UNLOCK_ENTRY; // always go to entry after clear
            S_UNLOCK_ENTRY:
                nextState <= done ? S_STORE_PREP : S_UNLOCK_ENTRY; // go to store prep if done
            S_STORE_LOCK:
                nextState <= S_LOCKED_CLR; // after storing, go to locked clear
            S_LOCKED_CLR:
                nextState <= S_LOCKED_ENTRY; // then go to locked entry
            S_LOCKED_ENTRY:
                nextState <= done ? (match ? S_SUCCESS_START : S_ERROR_START) : S_LOCKED_ENTRY; // check done and match
            S_SUCCESS_START:
                nextState <= S_SUCCESS_WAIT; // move to success wait
            S_SUCCESS_WAIT:
                nextState <= timer_done ? S_UNLOCK_CLR : S_SUCCESS_WAIT; // go to unlock clear when timer done
            S_ERROR_START:
                nextState <= S_ERROR_WAIT; // move to error wait
            S_ERROR_WAIT:
                nextState <= timer_done ? S_LOCKED_CLR : S_ERROR_WAIT; // go to locked clear when timer done
            S_STORE_PREP:
                nextState <= S_STORE_LOCK; // prepare store moves to store lock
            default:
                nextState <= S_UNLOCK_CLR; // default to unlock clear
        endcase
    end

    // output logic based on current state
    always @(*) begin
        // default outputs
        lock = 1'b0;
        clear_entry = 1'b0;
        accept_digit = 1'b0;
        load_code = 1'b0;
        start_timer = 1'b0;
        display_mode = 3'b100;

        case (currentState)
            S_UNLOCK_CLR: begin
                lock = 1'b0;           // unlocked
                clear_entry = 1'b1;    // clear entry
                display_mode = 3'b100; // default display
                $display("IN UNLOCK CLR");
            end
            S_UNLOCK_ENTRY: begin
                lock = 1'b0;           // unlocked
                accept_digit = 1'b1;   // allow digit input
                display_mode = 3'b010; // entry display
                $display("IN UNLOCK ENTRY");
            end
            S_STORE_LOCK: begin
                lock = 1'b1;           // lock after storing
                load_code = 1'b1;      // load new code
                display_mode = 3'b100; // default display
                $display("IN STORE LOCK");
            end
            S_LOCKED_CLR: begin
                lock = 1'b1;           // locked
                clear_entry = 1'b1;    // clear entry
                display_mode = 3'b100; // default display
                $display("IN LOCKED CLR");
            end
            S_LOCKED_ENTRY: begin
                lock = 1'b1;           // locked
                accept_digit = 1'b1;   // allow digit input
                display_mode = 3'b010; // entry display
                $display("IN LOCKED ENTRY");
            end
            S_SUCCESS_START: begin
                lock = 1'b1;           // locked during success
                start_timer = 1'b1;    // start timer
                display_mode = 3'b010; // entry display
                $display("IN SUCCESS START");
            end
            S_SUCCESS_WAIT: begin
                lock = 1'b1;           // locked until timer expires
                display_mode = 3'b010; // entry display
                $display("IN SUCCESS WAIT");
            end
            S_ERROR_START: begin
                lock = 1'b1;           // locked during error
                start_timer = 1'b1;    // start timer
                display_mode = 3'b001; // error display
                $display("IN ERROR START");
            end
            S_ERROR_WAIT: begin
                lock = 1'b1;           // locked until timer expires
                display_mode = 3'b001; // error display
                $display("IN ERROR WAIT");  
            end
            S_STORE_PREP: begin
                lock = 1'b1;           // preparing store, keep locked
                display_mode = 3'b100; // default display
                $display("IN STORE PREP");
            end
        endcase
    end

endmodule
