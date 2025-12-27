# systollic_array_4x4

In this project, I designed and verified a **4×4 systolic array accelerator** in Verilog that performs matrix–matrix multiplication using **16-bit fixed-point arithmetic**. I also built the full system around the array, including memories, a controller, a testbench, and evaluated the design’s **power, performance, and area (PPA)**.

---

## Project Overview

My goal was to implement a complete hardware accelerator, not just the compute core. The design includes:

- A **4×4 systolic array** composed of processing elements (PEs)
- Two input memories (A and B) that feed data into the array
- An instruction memory that controls execution
- An output memory to store results
- A controller that orchestrates data movement and computation
- A full Verilog testbench and Python golden model for verification

The system supports multiple matrix sizes through an instruction stream and follows a clean `ap_start / ap_done` execution model.

---

## Fixed-Point Arithmetic

The design uses **16-bit fixed-point Q16.0 arithmetic**:
- Inputs (`a_i`, `b_i`) are signed 16-bit integers
- Each PE performs a **16×16 → 32-bit multiply**
- Accumulation is done using a wider internal accumulator
- Results are **saturated to signed 16-bit** (`[-32768, 32767]`) at the output

This approach keeps the hardware simple and efficient while matching typical systolic-array behavior.

---

## Instruction-Driven Execution

I use an **instruction memory** to control which matrix sizes are executed.

- Each instruction is an integer representing matrix size `N`
- Instruction `0` marks the end of execution
- For a non-zero instruction `N`, the accelerator performs:
  - **(N×4) × (4×N) → (N×N)** matrix multiplication
