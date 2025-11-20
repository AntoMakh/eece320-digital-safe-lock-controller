`timescale 1ns/1ps
`include "team_params_202500415_202502112.vh"

module tb_interval_timer;

    reg clk;
    reg rst_n;
    reg start;
    wire done;

    // Instantiate DUT
    interval_timer uut (
        .clk(clk),
        .rst_n(rst_n),
        .start(start),
        .done(done)
    );

    // simple clock
    always #5 clk = ~clk;

    initial begin
        clk   = 0;
        rst_n = 0;
        start = 0;

        $display("Time   clk rst start done");

        // reset phase
        #10 rst_n = 1;

        // normal start
        #10 start = 1;
        #10 start = 0;

        // let it count down manually (ten cycles)
        #10;
        #10;
        #10;
        #10;
        #10;
        #10;
        #10;
        #10;
        #10;
        #10;

        // mid-count reset test
        #10 start = 1;
        #10 start = 0;
        #20 rst_n = 0;
        #10 rst_n = 1;

        // another short start pulse
        #10 start = 1;
        #10 start = 0;

        // a few cycles of countdown again
        #10;
        #10;
        #10;

        $finish;
    end

    initial begin
        $monitor("%0t    %b   %b   %b     %b",
                 $time, clk, rst_n, start, done);
    end

endmodule
