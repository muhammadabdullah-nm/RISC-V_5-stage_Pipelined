# RISC-V 5-Stage Pipelined Core

A 5-stage pipelined **RISC-V (RV32I)** processor core written in Verilog. The design splits instruction execution across five stages so that up to five instructions are in flight at once, with hazard handling to keep results correct.

## Features

- 32-bit RISC-V base integer ISA (RV32I)
- Classic 5-stage pipeline: IF, ID, EX, MEM, WB
- Pipeline registers between every stage
- Data forwarding to resolve read-after-write hazards
- Hazard detection with stalling for load-use cases
- Pipeline flush on taken branches and jumps
- Testbench for simulation and waveform inspection

## Pipeline Overview

```
 +------+    +------+    +------+    +------+    +------+
 |  IF  | -> |  ID  | -> |  EX  | -> | MEM  | -> |  WB  |
 +------+    +------+    +------+    +------+    +------+
  Fetch      Decode      Execute     Memory      Write
  instr.     + reg read  ALU, branch access      back to
                         target                  reg file
```

| Stage | Name         | What happens                                                         |
|-------|--------------|----------------------------------------------------------------------|
| IF    | Fetch        | PC selects the next instruction from instruction memory; PC updates |
| ID    | Decode       | Control unit decodes the instruction; register file is read; immediate is generated |
| EX    | Execute      | ALU performs the operation; branch condition and target are computed |
| MEM   | Memory       | Loads and stores access data memory                                  |
| WB    | Write Back   | Result (ALU or memory data) is written to the register file          |

## Supported Instructions

| Type   | Instructions                                      |
|--------|---------------------------------------------------|
| R-type | `add` `sub` `and` `or` `xor` `sll` `srl` `sra` `slt` `sltu` |
| I-type | `addi` `andi` `ori` `xori` `slli` `srli` `srai` `slti` `sltiu` |
| Load   | `lw` (and `lb` `lh` `lbu` `lhu` if implemented)   |
| Store  | `sw` (and `sb` `sh` if implemented)               |
| Branch | `beq` `bne` `blt` `bge` `bltu` `bgeu`             |
| Jump   | `jal` `jalr`                                      |
| Upper  | `lui` `auipc`                                     |

## Repository Structure

```
RISC-V_5-stage_Pipelined/
├── rtl/    # Verilog design sources (datapath, control, hazard logic, memories)
├── tb/     # Testbench 
└── README.md
```


## Author

**Muhammad Abdullah**: [GitHub](https://github.com/muhammadabdullah-nm)
