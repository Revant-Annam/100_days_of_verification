# 🧠 100 Days of Verification — Complete RTL to UVM Journey  

Welcome to my **100 Days of Verification** challenge!  
This repository documents my day-by-day progress in **Digital Design and Verification**, covering **Verilog, SystemVerilog, UVM**, and multiple **industry protocols** (UART, SPI, I2C, APB, AXI).  

Each day’s folder contains:
- ✅ Design & Testbench code  
- 🧾 A detailed README explaining the concepts, learnings, synthesis, waveform and industry relevance  

---

## 📅 Progress Tracker — 100 Days of Verification  


### Phase 1: RTL Design & TB Sprint (Days 1-24)

| Day | Project (Design + Testbench) | Key Concept |
| :--- | :--- | :--- |
| [Day 1](./Day1) | 4:1 MUX | Behavioral Modeling (`case`) |
| [Day 2](./Day2) | 4-bit Ripple Carry Adder | Structural Modeling |
| [Day 3](./Day3) | Carry Lookahead Adder | Fast Addition Logic |
| [Day 4](./Day4) | Carry Select and skip Adder | Parallel Adders |
| [Day 5](./Day5) | Basic 4-bit ALU | Combinational Logic (ADD, SUB, AND, OR) |
| [Day 6](./Day6) | Priority Encoder | Encoding Techniques |
| [Day 7](./Day7) | 2x4 Decoder | Combinational Logic |
| [Day 8](./Day8) | D & JK Flip-Flops | Sequential Elements |
| [Day 9](./Day9) | Shift Registers (SIPO/PISO) | Sequential Data Movement |
| [Day 10](./Day10) | 4-bit Sync/Async Counters | Sequential Logic |
| [Day 11](./Day11) | FSM – 1011 Sequence Detector | Mealy FSM Design |
| [Day 12](./Day12) | FSM – Traffic Light Controller | Moore FSM Design |
| [Day 13](./Day13) | RAM & ROM | Memory Modeling (`reg` array, `$readmemh`) |
| [Day 14](./Day14) | FIFO (Synchronous) | Buffer Design, Pointers, Full/Empty |
| [Day 15](./Day15) | FIFO (Asynchronous) | Clock Domain Crossing (CDC), Gray Code |
| [Day 16](./Day16) | Booth’s Multiplier | Signed Multiplication (FSM + Datapath) |
| [Day 17](./Day17) | Wallace Tree Multiplier | Parallel Multipliers |
| [Day 18](./Day18) | GCD Calculator | Sequential Division (FSM + Datapath) |
| [Day 19](./Day19) | LFSR | Pseudo-Random Generator |
| [Day 20](./Day20) | Digital Clock | Counter-Based Timing Integration |
| [Day 21](./Day21) | UART Transmitter | Serial Communication (FSM) |
| [Day 22](./Day22) | UART Receiver | Serial Data Reception (Oversampling) |
| [Day 23](./Day23) | SPI Master–Slave | Serial Protocol |
| [Day 24](./Day24) | APB Slave | AMBA Peripheral Interface |

### Phase 2: Advanced System Design (Days 25-40)

| Day(s) | Project | Key Concept |
| :--- | :--- | :--- |
| [Day 25-28](./Day25) | VGA Controller (RTL) | Pattern Display Generation |
| [Day 29-30](./Day29) | VGA Controller (TB) | V/H Sync Timing Verification |
| [Day 31-33](./Day31) | Simple RISC Processor (RTL) | Instruction Fetch, Decode, Execute |
| [Day 34-35](./Day34) | Simple RISC Processor (TB) | Program-Based Testbench |
| [Day 36-38](./Day36) | 16-bit CPU Design (RTL) | Integrate ALU, Registers, Control Unit |
| [Day 39-40](./Day39) | 16-bit CPU Design (TB) | Verify instruction set (ASM program) |

### Phase 3: SystemVerilog for Verification (Days 41-65)

| Day(s) | Project | Key Concept |
| :--- | :--- | :--- |
| [Day 41](./Day41) | SystemVerilog Basics | `logic`, `always_comb`, `always_ff` |
| [Day 42](./Day42) | SV Testbench | Convert ALU TB to SV |
| [Day 43-44](./Day43) | `interface` & `modport` | Testbench Connectivity (using FIFO) |
| [Day 45-46](./Day45) | SV Classes & Objects | OOP Concepts, `new()`, `Transaction` |
| [Day 47-48](./Day47) | Transaction-Level Modeling | Build `alu_transaction` class |
| [Day 49-50](./Day49) | Constrained Random Verification | `rand`, `randc`, `constraint` (on `alu_trans`) |
| [Day 51-52](./Day51) | Randomization Control | `pre_randomize`, `post_randomize` |
| [Day 53-54](./Day53) | `generator` Class | Build a stimulus generator class |
| [Day 55-56](./Day55) | Mailboxes & Semaphores | Process Communication (Gen-to-Driver) |
| [Day 57-58](./Day57) | Virtual Interfaces | DUT–TB Connection (OOP) |
| [Day 59-60](./Day59) | Scoreboard & Self-Checking TB | Build a `scoreboard` for the FIFO |
| [Day 61-62](./Day61) | Assertions (SVA) | `assert property` (for D-FF, MUX) |
| [Day 63-64](./Day63) | Advanced SVA | Assertions for FIFO (full/empty) |
| [Day 65](./Day65) | Functional Coverage | `covergroup`, `coverpoint` (for ALU) |

### Phase 4: UVM Methodology (Days 66-85)

| Day(s) | Project | Key Concept |
| :--- | :--- | :--- |
| [Day 66](./Day66) | UVM Basics | Environment Setup, `run_test()` |
| [Day 67-68](./Day67) | UVM Transaction | `uvm_sequence_item` (for APB) |
| [Day 69-70](./Day69) | UVM Sequence | `uvm_sequence`, `body()` |
| [Day 71-72](./Day71) | UVM Driver | `uvm_driver`, `run_phase()` |
| [Day 73-74](./Day73) | UVM Monitor | `uvm_monitor`, `analysis_port` |
| [Day 75-76](./Day75) | UVM Agent | `uvm_agent` (assemble Driver/Monitor) |
| [Day 77-78](./Day77) | UVM Environment | `uvm_env`, `connect_phase()` |
| [Day 79-80](./Day79) | UVM Scoreboard | `uvm_scoreboard`, `uvm_tlm_fifo` |
| [Day 81-82](./Day81) | UVM Test | `uvm_test`, `uvm_config_db` |
| [Day 83-84](./Day83) | UVM Register Model (RAL) | APB Register Verification |
| [Day 85](./Day85) | UVM Coverage | UVM `uvm_subscriber` for coverage |

### Phase 5: AXI Protocol & SoC Capstone (Days 86-100)

| Day(s) | Project | Key Concept |
| :--- | :--- | :--- |
| [Day 86-87](./Day86) | AXI Protocol Basics | Valid–Ready Handshake, 5 Channels |
| [Day 88-89](./Day88) | AXI4-Lite Slave (RTL) | Design an AXI-Lite register slave |
| [Day 90-91](./Day90) | AXI-Lite UVM (Adapt) | **Adapt** your APB UVM env. for AXI-Lite |
| [Day 92](./Day92) | AXI Full (RTL) | Read Channel Logic (AR, R) |
| [Day 93](./Day93) | AXI Full (RTL) | Write Channel Logic (AW, W, B) |
| [Day 94](./Day94) | AXI Full (RTL) | Burst Logic (INCR) |
| [Day 95-97](./Day95) | AXI UVM Testbench | Build a new UVM env. for AXI Full |
| [Day 98-100](./Day98) | AXI-Based SoC Project | Integrate CPU + AXI + APB Bridge + RAM |

---

## 🧩 Tools & Technologies  
- **HDL:** Verilog, SystemVerilog, UVM  
- **EDA Tools:** Vivado  
- **Protocols Covered:** UART, SPI, I2C, APB, AXI  
- **Verification Concepts:** Assertions, Functional Coverage, CRV, UVM  

---

## 🌟 Final Goal  
By the end of 100 days, this repository demonstrates complete verification proficiency — from **basic RTL design** to **UVM-based SoC-level verification**, aligning with industry practices for **Design Verification Engineers**.
