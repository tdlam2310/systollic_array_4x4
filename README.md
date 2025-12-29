# 4×4 Systolic Array Accelerator

In this project, I designed and verified a **4×4 systolic array accelerator** in SystemVerilog that performs matrix–matrix multiplication using **16-bit fixed-point arithmetic**. I also built the full system around the array, including memories, a controller, a testbench, and evaluated the design’s **power, performance, and area (PPA)**.
![drawing](arch.drawio.png)
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
![Figure 3: Memory B initialization waveform](pic3.png)

![Figure 4: Continued Memory B initialization waveform](pic4.png)

Although Memory A and Memory B support **simultaneous writes** through independent write interfaces, they are intentionally initialized **separately in the testbench**. This choice keeps the waveform cleaner and makes the memory initialization process easier to follow and debug.

---

### 3. Filling Instruction Memory
The instruction is a **5-bit value** that can take one of the following values: **0, 4, 8, or 16**.  
Each instruction specifies the matrix size to be executed, where an instruction value of **0** indicates the end of execution.

The instruction memory contains **4 addressable locations**, corresponding to **`addrI = 0, 1, 2, 3`**.  
As shown in **Figure 5 (pic5)**, I initialize the instruction memory using the signals highlighted in **pink** in the waveform.

Specifically:
- Instruction **4** is written to address `addrI = 0`
- Instruction **8** is written to address `addrI = 1`
- Instruction **16** is written to address `addrI = 2`
- Instruction **0** is written to address `addrI = 3`

This instruction sequence causes the accelerator to perform a **4×4**, followed by an **8×8**, and then a **16×16** matrix multiplication, after which execution terminates.
![Figure 5: Filling instruction memory initialization](pic5.png)

### 4. Set ap_start to 1 to make the system work (refer to the light blue signal on waveform)
![Uploading image.png…](start.png)
### 5. ap_done toggles from 0 to 1, which signals that the system has finished (refer to the red signal on waveform)
![Uploading image.png…](done.png)
### 6. Set dataO from 0 to 255 to access the data saved in the memory output, then saved all the data into `c_out_file.txt` (refer to two orange signals addrO and dataO)
![drawing](firstdata.png)
![drawing](lastdata.png)
### 7. Use google colab to test with my Python model.
1. Navigate to the `sim/` directory.
2. Copy the provided Python code into `google_colab_test.py`.
3. Run the script in Google Colab to generate the input files `a_file.txt` and `b_file.txt`.
4. Use these files as inputs to the Vivado testbench.
5. The testbench generates `c_out_file.txt`, which is then imported back into Google Colab for result verification. You should download c_out_file.txt and put it into your google colab notebook before you run the python script.

## Architecture
Block diagram from vivado: we have memory_output that stores the output of the systollic array, instruction memory that stores instruction, and DUT block that contains the controller, two memory blocks A and B that feed the data into the array, and the 4x4 systollic array itself

### PICTURE 1: OVERALL Architecture
![Figure 6: Overall picture](design1.png)
### PICTURE 2: DUT that consists of the systollic array 4x4, memory A and B, and controller
![Figure 6: Overall picture](array_with_mem-and_controller.png)
