module compare_codes (
    input [15:0] input_code, // code produced by input_shift_register
    input [15:0] stored_code, // scrambled passcode from stored_code_register
    output match // 1 if the user-entered and stored codes match, else 0
);

    // scrambled is d2 d1 d3 d0
    // so to unscramble, take d3 from [7:4], d2 from [15:12], d1 from [11:8], d0 from [3:0]
    wire [3:0] D3 = stored_code[7:4];
    wire [3:0] D2 = stored_code[15:12];
    wire [3:0] D1 = stored_code[11:8];
    wire [3:0] D0 = stored_code[3:0];
    
    wire [15:0] unscrambled_code = {D3, D2, D1, D0};
    
    assign match = (input_code == unscrambled_code);


endmodule