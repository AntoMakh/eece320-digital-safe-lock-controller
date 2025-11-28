`include "team_params_202500415_202502112.vh"

module safe_controller_fsm (
    input clk,
    input rst_n,
    input done,
    input match,
    input timer_done,
    output reg clear_entry,
    output reg accept_digit,
    output reg load_code,
    output reg start_timer,
    output reg [2:0] display_mode,
    output reg lock
);

    localparam [3:0]
        S_UNLOCK_NO_CODE_CLEAR   = 4'd0,
        S_UNLOCK_NO_CODE_ENTRY   = 4'd1,
        S_LOCK_STORE             = 4'd2,
        S_LOCKED_CLEAR           = 4'd3,
        S_LOCKED_ENTRY           = 4'd4,
        S_SUCCESS_START          = 4'd5,
        S_SUCCESS_WAIT           = 4'd6,
        S_ERROR_START            = 4'd7,
        S_ERROR_WAIT             = 4'd8,
        S_UNLOCK_WITH_CODE_CLEAR = 4'd9,
        S_UNLOCK_WITH_CODE_ENTRY = 4'd10;

    reg [3:0] state, next_state;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= S_UNLOCK_NO_CODE_CLEAR;
        end
        else begin
            state <= next_state;
        end
    end

    always @(*) begin
        next_state = state;
        case (state)
            S_UNLOCK_NO_CODE_CLEAR:   next_state = S_UNLOCK_NO_CODE_ENTRY;

            S_UNLOCK_NO_CODE_ENTRY: begin
                if (done) next_state = S_LOCK_STORE;
            end

            S_LOCK_STORE:             next_state = S_LOCKED_CLEAR;

            S_LOCKED_CLEAR:           next_state = S_LOCKED_ENTRY;

            S_LOCKED_ENTRY: begin
                if (done) begin
                    next_state = match ? S_SUCCESS_START : S_ERROR_START;
                end
            end

            S_SUCCESS_START:          next_state = S_SUCCESS_WAIT;

            S_SUCCESS_WAIT: begin
                if (timer_done) next_state = S_UNLOCK_WITH_CODE_CLEAR;
            end

            S_ERROR_START:            next_state = S_ERROR_WAIT;

            S_ERROR_WAIT: begin
                if (timer_done) next_state = S_LOCKED_CLEAR;
            end

            S_UNLOCK_WITH_CODE_CLEAR: next_state = S_UNLOCK_WITH_CODE_ENTRY;

            S_UNLOCK_WITH_CODE_ENTRY: begin
                if (done) next_state = S_LOCK_STORE;
            end

            default:                  next_state = S_UNLOCK_NO_CODE_CLEAR;
        endcase
    end

    always @(*) begin
        clear_entry  = 1'b0;
        accept_digit = 1'b0;
        load_code    = 1'b0;
        start_timer  = 1'b0;
        display_mode = `MODE_BLANK;
        lock         = 1'b0;

        case (state)
            S_UNLOCK_NO_CODE_CLEAR: begin
                clear_entry  = 1'b1;
                display_mode = `MODE_BLANK;
                lock         = 1'b0;
            end

            S_UNLOCK_NO_CODE_ENTRY: begin
                accept_digit = 1'b1;
                display_mode = `MODE_ENTER;
                lock         = 1'b0;
            end

            S_LOCK_STORE: begin
                load_code    = 1'b1;
                display_mode = `MODE_BLANK;
                lock         = 1'b1;
            end

            S_LOCKED_CLEAR: begin
                clear_entry  = 1'b1;
                display_mode = `MODE_BLANK;
                lock         = 1'b1;
            end

            S_LOCKED_ENTRY: begin
                accept_digit = 1'b1;
                display_mode = `MODE_ENTER;
                lock         = 1'b1;
            end

            S_SUCCESS_START: begin
                start_timer  = 1'b1;
                display_mode = `MODE_ENTER;
                lock         = 1'b1;
            end

            S_SUCCESS_WAIT: begin
                display_mode = `MODE_ENTER;
                lock         = 1'b1;
            end

            S_ERROR_START: begin
                start_timer  = 1'b1;
                display_mode = `MODE_ERROR;
                lock         = 1'b1;
            end

            S_ERROR_WAIT: begin
                display_mode = `MODE_ERROR;
                lock         = 1'b1;
            end

            S_UNLOCK_WITH_CODE_CLEAR: begin
                clear_entry  = 1'b1;
                display_mode = `MODE_BLANK;
                lock         = 1'b0;
            end

            S_UNLOCK_WITH_CODE_ENTRY: begin
                accept_digit = 1'b1;
                display_mode = `MODE_ENTER;
                lock         = 1'b0;
            end

            default: begin
                clear_entry  = 1'b1;
                display_mode = `MODE_BLANK;
                lock         = 1'b0;
            end
        endcase
    end

endmodule
