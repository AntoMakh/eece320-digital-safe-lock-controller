module input_shift_register (
    input clk, // system clock
    input rst_n, // active-low asynchronous reset
    input clear_entry, // clears the current 4-digit entry
    input [3:0] code, // digit value from the keypad encoder
    input valid, // asserted for valid key presses (0--9)
    output reg [15:0] entered_code, // saved 4-digit user entry
    output done // asserted when 4 digits have been entered
);

    reg [2:0] count_digits_inserted;   
     
    // assign done (since not reg) to 1 when 4 digits have been entered
    assign done = (count_digits_inserted == 3'd4);
    
    always @(posedge clk or negedge rst_n) begin
        // if reset or clear_entry, clear the entered code and digit count
        if(rst_n == 1'b0) begin
            entered_code <= 16'b0;
            count_digits_inserted <= 3'd0;
        end
        else if (clear_entry == 1'b1) begin
            entered_code <= 16'b0;
            count_digits_inserted <= 3'd0;
        end
        // if valid and less than 4 digits entered, shift in new digit
        else if (valid && count_digits_inserted < 3'd4) begin
            entered_code <= {entered_code[11:0], code};
            count_digits_inserted <= count_digits_inserted + 1;
        end
    end



endmodule