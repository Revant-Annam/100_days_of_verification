# ⚙️ Day 14 — Synchronous FIFO (Pointer Comparison)

## 📘 Topics Understood

  * **Synchronous FIFO (First-In-First-Out) Buffering**
  * **FIFO Pointers** (Read and Write) and **Wrap-around Logic**
  * **Status Flags** (`full`, `empty`)

-----

## 🧠 Description

A **synchronous FIFO (First-In-First-Out)** is a data buffer that operates under a single clock domain, meaning both read (`rd_en`) and write (`wr_en`) operations are controlled by the same `clk`.
This is particularly important in high-speed systems where timing discrepancies can lead to data loss or corruption.

I implemented the `full` and `empty` logic by directly comparing the read and write pointers.

  * **Memory:** I used a simple 2D `reg` array (`buffer`) as the storage.
  * **Pointers:** `wr_ptr` tracks the next open slot to write to. `rd_ptr` tracks the next slot to read from.
  * **`empty` Logic:** I set the `empty` flag to be true when `wr_ptr == rd_ptr`.
  * **`full` Logic:** The `full` condition results in `wr_ptr + 1 == rd_ptr` after the buffer is filled. This means the FIFO signals full when it has DEPTH - 1 (e.g., 7) items in it, leaving one slot unused. This is a standard, low-logic way to build a reliable FIFO.

-----

## 🧮 Timing / Behavior

  * **Reset (`rst=0`):** `wr_ptr` and `rd_ptr` are reset to 0. `empty` is high.
  * **Write (`wr_en=1`, `full=0`):** On the `posedge clk`, `data_in` is written to `buffer[wr_ptr]`, and `wr_ptr` increments.
  * **Read (`rd_en=1`, `empty=0`):** On the `posedge clk`, data from `buffer[rd_ptr]` is placed on `d_out`, and `rd_ptr` increments.

<img width="1412" height="423" alt="image" src="https://github.com/user-attachments/assets/a1b50ebc-33f3-4d35-b39b-c34a05db479c" />

<img width="785" height="262" alt="image" src="https://github.com/user-attachments/assets/bb9b3cbe-4c40-46b9-9fc5-94677f745365" />

-----

## 🧾 Verilog Design

  * **Synchronous FIFO — `Day14/sync_fifo.v`**
  * **Testbench — `Day14/sync_fifo_tb.v`**

## ⚙️ RTL Design (Synthesis)

When I synthesized this design, the tool inferred:

  * **Memory:** A **Block RAM (BRAM)** for the `buffer` array.
  * **Pointers:** The `wr_ptr` and `rd_ptr` synthesized into 3-bit registers (which act as counters).
  * **`full`/`empty` Logic:** This was synthesized into simple, fast combinational logic:
      * `empty`: One 3-bit comparator (`wr_ptr == rd_ptr`).
      * `full`: One 3-bit adder (for `wr_ptr + 1`), a MUX (for the wrap-around), and one 3-bit comparator.

<img width="1555" height="768" alt="image" src="https://github.com/user-attachments/assets/73c74101-6795-4712-967b-7fa3f4c2e629" />

-----

## 📊 Waveform

My simulation waveform showed:

1.  **Fill:** `wr_en=1`, `rd_en=0`. I wrote 7 items (0-6). On the 7th write, `wptr` became 7. `wptr_next` became 0, which equaled `rd_ptr` (still 0). The `full` flag asserted. The 8th write in the testbench loop was blocked.
2.  **Simultaneous R/W:** `wr_en=1`, `rd_en=1`. The pointers "chased" each other around the buffer, and the `full` flag remained asserted.
3.  **Drain:** `wr_en=0`, `rd_en=1`. I read 7 items. When the last item was read, `rd_ptr` incremented to 7, making it equal to `wr_ptr` (which was 7). The `empty` flag asserted, and the 8th read in the testbench loop was blocked.

<img width="1555" height="768" alt="image" src="https://github.com/user-attachments/assets/85203e95-5599-4b71-ad9d-0bbfb2e5b8e0" />

-----

## 🔍 Observations

  * **Logic:** This design uses pure pointer comparison. This can be faster and use fewer logic resources than a separate counter which is another way to flag the pointers.
  * **The Trade-off:** The sacrificial slot method (`full = (wptr_next == rd_ptr)`) is the trade-off. My `DEPTH=8` FIFO can now only hold **7** items. This is a common and acceptable trade-off in hardware design.
  * **Robust Pointers:** I calculated the next pointer value (`wptr_next`) explicitly. Using just `(wr_ptr + 1) == rd_ptr` in the `assign` statement can be ambiguous depending on expression widths, so this is a safer, more robust implementation.

-----

## 🧩 Industry Relevance

  * **Data Buffering:** This is the \#1 use case. FIFOs are placed between two modules that produce and consume data at different or bursty rates.
  * **Rate Matching:** They are essential for connecting a fast-producing module (e.g., a 100MHz ADC) to a slower-consuming module (e.g., a 50MHz processing block).
  * **Clock Domain Crossing (CDC):** The *asynchronous* version of this FIFO is one of the most critical circuits in all of modern digital design, used to safely pass data between two different clock domains.

-----

  * ✅ **Status:** Completed
  * 🗓 **Day:** 14 / 100
  * 📚 **Next:** [Day 15 – FIFO (Asynchronous) →](../Day15)
