# RV32I PipeLine Implementation

## Overview
This project implements a pipeline datapath for the RV32I architecture, supporting all instructions. NEXYS NOT SUPPORTED

## Authors
- **Aly Elaswad** (alyelaswad@aucegypt.edu)
- **Ismail Sabry** (ismailsabry@aucegypt.edu)


### What Works?
All RV32I instructions are supported.
## Module Description
### Inputs
- `ssdclk`: Clock signal.
- `rst`: Reset signal.


### Internal Signals
The module contains various internal signals for:
- Instruction processing.
- ALU operations.
- Control Unit.

## Functionality
### Datapath Components
- **Program Counter (PC)**: Tracks the current instruction address and updates based on instruction execution.
- **Instruction Memory**: Fetches instructions using the PC.
- **Control Unit**: Generates control signals for managing data flow and execution.
- **Register File**: Facilitates data reading and writing between registers.
- **Immediate Generator**: Produces immediate values from instructions.
- **ALU (Arithmetic Logic Unit)**: Executes arithmetic and logical operations based on control signals.
- **Data Memory**: Handles data read/write operations.


## Coding Structure
The main logic is organized in always blocks, combinational logic, and instantiations of other modules, including:
- **N-bit registers** for holding values.
- **Control units** for generating necessary signals.
- **ALU and  Memory** modules for execution and single memory handling.

### Example Instantiation
```verilog
Datapath myDatapath (
    .clk(clk),
    .rst(rst),
    .ledsel(ledsel),
    .ssdSel(ssdSel),
    .ssdClk(ssdClk),
    .leds(leds),
    .Anode(Anode),
    .ssd_out(ssd_out)
);
