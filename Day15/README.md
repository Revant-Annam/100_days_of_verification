
# ⚙️ Day 15 — Asynchronous FIFO (CDC & Metastability Handling)

## 📘 Topics Understood

- Why Asynchronous FIFO is needed when Synchronous FIFO already exists
- Clock Domain Crossing (CDC) fundamentals
- Metastability 
- Gray code encoding for safe pointer transfer across clock domains
- Two-flop synchronizer as the standard CDC solution

---

## 🧠 Description

**Why Async FIFO when Sync FIFO exists?**
A synchronous FIFO works perfectly when both the producer and consumer share the same clock. However, in real SoC designs, different blocks often operate at different clock frequencies or entirely unrelated clocks — a CPU running at 500 MHz writing data to a peripheral running at 100 MHz, for example. A synchronous FIFO would produce incorrect behavior here because the read and write pointers live in different time domains. An **Asynchronous FIFO** solves this by allowing independent read and write clocks, bridging two clock domains safely.

**Clock Domain Crossing (CDC)**
CDC refers to the challenge of passing a signal from one clock domain (clk_w) to another (clk_r). Simply routing the signal directly is dangerous — the receiving flip-flop may sample the signal while it is in transition, violating setup/hold time requirements and causing **metastability**.

**Metastability**
When a flip-flop's setup or hold time is violated, its output enters an indeterminate state — neither logic 0 nor logic 1 — and takes an unpredictable amount of time to resolve. This resolved value could be wrong, causing corrupted data or control logic failures. Metastability cannot be eliminated, but its probability of propagating can be made astronomically small by giving the signal extra time to resolve — achieved via a **synchronizer**.

**Two-Flop Synchronizer**
The industry-standard mitigation is passing the signal through two (sometimes three) back-to-back flip-flops clocked by the destination domain. The first flop may go metastable, but by the time the second flop samples it, the probability of it still being metastable is negligible (MTBF becomes millions of years in practice).

**Gray Code Encoding**
The read and write pointers must be passed across clock domains. Binary pointers are dangerous because multiple bits change simultaneously (e.g., 011 → 100 changes 3 bits), and the synchronizer could sample any intermediate value. **Gray code** changes only **one bit at a time**, guaranteeing that even if the synchronizer samples slightly early or late, it picks up either the old or the new pointer — never a corrupted in-between value. This is the cornerstone of async FIFO pointer management.

---

## 🧮 Timing / Behavior

```
Write Domain (clk_w)          Read Domain (clk_r)
─────────────────────         ────────────────────
wptr (binary) → Gray encode → [FF1] → [FF2] → wptr_sync (Gray) → binary decode → empty/full logic

rptr (binary) → Gray encode → [FF1] → [FF2] → rptr_sync (Gray) → binary decode → empty/full logic
```

**Full Condition** (evaluated in write domain):
```
full  = (wptr_gray == {~rptr_sync[MSB:MSB-1], rptr_sync[MSB-2:0]})
```

**Empty Condition** (evaluated in read domain):
```
empty = (rptr_gray == wptr_sync)
```

| Signal | Domain | Description |
|---|---|---|
| clk_w | Write | Write clock |
| clk_r | Read | Read clock |
| wr_en | Write | Write enable |
| rd_en | Read | Read enable |
| wptr | Write | Write pointer (Gray coded for CDC) |
| rptr | Read | Read pointer (Gray coded for CDC) |
| full | Write | Asserted when FIFO is full |
| empty | Read | Asserted when FIFO is empty |

---

## 🧾 Verilog Design

* Asynchronous FIFO Design — `Day15/async_fifo.v`
* Testbench — `Day15/async_fifo_tb.v`

---

## ⚙️ RTL Design (Synthesis)

**Inferred Hardware:**
- **Dual-port RAM** — separate read and write ports, each clocked independently
- **Gray code encoder** — XOR-based combinational logic on the pointers
- **Two-flop synchronizers** — inferred as a chain of 2 FFs with `ASYNC_REG` constraint recommended in Vivado to prevent optimization across the synchronizer stages
- **Full/Empty comparator logic** — purely combinational, fed by synchronized pointers

> ⚠️ Vivado Synthesis Note: Mark synchronizer flip-flops with `(* ASYNC_REG = "TRUE" *)` attribute to prevent the tool from optimizing them away or reordering them, which would break metastability protection.

---

## 📊 Waveform

> Waveform captured from Vivado simulation showing write operations on `clk_w`, the 2-cycle latency of pointer synchronization into `clk_r`, correct `empty` deassertion, and `full` assertion during back-pressure.

---

## 🔍 Observations

- The **2-cycle latency** in pointer synchronization means `empty` and `full` flags are slightly pessimistic — the FIFO may report "not full" one or two cycles after it actually becomes full, but it will **never falsely report empty when data exists** or vice versa, ensuring correctness over performance.
- Changing only **one Gray code bit per transition** visibly prevents pointer corruption even when the synchronizer samples at a boundary.
- The **full flag is checked in the write domain** and the **empty flag in the read domain** — crossing them to the wrong domain would require additional synchronization and adds latency.
- At reset, both pointers must be initialized to the same Gray code value (0) simultaneously to guarantee `empty` is correctly asserted.

---

## 🧩 Industry Relevance

Asynchronous FIFOs are one of the most critical and commonly interviewed RTL topics in the semiconductor industry. They appear in virtually every SoC at domain crossings — between a high-speed NoC and a low-speed peripheral, between DDR and a processing core, or between RF and baseband subsystems. Mastering async FIFO means mastering CDC, which is a top verification concern in tapeouts. Tools like Synopsys SpyGlass and Cadence JasperX CDC are dedicated entirely to catching CDC bugs. 

---

* ✅ Status: Completed
* 🗓 Day: 15 / 100
* 📚 Next: Day 16 – Booth's Multiplier →
