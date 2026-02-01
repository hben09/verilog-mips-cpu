# Verilog MIPS CPU

A Verilog implementation of both single-cycle and pipelined 32-bit MIPS processors, featuring hazard detection and data forwarding units.

## Project Structure

```
verilog-mips-cpu/
├── single_cycle_CPU_src/    # Single-cycle CPU implementation (13 modules)
├── pipelined_CPU_src/       # Pipelined CPU implementation (24 modules)
└── testbenches/             # Simulation testbenches
```

## Architectures

### Single-Cycle CPU

The single-cycle implementation executes one instruction per clock cycle, with all stages (fetch, decode, execute, memory access, write-back) completing in a single cycle.

**Key Modules:**
- `ALU.v` - 7-operation ALU (ADD, SUB, AND, OR, NOR, SLT, LUI)
- `control.v` - Main control unit generating 11 control signals
- `ALU_control.v` - ALU operation decoder
- `nbit_register_file.v` - 32 x 32-bit register file
- `InstrMem.v` - Instruction memory (32 words)
- `Memory.v` - Data memory (64K words)

### Pipelined CPU

The pipelined implementation features a classic 5-stage MIPS pipeline with hazard handling:

**Pipeline Stages:**
1. **IF** - Instruction Fetch
2. **ID** - Instruction Decode
3. **EX** - Execute
4. **MEM** - Memory Access
5. **WB** - Write Back

**Key Features:**
- **Hazard Detection Unit** (`hazardunit.v`) - Detects load-use hazards and stalls the pipeline
- **Forwarding Unit** (`forwardingunit.v`) - Data forwarding from EX/MEM and MEM/WB stages
- **Hi/Lo Registers** - Support for multiply operations with MFHI/MFLO instructions
- **Branch Flushing** - IF_Flush signal clears pipeline on branch taken

## Supported Instructions

### R-Type (Register Operations)
| Instruction | Funct | Description |
|-------------|-------|-------------|
| ADD | 32 | Add two registers |
| SUB | 34 | Subtract |
| AND | 36 | Bitwise AND |
| OR | 37 | Bitwise OR |
| NOR | - | Bitwise NOR (single-cycle) |
| SLT | 42 | Set Less Than |
| SLL | 0 | Shift Left Logical |
| SRL | 2 | Shift Right Logical |
| MULT | 24 | Multiply (pipelined) |
| MFHI | 16 | Move From Hi |
| MFLO | 18 | Move From Lo |

### I-Type (Immediate Operations)
| Instruction | Opcode | Description |
|-------------|--------|-------------|
| ADDI | 8 | Add immediate |
| ANDI | 12 | AND immediate |
| ORI | 13 | OR immediate |
| SLTI | 10 | Set Less Than Immediate |
| LUI | 15 | Load Upper Immediate |
| LW | 35 | Load Word |
| SW | 43 | Store Word |

### Branch/Jump
| Instruction | Opcode | Description |
|-------------|--------|-------------|
| BEQ | 4 | Branch if Equal |
| BNE | 5 | Branch if Not Equal |
| J | 2 | Unconditional Jump |

## Feature Comparison

| Feature | Single-Cycle | Pipelined |
|---------|--------------|-----------|
| Pipeline Stages | 1 | 5 |
| Register File | 32 x 32-bit | 32 x 32-bit |
| Instruction Memory | 32 words | Dynamic |
| Data Memory | 64K words | 64K words |
| ALU Operations | 7 | 9 + multiply |
| Hazard Detection | No | Yes |
| Data Forwarding | No | Yes |
| Hi/Lo Registers | No | Yes |

## Running Simulations

### Single-Cycle CPU
```bash
# Using Icarus Verilog
iverilog -o single_cycle_tb testbenches/tb_single_cycle.v single_cycle_CPU_src/*.v
vvp single_cycle_tb
```

### Pipelined CPU
```bash
# Using Icarus Verilog
iverilog -o pipelined_tb testbenches/tb_pipelined_cpu.v pipelined_CPU_src/*.v
vvp pipelined_tb
```

The testbenches include instruction sequences that test arithmetic operations, memory access, branching, and (for the pipelined version) hazard detection and forwarding.

## Module Reference

### Single-Cycle Modules
| Module | Description |
|--------|-------------|
| `single_cycle_cpu.v` | Top-level module |
| `ALU.v` | Arithmetic Logic Unit |
| `ALU_control.v` | ALU operation decoder |
| `control.v` | Main control unit |
| `nbit_register_file.v` | Register file |
| `InstrMem.v` | Instruction memory |
| `Memory.v` | Data memory |
| `mux.v` | 2-to-1 multiplexer |
| `sign_extend.v` | 16 to 32-bit sign extension |

### Pipelined Modules
| Module | Description |
|--------|-------------|
| `top.v` | Top-level module |
| `alu.v` | ALU with multiply support |
| `alucontrol.v` | ALU operation decoder |
| `pipecontrol.v` | Pipeline control unit |
| `RegFile.v` | Register file |
| `hazardunit.v` | Hazard detection |
| `forwardingunit.v` | Data forwarding |
| `multiplycontrol.v` | Hi/Lo register control |
| `reg_*.v` | Pipeline registers |
