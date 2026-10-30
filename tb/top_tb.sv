`timescale 1ns / 1ps

module top_tb();

    reg clk, reset;

    // Instantiate the design module
    top uut (
        .clk(clk),
        .reset(reset)
    );

    // Clock generation
    always begin
        #5 clk = ~clk; // Toggle clock every 5 ns
    end

    initial begin
        // Initialize signals
        //add
        clk = 0;
        reset = 0;
       

        // Reset the system
        #10 reset = 1;
       

    end

endmodule
