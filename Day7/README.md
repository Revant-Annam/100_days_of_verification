# ⚙️ Day 7 — 3:8 Decoder (Dataflow Modeling)

## 📘 Topics Understood

  * **Decoder Logic** 
  * **Dataflow Modelling** 

-----

## 🧠 Description

The combinational circuit that changes the binary information into $2^N$ output lines is known as a **decoder**. The binary information is passed in the form of N input lines. The output lines define the $2^N$ bit code for the binary information. This is the reverse process of encoding.

**Data flow modelling** is a medium-level abstraction, which is achieved by defining the data flow of the module. You can design the module by defining and expressing input signals, which are assigned to the output, very much similar to logical expressions. A continuous assignment replaces gates in the circuit's description and describes the circuit at a higher level of abstraction. A continuous assignment statement starts with the keyword `assign`. Output is generally a wire, which means any change in input immediately changes the output.

-----

## 🧮 Equations

The logic for a decoder is based on its **minterms**. Each output line corresponds to one unique combination of the inputs.

  * $B_0 = \sim A_2 \cdot \sim A_1 \cdot \sim A_0$
  * $B_1 = \sim A_2 \cdot \sim A_1 \cdot A_0$
  * ...and so on up to...
  * $B_7 = A_2 \cdot A_1 \cdot A_0$

-----

## 🧾 Truth Table (3:8 Decoder)

| **A[2]** | **A[1]** | **A[0]** | **B[7]** | **B[6]** | **B[5]** | **B[4]** | **B[3]** | **B[2]** | **B[1]** | **B[0]** |
|:---:|:---:|:---:|:---:|:---:|:---:|:---:|:---:|:---:|:---:|:---:|
| 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 1 |
| 0 | 0 | 1 | 0 | 0 | 0 | 0 | 0 | 0 | 1 | 0 |
| 0 | 1 | 0 | 0 | 0 | 0 | 0 | 0 | 1 | 0 | 0 |
| 0 | 1 | 1 | 0 | 0 | 0 | 0 | 1 | 0 | 0 | 0 |
| 1 | 0 | 0 | 0 | 0 | 0 | 1 | 0 | 0 | 0 | 0 |
| 1 | 0 | 1 | 0 | 0 | 1 | 0 | 0 | 0 | 0 | 0 |
| 1 | 1 | 0 | 0 | 1 | 0 | 0 | 0 | 0 | 0 | 0 |
| 1 | 1 | 1 | 1 | 0 | 0 | 0 | 0 | 0 | 0 | 0 |

-----

## 🧾 Verilog Design

  * **Design — `Day7/decoder.v`**
  * **Testbench — `Day7/Decoder_tb.v`**

-----

## ⚙️ RTL Design (Synthesis)

For this design, the synthesis tool creates three **NOT** gates (for `nA`) and eight 3-input **AND** gates, one for each minterm `B[0]` to `B[7]`.

<img width="574" height="416" alt="image" src="https://github.com/user-attachments/assets/9c11eecf-ce45-4e75-86a2-356684e1e72c" />

-----

## 📊 Waveform

The waveform will show that as the 3-bit input `A` changes every 10ns, the 8-bit output `B` immediately updates, with only one bit being high (a "one-hot" signal) at any time.

<img width="775" height="127" alt="image" src="https://github.com/user-attachments/assets/6f22c2ce-290c-4a2f-90e6-7a923343fe38" />

-----

## 🔍 Observations

  * The `$monitor` output from the testbench confirms the one-hot output for each input.
      * `For the encoded value 100 the decoded output will be 00010000`
      * `For the encoded value 101 the decoded output will be 00100000`
      * ...and so on.
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
