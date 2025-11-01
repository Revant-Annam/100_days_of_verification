# ⚙️ Day 5 — Basic ALU (4-bit Behavioral Modeling)

## 📘 Topics Understood

* Basic arithmetic and logical operations on bits
* Behavioral modeling in Verilog
* Case statements and procedural blocks

---

## 🧠 Description

A **Basic Arithmetic Logic Unit (ALU)** performs fundamental arithmetic and logical operations such as **Addition**, **Subtraction**, **Bitwise AND**, and **Bitwise OR**.
The specific operation is determined by a **2-bit opcode** input.

Behavioral modeling is used here to describe the **functionality** of the circuit using **procedural statements** like `always` and `case`.
The **case statement** executes one of several blocks of code depending on the value of the opcode.

Procedural assignments to a signal must be done to a **reg**, not a wire. The `always @(*)` block ensures that the output is updated whenever any input changes.

---

## 🧮 Operations and Opcodes

| **Opcode** | **Operation** | **Expression** |
| :--------: | :------------ | :------------- |
|     00     | Addition      | A + B          |
|     01     | Subtraction   | A - B          |
|     10     | Bitwise AND   | A & B          |
|     11     | Bitwise OR    | A | B          |

---

## 🧩 Synthesis

A simple ALU block diagram with A, B, opcode inputs, and output Y uses a MUX for control.

<img width="761" height="392" alt="image" src="https://github.com/user-attachments/assets/facda3ab-4aaa-46e5-b8ed-bd6b24ff747f" />

---

## 🧾 Verilog Design

* **Design — `Day5/ALU_basic.v`**
* **Testbench — `Day5/ALU_tb.v`**

---

## 📊 Waveform

<img width="776" height="176" alt="image" src="https://github.com/user-attachments/assets/ad27e5df-216d-4e36-a892-92023a49bbd6" />

Expected behavior:

* Output `Y` changes according to opcode.
* Operations correspond correctly to addition, subtraction, AND, and OR.

---

## 🔍 Observations

* The `case` block allows clear and modular implementation of multi-operation circuits.
* Behavioral modeling provides flexibility for functional-level design.
* Simulation verifies correctness of all four ALU operations.

---

## 🧩 Industry Relevance

* ALUs form the **core of processors** and **embedded controllers**.
* Behavioral modeling is widely used for **functional verification** before synthesis.
* This concept scales to larger ALUs that include **shift**, **compare**, and **multiply** operations.

---

* ✅ **Status:** Completed
* 🗓 **Day:** 5 / 50
* 📚 **Next:** [Day 6 – Advanced ALU / MUX Integration →](../Day6)

