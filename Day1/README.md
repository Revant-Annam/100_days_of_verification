# 🧩 Day 1 — 4:1 Multiplexer (Behavioral Modeling)

## 📘 Topics Understood
- Multiplexer (MUX) basics  
- Basic Verilog syntax and module structure  
- Behavioral modeling using `always` blocks  

---

## 🧠 Description
A **Multiplexer (MUX)** is a combinational circuit that selects one of several input signals and forwards the selected input to a single output line.  
In a **4:1 MUX**, four inputs are controlled by two select lines.  

The design is written using **Behavioral Modeling** in Verilog, which describes the functionality of the circuit using **procedural statements** like `always` and `case`.  
Behavioral modeling is useful for simulating the logical behavior of a design without specifying the gate-level structure.

---

## 🧮 Truth Table

| **S1** | **S0** | **Output (OUT)** |
|:------:|:------:|:----------------:|
| 0 | 0 | I0 |
| 0 | 1 | I1 |
| 1 | 0 | I2 |
| 1 | 1 | I3 |

---

## ⚙️ RTL Design

<img width="674" height="361" alt="image" src="https://github.com/user-attachments/assets/540d1409-6d0a-46f0-a858-0de774917dc3" />

---

## 🧾 Verilog Code

**Design Code — `Day1/mux_behave.v`**
**Testbench Code — `Day1/tb_mux_4_1.v`**

---

## 📊 Waveform

<img width="658" height="225" alt="image" src="https://github.com/user-attachments/assets/4cff4978-f53d-45b4-a98b-8ade54f08282" />

Expected behavior: Output follows the input corresponding to the select-line combination.

---

## 🔍 Observations

* The output correctly follows the selected input as per the truth table.
* Behavioral modeling simplifies logic design for larger circuits.

---

## 🧩 Industry Relevance

* MUX is a **fundamental component** in digital systems — used in **data routing, ALUs, control units, and CPUs**.
* Behavioral modeling helps in **early verification and debugging** before synthesis.
* Concepts here extend into **protocol selection logic** and **SoC interconnects** in advanced verification environments.

---

✅ **Status:** Completed
🗓 **Day:** 1 / 50
📚 **Next:** [Day 2 – Ripple Carry Adder →](../Day02_RippleCarryAdder)
