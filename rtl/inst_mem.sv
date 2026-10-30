`timescale 1ns / 1ps

module inst_mem
#(parameter IMEM_DEPTH=32)
(
input [31:0] addr,
input IFDWrite,
output logic [31:0] dataR
    );
    logic [31:0] tempaddr;
    
    reg [32-1:0] instrFile [IMEM_DEPTH-1:0];
    initial
    begin
        $readmemh("reg_im.mem", instrFile); 
    end

    always_comb
    begin 
        if(IFDWrite)
            begin
                tempaddr={2'b00,addr[31:2]};
                dataR=instrFile[tempaddr];
            end
        else  //stall
            dataR=dataR;
    end
endmodule
