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
  * **Pointers:** `wr_ptr` tracks the open slot to write to. `rd_ptr` tracks the slot to read from.
  * **`empty` Logic:** I set the `empty` flag to be true when `count==0`.
  * **`full` Logic:** The `full` condition results in `count==DEPTH` after the buffer is filled.

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
  * **`full`/`empty` Logic:** This was synthesized into counter, fast combinational logic:
      * `count`: This creates a counter which sets the `empty` or `full` flags.

<img width="522" height="501" alt="Screenshot from 2026-02-19 14-25-50" src="https://github.com/user-attachments/assets/a2e6a2bf-5492-48d5-aab6-69b46cec2c69" />

-----

## 📊 Waveform

My simulation waveform showed:

1.  **Fill:** `wr_en=1`, `rd_en=0`. I wrote 8 items (0-7). On the 8th write, `wptr` became 7 and `count=DEPTH`. Thus `full` flag asserted.
2.  **Simultaneous R/W:** `wr_en=1`, `rd_en=1`. The pointers "chased" each other around the buffer while maintaining the count.
3.  **Drain:** `wr_en=0`, `rd_en=1`. I read 8 items. When the last item was read, `rd_ptr` incremented to 7 and the `empty` flag asserted.

<img width="1004" height="557" alt="image" src="https://github.com/user-attachments/assets/05447539-276c-4533-b158-e5e0b1196a2c" />

-----

## 🔍 Observations

  * **Logic:** This design uses counter for setting the flags. 

-----

## 🧩 Industry Relevance

  * **Data Buffering:** This is the \#1 use case. FIFOs are placed between two modules that produce and consume data at different or bursty rates.
  * **Rate Matching:** They are essential for connecting a fast-producing module (e.g., a 100MHz ADC) to a slower-consuming module (e.g., a 50MHz processing block).
  * **Clock Domain Crossing (CDC):** The *asynchronous* version of this FIFO is one of the most critical circuits in all of modern digital design, used to safely pass data between two different clock domains.

-----

  * ✅ **Status:** Completed
  * 🗓 **Day:** 14 / 100
  * 📚 **Next:** [Day 15 – FIFO (Asynchronous) →](../Day15)
