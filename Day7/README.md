# ⚙️ Day 7 — 2:4 Decoder (Dataflow Modeling)

## 📘 Topics Understood

  * **Decoder Logic** 
  * **Dataflow Modelling** 

-----

## 🧠 Description

The combinational circuit that changes the binary information into $2^N$ output lines is known as a **decoder**. The binary information is passed in the form of N input lines. The output lines define the $2^N$ 
bit code for the binary information. This is the reverse process of encoding.

**Data flow modelling** is a medium-level abstraction, which is achieved by defining the data flow of the module. You can design the module by defining and expressing input signals, which are assigned to the
output, very much similar to logical expressions. A continuous assignment replaces gates in the circuit's description and describes the circuit at a higher level of abstraction. A continuous assignment 
statement starts with the keyword `assign`. Output is generally a wire, which means any change in input immediately changes the output.

-----

## 🧮 Equations

The logic for a decoder is based on its **minterms**. Each output line corresponds to one unique combination of the inputs.

  * $B_0 = \sim A_1 \cdot \sim A_0$
  * ...and so on up to...
  * $B_3 = A_1 \cdot A_0$

-----

## 🧩 Circuit Diagram

<img width="574" height="416" alt="image" src="https://github.com/user-attachments/assets/24b86b5c-c4d8-40fc-b32f-fdeb49294b4c" />

-----

## 🧾 Truth Table (3:8 Decoder)

| **A[1]** | **A[0]** | **B[3]** | **B[2]** | **B[1]** | **B[0]** |
|:---:|:---:|:---:|:---:|:---:|:---:|
| 0 | 0 | 0 | 0 | 0 | 1 |
| 0 | 1 | 0 | 0 | 1 | 0 |
| 1 | 0 | 0 | 1 | 0 | 0 |
| 1 | 1 | 1 | 0 | 0 | 0 |

-----

## 🧾 Verilog Design

  * **Design — `Day7/decoder.v`**
  * **Testbench — `Day7/Decoder_tb.v`**

-----

## ⚙️ RTL Design (Synthesis)

For this design, the synthesis tool creates three **NOT** gates (for `nA`) and four 2-input **AND** gates, one for each minterm `B[0]` to `B[3]`.

<img width="574" height="416" alt="image" src="https://github.com/user-attachments/assets/cefe312c-184b-4f4a-b4a9-8cf3d13daa85" />

-----

## 📊 Waveform

The waveform will show that as the 2-bit input `A` changes every 10ns, the 4-bit output `B` immediately updates, with only one bit being high at any time.

<img width="775" height="127" alt="image" src="https://github.com/user-attachments/assets/65fd9f7a-4fd0-43e9-943e-bd71defd1265" />

-----

## 🔍 Observations

  * The `$monitor` output from the testbench confirms the one-hot output for each input.
      * `For the encoded value 00 the decoded output will be 0001`
      * `For the encoded value 01 the decoded output will be 0010`
  * The design is purely combinational. Any change to `A` results in an immediate change to `B` in the simulation.
  * This is a "full" decoder, meaning every input combination has a corresponding output line.

-----

## 🧩 Industry Relevance

  * **Memory Addressing:** Decoders are essential for memory. An address from the CPU (e.g., 32 bits) is fed into a large decoder to select *which specific row* of memory cells to read from or write to.
  * **Instruction Decoding:** In a CPU, the "opcode" of an instruction is fed into a decoder. The activated output line then enables the correct circuit (e.g., the ALU, the load/store unit) to execute that instruction.
  * **Chip Select:** Used in SoCs to select which peripheral (e.g., UART, SPI, I2C) the CPU wants to communicate with on a shared bus.

-----

  * ✅ **Status:** Completed
  * 🗓 **Day:** 7 / 100
  * 📚 **Next:** [Day 8 – D & JK Flip-Flops →](../Day8)
