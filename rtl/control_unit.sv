`timescale 1ns / 1ps

module control_unit(
    input [8:0] inst,
    input BrEq, BrLt,
    output logic PCSel,
    output logic [2:0] ImmSel,
    output logic BrUn, ASel, BSel,
    output logic [3:0] ALUSel,
    output logic MemRW, RegWEn,
    output logic [2:0] WBSel 
    );
    
    always_comb
        begin
            casex(inst)
                9'bx01000000: //lw I-type
                    begin
                        PCSel=0; //PCSel (+4)
                        ASel=0; //reg data
                        BSel=1; //immediate data
                        ALUSel=4'b0000; //add
                        ImmSel=3'b000; //I-type
                        MemRW=0; //read
                        RegWEn=1; //write enable for reg file
                        WBSel=3'b000; //mem
			            BrUn=1'bx;
                    end
                9'bx00000000: //lb I-type
                    begin
                        PCSel=0; //PCSel (+4)
                        ASel=0; //reg data
                        BSel=1; //immediate data
                        ALUSel=4'b0000; //add
                        ImmSel=3'b000; //I-type
                        MemRW=0; //read
                        RegWEn=1; //write enable for reg file
                        WBSel=3'b000; //mem
			            BrUn=1'bx;
                    end
                9'bx00100000: //lh I-type
                    begin
                        PCSel=0; //PCSel (+4)
                        ASel=0; //reg data
                        BSel=1; //immediate data
                        ALUSel=4'b0000; //add
                        ImmSel=3'b000; //I-type
                        MemRW=0; //read
                        RegWEn=1; //write enable for reg file
                        WBSel=3'b000; //mem
			BrUn=1'bx;
                    end
                9'bx10000000: //lbu I-type
                    begin
                        PCSel=0; //PCSel (+4)
                        ASel=0; //reg data
                        BSel=1; //immediate data
                        ALUSel=4'b0000; //add
                        ImmSel=3'b000; //I-type
                        MemRW=0; //read
                        RegWEn=1; //write enable for reg file
                        WBSel=3'b000; //mem
			BrUn=1'bx;
                    end
                9'bx10100000: //lhu I-type
                    begin
                        PCSel=0; //PCSel (+4)
                        ASel=0; //reg data
                        BSel=1; //immediate data
                        ALUSel=4'b0000; //add
                        ImmSel=3'b000; //I-type
                        MemRW=0; //read
                        RegWEn=1; //write enable for reg file
                        WBSel=3'b000; //mem
			            BrUn=1'bx;
                    end
                9'bx00000100: //addi I-type
                    begin
                        PCSel=0; //PCSel (+4)
                        ASel=0; //reg data
                        BSel=1; //immediate data
                        ALUSel=4'b0000; //addi
                        ImmSel=3'b000; //I-type
                        MemRW=0; //read
                        RegWEn=1; //write enable for reg file
                        WBSel=3'b001; //ALU
			            BrUn=1'bx;
                    end
                9'bx00100100: //slli I-type
                    begin
                        PCSel=0; //PCSel (+4)
                        ASel=0; //reg data
                        BSel=1; //immediate data
                        ALUSel=4'b0010; //slli 
                        ImmSel=3'b000; //I-type
                        MemRW=0; //read
                        RegWEn=1; //write enable for reg file
                        WBSel=3'b001; //ALU
			            BrUn=1'bx;
                    end
                9'bx01000100: //slti I-type
                    begin
                        PCSel=0; //PCSel (+4)
                        ASel=0; //reg data
                        BSel=1; //immediate data
                        ALUSel=4'b0011; //slti
                        ImmSel=3'b000; //I-type
                        MemRW=0; //read
                        RegWEn=1; //write enable for reg file
                        WBSel=3'b001; //ALU
			            BrUn=1'bx;
                    end
                9'bx01100100: //sltiu I-type
                    begin
                        PCSel=0; //PCSel (+4)
                        ASel=0; //reg data
                        BSel=1; //immediate data
                        ALUSel=4'b1001; //sltiu
                        ImmSel=3'b000; //I-type
                        MemRW=0; //read
                        RegWEn=1; //write enable for reg file
                        WBSel=3'b001; //ALU
			            BrUn=1'bx;
                    end
                9'bx10000100: //xor I-type
                    begin
                        PCSel=0; //PCSel (+4)
                        ASel=0; //reg data
                        BSel=1; //immediate data
                        ALUSel=4'b0100; //xori
                        ImmSel=3'b000; //I-type
                        MemRW=0; //read
                        RegWEn=1; //write enable for reg file
                        WBSel=3'b001; //ALU
			            BrUn=1'bx;
                    end
                9'b010100100: //srli I-type
                    begin
                        PCSel=0; //PCSel (+4)
                        ASel=0; //reg data
                        BSel=1; //immediate data
                        ALUSel=4'b0101; //srli
                        ImmSel=3'b000; //I-type
                        MemRW=0; //read
                        RegWEn=1; //write enable for reg file
                        WBSel=3'b001; //ALU
			            BrUn=1'bx;
                    end
                9'b110100100: //srai I-type
                    begin
                        PCSel=0; //PCSel (+4)
                        ASel=0; //reg data
                        BSel=1; //immediate data
                        ALUSel=4'b0110; //srai
                        ImmSel=3'b000; //I-type
                        MemRW=0; //read
                        RegWEn=1; //write enable for reg file
                        WBSel=3'b001; //ALU
			            BrUn=1'bx;
                    end
                9'bx11000100: //ori I-type
                    begin
                        PCSel=0; //PCSel (+4)
                        ASel=0; //reg data
                        BSel=1; //immediate data
                        ALUSel=4'b0111; //ori
                        ImmSel=3'b000; //I-type
                        MemRW=0; //read
                        RegWEn=1; //write enable for reg file
                        WBSel=3'b001; //ALU
			            BrUn=1'bx;
                    end
                9'bx11100100: //andi I-type
                    begin
                        PCSel=0; //PCSel (+4)
                        ASel=0; //reg data
                        BSel=1; //immediate data
                        ALUSel=4'b1000; //ori
                        ImmSel=3'b000; //I-type
                        MemRW=0; //read
                        RegWEn=1; //write enable for reg file
                        WBSel=3'b001; //ALU
			            BrUn=1'bx;
                    end
              
                9'bx00001000: //sb S-type
                    begin
                        PCSel=0; //PCSel (+4)
                        ASel=0; //reg data
                        BSel=1; //immediate data
                        ALUSel=4'b0000; //add
                        ImmSel=3'b001; //S-type
                        MemRW=1; //write
                        RegWEn=0; //read enable for reg file
                        WBSel=3'bx; 
                        BrUn=1'bx;
                    end
                9'bx00101000: //sh S-type
                    begin
                        PCSel=0; //PCSel (+4)
                        ASel=0; //reg data
                        BSel=1; //immediate data
                        ALUSel=4'b0000; //add
                        ImmSel=3'b001; //S-type
                        MemRW=1; //write
                        RegWEn=0; //read enable for reg file
                        WBSel=3'bx; 
                        BrUn=1'bx;
                    end
                9'bx01001000: //sw S-type
                    begin
                        PCSel=0; //PCSel (+4)
                        ASel=0; //reg data
                        BSel=1; //immediate data
                        ALUSel=4'b0000; //add
                        ImmSel=3'b001; //S-type
                        MemRW=1; //write
                        RegWEn=0; //read enable for reg file
                        WBSel=3'bx; 
                        BrUn=1'bx;
                    end
                9'b000001100: //add R-type
                    begin
                        PCSel=0; //PCSel (+4)
                        ASel=0; //reg data
                        BSel=0; //reg data
                        ALUSel=4'b0000; //add
                        MemRW=0; //read
                        RegWEn=1; //write enable for reg file
                        WBSel=3'b001; //ALU
                        ImmSel=2'bx; 
                        BrUn=1'bx;
                    end
                9'b100001100: //sub R-type
                    begin
                        PCSel=0; //PCSel (+4)
                        ASel=0; //reg data
                        BSel=0; //reg data
                        ALUSel=4'b0001; //sub
                        MemRW=0; //read
                        RegWEn=1; //write enable for reg file
                        WBSel=3'b001; //ALU
                        ImmSel=2'bx; 
                        BrUn=1'bx;
                    end
                9'bx00101100: //sll R-type
                    begin
                        PCSel=0; //PCSel (+4)
                        ASel=0; //reg data
                        BSel=0; //reg data
                        ALUSel=4'b0010; //sll
                        MemRW=0; //read
                        RegWEn=1; //write enable for reg file
                        WBSel=3'b001; //ALU
                        ImmSel=2'bx; 
                        BrUn=1'bx;
                    end
                9'bx01001100: //slt R-type
                    begin
                        PCSel=0; //PCSel (+4)
                        ASel=0; //reg data
                        BSel=0; //reg data
                        ALUSel=4'b0011; //slt
                        MemRW=0; //read
                        RegWEn=1; //write enable for reg file
                        WBSel=3'b001; //ALU
                        ImmSel=2'bx; 
                        BrUn=1'bx;
                    end
                9'bx01101100: //sltu R-type
                    begin
                        PCSel=0; //PCSel (+4)
                        ASel=0; //reg data
                        BSel=0; //reg data
                        ALUSel=4'b1001; //sltu
                        MemRW=0; //read
                        RegWEn=1; //write enable for reg file
                        WBSel=3'b001; //ALU
                        ImmSel=2'bx; 
                        BrUn=1'bx;
                    end
                9'bx10001100: //xor R-type
                    begin
                        PCSel=0; //PCSel (+4)
                        ASel=0; //reg data
                        BSel=0; //reg data
                        ALUSel=4'b0100; //xor
                        MemRW=0; //read
                        RegWEn=1; //write enable for reg file
                        WBSel=3'b001; //ALU
                        ImmSel=2'bx; 
                        BrUn=1'bx;
                    end
                9'b010101100: //srl R-type
                    begin
                        PCSel=0; //PCSel (+4)
                        ASel=0; //reg data
                        BSel=0; //reg data
                        ALUSel=4'b0101; //srl
                        MemRW=0; //read
                        RegWEn=1; //write enable for reg file
                        WBSel=3'b001; //ALU
                        ImmSel=2'bx; 
                        BrUn=1'bx;
                    end
                9'b110101100: //sra R-type
                    begin
                        PCSel=0; //PCSel (+4)
                        ASel=0; //reg data
                        BSel=0; //reg data
                        ALUSel=4'b0110; //sra
                        MemRW=0; //read
                        RegWEn=1; //write enable for reg file
                        WBSel=3'b001; //ALU
                        ImmSel=2'bx; 
                        BrUn=1'bx;
                    end
                9'bx11001100: //or R-type
                    begin
                        PCSel=0; //PCSel (+4)
                        ASel=0; //reg data
                        BSel=0; //reg data
                        ALUSel=4'b0111; //or
                        MemRW=0; //read
                        RegWEn=1; //write enable for reg file
                        WBSel=3'b001; //ALU
                        ImmSel=2'bx; 
                        BrUn=1'bx;
                    end
                9'bx11101100: //and R-type
                    begin
                        PCSel=0; //PCSel (+4)
                        ASel=0; //reg data
                        BSel=0; //reg data
                        ALUSel=4'b1000; //and
                        MemRW=0; //read
                        RegWEn=1; //write enable for reg file
                        WBSel=3'b001; //ALU
                        ImmSel=2'bx; 
                        BrUn=1'bx;
                    end
		  9'bxxxx00101: //auipc U-type
                    begin
                        PCSel=0; //PCSel (+4)
                        ASel=1; //PC data
                        BSel=1; //immediate data
                        ALUSel=4'b0000; //add
                        ImmSel=3'b100; //U-type
                        MemRW=0; //read
                        RegWEn=1; //write enable for reg file
                        WBSel=3'b001; //ALU
			            BrUn=1'bx;
                    end
                9'bxxxx01101: //lui U-type
                    begin
                        PCSel=0; //PCSel (+4)
                        ASel=1; //PC data
                        BSel=1; //immediate data
                        ALUSel=4'b1010; //lui
                        ImmSel=3'b100; //U-type
                        MemRW=0; //read
                        RegWEn=1; //write enable for reg file
                        WBSel=3'b001; //ALU
			            BrUn=1'bx;
                    end
                9'bx00011000: //beq B-type
                    begin
                        if(BrEq==0) //not equal
                            begin
                                PCSel=0; //PCSel (+4)
                                ASel=1; //PC data
                                BSel=1; //immediate data
                                ALUSel=4'b0000; //add
                                ImmSel=3'b011; //S-type
                                MemRW=0; //read
                                RegWEn=0; //read enable for reg file
                                BrUn=1'bx;
                                WBSel=3'bx; 
                            end
                        else
                            begin
                                PCSel=1; //ALU
                                ASel=1; //PC data
                                BSel=1; //immediate data
                                ALUSel=4'b0000; //add
                                ImmSel=3'b011; //S-type
                                MemRW=0; //read
                                RegWEn=0; //read enable for reg file
                                BrUn=1'bx;
                                WBSel=3'bx; 
                            end
                       // BrEq=0; //not equal
                        
                    end
                9'bx00111000: //bne B-type
                    begin
                        if(BrEq==0) //not equal
                            begin
                                PCSel=1; //ALU
                                ASel=1; //PC data
                                BSel=1; //immediate data
                                ALUSel=4'b0000; //add
                                ImmSel=3'b011; //B-type
                                MemRW=0; //read
                                RegWEn=0; //read enable for reg file
                                BrUn=0; //signed check
				                WBSel=3'bx; 
                            end
                        else
                            begin
                                PCSel=1; //PCSel (+4)
                                ASel=1; //PC data
                                BSel=1; //immediate data
                                ALUSel=4'b0000; //add
                                ImmSel=3'b011; //B-type
                                MemRW=0; //read
                                RegWEn=0; //read enable for reg file
                                BrUn=0; //signed check
				                WBSel=3'bx; 
                            end
                    end
                9'bx10011000: //blt B-type
                    begin
			if(BrLt==1)
		                begin
		                    PCSel=1; //ALU
		                    ASel=1; //PC data
		                    BSel=1; //immediate data
		                    ALUSel=4'b0000; //add
		                    ImmSel=3'b011; //B-type
		                    MemRW=0; //read
		                    RegWEn=0; //read enable for reg file
		                    BrUn=1'bx; //signed check
				            WBSel=3'bx; 
		                end
                    end
                9'bx10111000: //bge B-type
                    begin
			if(BrLt==0)
		                begin
		                    PCSel=1; //ALU
		                    ASel=1; //PC data
		                    BSel=1; //immediate data
		                    ALUSel=4'b0000; //add
		                    ImmSel=3'b011; //B-type
		                    MemRW=0; //read
		                    RegWEn=0; //read enable for reg file
		                    BrUn=1'bx; //signed check
				WBSel=3'bx; 
		                end
                    end
                9'bx11011000: //bltu B-type
                    begin
			if(BrLt==1)
			begin
		                PCSel=1; //PCSel (+4)
		                ASel=1; //PC data
		                BSel=1; //immediate data
		                ALUSel=4'b0000; //add
		                ImmSel=3'b011; //B-type
		                MemRW=0; //read
		                RegWEn=0; //read enable for reg file
		                BrUn=1; //unsigned check
				        WBSel=3'bx; 
			end
                    end
                9'bx11111000: //bgeu B-type
                    begin
			if(BrLt==1)
			begin
		                PCSel=1; //PCSel (+4)
		                ASel=1; //PC data
		                BSel=1; //immediate data
		                ALUSel=4'b0000; //add
		                ImmSel=3'b011; //B-type
		                MemRW=0; //read
		                RegWEn=0; //read enable for reg file
		                BrUn=1; //unsigned check
				        WBSel=3'bx; 
			end
                    end
                9'bxxxx11011: //jal J-type
                    begin
                        PCSel=1; //ALU
                        ASel=1; //PC data
                        BSel=1; //immediate data
                        ALUSel=4'b0000; //add
                        ImmSel=3'b010; //J-type
                        MemRW=0; //read
                        RegWEn=1; //write enable for reg file
                        WBSel=3'b010; //PC+4
				        BrUn=1'bx;
                    end
                9'bx00010011: //jalr I-type
                    begin
                        PCSel=1; //ALU
                        ASel=1; //PC data
                        BSel=1; //immediate data
                        ALUSel=4'b0000; //add
                        ImmSel=3'b000; //I-type
                        MemRW=0; //read
                        RegWEn=1; //write enable for reg file
                        WBSel=3'b010; //PC+4
				        BrUn=1'bx;
                    end
            endcase
        end
    
endmodule
