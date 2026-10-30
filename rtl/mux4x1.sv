`timescale 1ns / 1ps

module mux4x1(
input [2:0] sel,
input [32-1:0] in0, in1, in2, in3,
output logic [32-1:0] outMux4x1
    );
    
    always_comb
        begin
            case(sel)
                3'b000: 
                    outMux4x1=in0;
                3'b001: 
                    outMux4x1=in1;
                3'b010: 
                    outMux4x1=in2;
                default:
                    outMux4x1=32'b0;
            endcase
        end
endmodule
