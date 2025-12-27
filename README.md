# systollic_array_4x4

In this project, I designed and verified a **4×4 systolic array accelerator** in SystemVerilog that performs matrix–matrix multiplication using **16-bit fixed-point arithmetic**. I also built the full system around the array, including memories, a controller, a testbench, and evaluated the design’s **power, performance, and area (PPA)**.

---

## Project Overview

My goal was to implement a complete hardware accelerator, not just the compute core. The design includes:

- A **4×4 systolic array** composed of processing elements (PEs)
- Two input memories (A and B) that feed data into the array
- An instruction memory that controls execution
- An output memory to store results
- A controller that orchestrates data movement and computation
- A full SystemVerilog testbench and Python golden model for verification

The system supports multiple matrix sizes through an instruction stream and follows a clean `ap_start / ap_done` execution model.

---

## Fixed-Point Arithmetic

The design uses **16-bit fixed-point Q16.0 arithmetic**:
- Inputs (`a_i`, `b_i`) are signed 16-bit integers
- Each PE performs a **16×16 → 32-bit multiply**
- Accumulation is done using a wider internal accumulator
- Results are **saturated to signed 16-bit** (`[-32768, 32767]`) at the output
. 
This approach keeps the hardware simple and efficient while matching typical systolic-array behavior.

---

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
    
---

## Testbench Waveform
Memory A and Memory B each contain **64 addressable locations** (address range **0–63**).

### 1. Filling Memory A

As shown in **Figure 1 (pic1)** and **Figure 2 (pic2)**, the first step in the testbench is to initialize **Memory A**.  
All **64 entries of Memory A** are written sequentially using the signals **`enA`**, **`addrA`**, and **`dataA`**, which are highlighted in **blue** in the waveform.  
The data values are loaded from `a_file.txt` into addresses **0 through 63**.

![Figure 1: Memory A initialization waveform](pic1.png)

![Figure 2: Continued Memory A initialization waveform](pic2.png)

---

### 2. Filling Memory B

After Memory A is fully initialized, the testbench proceeds to initialize **Memory B**. ( shown in **Figure 3 (pic3)** and **Figure 4 (pic4)**)
Memory B is written using the signals **`enB`**, **`addrB`**, and **`dataB`**, which are highlighted in **yellow** in the waveform.  
The data values for Memory B are loaded from `b_file.txt`.
![Figure 3: Memory A initialization waveform](pic3.png)

![Figure 4: Continued Memory A initialization waveform](pic4.png)

Although Memory A and Memory B support **simultaneous writes** through independent write interfaces, they are intentionally initialized **separately in the testbench**. This choice keeps the waveform cleaner and makes the memory initialization process easier to follow and debug.

