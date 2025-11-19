# Digital-Adder-Family
Implementation of a complete family of digital adders, from basic logic gates to a fully hierarchical 64-bit Carry Lookahead Adder (CLA) in Verilog RTL. Includes testbenches, CMOS transistor-level design, LTspice simulations, and propagation delay analysis.

The `ReportV2.pdf` file provides the full documentation of the project.

---

# Project Overview

This repository contains:
- Complete Verilog RTL implementation:
  - Full Adder
  - Ripple-Carry Adders (N-bit)
  - 4-bit CLA
  - 16-bit hierarchical CLA
  - 64-bit hierarchical CLA
- Testbenches (exhaustive + randomized).
- CMOS transistor-level implementations in LTspice of basic gates, FA 42T and FA 28T, with automatic delay measurements.

---

# Verification Overview (Verilog)

## Full Adder (FA), N-bit Ripple-Carry Adder and 4-bit CLA
- Exhaustive test: all input combinations. For N-bit RCA, parameter N is set at default N=8, which tests all 65,536 combinations.
- For N-bit RCA: comparison against `A + B + cin` using Verilog arithmetic.

## 64-bit CLA
- Randomized testbench with:
  - Overflow detection (unsigned operands).
  - Colored output.
  - Comparison against `A + B + cin` using Verilog arithmetic.

---

# CMOS Transistor-Level Simulation (LTspice)

## Provided circuits
- Inverter and basic Gates: AND2, OR2, NAND2, NOR2, OR4, AND4, NOR4, XOR (12T)
- Full Adder 42T
- Optimized Full Adder 28T

---

# How to Run the Project
This repository includes both Verilog and LTspice simulations.

---

## Requirements

### Verilog simulation
Icarus Verilog  
https://bleyer.org/icarus/

GTKWave  
https://gtkwave.sourceforge.net/

### LTspice simulation
LTspice XVII  
https://www.analog.com/en/resources/design-tools-and-calculators/ltspice-simulator.html

---

## Running the Verilog Testbenches

Navigate to the repository root and compile:

### Full Adder
```bash
iverilog -o FullAdderTest.vvp Verilog/full_adder.v Verilog/testbench/full_adder_tb.v
```

### N-bit RCA
```bash
iverilog -o RCATest.vvp Verilog/adderNbits.v Verilog/testbench/adderNbits_tb.v
```

### 4-bit CLA
```bash
iverilog -o CLA4bitsTest.vvp Verilog/adder4bitsCLA.v Verilog/testbench/adder4bitsCLA_tb.v
```

### 64-bit CLA (requires SystemVerilog syntax)
```bash
iverilog -g2012 -o CLA64Test.vvp Verilog/Adder64bitsCLA.v Verilog/testbench/Adder64bitsCLA_tb.v
```
-g2012 is required because the 64-bit testbench uses SystemVerilog constructs.

### Running the compiled simulation:
```bash
vvp FullAdderTest.vvp
vvp RCATest.vvp
vvp CLA4bitsTest.vvp
vvp CLA64Test.vvp
```

All testbenches already include the necessary $dumpfile and $dumpvars statements.
If you compile normally with Icarus Verilog, a .vcd file will be generated automatically.

### Viewing waveforms with GTKWave

To view the waveform execute one of these after compiling:
```bash
gtkwave full_adder.vcd
gtkwave addNbits.vcd
gtkwave carry_lookahead_4bit.vcd
gtkwave add64bitsCLA.vcd
```
## Running LTspice Simulations

    Open any .asc file in LTspice

    Press the Run icon

    View waveforms

    For delay measurements:
    Go to View → SPICE Output Log

You will see entries such as:


T_PLH = -4.82558687789e-09 FROM 1.50760560898e-08 TO 1.02504692119e-08

T_PHL = -1.504728605e-08 FROM 2.0112935272e-08 TO 5.06564922202e-09

(Values may appear negative due to internal reference points of LTspice; only magnitudes matter.)

