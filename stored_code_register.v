`include "team_params_202500415_202502112.vh"

module stored_code_register (
    input clk,
    input rst_n,
    input load,
    input [15:0] datain,
    output [15:0] dataout,
    output reg valid_code // indicates whether a code is stored
);

    reg [15:0] stored_value;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            stored_value <= 16'b0;
            valid_code <= 1'b0;   // invalid on reset
        end
        else if (load) begin
            // store scrambled code
            stored_value <= {
                datain[11:8], // nibble 2
                datain[7:4], // nibble 1
                datain[3:0], // nibble 0
                datain[15:12] // nibble 3
            };
            valid_code <= 1'b1; // now we have a valid code
        end
    end

    assign dataout = stored_value;

endmodule