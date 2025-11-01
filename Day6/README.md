# ⚙️ Day 6 — 4:2 Priority Encoder (Dataflow Modeling)

## 📘 Topics Understood

  - Priority Encoder Logic
  - Dataflow Modeling (`assign`)
  - Combinational Circuits

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

<img width="518" height="216" alt="image" src="https://github.com/user-attachments/assets/1100861b-30c3-46a6-a267-8e0197ffdf96" />

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

*Note: A full industrial design often includes a "Valid" output bit to indicate if any input is active. This design outputs `00` for no input.*

-----

## 🧾 Verilog Design

* **Design — `Day6/priority_encode.v`**
* **Testbench — `Day6/priority_encode_tb.v`**

-----

## ⚙️ RTL Design

<img width="774" height="263" alt="image" src="https://github.com/user-attachments/assets/da432630-aa91-479f-8c87-ba97afb8a18e" />

-----

## 📊 Waveform

<img width="776" height="106" alt="image" src="https://github.com/user-attachments/assets/2e52a918-abd2-495f-a2a7-d9729bfafe30" />

-----

## 🔍 Observations

  - The `$monitor` output from the testbench confirms the priority logic.
  - For `I = 4'b0111`, the output is `Y=10`. This correctly indicates that input $I_2$ is encoded, and the lower-priority inputs ($I_1$, $I_0$) are ignored.
  - For `I = 4'b1101`, the output is `Y=11`. This confirms $I_3$ has the highest priority, ignoring all other active inputs.
  - Dataflow modeling with `assign` statements is a concise way to represent this combinational logic.

-----

## 🧩 Industry Relevance

  - **Interrupt Controllers:** Priority encoders are the core logic in a CPU's interrupt controller, which must prioritize multiple interrupt requests (e.g., keyboard, mouse, disk) and service the most critical one first.
  - **Bus Arbiters:** In a system with multiple "masters" (like a CPU and a DMA controller) trying to access the same bus, a priority encoder is used to decide which master gets access.
  - **Data Compression:** Used in algorithms that need to find the most significant bit in a data word.

-----

  - ✅ **Status:** Completed
  - 🗓 **Day:** 6 / 100
  - 📚 **Next:** [Day 7 – 3:8 Decoder →](../Day7)
