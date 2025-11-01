# ⚙️ Day 2 — 4-bit Ripple Carry Adder (Structural Modeling)

## 📘 Topics Understood
- Basic Adders (Half Adder and Full Adder)
- Structural Modeling in Verilog
- Module Instantiation and Hierarchical Design

---

## 🧠 Description
A **Ripple Carry Adder (RCA)** is built by cascading several **Full Adders**, where the carry output of one adder becomes the carry input of the next stage.  
This design adds two 4-bit binary numbers and produces a 4-bit sum and a final carry-out.

**Structural modelling** in Verilog is a style to describe a circuit using logic gates and their connections. It's also known as gate-level modelling. 

**Module Instantiation:**
Modules can be instantiated within other modules and ports of these instances can be connected with other signals inside the parent module. 
**Port connections** in a module instance can be made in two ways: by **name** or by **position**. Both of them together cannot be given in a single argument. 
In this example the design of the full adder is in the style of dataflow modelling. 

Each **Full Adder** here is instantiated as a module inside the top-level RCA module.

---

## 🧮 Equations for Full Adder
$$\text{Sum} = A \oplus B \oplus C_{in}$$
$$C_{out} = (A \cdot B) + (C_{in} \cdot (A \oplus B))$$

---

## 🧩 Circuit Diagram

<img width="557" height="200" alt="image" src="https://github.com/user-attachments/assets/112d475a-ce7d-4d42-b556-52a1cfe5a02c" />

---

## 🧾 Truth Table (1-bit Full Adder)

| **A** | **B** | **Cin** | **Sum** | **Cout** |
|:------:|:------:|:------:|:------:|:------:|
| 0 | 0 | 0 | 0 | 0 |
| 0 | 0 | 1 | 1 | 0 |
| 0 | 1 | 0 | 1 | 0 |
| 0 | 1 | 1 | 0 | 1 |
| 1 | 0 | 0 | 1 | 0 |
| 1 | 0 | 1 | 0 | 1 |
| 1 | 1 | 0 | 0 | 1 |
| 1 | 1 | 1 | 1 | 1 |

---

## 🧾 Verilog Design

* **Full Adder — `Day2/full_adder.v`**
* **Ripple Carry Adder — `Day2/rip_add.v`**
* **Testbench — `Day2/rip_add_tb.v`**

---

## ⚙️ RTL Design

1. **RCA using FA:**

<img width="612" height="341" alt="image" src="https://github.com/user-attachments/assets/346ed729-caeb-4dd2-9d2e-8cfcaf67b928" />

2. **FA using basic gates**

<img width="683" height="274" alt="image" src="https://github.com/user-attachments/assets/06746385-593b-49a1-a546-2251095696fd" />

---

## 📊 Waveform

<img width="778" height="199" alt="image" src="https://github.com/user-attachments/assets/b8a0d6d1-588d-4701-b770-54f970a074c8" />

Expected behavior: Carry ripples through each stage, and the final sum matches the binary addition.

---

## 🔍 Observations

* The carry signal successfully ripples through all 4 stages.
* Structural modeling allows modular hierarchy for reuse in larger arithmetic designs.
* Simulation confirms correct summation and carry propagation.

---

## 🧩 Industry Relevance

* Ripple Carry Adders are fundamental components in **ALUs, CPUs, and DSP processors**.
* Structural modeling is used in hierarchical SoC design where **multiple sub-blocks** are instantiated and verified.
* The concept extends to **Carry Look-Ahead** and **Carry Select** Adders used in high-speed processors.

---

- ✅ **Status:** Completed
- 🗓 **Day:** 2 / 50
- 📚 **Next:** [Day 3 – Carry Look-Ahead Adder →](../Day3)


