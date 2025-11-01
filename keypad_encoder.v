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
        // priority policy says select lower-index ke
        // set both to -1 as default
        pressed_keys_count = 0;
        msb_pressed = -1;
        lsb_pressed = -1;
        for(integer i = 0; i < 12; i = i+1) begin
            if(key[i] == 1'b1) begin
                pressed_keys_count = pressed_keys_count + 1;
                msb_pressed = i; // last value it takes is that of last pressed key
                if(lsb_pressed == -1) begin
                    lsb_pressed = i; // will only set it once
                end
            end
        end
        
        if(pressed_keys_count == 0) begin
            valid = 1'b0;
        end else if(pressed_keys_count == 1) begin
            valid  = 1'b1;
            selected_key_index = lsb_pressed; // only bit pressed is lsb or msb
        end else if(pressed_keys_count == 2) begin
            selected_key_index = msb_pressed;
            valid = 1'b1;
        end else begin
            selected_key_index = lsb_pressed;
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