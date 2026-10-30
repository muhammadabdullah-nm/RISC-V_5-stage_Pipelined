`timescale 1ns / 1ps

module top(
    input clk, reset
);
    logic RegWEn, BSel;
    logic MEMRW;
    logic [2:0] WBSel;
    logic [3:0] ALUSel;
    logic [31:0] dataWmem;
    logic [2:0] typeOfInstr;
    logic PCMux, data1Mux;
    logic [2:0] lastMuxSel;
    logic BrUn;

    parameter IMEM_DEPTH = 32;
    parameter REGF_WIDTH = 5;
    parameter ALU_WIDTH = 32;
    parameter PROG_VALUE = 32;
    parameter DATA_WIDTH = 32;
    
    logic [31:0] A, B;
    logic Eq, Lt;
    
    logic [PROG_VALUE-1:0] prg_count, PCOut;
    logic [PROG_VALUE-1:0] prg_countAdd;

    logic [31:0] muxOutPC;
    logic [ALU_WIDTH-1:0] alu_out;
    
    logic reg_wEn_o_wb;
    
    //<--------------------------CONTROL UNIT---------------------------->
    
    control_unit controlUnitDUT(
    .inst({instruction[30],instruction[14:12], instruction[6:2]}),
    .BrEq(Eq), .BrLt(Lt),
    .PCSel(PCMux),
    .ImmSel(typeOfInstr),
    .BrUn(BrUn), 
    .ASel(data1Mux), 
    .BSel(BSel),
    .ALUSel(ALUSel),
    .MemRW(MEMRW),
    .RegWEn(RegWEn),
    .WBSel(lastMuxSel) 
    );
    
    logic [DATA_WIDTH-1:0] reg_type_of_intr_o;

    pipe_reg #(.width_i(DATA_WIDTH), .width_o(DATA_WIDTH)) reg_type_of_instr(
         .clk(clk), .reset(reset),
        .reg_i(typeOfInstr),
        .reg_o(reg_type_of_intr_o)
        );
        
    logic reg_wEn_o;

    pipe_reg #(.width_i(1), .width_o(1)) reg_wEn(
         .clk(clk), .reset(reset),
        .reg_i(RegWEn),
        .reg_o(reg_wEn_o)
        );
        
    logic reg_BrUn_o_dec;

    pipe_reg #(.width_i(1), .width_o(1)) reg_BrUn(
         .clk(clk), .reset(reset),
        .reg_i(BrUn),
        .reg_o(reg_BrUn_o_dec)
        );
        
    logic reg_BSel_o_dec;

    pipe_reg #(.width_i(1), .width_o(1)) reg_BSel(
         .clk(clk), .reset(reset),
        .reg_i(BSel),
        .reg_o(reg_BSel_o_dec)
        );
        
    logic reg_ASel_o_dec;

    pipe_reg #(.width_i(1), .width_o(1)) reg_ASel(
         .clk(clk), .reset(reset),
        .reg_i(data1Mux),
        .reg_o(reg_ASel_o_dec)
        );
        
    logic [3:0] reg_ALUSel_o_dec;

    pipe_reg #(.width_i(4), .width_o(4)) reg_ALU(
         .clk(clk), .reset(reset),
        .reg_i(ALUSel),
        .reg_o(reg_ALUSel_o_dec)
        );
    
    logic reg_MemRW_o_dec;

    pipe_reg #(.width_i(1), .width_o(1)) reg_MemRW(
         .clk(clk), .reset(reset),
        .reg_i(MEMRW),
        .reg_o(reg_MemRW_o_dec)
        );
        
    logic [2:0] reg_WBSel_o_dec;

    pipe_reg #(.width_i(3), .width_o(3)) reg_WBSel(
         .clk(clk), .reset(reset),
        .reg_i(lastMuxSel),
        .reg_o(reg_WBSel_o_dec)
        );
    
    //pipeline regeister from Instruction Fetch to Instruction Decode
    //program counter
    //instruction
    
    
    logic [ALU_WIDTH-1:0] reg_alu_out_o;
    
    //<-----------------INSTRUCTION FETCH------------------->
    logic PCWrite, IFDWrite;
    logic muxSel;
    
    hazard_detection hazard_unit(
    .PCWrite(PCWrite), 
    .IFDWrite(IFDWrite),
    .muxSel(muxSel),
    .IdExMemRead(reg_wEn_o),
    .rs1(reg_instruction_o[19:15]), 
    .rs2(reg_instruction_o[24:20]), 
    .rd(reg_instr_ex_o[11:7])
    );
    
    logic reg_WEn_mux_out;
    
    mux2x1 muxControlReg(
        .Bsel(muxSel),
        .data2(1'b0),  //stall
        .immGen(reg_wEn_o),
        .outALU(reg_WEn_mux_out)
    );
    
    logic mem_WEn_mux_out;
    
    mux2x1 muxControlMem(
        .Bsel(muxSel),
        .data2(1'b0),  //stall
        .immGen(reg_MemRW_o_dec),
        .outALU(mem_WEn_mux_out)
    );
    
    
    
    //<-----------------INSTRUCTION FETCH------------------->
    
    
//    logic [DATA_WIDTH-1:0] reg_type_of_intr_o_dec;

//    pipe_reg #(.width_i(DATA_WIDTH), .width_o(DATA_WIDTH)) reg_type_of_instr_dec(
//         .clk(clk), .reset(reset),
//        .reg_i(reg_type_of_intr_o),
//        .reg_o(reg_type_of_intr_o_dec)
//        );
        
     
    mux2x1 muxPC(
        .Bsel(PCMux),
        .data2(prg_countAdd), 
        .immGen(reg_alu_out_o),
        .outALU(PCOut)
    );
    
    program_counter pc
    (
     .clk(clk), .reset(reset),
     .PCWrite(PCWrite),
     .PCOut(PCOut),
     .prg_count(prg_count), .prg_countAdd(prg_countAdd)
        );
    
    //pipeline register for program counter
    logic [PROG_VALUE-1:0] reg_prg_count_dec;

    pipe_reg #(.width_i(PROG_VALUE), .width_o(PROG_VALUE)) reg_prog_count(
         .clk(clk), .reset(reset),
        .reg_i(prg_count),
        .reg_o(reg_prg_count_dec)
        );
    
    logic [31:0] instruction;

    inst_mem
    #(.IMEM_DEPTH(IMEM_DEPTH)) im 
    (.addr(prg_count),
     .IFDWrite(IFDWrite),
     .dataR(instruction));
//(.addr(prg_count - 32'h8000_0000), .dataR(instruction));

    logic [32-1:0] reg_instruction_o;

    pipe_reg #(.width_i(32), .width_o(32)) reg_instr(
         .clk(clk), .reset(reset),
        .reg_i(instruction),
        .reg_o(reg_instruction_o)
        );
    
//    parameter width_i=16;
//    parameter width_o=8;
    
    
    //<-----------------INSTRUCTION DECODE------------------->
    
    logic [1:0] sel;
    logic [32-1:0] in0, in1, in2, in3;
    logic [32-1:0] outMux4x1;

    logic [DATA_WIDTH-1:0] dataW;
    logic [REGF_WIDTH -1:0] rs1, rs2, rsW;
    logic [DATA_WIDTH-1:0] data1, data2;
    
    logic reg_wEn_o_dec;

    pipe_reg #(.width_i(1), .width_o(1)) reg_wEn_dec(
         .clk(clk), .reset(reset),
        .reg_i(reg_WEn_mux_out),
        .reg_o(reg_wEn_o_dec)
        );
        
         
    logic reg_BrUn_o_ex;

    pipe_reg #(.width_i(1), .width_o(1)) reg_BrUn_dec(
         .clk(clk), .reset(reset),
        .reg_i(reg_BrUn_o_dec),
        .reg_o(reg_BrUn_o_ex)
        );
       
    logic reg_wEn_o_mem;

    reg_file
    #(.REGF_WIDTH(REGF_WIDTH), .DATA_WIDTH(DATA_WIDTH) ) rf
    (.clk(clk), .reset(reset), 
    .dataW(outMux4x1), 
    .rs1(reg_instruction_o[19:15]), 
    .rs2(reg_instruction_o[24:20]), 
    .rsW(reg_instr_mem_wb_o[11:7]), 
    .data1(data1), 
    .data2(data2), 
    .RegWEn(reg_wEn_o_mem));
    
    logic [DATA_WIDTH-1:0] reg_data1_o;

    pipe_reg #(.width_i(DATA_WIDTH), .width_o(DATA_WIDTH)) reg_data1_ex(
         .clk(clk), .reset(reset),
        .reg_i(data1),
        .reg_o(reg_data1_o)
        );
        
    logic [DATA_WIDTH-1:0] reg_data2_o;

    pipe_reg #(.width_i(DATA_WIDTH), .width_o(DATA_WIDTH)) reg_data2_ex(
         .clk(clk), .reset(reset),
        .reg_i(data2),
        .reg_o(reg_data2_o)
        );
    
    logic [11:0] imm;
    logic [31:0] immUp;
    
    logic [DATA_WIDTH-1:0] mux_out, immGen, mux_out_data1;
    imm_gen immediate_block(
    .imm(reg_instruction_o),
    .typeOfInstr(reg_type_of_intr_o),
    .immUp(immGen)
    );
    
    logic [DATA_WIDTH-1:0] reg_imm_gen_ex_o;

    pipe_reg #(.width_i(DATA_WIDTH), .width_o(DATA_WIDTH)) reg_imm_gen_ex(
         .clk(clk), .reset(reset),
        .reg_i(immGen),
        .reg_o(reg_imm_gen_ex_o)
        );
        
    logic [PROG_VALUE-1:0] reg_prg_count_ex;

    pipe_reg #(.width_i(PROG_VALUE), .width_o(PROG_VALUE)) reg_prog_count_execute(
         .clk(clk), .reset(reset),
        .reg_i(reg_prg_count_dec),
        .reg_o(reg_prg_count_ex)
        );
    
    logic [DATA_WIDTH-1:0] reg_instr_ex_o;

    pipe_reg #(.width_i(DATA_WIDTH), .width_o(DATA_WIDTH)) reg_instr_execute(
         .clk(clk), .reset(reset),
        .reg_i(reg_instruction_o),
        .reg_o(reg_instr_ex_o)
        );
        
     
    logic reg_ASel_o_ex;

    pipe_reg #(.width_i(1), .width_o(1)) reg_ASel_dec(
         .clk(clk), .reset(reset),
        .reg_i(reg_ASel_o_dec),
        .reg_o(reg_ASel_o_ex)
        );
        
    logic reg_BSel_o_ex;

    pipe_reg #(.width_i(1), .width_o(1)) reg_BSel_dec(
         .clk(clk), .reset(reset),
        .reg_i(reg_BSel_o_dec),
        .reg_o(reg_BSel_o_ex)
        );
        
        
    logic [3:0] reg_ALUSel_o_ex;

    pipe_reg #(.width_i(4), .width_o(4)) reg_ALU_dec(
         .clk(clk), .reset(reset),
        .reg_i(reg_ALUSel_o_dec),
        .reg_o(reg_ALUSel_o_ex)
        );
        
     logic reg_MemRW_o_ex;

    pipe_reg #(.width_i(1), .width_o(1)) reg_MemRW_dec(
         .clk(clk), .reset(reset),
        .reg_i(mem_WEn_mux_out),
        .reg_o(reg_MemRW_o_ex)
        );
    
    logic [2:0] reg_WBSel_o_ex;

    pipe_reg #(.width_i(3), .width_o(3)) reg_WBSel_dec(
         .clk(clk), .reset(reset),
        .reg_i(reg_WBSel_o_dec),
        .reg_o(reg_WBSel_o_ex)
        );
    //<-----------------INSTRUCTION EXECUTE------------------->
      
    logic reg_wEn_o_ex;

    pipe_reg #(.width_i(1), .width_o(1)) reg_wEn_ex(
         .clk(clk), .reset(reset),
        .reg_i(reg_wEn_o_dec),
        .reg_o(reg_wEn_o_ex)
        );


    branchComp branchCompOk(
    .A(reg_data1_o), 
    .B(reg_data2_o),
    .BrUn(reg_BrUn_o_ex),
    .Eq(Eq), 
    .Lt(Lt)
    );
   
    
//    //bSel
//    mux2x1 mux(
//        .Bsel(reg_BSel_o_ex),
//        .data2(reg_data2_o), 
//        .immGen(reg_imm_gen_ex_o),
//        .outALU(mux_out)
//    );
    
//    //Asel
//    mux2x1 muxData1(
//        .Bsel(reg_ASel_o_ex),
//        .data2(reg_data1_o), 
//        .immGen(reg_prg_count_ex),
//        .outALU(mux_out_data1)
//    );
    
  
//    alu_logic #( .ALU_WIDTH(ALU_WIDTH)) alu
//    ( .data1(mux_out_data1), .data2(mux_out), .ALUSel(reg_ALUSel_o_ex), .dataW(alu_out));
    
       
     //bSel
    mux2x1 mux(
        .Bsel(reg_BSel_o_ex),
        .data2(reg_data2_o), 
        .immGen(reg_imm_gen_ex_o),
        .outALU(mux_out)
    );
    
    //Asel
    mux2x1 muxData1(
        .Bsel(reg_ASel_o_ex),
        .data2(reg_data1_o), 
        .immGen(reg_prg_count_ex),
        .outALU(mux_out_data1)
    );
    
     logic [1:0] fwdA, fwdB;
    
    logic [DATA_WIDTH-1:0] reg_instr_mem_o;
    logic [DATA_WIDTH-1:0] reg_instr_mem_wb_o;
    
    
    fwd_logic fwd_logic_unit(
     .exMemRegWEn(reg_wEn_o_mem), 
     .memWBRegWEn(reg_wEn_o_wb),
     .exMemRd(reg_instr_mem_o[11:7]), 
     .memWBRd(reg_instr_mem_wb_o[11:7]), 
     .rs1(reg_instr_ex_o[19:15]), 
     .rs2(reg_instr_ex_o[24:20]), 
     .fwdA(fwdA), 
     .fwdB(fwdB)
    );
    
    logic [ALU_WIDTH-1:0] reg_alu_out_wb_o;
    logic [31:0] data1_to_alu_fwdA, data1_to_alu_fwdB;
    
    mux4x1 muxFwdA(
        .sel({1'b0,fwdA}),
        .in0(reg_alu_out_o), //execute fwdA
        .in1(outMux4x1),  //memory fwdA
        .in2(mux_out_data1),  //simple
        .in3(in3),
        .outMux4x1(data1_to_alu_fwdA)
    );
    
    mux4x1 muxFwdB(
        .sel({1'b0,fwdB}),
        .in0(reg_alu_out_o), 
        .in1(outMux4x1), 
        .in2(mux_out), 
        .in3(in3),
        .outMux4x1(data1_to_alu_fwdB)
    );
  
    alu_logic #( .ALU_WIDTH(ALU_WIDTH)) alu
    ( .data1(data1_to_alu_fwdA), .data2(data1_to_alu_fwdB), .ALUSel(reg_ALUSel_o_ex), .dataW(alu_out));
    
    logic [PROG_VALUE-1:0] reg_prg_count_mem_o;

    pipe_reg #(.width_i(PROG_VALUE), .width_o(PROG_VALUE)) reg_prog_count_memory(
         .clk(clk), .reset(reset),
        .reg_i(reg_prg_count_ex),
        .reg_o(reg_prg_count_mem_o)
        );
        

    pipe_reg #(.width_i(ALU_WIDTH), .width_o(ALU_WIDTH)) reg_alu_out(
         .clk(clk), .reset(reset),
        .reg_i(alu_out),
        .reg_o(reg_alu_out_o)
        );
        
        
    logic [DATA_WIDTH-1:0] reg_data2_o_mem;

    pipe_reg #(.width_i(DATA_WIDTH), .width_o(DATA_WIDTH)) reg_data2_mem(
         .clk(clk), .reset(reset),
        .reg_i(reg_data2_o),
        .reg_o(reg_data2_o_mem)
        );
        

    pipe_reg #(.width_i(DATA_WIDTH), .width_o(DATA_WIDTH)) reg_instr_mem(
         .clk(clk), .reset(reset),
        .reg_i(reg_instr_ex_o),
        .reg_o(reg_instr_mem_o)
        );
        
    logic reg_MemRW_o_mem;

    pipe_reg #(.width_i(1), .width_o(1)) reg_MemRW_ex(
         .clk(clk), .reset(reset),
        .reg_i(reg_MemRW_o_ex),
        .reg_o(reg_MemRW_o_mem)
        );
        
      
    logic [2:0] reg_WBSel_o_mem;

//    pipe_reg #(.width_i(3), .width_o(3)) reg_WBSel_ex(
//         .clk(clk), .reset(reset),
//        .reg_i(reg_WBSel_o_ex),
//        .reg_o(reg_WBSel_o_mem)
//        );
    
    //<-----------------MEMORY------------------->
   
    logic [31:0] dataR;
    
    logic [PROG_VALUE-1:0] prg_count_mem_to_wb;
    assign prg_count_mem_to_wb=reg_prg_count_mem_o+4;
    
    logic [PROG_VALUE-1:0] reg_prg_count_plus_four_wb_o;
    
    

    pipe_reg #(.width_i(1), .width_o(1)) reg_wEn_mem(
         .clk(clk), .reset(reset),
        .reg_i(reg_wEn_o_ex),
        .reg_o(reg_wEn_o_mem)
        );

    pipe_reg #(.width_i(PROG_VALUE), .width_o(PROG_VALUE)) reg_prog_count_wb(
         .clk(clk), .reset(reset),
        .reg_i(prg_count_mem_to_wb),
        .reg_o(reg_prg_count_plus_four_wb_o)
        );
       
    
    data_mem dataMemDUT(
        .addr(reg_alu_out_o),
        .dataW(reg_data2_o_mem),
        .clk(clk), 
        .reset(reset), 
        .MemRW(reg_MemRW_o_mem),
        .func3(reg_instr_mem_o[14:12]),
        .dataR(dataR)
        );
           
    logic [DATA_WIDTH-1:0] reg_data_mem_wb_o;

    pipe_reg #(.width_i(DATA_WIDTH), .width_o(DATA_WIDTH)) reg_data_mem_wb(
         .clk(clk), .reset(reset),
        .reg_i(dataR),
        .reg_o(reg_data_mem_wb_o)
        );
       

    pipe_reg #(.width_i(ALU_WIDTH), .width_o(ALU_WIDTH)) reg_alu_out_wb(
         .clk(clk), .reset(reset),
        .reg_i(reg_alu_out_o),
        .reg_o(reg_alu_out_wb_o)
        );
        
        

    pipe_reg #(.width_i(DATA_WIDTH), .width_o(DATA_WIDTH)) reg_instr_mem_wb(
         .clk(clk), .reset(reset),
        .reg_i(reg_instr_mem_o),
        .reg_o(reg_instr_mem_wb_o)
        );
             
    logic [2:0] reg_WBSel_o_wb;

    pipe_reg #(.width_i(3), .width_o(3)) reg_WBSel_mem(
         .clk(clk), .reset(reset),
        .reg_i(reg_WBSel_o_mem),
        .reg_o(reg_WBSel_o_wb)
        );
        
    //<-----------------WRITE BACK------------------->
   
    

    pipe_reg #(.width_i(1), .width_o(1)) reg_wEn_wb(
         .clk(clk), .reset(reset),
        .reg_i(reg_wEn_o_mem),
        .reg_o(reg_wEn_o_wb)
        );

   
    logic [32-1:0] mux_out2;
    
    mux4x1 muxlast(
        .sel(reg_WBSel_o_ex),
        .in0(reg_data_mem_wb_o), 
        .in1(reg_alu_out_wb_o), 
        .in2(reg_prg_count_plus_four_wb_o), 
        .in3(in3),
        .outMux4x1(outMux4x1)
    );

    // Connecting ALU output to dataW
//    assign dataW = mux_out2;
    

//	tracer tracer_ip (
//	.clk_i(clk),
//	.rst_ni(reset),
//	.hart_id_i(32'b0),
//	.rvfi_valid(1'b1),
//	.rvfi_insn_t(instruction),
//	.rvfi_rs1_addr_t(instruction[19:15]),
//	.rvfi_rs2_addr_t(instruction[24:20]),
//	.rvfi_rs1_rdata_t(data1),
//	.rvfi_rs2_rdata_t(data2),
//	.rvfi_rd_addr_t(instruction[11:7]) ,
//	.rvfi_rd_wdata_t(outMux4x1),
//	.rvfi_pc_rdata_t(prg_count),
//	.rvfi_pc_wdata_t(PCOut),
//	.rvfi_mem_addr(0),
//	.rvfi_mem_rmask(0),
//	.rvfi_mem_wmask(0),
//	.rvfi_mem_rdata(0),
//	.rvfi_mem_wdata(0)
//	);
   
  

endmodule
