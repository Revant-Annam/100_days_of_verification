# ⚙️ Day 6 — 4:2 Priority Encoder (Dataflow Modeling)

## 📘 Topics Understood

  * Priority Encoder Logic
  * Dataflow Modeling (`assign`)
  * Truth Tables with "Don't Cares" (`x`)

-----

## 🧠 Description

An **encoder** is a combinational circuit with $2^n$ input lines and $n$ output lines. It encodes the $2^n$ inputs into an $n$-bit binary code.

A simple encoder only works if one input is active. A **Priority Encoder** solves this by establishing a priority for the inputs. If multiple input lines are active, the output code will correspond to the input with the **highest designated priority**.

In this 4:2 example, $I_3$ has the highest priority, and $I_0$ has the lowest. For example, if both $I_2$ and $I_1$ are high, the output will be `10`, representing $I_2$.

-----

## 🧮 Equations

The logic is implemented using dataflow modeling based on these Boolean equations (assuming $I_3$ is highest priority):

$$Y_1 = I_2 + I_3$$
$$Y_0 = (\sim I_2 \cdot I_1) + I_3$$

-----

## 🧩 Circuit Diagram

<img width="518" height="216" alt="image" src="https://github.com/user-attachments/assets/d82d49c1-8e6e-4b06-b08c-394b7ddb1732" />

-----

## 🧾 Truth Table (4:2 Priority Encoder)

This table uses 'x' (don't-care) to show the priority logic. For example, if $I_3$ is 1, the other inputs don't matter.

| **I(3)** | **I(2)** | **I(1)** | **I(0)** | **Y(1)** | **Y(0)** |
|:---:|:---:|:---:|:---:|:---:|:---:|
| 0 | 0 | 0 | 0 | 0 | 0 |
| 0 | 0 | 0 | 1 | 0 | 0 |
| 0 | 0 | 1 | x | 0 | 1 |
| 0 | 1 | x | x | 1 | 0 |
| 1 | x | x | x | 1 | 1 |

-----

## 🧾 Verilog Design

* **Design — `Day6/priority_encode.v`**
* **Testbench — `Day6/priority_encode_tb.v`**

-----

## ⚙️ RTL Design (Synthesis)

* `assign Y[1] = I[2] | I[3];` - OR gate.
* `assign Y[0] = (~I[2])&(I[1]) | I[3];` - one NOT gate, one AND gate, and one OR gate.
  
<img width="774" height="263" alt="image" src="https://github.com/user-attachments/assets/da432630-aa91-479f-8c87-ba97afb8a18e" />

-----

## 📊 Waveform

The inputs `I` are changed every 10ns, and the output Y updates combinationally.
* At 20ns, I is 5 (0101). The output Y is 2 (10), correctly showing $I_2$ has priority over $I_0$.
* At 30ns, I is d (1101). The output Y is 3 (11), correctly showing $I_3$ has the highest priority.

<img width="776" height="106" alt="image" src="https://github.com/user-attachments/assets/2e52a918-abd2-495f-a2a7-d9729bfafe30" />

-----

## 🔍 Observations

  * The `$monitor` output from the testbench confirms the priority logic.
  * For `I = 4'b0111`, the output is `Y=10`. This correctly indicates that input $I_2$ is encoded, and the lower-priority inputs ($I_1$, $I_0$) are ignored.
  * For `I = 4'b1101`, the output is `Y=11`. This confirms $I_3$ has the highest priority, ignoring all other active inputs.
  * Dataflow modeling with `assign` statements is a concise way to represent this combinational logic.

-----

## 🧩 Industry Relevance

  * **Interrupt Controllers:** Priority encoders are the core logic in a CPU's interrupt controller, which must prioritize multiple interrupt requests (e.g., keyboard, mouse, disk) and service the most critical one first.
  * **Bus Arbiters:** In a system with multiple "masters" (like a CPU and a DMA controller) trying to access the same bus, a priority encoder is used to decide which master gets access.
  * **Data Compression:** Used in algorithms that need to find the most significant bit in a data word.

-----

  * ✅ **Status:** Completed
  * 🗓 **Day:** 6 / 100
  * 📚 **Next:** [Day 7 – 3:8 Decoder →](../Day7)
