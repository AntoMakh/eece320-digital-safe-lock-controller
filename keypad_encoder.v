`include "team_params_202500415_202502112.vh"

// antonio is working on this

module keypad_encoder(
    input [11:0] key,
    output reg [3:0] code,
    output reg valid  
);
    integer pressed_keys_count;
    integer msb_pressed;
    integer lsb_pressed;
    integer selected_key_index;
    always @(*) begin
        // count number of keys pressed
        // dual key policy says select higher-index key
        // priority policy says select lower-index key
        // set both to -1 as default
        pressed_keys_count = key[0] + key[1] + key[2] + key[3] + key[4] + key[5] + key[6] + key[7] + key[8] + key[9] + key[10] + key[11];
        
        if(pressed_keys_count == 0) begin
            valid = 1'b0;
        end else if(pressed_keys_count == 1) begin
            valid  = 1'b1;
            if(key[11] == 1'b1) selected_key_index = 11;
            else if(key[10] == 1'b1) selected_key_index = 10;
            else if(key[9] == 1'b1) selected_key_index = 9;
            else if(key[8] == 1'b1) selected_key_index = 8;
            else if(key[7] == 1'b1) selected_key_index = 7;
            else if(key[6] == 1'b1) selected_key_index = 6;
            else if(key[5] == 1'b1) selected_key_index = 5;
            else if(key[4] == 1'b1) selected_key_index = 4;
            else if(key[3] == 1'b1) selected_key_index = 3;
            else if(key[2] == 1'b1) selected_key_index = 2;
            else if(key[1] == 1'b1) selected_key_index = 1;
            else if(key[0] == 1'b1) selected_key_index = 0;
        end else if(pressed_keys_count == 2) begin
            if(key[11] == 1'b1) selected_key_index = 11;
            else if(key[10] == 1'b1) selected_key_index = 10;
            else if(key[9] == 1'b1) selected_key_index = 9;
            else if(key[8] == 1'b1) selected_key_index = 8;
            else if(key[7] == 1'b1) selected_key_index = 7;
            else if(key[6] == 1'b1) selected_key_index = 6;
            else if(key[5] == 1'b1) selected_key_index = 5;
            else if(key[4] == 1'b1) selected_key_index = 4;
            else if(key[3] == 1'b1) selected_key_index = 3;
            else if(key[2] == 1'b1) selected_key_index = 2;
            else if(key[1] == 1'b1) selected_key_index = 1;
            else if(key[0] == 1'b1) selected_key_index = 0;
            valid = 1'b1;
        end else begin
            if(key[0] == 1'b1) selected_key_index = 0;
            else if(key[1] == 1'b1) selected_key_index = 1;
            else if(key[2] == 1'b1) selected_key_index = 2;
            else if(key[3] == 1'b1) selected_key_index = 3;
            else if(key[4] == 1'b1) selected_key_index = 4;
            else if(key[5] == 1'b1) selected_key_index = 5;
            else if(key[6] == 1'b1) selected_key_index = 6;
            else if(key[7] == 1'b1) selected_key_index = 7;
            else if(key[8] == 1'b1) selected_key_index = 8;
            else if(key[9] == 1'b1) selected_key_index = 9;
            else if(key[10] == 1'b1) selected_key_index = 10;
            else if(key[11] == 1'b1) selected_key_index = 11;
            valid = 1'b1;
        end
        // fi ktir redundant statements i will fix later
        
        // encoding (idk i don't like this it seems bulky)
        case (selected_key_index)
            0: code = 4'b0000;
            1: code = 4'b0001;
            2: code = 4'b0010;
            3: code = 4'b0011;
            4: code = 4'b0100;
            5: code = 4'b0101;
            6: code = 4'b0110;
            7: code = 4'b0111;
            8: code = 4'b1000;
            9: code = 4'b1001;
            10: code = 4'b1010;
            11: code = 4'b1011;
            default: code = 4'b1110;
        endcase
    end
endmodule