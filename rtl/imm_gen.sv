`timescale 1ns / 1ps


module imm_gen(
input [31:0] imm,
input [2:0] typeOfInstr,
output logic [31:0] immUp
    );
    
    
    always_comb
        begin
        
        case(typeOfInstr)
            3'b000: //I type
                begin
                    //000000000011 00001000000110010011
                    logic [19:0] temp;
                    temp={20{imm[31]}};
                    immUp={temp, imm[31:20]};
                end
            3'b001: //S type
                begin
                    //00000000001000001010000110100011
                    //000000000011
                    logic [19:0] temp;
                    temp={20{imm[31]}};
                    immUp={temp, imm[31:25], imm[11:7]};
                end
            3'b010: //J type
                begin
                    //01001100010100101000 000011101111
                    //01001100010100101000
                    //00100101000110011000
                    logic [11:0] temp;
                    temp={12{imm[31]}};
                    immUp={temp, imm[19:12], imm[20], imm[30:21], 1'b0};
                end
            3'b011: //B type
                begin
                    //11000100110100010011001001100011
                    //110001000100
                    logic [19:0] temp;
                    temp={20{imm[31]}};
                    immUp={temp, imm[7], imm[30:25], imm[11:8], 1'b0};
                end
            3'b100: //U type
                begin
                    //00001001000000000000000110110111
                    //00001001000000000000
                    logic [11:0] temp;
                    temp={12{1'b0}};
                    immUp={imm[31:12],temp};
                end
            
        
        endcase
            
        end
endmodule
