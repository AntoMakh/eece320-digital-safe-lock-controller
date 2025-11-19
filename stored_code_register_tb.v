`timescale 1ns/1ps

module tb_stored_code_register;

    reg clk;
    reg rst_n;
    reg load;
    reg [15:0] datain;
    wire [15:0] dataout;

    // Instantiate the module
    stored_code_register uut (
        .clk(clk),
        .rst_n(rst_n),
        .load(load),
        .datain(datain),
        .dataout(dataout)
    );

    // Clock generation (not really used here)
    initial begin
        clk = 0;
    end
    always #5 clk = ~clk;

    initial begin
        // Initialize inputs
        rst_n = 0;
        load = 0;
        datain = 16'h0000;

        // Wait some time and release reset
        #10;
        rst_n = 1;

        // Wait to observe the output
        #10;

        // Display the output
        $display("PASSCODE = %h", `PASSCODE);
        $display("Scrambled stored_code_register output = %h", dataout);

        // Check expected value (manual verification)
        if (dataout == 16'h0790) // {D2,D1,D3,D0} for PASSCODE=16'h9070, STORED_MASK=16'h2130
            $display("Test PASSED");
        else
            $display("Test FAILED");

        #10;
        $finish;
    end

endmodule
