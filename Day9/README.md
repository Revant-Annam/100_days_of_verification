# ⚙️ Day 9 — SIPO & PISO Shift Registers

## 📘 Topics Understood

  * **Shift Register Operation** (SIPO & PISO)
  * **Blocking (`=`) vs. Non-Blocking (`<=`) Assignments**
  * **Verilog Vector Concatenation** (e.g., `{D, Q[3:1]}`)
  * **Sequential Logic** with Control Signals

-----

## 🧠 Description

A **register** is a device that is used to store data, built from a group of flip-flops. A **Shift Register** can store multiple bits and move this data within the register (shifting) or in/out of it. There are 4 main types: SISO, SIPO, PISO, and PIPO.

  * **SIPO (Serial In, Parallel Out):** Data is entered serially (one bit per clock cycle) but read out in parallel (all bits at once).
  * **PISO (Parallel In, Serial Out):** Data is loaded in parallel (all bits at once) and then read out serially (one bit per clock cycle).

**Blocking vs. Non-Blocking Assignments:**
This is a critical Verilog concept.

  * **Blocking (`=`)**: Used for **combinational logic** (like in an `always @(*)` block). Statements are executed in order, one after the other. The next line is "blocked" until the current one is complete.
  * **Non-Blocking (`<=`)**: Used for **sequential logic** (like in an `always @(posedge clk)` block). All assignments are "scheduled" to happen at the end of the time step (e.g., on the clock edge) and execute in parallel. This prevents race conditions and correctly models how flip-flops behave.

> **Rule of Thumb:**
>
>   * Sequential Logic (`always @(posedge clk)`): Use **Non-Blocking (`<=`)**.
>   * Combinational Logic (`always @(*)`): Use **Blocking (`=`)**.

-----

## 🧮 Equations (Behavioral)

**SIPO:**

$$Q[n]_{next} = Q[n+1]$$
$$Q[MSB]_{next} = Serial_{In}$$

**PISO:**

$$\text{if (shift)} \quad Q_{next} = Parallel_{In}$$
$$\text{if (not shift)} \quad Q[n]_{next} = Q[n-1]$$

-----

## 🧾 Truth Table (Behavioral)

**SIPO (4-bit)**
| **Clk Edge** | **clr** | **D (in)** | **Q[3]** | **Q[2]** | **Q[1]** | **Q[0]** |
|:---:|:---:|:---:|:---:|:---:|:---:|:---:|
| - | 1 | x | 0 | 0 | 0 | 0 |
| 1 (posedge) | 0 | **1** | **1** | 0 | 0 | 0 |
| 2 (posedge) | 0 | **0** | **0** | 1 | 0 | 0 |
| 3 (posedge) | 0 | **0** | **0** | 0 | 1 | 0 |
| 4 (posedge) | 0 | **1** | **1** | 0 | 0 | 1 |

**PISO (4-bit, LSB-first out, per the design code)**
| **Clk Edge** | **clr** | **shift** | **D[3:0]** | **Q (out)** | **Internal State (Q1[3:1], Q)** |
|:---:|:---:|:---:|:---:|:---:|:---:|
| - | 1 | x | xxxx | 0 | `x, x, x, 0` |
| 1 (posedge) | 0 | 1 (Load) | **0101** | 1 | `(Q1[3]=0, Q1[2]=1, Q1[1]=0, Q=1)` |
| 2 (posedge) | 0 | 0 (Shift) | 0101 | 0 | `(Q1[3]=0, Q1[2]=0, Q1[1]=1, Q=0)` |
| 3 (posedge) | 0 | 0 (Shift) | 0101 | 1 | `(Q1[3]=0, Q1[2]=0, Q1[1]=0, Q=1)` |
| 4 (posedge) | 0 | 0 (Shift) | 0101 | 0 | `(Q1[3]=0, Q1[2]=0, Q1[1]=0, Q=0)` |

-----

## 🧾 Verilog Design

  * **SIPO — `Day9/SIPO.v`**
  * **PISO — `Day9/PISO_ff.v`**
  * **Testbench (SIPO) — `Day9/sipo_tb_reg.v`**
  * **Testbench (PISO) — `Day9/PISO_tb.v`**

-----

## ⚙️ RTL Design (Synthesis)

  * **SIPO:** Synthesizes to four **D-FlipFlops** in a chain. The `Q` of the first FF connects to the `D` of the second, and so on. The parallel output `Q[3:0]` is tapped from the `Q` of each FF.

<img width="681" height="325" alt="image" src="https://github.com/user-attachments/assets/947532f5-89ff-4326-909a-16c556292e7d" />

  * **PISO:** Synthesizes to four **D-FlipFlops**. Each FF has a **2:1 MUX** at its D-input, controlled by the `shift` signal, to select between the parallel input `D[n]` (when `shift=1`) or the output of the previous FF (when `shift=0`).

<img width="771" height="388" alt="image" src="https://github.com/user-attachments/assets/d7edefef-8e4d-4ae4-bdd8-62afa13ad15f" />

-----

## 📊 Waveform

A **Waveform** is a graph that visually represents the value (1 or 0) of your design's signals over time. It is the main tool used to debug a design.

  * **SIPO:** The waveform will show the serial input `D = 1` appearing at `Q[3]` after the first clock edge. After the second edge, `D = 0` appears at `Q[3]` and the original `1` moves to `Q[2]`. The data `1001` is seen shifting across the `Q` bus.
  
  <img width="779" height="186" alt="image" src="https://github.com/user-attachments/assets/c41ab80e-df6f-4ed4-81b7-e54e3375ae03" />

  *  **PISO:** The waveform will show the parallel data `4'b0101` being loaded when `shift=1`. On the *next* clock edge (when `shift=0`), the serial output `Q` will show `1`. On subsequent edges, `Q` will show `0`, then `1`, then `0`, as the data is shifted out.

  <img width="732" height="221" alt="image" src="https://github.com/user-attachments/assets/74328062-9e90-46f8-bdb0-67a513460666" />

-----

## 🔍 Observations

  * **SIPO:** The concatenation operator `{D, Q[3:1]}` is a powerful and clean way to express the shift operation. It creates a new 4-bit vector and assigns it to `Q`.
  * **PISO:** The `shift` signal is used here as a "load" enable. When `shift` is 1, the parallel data `D` is loaded. When `shift` is 0, the register shifts.
  * **Non-Blocking (`<=`):** Using non-blocking assignments is essential here. If blocking assignments (`=`) were used, the simulation would be incorrect, as the value of `Q1[1]` would be overwritten *before* it could be passed to `Q`, breaking the shift chain.

-----

## 🧩 Industry Relevance

  * **Serial Communication:** Shift registers are the heart of serial protocols like **UART** and **SPI**.
      * A PISO register on the transmitter side loads a parallel byte from the CPU and shifts it out, one bit at a time.
      * An SIPO register on the receiver side collects the serial bits one at a time and presents them as a parallel byte to the CPU.
  * **Data Conversion:** They are fundamental for converting between parallel and serial data formats, which is done constantly inside and between chips.

-----

  * ✅ **Status:** Completed
  * 🗓 **Day:** 9 / 100
  * 📚 **Next:** [Day 10 – Counters →](../Day10)
