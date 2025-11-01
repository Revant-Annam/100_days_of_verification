# ⚙️ Day 3 — Carry Look-Ahead Adder (LCA)

## 📘 Topics Understood

* Carry Look-Ahead Adder (LCA) concept
* Delay in Ripple Carry Adder (RCA)
* Number representation in Verilog

---

## 🧠 Description

A **Carry Look-Ahead Adder (LCA)** is designed to overcome the delay limitations of the **Ripple Carry Adder (RCA)** by generating carry signals in advance using combinational logic.
Instead of waiting for each previous carry to ripple through, the LCA computes all carry outputs in parallel using generate and propagate terms. This increases the area of the circuit but decreases delay - 
a classic **Area-Delay** trade-off.

This drastically reduces the propagation delay from **O(N)** in RCA to approximately **O(log N)** in LCA.

---

## 🧮 Equations for LCA

$$G_i = A_i \cdot B_i \quad \text{(Carry Generate)}$$
$$P_i = A_i \oplus B_i \quad \text{(Carry Propagate)}$$
$$C_{i+1} = G_i + (P_i \cdot C_i)$$
$$S_i = P_i \oplus C_i$$

---

## 🔢 Number Representation in Verilog

Numbers in Verilog can be expressed as:

```
<size>'<base><value>
```

where

* `<size>` → number of bits (optional)
* `<base>` → data base

  * `b` → binary `o` → octal `d` → decimal `h` → hexadecimal
* `<value>` → actual number (can contain `x` or `z`)

Example: `8'b10101010` represents an 8-bit binary value.

---

## 🧩 Synthesis 

<img width="737" height="432" alt="image" src="https://github.com/user-attachments/assets/149a8c13-6a9c-4cdf-b235-eebadda17842" />

A Carry Look-Ahead unit computes all intermediate carry signals simultaneously using AND/OR logic.
This allows the adder to generate the sum outputs faster compared to the Ripple Carry Adder.

---

## 🧾 Verilog Codes

* **Design — `Day3/LCA_design.v`**
* **Testbench — `Day3/LCA_tb.v`**

---

## 📊 Waveform

<img width="776" height="201" alt="image" src="https://github.com/user-attachments/assets/75eb17b6-84a7-47c5-a262-2c0fe6463486" />

Expected behavior:

* All carry signals are generated in parallel.
* Sum and carry out match expected binary addition results.
* Total delay significantly lower than RCA.

---

## 🔍 Observations

* LCA computes carries faster using **generate–propagate logic**.
* Overall delay is reduced from linear (O(N)) to logarithmic (O(log N)).
* Efficient for high-speed arithmetic circuits like ALUs and processors.
* The Combinational logic increased compared to the RCA.

---

## 🧩 Industry Relevance

* Widely used in **high-performance ALUs, CPUs, and DSPs**.
* Core concept behind advanced adders like Carry Select and Carry Skip Adders.
* Forms the basis for parallel adder architectures in modern SoCs and ASICs.

---

* ✅ **Status:** Completed
* 🗓 **Day:** 3 / 100
* 📚 **Next:** [Day 4 – Carry Select Adder →](../Day4)
