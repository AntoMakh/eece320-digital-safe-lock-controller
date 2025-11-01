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
        $display("--- Pressing one key only ---");
        for(integer i = 0; i < 12; i = i + 1) begin
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
        
        $display("--- Pressing two keys ---");
        for(integer j = 0; j < 11; j = j+1) begin
            for(integer k = j+1; k < 12; k = k + 1) begin
                key_TB = 12'b0;
                key_TB[j] = 1;
                key_TB[k] = 1;
                #10;
                // expected one is j since j is the higher index
                case (k)
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
                    $display("PASS: Keys: %0d and %0d -> Code %b", j, k, code_TB);    
                end else begin
                    failed = failed + 1;
                    $display("FAIL: Keys: %0d and %0d --- Expected code: %b, Expected valid: %b --- Actual code: %b, Actual valid: %b", j, k, expected_code, expected_valid, code_TB, valid_TB);
                end
                
            end
        end
        
        $display("--- Pressing three keys ---");
        key_TB = 12'b000000011100; // keys 2,3,4 pressed
        #10;
        expected_code = 4'b0010; // lowest index = 2
        expected_valid = 1'b1;
        if (code_TB === expected_code && valid_TB === expected_valid) begin
            passed = passed + 1;
            $display("PASS: Keys: 2, 3, and 4 -> Code %b", code_TB);
        end else begin
            failed = failed + 1;
            $display("FAIL: Keys: 2, 3, and 4 --- Expected code: %b, Expected valid: %b --- Actual code: %b, Actual valid: %b", expected_code, expected_valid, code_TB, valid_TB);
        end

        $display("--- Pressing four keys ---");
        key_TB = 12'b000111100000; // keys 5,6,7,8 pressed
        #10;
        expected_code = 4'b0101; // lowest index = 5
        expected_valid = 1'b1;
        if (code_TB === expected_code && valid_TB === expected_valid) begin
            passed = passed + 1;
            $display("PASS: Keys: 5, 6, 7, 8 -> Code %b", code_TB);
        end else begin
            failed = failed + 1;
            $display("FAIL: Keys: 5, 6, 7, 8 --- Expected code: %b, Expected valid: %b --- Actual code: %b, Actual valid: %b", expected_code, expected_valid, code_TB, valid_TB);
        end

        $display("--- Pressing all keys ---");
        key_TB = 12'b111111111111; // all keys pressed
        #10;
        expected_code = 4'b0000; // lowest index = 0
        expected_valid = 1'b1;
        if (code_TB === expected_code && valid_TB === expected_valid) begin
            passed = passed + 1;
            $display("PASS: All keys pressed -> Code %b", code_TB);
        end else begin
            failed = failed + 1;
            $display("FAIL: All keys --- Expected code: %b, Expected valid: %b --- Actual code: %b, Actual valid: %b", expected_code, expected_valid, code_TB, valid_TB);
        end
        
        
        
        $display("\n======= SUMMARY =======");
        $display("Tests completed. Results:");
        $display("Passed tests: %0d | Failed tests: %0d", passed, failed);        
        $finish;
    end    
endmodule