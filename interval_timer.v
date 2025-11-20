`include "team_params_202500415_202502112.vh"

module interval_timer (
    input clk,         // system clock
    input rst_n,       // active-low asynchronous reset
    input start,       // reloads the countdown from TIMER_MAX_CYCLES
    output done        // asserted when countdown reaches zero
);

    reg [3:0] counter; // enough bits to hold TIMER_MAX_CYCLES (4 bits)

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            counter <= 4'b0; // reset counter to 0
        end
        else if (start) begin
            counter <= 4'd10; // reload the timer
        end
        else if (counter != 0) begin
            counter <= counter - 1'b1;    // count down
        end
    end

    assign done = (counter == 0); // done asserted when counter reaches zero

endmodule
