# systollic_array_4x4

4×4 Systolic Array accelerator in Verilog with on-chip memories, instruction-driven controller, testbench, and PPA evaluation (power, performance, area).

## Project Goal
Design and verify a **4×4 systolic array** that performs matrix-matrix multiplication (MMM) using **16-bit fixed-point Q16.0** multiply-accumulate (MAC). The full system includes:
- 4×4 systolic array (processing elements)
- Memory A (data input)
- Memory B (data input)
- Instruction memory (matrix size sequence)
- Output memory (stores computed C results)
- Controller (drives memory read, systolic array flow, ap_start/ap_done)

## Requirements (from spec)
Your design contains:
- Systolic array supporting **16-bit fixed-point multiplication & accumulation**
- Two memory blocks feeding the array (A and B)
- Controller controlling memory + systolic array
- Output memory storing results
- Instruction memory storing matrix sizes

### Top-level IO
The top module uses:
- `clk`, `rst`
- `addrA`, `enA`, `dataA` (write Memory A)
- `addrB`, `enB`, `dataB` (write Memory B)
- `addrI`, `enI`, `dataI` (write Instruction Memory)
- `addrO`, `dataO` (read Output Memory)
- `ap_start` (pulse)
- `ap_done` (level)

## Fixed-Point Format
This implementation uses **Q16.0**:
- `a_i`, `b_i`: signed 16-bit integers
- Multiply: 16×16 → 32-bit signed product
- Accumulate: internal wider accumulator
- Output: saturated to signed 16-bit (`[-32768, 32767]`) when writing/reading results

> Note: “fixed-point” here is treated as integer fixed-point (no fractional bits).

## Instruction Behavior
Instruction is a 5-bit integer representing the matrix size `N`.

- If instruction is `0`: **end of execution**
- Otherwise: perform one MMM of size:
  - **N×4** multiplied by **4×N** → **N×N**

Example instruction stream:
- `[4, 8, 16]`
  - compute **4×4 = (4×4) × (4×4)**
  - compute **8×8 = (8×4) × (4×8)**
  - compute **16×16 = (16×4) × (4×16)**
