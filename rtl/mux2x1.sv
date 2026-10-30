`timescale 1ns / 1ps


module mux2x1(
input Bsel,
input [32-1:0] data2, immGen,
output logic [32-1:0] outALU
    );
    
    always_comb
        begin
            if(Bsel)
                outALU=immGen;
            else 
                outALU=data2;
        end
endmodule
