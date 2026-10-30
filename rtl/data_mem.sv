`timescale 1ns / 1ps

module data_mem(
    input [31:0] addr,
    input [31:0] dataW,
    input clk, reset, MemRW,
//    input [31:0] imm, 
    input [2:0] func3,
    output logic [31:0] dataR
    );
    
    reg [32-1:0] dataFile [31:0];
    integer i;
    initial
    begin
        $readmemb("data_m.mem", dataFile); 
//	for(i = 0; i < 1024;i++)
//		dataFile[i] = 0;
    end
    
    
    logic [31:0] tempForLast, tempForAgain, dataToOut, tempToTrace;
    logic [1:0] tempBits;
    
    logic [31:0] temp;
    logic [15:0] tempOfFt, tempAgain;
    logic [7:0]  tempOfByte, maskBitsEight;
    logic [23:0] tempOfAgain;
    
    
    always_comb
    begin
        if(MemRW)
        begin
            case(func3)
                3'b010: //sw
                    begin
                        dataToOut=dataW;
                    end 
                3'b001: //sh
                    begin
                        tempForLast=addr&(-4); //go to original addr
                        tempBits=addr&3; //get last two bits
                        tempForLast=tempForLast>>2; //to match with memory addres i.e 0->0, 4->1, 8->2 so on
                        if(tempBits == 2'b00)
                                begin
                                    tempAgain=dataW[15:0]; //original data in temp variable
                                    tempForAgain=dataFile[tempForLast]; //original data in temp variable
                                    dataToOut={tempForAgain[31:16], tempAgain}; //concatenating 
                                end
                         else 
                                begin
                                    tempAgain=dataW[15:0]; //original data in temp variable
                                    tempForAgain=dataFile[tempForLast]; //original data in temp variable
                                    dataToOut={tempAgain, tempForAgain[15:0]}; //concatenating 
                                end
                    end
                3'b000: //sb (signed)
                    begin
                        tempForLast=addr&(-4); //go to original addr
                        tempBits=addr&3; //get last two bits
                        tempForLast=tempForLast>>2; //to match with memory addres i.e 0->0, 4->1, 8->2 so on
                        case(tempBits)
                            2'b00: 
                                begin
                                    tempOfByte=dataW[7:0]; //original data in temp variable
                                    tempForAgain=dataFile[tempForLast]; //original data in temp variable
                                    dataToOut={tempForAgain[31:8], tempOfByte}; //concatenating 
                                end
                            2'b01:
                                begin
                                    tempOfByte=dataW[7:0]; //original data in temp variable
                                    tempForAgain=dataFile[tempForLast]; //original data in temp variable
                                    dataToOut={tempForAgain[31:16], tempOfByte, tempForAgain[7:0]}; //concatenating 
                                end
                            2'b10:
                                begin
                                    tempOfByte=dataW[7:0]; //original data in temp variable
                                    tempForAgain=dataFile[tempForLast]; //original data in temp variable
                                    dataToOut={tempForAgain[31:24], tempOfByte, tempForAgain[15:0]}; //concatenating 
                                end
                            2'b11:
                                begin
                                    tempOfByte=dataW[7:0]; //original data in temp variable
                                    tempForAgain=dataFile[tempForLast]; //original data in temp variable
                                    dataToOut={tempOfByte, tempForAgain[23:0]}; //concatenating 
                                end
                            default:
                                dataR=32'bx; //no value (error)
                              
                        endcase 
                    end
            endcase
        end
        else
        begin
            case(func3)
                3'b010: //lw 
                    begin
                        tempForLast=addr>>2;
                        dataR=dataFile[tempForLast];
                    end
                3'b001: //lh (signed)
                    begin
                        tempForLast=addr&(-4); //go to original addr
                        tempBits=addr&3; //get last two bits
                        tempForLast=tempForLast>>2; //to match with memory addres i.e 0->0, 4->1, 8->2 so on
                        case(tempBits)
                            2'b00: 
                                begin
                                    temp=dataFile[tempForLast]; //original data in temp variable
                                    tempOfFt=temp[15:0]; //get first 2 bytes
                                    tempAgain={16{temp[15]}}; //16 bit sign extend
                                    dataR={tempAgain, tempOfFt}; //concatenatingg 
                                end
                            2'b10:
                                begin
                                    temp=dataFile[tempForLast]; //original data in temp variable
                                    tempForAgain=temp>>16; //get 1st byte
                                    tempOfFt=tempForAgain[15:0]; //get first 2 bytes
                                    tempAgain={16{tempForAgain[15]}}; //16 bit sign extend
                                    dataR={tempAgain, tempOfFt}; //concatenatingg
                                end
                           default:
                                dataR=32'bx; //no value (error)
                        endcase 
                    end
                3'b101: //lhu (unsigned)
                    begin
                        tempForLast=addr&(-4); //go to original addr
                        tempBits=addr&3; //get last two bits
                        tempForLast=tempForLast>>2; //to match with memory addres i.e 0->0, 4->1, 8->2 so on
                        case(tempBits)
                            2'b00: 
                                begin
                                    temp=dataFile[tempForLast]; //original data in temp variable
                                    tempOfFt=temp[15:0]; //get first 2 bytes
                                    tempAgain={16{1'b0}}; //16 bit sign extend
                                    dataR={tempAgain, tempOfFt}; //concatenatingg 
                                end
                            2'b10:
                                begin
                                    temp=dataFile[tempForLast]; //original data in temp variable
                                    tempForAgain=temp>>16; //get 1st byte
                                    tempOfFt=tempForAgain[15:0]; //get first 2 bytes
                                    tempAgain={16{1'b0}}; //16 bit sign extend
                                    dataR={tempAgain, tempOfFt}; //concatenatingg
                                end
                           default:
                                dataR=32'bx; //no value (error)
                        endcase 
                    end
                3'b000: //lb (signed)
                    begin
                        tempForLast=addr&(-4); //go to original addr
                        tempBits=addr&3; //get last two bits
                        tempForLast=tempForLast>>2; //to match with memory addres i.e 0->0, 4->1, 8->2 so on
                        case(tempBits)
                            2'b00: 
                                begin
                                    temp=dataFile[tempForLast]; //original data in temp variable
                                    tempOfByte=temp[7:0]; //get zero byte
                                    tempOfAgain={24{temp[7]}}; //24 bit sign extend
                                    dataR={tempOfAgain, tempOfByte}; //concatenating 
                                end
                            2'b01:
                                begin
                                    temp=dataFile[tempForLast]; //original data in temp variable
                                    tempForAgain=temp>>8; //get 1st byte
                                    tempOfByte=tempForAgain[7:0]; //get first byte
                                    tempOfAgain={24{tempForAgain[7]}}; //24 bit sign extend
                                    dataR={tempOfAgain, tempOfByte}; //concatenating 
                                end
                            2'b10:
                                begin
                                    temp=dataFile[tempForLast]; //original data in temp variable
                                    tempForAgain=temp>>16; //get 1st byte
                                    tempOfByte=tempForAgain[7:0]; //get first byte
                                    tempOfAgain={24{tempForAgain[7]}}; //24 bit sign extend
                                    dataR={tempOfAgain, tempOfByte}; //concatenating 
                                end
                            2'b11:
                                begin
                                    temp=dataFile[tempForLast]; //original data in temp variable
                                    tempForAgain=temp>>24; //get 1st byte
                                    tempOfByte=tempForAgain[7:0]; //get first byte
                                    tempOfAgain={24{tempForAgain[7]}}; //24 bit sign extend
                                    dataR={tempOfAgain, tempOfByte}; //concatenating 
                                end
                            default:
                                dataR=32'bx; //no value (error)
                              
                        endcase 
                    end
                3'b100: //lbu (unsigned)
                    begin
                        tempForLast=addr&(-4); //go to original addr
                        tempBits=addr&3; //get last two bits
                        tempForLast=tempForLast>>2; //to match with memory addres i.e 0->0, 4->1, 8->2 so on
                        case(tempBits)
                            2'b00: 
                                begin
                                    temp=dataFile[tempForLast]; //original data in temp variable
                                    tempOfByte=temp[7:0]; //get zero byte
                                    tempOfAgain={24{1'b0}}; //24 bit sign extend
                                    dataR={tempOfAgain, tempOfByte}; //concatenating 
                                end
                            2'b01:
                                begin
                                    temp=dataFile[tempForLast]; //original data in temp variable
                                    tempForAgain=temp>>8; //get 1st byte
                                    tempOfByte=tempForAgain[7:0]; //get first byte
                                    tempOfAgain={24{1'b0}}; //24 bit sign extend
                                    dataR={tempOfAgain, tempOfByte}; //concatenating 
                                end
                            2'b10:
                                begin
                                    temp=dataFile[tempForLast]; //original data in temp variable
                                    tempForAgain=temp>>16; //get 1st byte
                                    tempOfByte=tempForAgain[7:0]; //get first byte
                                    tempOfAgain={24{1'b0}}; //24 bit sign extend
                                    dataR={tempOfAgain, tempOfByte}; //concatenating 
                                end
                            2'b11:
                                begin
                                    temp=dataFile[tempForLast]; //original data in temp variable
                                    tempForAgain=temp>>24; //get 1st byte
                                    tempOfByte=tempForAgain[7:0]; //get first byte
                                    tempOfAgain={24{1'b0}}; //24 bit sign extend
                                    dataR={tempOfAgain, tempOfByte}; //concatenating 
                                end
                            default:
                                dataR=32'bx; //no value (error)
                              
                        endcase 
                    end
            endcase
        end
    end

   
    
     always_ff@(posedge clk) begin
        if(MemRW)//write for 1
            begin
                case(func3)
            3'b010: //sw
                begin
                    tempToTrace=addr>>2;
                    dataFile[tempToTrace]<=dataToOut;
                end 
            3'b001: //sh
                begin
                     dataFile[addr]<=dataToOut; //concatenating 
//                    tempForLast<=addr&(-4); //go to original addr
//                    tempBits<=addr&3; //get last two bits
//                    tempForLast<=tempForLast>>2; //to match with memory addres i.e 0->0, 4->1, 8->2 so on
//                    if(tempBits == 2'b00)
//                            begin
//                                temp<=dataFile[tempForLast]; //original data in temp variable
//                                tempOfFt<=temp[31:16]; //get second 2 bytes
//                                tempAgain<=dataW[15:0]; //first 2 bytes
//                                tempForAgain<={tempOfFt, tempAgain}; //concatenatingg 
//                                dataFile[addr]<=tempForAgain;
////                                        $fwrite(fd, tempForAgain);
//                            end
//                     else 
//                            begin
//                                temp<=dataFile[tempForLast]; //original data in temp variable
//                                tempOfFt<=temp[15:0]; //get first 2 bytes
//                                tempAgain<=dataW[31:16]; //second 2 bytes
//                                dataFile[addr]<={tempAgain, tempOfFt}; //concatenatingg 
////                                        $fwrite(fd, {tempAgain, tempOfFt});
//                            end
                end
            3'b000: //sb (signed)
                begin
//                dataFile[addr]<=dataToOut;
                    case(tempBits)
                        2'b00: 
                            begin
                                dataFile[addr]<=dataToOut; //concatenating 
                            end
                        2'b01:
                            begin
                                dataFile[addr]<=dataToOut; //concatenating 
                            end
                        2'b10:
                            begin
                                dataFile[addr]<=dataToOut; //concatenating
                            end
                        2'b11:
                            begin
                                dataFile[addr]<=dataToOut; //concatenating
                            end
                        default:
                            dataFile[addr] <= dataFile[addr];
                          
                    endcase 
                end
        endcase
            end
    end
    
endmodule
