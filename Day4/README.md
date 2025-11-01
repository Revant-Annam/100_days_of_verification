# ⚙️ Day 4 — 16-bit Carry Select Adder (CSA) and 32-bit Carry Skip Adder

## 📘 Topics Understood

* Carry Select Adder (CSA)
* Carry Skip Adder (CSKA)
* Verilog Datatypes — `wire` and `reg`

---

## 🧠 Description

A **Carry Select Adder (CSA)** improves the speed of binary addition by calculating possible sums for both carry-in values (0 and 1) **in parallel** and then selecting the correct result using a multiplexer.
Unlike the Ripple Carry Adder, which must wait for carry propagation through all stages, the CSA reduces delay by preparing results ahead of time.

CSA delay is approximately **O(√n)**, and its propagation delay can be represented by the following cases:

**Case 1:** (Equal bits per RCA stage)

$$t_{CSA} = K \cdot t_{carry} + (NK - 1) \cdot t_{mux}$$

**Case 2:** (Increasing bits per stage, for large N)

$$t_{CSA} = K \cdot t_{carry} + (2N - 1) \cdot t_{mux}$$

Where:

* ( K ): number of bits in each stage
* ( N ): total bits in CSA

Additionally, the **Carry Skip Adder (CSKA)** uses *propagation* and *generation* concepts:

* **Propagation (P):** ( A \oplus B = 1 \Rightarrow C_{out} = C_{in} )
* **Generation:** Carry is produced by normal addition logic.

In CSKA, carry can skip over certain bit groups if all bits propagate, reducing delay further.
In this design:

* **CSA:** Case 1 with N = 16, K = 4
* **CSKA:** Carry skip logic implementation

---

## 📗 Verilog Datatypes Recap

In Verilog:

* **`wire`** → used for continuous connections and temporary values (default `'z'`)
* **`reg`** → used for procedural assignments in testbenches (default `'x'`)

**Usage:**

* In **designs**, inputs and intermediate signals are declared as `wire`.
* In **testbenches**, input stimuli are declared as `reg`, while outputs are `wire`.

If multiple drivers attempt to assign conflicting values to the same net, the result becomes `'x'` (unknown) or `'z'` (high impedance).

---

## ⚙️ RTL Design

1. **Carry Select Adder:**

   * Built using 4-bit Ripple Carry Adders.
   * Two sums are calculated in parallel for carry-in = 0 and carry-in = 1.
   * Multiplexers select the final sum and carry.

2. **Carry Skip Adder:**

   * Uses ripple adders for each block.
   * Carry skips blocks if all propagate bits are 1 (`A⊕B = 1` for all bits in block).
   * Faster than pure RCA for wide additions.

---

## 🧩 Synthesis 

* **Carry Select Adder**

<img width="789" height="343" alt="image" src="https://github.com/user-attachments/assets/e714936d-5ef5-453d-9b5d-7f3a379edc6c" />

* **Carry Skip Adder**

<img width="790" height="291" alt="image" src="https://github.com/user-attachments/assets/eb01cfee-6ad5-4c68-97f2-d5e5cd91c1ae" />

* The **CSA** uses more area (due to duplicate adders and multiplexers) but achieves lower propagation delay than a standard RCA.
* The **CSKA** further reduces carry dependency by skipping unnecessary carry propagation stages.
* Both synthesized designs confirm proper hierarchical structure and optimized logic grouping.
* The **critical path** lies through the multiplexer chain in CSA and the skip logic in CSKA.

---

## 📊 Waveform

**Carry Select Adder (16-bit):**

<img width="778" height="149" alt="image" src="https://github.com/user-attachments/assets/72724c96-efb6-43b7-912b-4ecf871a0fdb" />

**Carry Skip Adder (32-bit):**

<img width="771" height="143" alt="image" src="https://github.com/user-attachments/assets/dd0b0590-ca0d-4991-803a-fb604bb6e53b" />

**Expected behavior:**
Sum and carry outputs update correctly after each input combination, confirming reduced delay for both CSA and CSKA architectures.

---

## 🔍 Observations

* Carry Select Adder significantly improves speed by parallel sum computation.
* Carry Skip Adder further optimizes addition using skip logic, reducing redundant propagation.
* Proper datatype usage (`wire`, `reg`) ensures clean simulation and synthesis compatibility.
* Both designs demonstrate trade-offs between **speed** and **area**.

---

## 🧩 Industry Relevance

* These adders form the basis of **arithmetic logic units (ALUs)** in CPUs and DSPs.
* CSA and CSKA are practical examples of **parallelism and pipelined computation** in digital arithmetic.
* Such designs are critical in **high-speed processors**, **FPGA accelerators**, and **DSP cores**.

---

* ✅ **Status:** Completed
* 🗓 **Day:** 4 / 50
* 📚 **Next:** [Day 5 – Advanced Adder Comparison →](../Day5)
