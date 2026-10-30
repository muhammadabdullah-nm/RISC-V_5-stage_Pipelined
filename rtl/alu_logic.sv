`timescale 1ns / 1ps

module alu_logic #(parameter ALU_WIDTH=32)
 ( input [ALU_WIDTH-1:0] data1, data2,
   input [3:0] ALUSel,
   output logic [ALU_WIDTH-1:0] dataW );
   
    always_comb
    begin
        case(ALUSel)
            4'b0000: dataW=data1+data2; //add
            4'b0001: dataW=data1-data2; //sub
            4'b0010: begin
                    	dataW=data1<<data2[4:0]; //left shift logical
                     end
            
            4'b0011: begin //set less than signed
                        if($signed(data1)<$signed(data2))
                            dataW=1; 
                        else 
                            dataW=0;
                     end
            4'b0100: dataW=data1^data2; //xor
            4'b0101: begin
                            dataW=data1>>data2[4:0]; //shift right logical
                     end
            4'b0110: begin
                            dataW=$signed(data1)>>>$signed(data2[4:0]); //shift right arithmetic
                     end
            
            4'b0111: dataW=data1|data2; //or
            4'b1000: dataW=data1&data2; //and
            4'b1001: begin //set less than unsigned
                        if(data1<data2)
                            dataW=1; 
                        else 
                            dataW=0;
                     end
            4'b1010: dataW=data2; //lui
            default: dataW=0;
        endcase
    end
endmodule
