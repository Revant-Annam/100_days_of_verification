# ⚙️ Day 10 — 4-bit Synchronous & Asynchronous Up-Counters

## 📘 Topics Understood

  * **Counter Design** (Asynchronous vs. Synchronous)
  * **Asynchronous (Ripple) Clocking**
  * **Synchronous (Parallel) Clocking**
  * **Verilog `parameter`** and `localparam`
  * **Verilog `generate` blocks** (`genvar`, `generate-for`)

-----

## 🧠 Description

**Generate Blocks:** These allow Verilog code to be created dynamically before simulation. This is very convenient when the same operation or module instance needs to be repeated (e.g., creating N flip-flops for an N-bit counter). All generate code is placed between `generate` and `endgenerate` keywords. The two main types are loops (`for`) and conditionals (`if`/`case`). A `genvar` is a special variable used as the index in a generate loop.

**Parameters:** These allow constants to be defined in a module (e.g., `parameter N=4`). This makes the module reusable and configurable. The value can be overridden during instantiation (e.g., `async_count #(5) ...`). `localparam` is a constant that cannot be overridden from outside.

**Asynchronous (Ripple) Counter:** In this design, only the first flip-flop is connected to the main clock. The clock input for all *other* flip-flops is driven by the **output** of the previous flip-flop (e.g., `clk_ff1 = ~Q_ff0`). This is simple but slow, as the clock signal has to "ripple" through the chain, causing a delay.

**Synchronous Counter:** In this design, one **global clock** is connected to *all* flip-flops simultaneously. All outputs change at the same time. To control *when* a bit toggles, we use logic on the J/K inputs. For an up-counter, a bit `i` should toggle only when all previous bits (`i-1` down to 0) are '1'.

-----

## 🧮 Equations (Toggle Logic)

**Asynchronous Up-Counter:**

$$Clk_0 = MainClk$$
$$Clk_i = \sim Q_{i-1} \quad \text{(for i > 0)}$$
$$J_i = K_i = 1 \quad \text{(All FFs in toggle mode)}$$

**Synchronous Up-Counter:**

$$Clk_i = MainClk \quad \text{(All FFs share one clock)}$$
$$J_0 = K_0 = 1$$
$$J_i = K_i = (Q_0 \cdot Q_1 \cdot ... \cdot Q_{i-1}) \quad \text{(Toggle only if all previous bits are 1)}$$

-----

## 🧾 Truth Table (4-bit Up-Count Sequence)

| **Q[3]** | **Q[2]** | **Q[1]** | **Q[0]** | **Value** |
|:---:|:---:|:---:|:---:|:---:|
| 0 | 0 | 0 | 0 | 0 |
| 0 | 0 | 0 | 1 | 1 |
| 0 | 0 | 1 | 0 | 2 |
| 0 | 0 | 1 | 1 | 3 |
| 0 | 1 | 0 | 0 | 4 |
| ... | ... | ... | ... | ... |
| 1 | 1 | 1 | 0 | 14 |
| 1 | 1 | 1 | 1 | 15 |
| 0 | 0 | 0 | 0 | 0 |

-----

## 🧾 Verilog Design

  * **JK Flip-Flop — `Day10/jk_ff.v`**
  * **Asynchronous Counter — `Day10/async_count.v`**
  * **Synchronous Counter — `Day10/sync_count.v`**
  * **Testbench (Async) — `Day10/async_tb.v`**
  * **Testbench (Sync) — `Day10/sync_count_tb.v`**

-----

## ⚙️ RTL Design (Synthesis)

**Synthesis** is an automated process that "compiles" your Verilog RTL code into a **gate-level netlist** of basic logic gates and flip-flops.

  * **Asynchronous Counter:** Synthesizes to N `jk_ff` modules. The `clk` pin of `ff0` is driven by the global clock, but the `clk` pin of `ff1` is driven by the **`Q` output** of `ff0`, `ff2` by `Q` of `ff1`, and so on. This creates the "ripple" clock chain.
  
  <img width="463" height="448" alt="image" src="https://github.com/user-attachments/assets/c47bb392-b9e1-45c5-91c1-e897076f11b3" />

  * **Synchronous Counter:** Synthesizes to N `jk_ff` modules. All 4 `clk` pins are connected **in parallel** to the global clock. The `JK` inputs are driven by combinational logic (a tree of **AND gates**, from the `&` reduction operator) to implement the toggle-enable logic.

  <img width="487" height="383" alt="image" src="https://github.com/user-attachments/assets/58de2bb1-9ced-44c3-8bd5-e7542579271f" />

-----

## 📊 Waveform

A **Waveform** is a graph that visually represents the value (1 or 0) of your design's signals over time. It is the main tool used to debug a design.

  * **Asynchronous Waveform:** The key observation is the **"ripple" effect**. After a clock edge, `Q[0]` changes first. Then, `Q[1]` changes *after* a small propagation delay (when it sees the edge from `Q[0]`). `Q[2]` changes after `Q[1]`, etc. All outputs do *not* change at the same time.
  
  <img width="955" height="138" alt="image" src="https://github.com/user-attachments/assets/7cb742da-9bcb-47b5-857c-d103c0312174" />

  * **Synchronous Waveform:** All output bits (`Q[3:0]`) change **simultaneously** on the positive edge of the global clock. There is no ripple delay between the bits, which is the key advantage of a synchronous design.

  <img width="772" height="174" alt="image" src="https://github.com/user-attachments/assets/ac115221-b018-4fbe-aa8c-44cbe4f023c9" />

-----

## 🔍 Observations

  * The `generate` block (using `genvar i`) and `parameter N` work together to create scalable, N-bit versions of both counters.
  * The `async_tb` correctly overrides the parameter to `N=5`, creating a 5-bit counter.
  * **Asynchronous:** The clock path is logic-dependent, which is slow and can cause glitches (metastability) if the rippling value is read by another synchronous circuit.
  * **Synchronous:** The clock path is clean (a single net), making it fast and reliable. The delay is moved from the clock path to the combinational logic path (`&(Q[i-1:0])`), which is standard practice.

-----

## 🧩 Industry Relevance

  * **Counters are everywhere:** They are used as **Program Counters (PCs)** in CPUs, timers, frequency dividers, digital clocks, and simple state machines.
  * **Asynchronous counters** are rarely used in modern SoCs for anything other than simple, non-critical frequency division due to their timing issues.
  * **Synchronous counters** are the industry standard for all counting, timing, and state-generation tasks.
  * `generate` and `parameter` are essential for creating reusable, configurable **IP (Intellectual Property)** blocks that can be sold or reused in different projects.

-----

  * ✅ **Status:** Completed
  * 🗓 **Day:** 10 / 100
  * 📚 **Next:** [Day 11 – FSM (Traffic Light Controller) →](../Day11)
