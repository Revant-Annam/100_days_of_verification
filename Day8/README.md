# ⚙️ Day 8 — D & JK Flip-Flops (Sequential Logic)

## 📘 Topics Understood

  * **Sequential Logic** (vs. Combinational)
  * **Flip-Flops** (D-FF and JK-FF)
  * **Clock Generation**

-----

## 🧠 Description

This marks the move from combinational to **sequential logic**. Sequential circuits have memory, and their outputs depend on both current inputs and previous states. The fundamental building block of this
memory is the **flip-flop**.

  * **D Flip-Flop (Data-FF):** This is the simplest memory element. It captures the value on its `D` input at the positive edge of the `clk` and holds that value on its `Q` output until the next clock edge.
It's used as a delay or storage unit.
  * **JK Flip-Flop:** A more versatile flip-flop. It has a "Set" (`J`) and "Reset" (`K`) input. It avoids the undefined state of an SR-FF and adds a "toggle" state (`J=1, K=1`), which is useful for counters.

**Clock Generation:** A clock signal is generated in the testbench using an `always` block.

```verilog
always begin
  #5 clk = ~clk; // Inverts 'clk' every 5ns
end
```

This creates a clock with a 10ns period (5ns high, 5ns low). Using a delay like `#5` is crucial here. An `always @(*)` block is used for combinational logic and would create an infinite loop if used for clock
generation.

-----

## 🧮 Equations (Characteristic Equations)

**JK Flip-Flop:**

$$Q_{next} = (J \cdot \sim Q) + (\sim K \cdot Q)$$

**D Flip-Flop:**

$$Q_{next} = D$$

-----

## 🧾 Truth Table (Clocked Behavior)

**JK-FlipFlop**
| **J** | **K** | **Clk** | **Q (next)** | **Mode** |
|:---:|:---:|:---:|:---:|:---:|
| 0 | 0 | ↑ | Q | Hold |
| 0 | 1 | ↑ | 0 | Reset |
| 1 | 0 | ↑ | 1 | Set |
| 1 | 1 | ↑ | ~Q | Toggle |

**D-FlipFlop**
| **D** | **Clk** | **Q (next)** | **Mode** |
|:---:|:---:|:---:|:---:|
| 0 | ↑ | 0 | Reset/Store 0 |
| 1 | ↑ | 1 | Set/Store 1 |

-----

## 🧾 Verilog Design

  * **JK Flip-Flop — `Day8/JK_FF.v`**
  * **D Flip-Flop — `Day8/D_ff.v`**
  * **Testbench (JK) — `Day8/JK_FF_tb.v`**
  * **Testbench (D) — `Day8/D_ff_tb.v`**

-----

## ⚙️ RTL Design (Synthesis)

  * **`always @(posedge clk)`** tells the synthesis tool to create **sequential logic** (a register).
  * **D-FF:** `Q <= D;` synthesizes directly to a **D-type Flip-Flop**.
  * **JK-FF:** The `case` statement synthesizes to a **D-type Flip-Flop** preceded by multiplexers that implements the characteristic equation $Q_{next} = (J \cdot \neg Q) + (\neg K \cdot Q)$.

**JK-FF:**

<img width="775" height="445" alt="image" src="https://github.com/user-attachments/assets/c40c8907-dd64-4017-8fec-baeedd4c6d8d" />

**D-FF:**

<img width="753" height="286" alt="image" src="https://github.com/user-attachments/assets/16cb9ac0-46ea-4586-8149-90cf0690aed1" />

-----

## 📊 Waveform

A **Waveform** is a graph that visually represents the value (1 or 0) of your design's signals over time. It's the primary output of a simulation and the main tool you use to **debug your design**, allowing you
to see if your outputs are correct at every time step.

  * **D-FF Waveform:** The output `Q` will be observed to change *only* on the positive edge of `clk`. It will exactly match the value of `D` from the previous clock edge, showing the "delay" behavior.
  * **JK-FF Waveform:** The `Q` output will change at each `posedge clk` according to the `JK` inputs. The most interesting part is when `JK=2'b11`, where the waveform for `Q` will be seen to invert its own
value on every clock tick.

-----

## 🔍 Observations

  * **Sequential vs. Combinational:** Unlike the decoders/encoders, the output `Q` only changes at the `posedge clk`, not immediately when the inputs `D` or `JK` change.
  * **Non-Blocking (`<=`):** Using non-blocking assignments is the standard for sequential logic. It prevents race conditions by scheduling the update to `Q` to occur *after* all right-hand-side values in the
`always` block are evaluated.
  * The JK-FF's toggle state (`J=1, K=1`) is clearly visible in the simulation, showing how it can be used to divide a clock's frequency by two.

-----

## 🧩 Industry Relevance

  * **Fundamental Memory:** Flip-flops are the most basic unit of memory in all synchronous digital systems.
  * **Building Blocks:** All complex sequential circuits are built from flip-flops:
      * **Registers:** A group of D-FFs (like in a CPU)
      * **Counters:** A chain of T-FFs or JK-FFs
      * **Finite State Machines (FSMs):** The "state" is stored in a register made of D-FFs.
  * The D-FF is the most common flip-flop in modern RTL design.

-----

  * ✅ **Status:** Completed
  * 🗓 **Day:** 8 / 100
  * 📚 **Next:** [Day 9 – Shift Registers →](../Day9)
