`timescale 1ns / 1ps

module program_counter
(
input clk, reset,
input PCWrite,
input [31:0] PCOut,
output logic [32 - 1:0] prg_count, prg_countAdd
    );
  assign prg_countAdd=prg_count+4;
    always@(posedge clk)
    begin
        if(!reset)
            prg_count<=0;
//            prg_count<=32'h8000_0000;
        else if(PCWrite)
            prg_count<=PCOut;
       else 
            prg_count<=prg_count; //stall
    end
endmodule
