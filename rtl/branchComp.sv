`timescale 1ns / 1ps

module branchComp(
input [31:0] A, B,
input BrUn,
output logic Eq, Lt
    );
    
    always_comb
        begin
            Eq=(A==B); //equal
            if(BrUn) //unsigned check
               Lt=(A<B); //A is less than B
            else 
               Lt=($signed(A)<$signed(B)); //A is less than B
        end
endmodule
