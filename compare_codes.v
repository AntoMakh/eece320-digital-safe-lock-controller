module compare_codes (
    input [15:0] input_code, // code produced by input_shift_register
    input [15:0] stored_code, // scrambled passcode from stored_code_register
    output match // 1 if the user-entered and stored codes match, else 0
);

    // Stored code format: {D2, D1, D0, D3} = {[15:12], [11:8], [7:4], [3:0]}
    // To unscramble: extract D3 from [3:0], D2 from [15:12], D1 from [11:8], D0 from [7:4]
    wire [3:0] D3 = stored_code[3:0];
    wire [3:0] D2 = stored_code[15:12];
    wire [3:0] D1 = stored_code[11:8];
    wire [3:0] D0 = stored_code[7:4];
    
    wire [15:0] unscrambled_code = {D3, D2, D1, D0};
    
    assign match = (input_code == unscrambled_code);


endmodule