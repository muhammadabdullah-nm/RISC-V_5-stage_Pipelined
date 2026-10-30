`timescale 1ns / 1ps

module fwd_logic(
    input exMemRegWEn, memWBRegWEn,
    input [4:0] exMemRd, memWBRd, rs1, rs2,
    output logic [1:0] fwdA, fwdB
    );
    
    always_comb
    begin
//                if(memWBRd != 0 || exMemRd != 0  )
//                    begin
                        if(memWBRd==rs1 && memWBRegWEn==1 && memWBRd!=0)
                        begin
                            fwdA=2'b01; //forward memory value of rs1
                            fwdB=2'b10; //forward simple value of rs2
                        end
                        else if(exMemRd==rs1 && exMemRegWEn==1 && exMemRd!=0)
                        begin
                            fwdA=2'b00; //forward execute value of rs1
                            fwdB=2'b10; //forward simple value of rs2
                        end
                 else 
                    begin
                        fwdB=2'b10; //forward simple value of rs2
                        fwdA=2'b10; //forward simple value of rs1
                    end
//                    end
//               else 
//            begin
//                fwdB=2'b10; //forward simple value of rs2
//                fwdA=2'b10; //forward simple value of rs1
//            end
//              if(exMemRd != 0 || memWBRd != 0  )
//                    begin
                       if(memWBRd==rs2 && memWBRegWEn==1 && memWBRd!=0)
                        begin
                            fwdA=2'b10; //forward simple value of rs2
                            fwdB=2'b01; //forward memory value of rs1
                        end
                        else if(exMemRd==rs2 && exMemRegWEn==1 && exMemRd!=0)
                        begin
                            fwdA=2'b10; //forward simple value of rs2
                            fwdB=2'b00; //forward execute value of rs1
                        end
//                    end
//             end
            else 
                begin
                    fwdB=2'b10; //forward simple value of rs2
                    fwdA=2'b10; //forward simple value of rs1
                end
     end
    
endmodule
