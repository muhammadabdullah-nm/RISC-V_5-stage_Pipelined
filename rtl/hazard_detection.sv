`timescale 1ns / 1ps

module hazard_detection(
    output logic PCWrite, IFDWrite,
    output logic muxSel,
    input IdExMemRead,
    input [4:0] rs1, rs2, rd
    );
    
    always_comb
    begin
        if(((rd==rs1) || (rd==rs2)) && IdExMemRead)
            begin
                PCWrite = 0; //stall the PC
                IFDWrite = 0; //stall the Instruction
                muxSel = 0; //set RegWrite and MemWrite to ZERO
            end
        else    
            begin
                PCWrite = 1; //donot stall the PC
                IFDWrite = 1; //donotstall the Instruction
                muxSel = 1; //set RegWrite and MemWrite to ONE
            end
    
    end
endmodule
