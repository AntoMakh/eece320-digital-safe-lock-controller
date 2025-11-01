module keypad_encoder_tb;
    reg [11:0] key_TB;
    wire [3:0] code_TB;
    wire valid_TB;
    
    integer passed = 0;
    integer failed = 0;
    reg [3:0] expected_code;
    reg expected_valid;
    
    keypad_encoder dut (
        .key(key_TB),
        .code(code_TB),
        .valid(valid_TB)
    );
    
    initial begin
        $display("Starting Keypad Encoder Testbench...");
        $display("--- Pressing one key only ---")
        for(integer i = 0; i < 12; i = i + 1) begin
            // 1 key pressed only
            key_TB = 12'b0; // set ev to zero
            key_TB[i] = 1; // set i'th bit to 1;
            #10;
            // encoding (again i don't like this it seems bulky)
            case (i)
                0: expected_code = 4'b0000;
                1: expected_code = 4'b0001;
                2: expected_code = 4'b0010;
                3: expected_code = 4'b0011;
                4: expected_code = 4'b0100;
                5: expected_code = 4'b0101;
                6: expected_code = 4'b0110;
                7: expected_code = 4'b0111;
                8: expected_code = 4'b1000;
                9: expected_code = 4'b1001;
                10: expected_code = 4'b1010;
                11: expected_code = 4'b1011;
            endcase
            
            expected_valid = 1'b1;
            #10;
            if(code_TB === expected_code && valid_TB === expected_valid) begin
                passed = passed + 1;
                $display("PASS: Key %0d -> Code %b", i, code_TB);    
            end else begin
                failed = failed + 1;
                $display("FAIL: Key %0d --- Expected code: %b, Expected valid: %b --- Actual code: %b, Actual valid: %b", i, expected_code, expected_valid, code_TB, valid_TB);
            end
        end
        
        
        
        
        
        
        $display("======= SUMMARY =======");
        $display("Tests completed. Results:");
        $display("Passed tests: %0d | Failed tests: %0d", passed, failed);        
        $finish;
    end
    
    
endmodule