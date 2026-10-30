`timescale 1ns / 1ps

module reg_file
#(parameter REGF_WIDTH=5, 
  parameter DATA_WIDTH=32)
 (
input clk, reset,
input logic [DATA_WIDTH-1:0] dataW,
input logic [REGF_WIDTH -1:0] rs1, rs2,rsW,
output logic [DATA_WIDTH-1:0] data1, data2,
input RegWEn
    );
   
    
    logic [32 - 1:0] regFile [DATA_WIDTH-1:0];
    integer i;
    initial
    begin
        $readmemh("reg.mem", regFile); 
//	for(i = 0; i < 32;i++)
//		regFile[i] = 0;
    end
    
    always_comb
        begin
            data1= regFile[rs1]; 
            data2= regFile[rs2]; 
        end

    always_ff@(negedge clk)
    begin 
        if(rsW!=0 && RegWEn) //write
            regFile[rsW] <= dataW; //writing of data
        else if(rsW==0)//for x0
            regFile[rsW] <= 0; //writing of data
       
    end

   
  
endmodule
