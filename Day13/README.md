# ⚙️ Day 13 — RAM (DRAM Model) & Synchronous ROM

## 📘 Topics Understood

  * **Synchronous RAM & ROM**
  * **Memory Modeling (2D Arrays)**: `reg [width] mem [rows][cols]`
  * **Address Multiplexing**: Using one address port for both row and column.
  * **Coincident Decoding**: Modeling the 2D array structure of memory. In hardware it is equivalent to using 2 decoders. 
  * **Synthesizable Initialization**: Using `$readmemh` to load memory from a file.

-----

## 🧠 Description

This project implements two different types of synchronous memory blocks.

1.  **Synchronous RAM (DRAM Model):** DRAM is modeled using **address multiplexing** to save pins for the row and column addresses. A single `addr` port is used to first latch a **row address** (using `ras_b`) and then provide a **column address** (using `cas_b`). This is called **coincident decoding**, where the final memory cell is selected by the intersection of a row and column. This model uses 8 bits for the row and 8 bits for the column, creating a 256x256 (65,536 locations) memory array.

<img width="1280" height="720" alt="image" src="https://github.com/user-attachments/assets/c4a83775-9c0f-4d5b-8897-1dcf3d68450a" />

2.  **Synchronous ROM:** This models a simple Read-Only Memory. Its key feature is that it is **initialized from an external file** (`rom_data.mem`) using the `$readmemh` system task. This is the standard, synthesizable method for initializing large memories, as it separates the hardware design (the Verilog code) from the data it contains. The output is registered, giving it a one-cycle read latency.

<img width="724" height="322" alt="image" src="https://github.com/user-attachments/assets/fd2869a2-b52d-4bbf-95c1-09f2598e045d" />

-----

## 🧮 Timing Diagrams

  * **DRAM Write Cycle:**

    1.  `ras_b` goes low, latching the `addr` bus as the `row_reg`.
    2.  `cas_b` goes low, `addr` bus is used as the column, and `read=0` causes the `data_in` to be written.

  * **DRAM Read Cycle:**

    1.  `ras_b` goes low, latching the `row_reg`.
    2.  `cas_b` goes low, `addr` bus is used as the column, and `read=1` accesses the memory.
    3.  The `data_out` appears on the bus after a 1-clock-cycle synchronous delay.

<img width="656" height="454" alt="image" src="https://github.com/user-attachments/assets/63e87c48-a175-4d49-8a9a-c06276317767" />

-----

## 🧾 Verilog Design

  * **DRAM Model — `Day13/RAM.v`**
  * **Testbench (RAM) — `Day13/RAM_tb.v`**
  * **Synchronous ROM — `Day13/ROM.v`**
  * **ROM Data File — `Day13/rom_data.mem`**
  * **ROM Testbench — `Day13/rom_tb.v`**

-----

## ⚙️ RTL Design (Synthesis)

  * **RAM (DRAM Model):** The `reg [...] ram [...]` line synthesizes into a large **Block RAM (BRAM)**. The `always` block creates the logic around it.
      * `if (~ras_b)` synthesizes to a D-flip-flop (`row_reg`) with its enable pin connected to `~ras_b`.
      * `if (~cas_b)` synthesizes to the logic controlling the DRAM's read/write ports, using `row_reg` for the upper address bits and the `addr` port for the lower address bits.

      <img width="1555" height="768" alt="Screenshot from 2025-11-09 22-01-48" src="https://github.com/user-attachments/assets/93509bd7-0d30-4d82-95a9-b346b4542921" />

      <img width="1555" height="768" alt="Screenshot from 2025-11-09 22-01-58" src="https://github.com/user-attachments/assets/03c307d7-bfa8-46bd-baa6-9eb7020f2eea" />

  * **ROM (Sync):** The `reg [...] rom_data [...]` line also synthesizes to a DRAM, but in ROM mode. The `$readmemh` task is a **synthesis-time directive** that tells the tool to pre-load the DRAM with the data from `rom_data.mem`.

      <img width="1150" height="565" alt="Screenshot from 2025-11-02 22-35-33" src="https://github.com/user-attachments/assets/3d076fcd-859b-49b4-8afe-fe37bf047578" />

-----

## 📊 Waveform

  * **RAM Waveform:** The `RAM_tb.v` simulation will show `ras_b` going low, latching `addr=A4`. Then, `cas_b` goes low, and the `addr=73` is used as the column. The read/write happens at this point. For the read, `data_out` will show the data on the *next* clock edge.

<img width="1255" height="293" alt="Screenshot from 2025-11-09 20-57-19" src="https://github.com/user-attachments/assets/25a53878-63b4-46a0-b85c-ed415ea53d46" />

<img width="649" height="185" alt="Screenshot from 2025-11-09 20-57-43" src="https://github.com/user-attachments/assets/facb98db-de00-4792-82a8-6977a3e6ad85" />

  * **ROM Waveform:** The `rom_tb.v` simulation will show a **one-cycle read latency**. When the `addr` changes, `data_out` will still show the data for previous `addr`. On the *next* clock edge, `data_out` will update to the data for next `addr`.

<img width="1268" height="220" alt="Screenshot from 2025-11-02 22-30-17" src="https://github.com/user-attachments/assets/73213ec6-9a74-46be-b234-a5c76414a546" />

-----

## 🔍 Observations

  * **Robustness:** The DRAM model is robust. By separating the `ras_b` (row latch) and `cas_b` (column operation) into independent `if` statements, and also using the `addr` directly when the `cas_b = 0` I was able to fix the race condition.
  * **Sequential Operation:** This design correctly models the multi-cycle nature of DRAM access: (1) latch row, (2) latch column and operate.
  * **Synthesizable Initialization:** The `$readmemh` method is the industry standard for initializing any on-chip memory (RAM or ROM) as it separates the hardware logic from the data.

-----

## 🧩 Industry Relevance

  * **High-Capacity RAM:** This is the **fundamental concept** behind all modern, high-capacity DRAM (like the DDR3/4/5 in PC). Address multiplexing is essential for saving package pins.
  * **ROM:** Used for storing fixed data like bootloaders, firmware, and **Lookup Tables (LUTs)** (e.g., for sine/cosine values, filter coefficients, or video color correction).

-----

  * ✅ **Status:** Completed
  * 🗓 **Day:** 13 / 100
  * 📚 **Next:** [Day 14 – FIFO (Synchronous) →](../Day14)
