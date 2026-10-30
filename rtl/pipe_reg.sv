`timescale 1ns / 1ps

module pipe_reg #(parameter width_i=8, parameter width_o=8)(
    input clk, reset,
    input [width_i-1:0] reg_i,
    output logic [width_o-1:0] reg_o
    );
    
    always_ff@(posedge clk)
    begin
        if(!reset)
            reg_o<=0;
        else
            reg_o<=reg_i;
    end
endmodule
