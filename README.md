# RV32I Single-Cycle Implementation

## Overview
This project implements a single-cycle datapath for the RV32I architecture, specifically designed for an alarm clock system. The implementation features instruction fetching, execution, and data memory operations, along with LED and 7-segment display outputs.

## Authors
- **Aly Elaswad** (alyelaswad@aucegypt.edu)
- **Ismail Sabry** (ismailsabry@aucegypt.edu)

## File: Datapath.v
The main module that manages the count for the alarm, clock, LED signals, and buzzer signal.

### Change History

## Module Description
### Inputs
- `clk`: Clock signal.
- `rst`: Reset signal.
- `ledsel`: Selector for LED outputs.
- `ssdSel`: Selector for 7-segment display outputs.
- `ssdClk`: Clock for the 7-segment display.

### Outputs
- `leds`: Output signals for LEDs.
- `Anode`: Anode control signals for the 7-segment display.
- `ssd_out`: Output for the 7-segment display.

### Internal Signals
The module contains various internal signals for:
- Instruction processing.
- ALU operations.
- Data memory interactions.

## Functionality
### Datapath Components
- **Program Counter (PC)**: Tracks the current instruction address and updates based on instruction execution.
- **Instruction Memory**: Fetches instructions using the PC.
- **Control Unit**: Generates control signals for managing data flow and execution.
- **Register File**: Facilitates data reading and writing between registers.
- **Immediate Generator**: Produces immediate values from instructions.
- **ALU (Arithmetic Logic Unit)**: Executes arithmetic and logical operations based on control signals.
- **Data Memory**: Handles data read/write operations.

### LED Display Management
The module controls a 7-segment display to show selected data, with the display updating based on input selection.

### Clock and Button Handling
Clock signals for button interactions and display refreshing are managed through dedicated clock dividers and push button detectors.

## Coding Structure
The main logic is organized in always blocks, combinational logic, and instantiations of other modules, including:
- **N-bit registers** for holding values.
- **Control units** for generating necessary signals.
- **ALU and data memory** modules for execution and data handling.

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
