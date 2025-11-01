# ⚙️ Day 12 — Moore FSM: Traffic Light Controller

## 📘 Topics Understood

  * **Moore FSM Design**
  * **State-Based Timers** 
  * **Multi-Process FSM Coding Style** (State Register, Timer Logic, Next-State Logic, Output Logic)
  * `parameter` for configurable delays

-----

## 🧠 Description

This project implements a traffic light controller for a highway intersected by a farm road using a state machine. The objective is to manage traffic efficiently, giving priority to the highway while also ensuring the farm road gets fair access when vehicles are detected (`X`).

This is a **Moore FSM** because the outputs (the `highway_light` and `country_light`) depend **only on the present state**. The `always @(*)` block for the lights uses a `case(state)` statement, which is the classic structure for a Moore machine. The *next state* logic depends on both the state and the input `X`, which is true for all FSMs.

A key part of this design is the **state-based timer** (`T_green`). This counter only increments when the FSM is in the `CG` (Country Green) state, `X` is high, and the timer limit (`G2R`) has not been reached. If `X` goes to 0 or the timer expires, the FSM transitions away from the `CG` state.

-----

## 🧮 Equations (State Logic)

The logic is defined by the state transitions.

  * **HG (Highway Green):** Default state. If `X=1` (car on farm road), move to `HOR`. Else, stay `HG`.
  * **HOR (Highway Orange/Yellow):** Timed transition state. Always move to `CG`.
  * **CG (Country Green):** Stay in this state *only if* `X=1` AND `T_green < G2R`. If `X=0` (no car) OR `T_green` expires, move to `COR`.
  * **COR (Country Orange/Yellow):** Timed transition state. Always move to `HG`.

-----

## 🧾 Truth Table (State & Output Table)

| **State** | **State Code** | **Input `X`** | **Timer `(T_green < G2R)`** | **Next State** | **Highway Light** | **Country Light** |
|:---:|:---:|:---:|:---:|:---:|:---:|:---:|
| HG | `00` | 0 | x | HG (`00`) | **Green (10)** | Red (00) |
| HG | `00` | 1 | x | HOR (`01`) | **Green (10)** | Red (00) |
| HOR | `01` | x | x | CG (`10`) | **Yellow (01)** | Red (00) |
| CG | `10` | 1 | 1 (True) | CG (`10`) | Red (00) | **Green (10)** |
| CG | `10` | 1 | 0 (False) | COR (`11`) | Red (00) | **Green (10)** |
| CG | `10` | 0 | x | COR (`11`) | Red (00) | **Green (10)** |
| COR | `11` | x | x | HG (`00`) | Red (00) | **Yellow (01)** |

-----

## 🧾 Verilog Design

  * **Design — `Day12/traffic_control.v`**
  * **Testbench — `Day12/traffic_control_tb.v`**

-----

## ⚙️ RTL Design (Synthesis)

  * The `state` register synthesizes to **two D-FlipFlops**.
  * The `T_green` register synthesizes to **four D-FlipFlops** with enabling logic.
  * The `always @(*)` block for `nxt_state` synthesizes to a cloud of **combinational logic** (MUXes, AND/OR gates) that takes `state`, `X`, and `T_green` as inputs.
  * The `always @(*)` block for the lights synthesizes to a **decoder** (a simple set of logic gates) that maps the `state` bits to the light outputs.

<img width="789" height="254" alt="image" src="https://github.com/user-attachments/assets/e4b4c54c-0703-4ce7-b374-cbf85a9eb5d0" />

<img width="805" height="197" alt="image" src="https://github.com/user-attachments/assets/ac1e8838-ae4a-4444-91b9-16c2e304575f" />

-----

## 📊 Waveform

The simulation waveform shows that the FSM stays in state `HG` (Highway Green) as long as `X=0`.

<img width="779" height="126" alt="image" src="https://github.com/user-attachments/assets/5af7b3d2-188d-49f9-97a0-4c8edd4cdad5" />

1.  When `X` goes high at 50ns, the state transitions to `HOR` (Highway Yellow) at the next clock edge (55ns).
2.  At 65ns, it transitions to `CG` (Country Green).
3.  The `country_light` stays Green for 3 clock cycles (30ns) because `X` remains high but the timer `T_green` expires (at 85ns, `T_green` becomes 2, failing `T_green < G2R`).
4.  At 95ns, the state moves to `COR` (Country Yellow), and then back to `HG` at 105ns.

-----

## 🔍 Observations

  * **Moore Machine:** The lights change *after* the state transition is complete. For example, when the state changes from `HG` to `HOR` at 55ns, the `highway_light` only becomes Yellow *at* 55ns, not before.
  * **Timer Control:** The `parameter G2R = 4'd2` allows the country green light duration to be easily changed. The test shows the timer correctly forces a state change even when `X` is still high.
  * **Multi-Process FSM:** The design is cleanly separated into four distinct `always` blocks: State Register, Timer Logic, Next State Logic, and Output Logic. This is a very robust and easy-to-debug way to write FSMs.

-----

## 🧩 Industry Relevance

  * This is a classic example of a "control-dominated" design, which is extremely common.
  * The use of state-based timers is fundamental for implementing any time-sensitive logic, such as bus timeouts, protocol timers (e.g., in SPI/I2C), or debounce circuits for buttons.
  * This exact logic (prioritized access with a timeout) is used in bus **arbiters**, which decide which component (e.g., CPU, DMA) gets to use a shared memory bus.

-----

  * ✅ **Status:** Completed
  * 🗓 **Day:** 12 / 100
  * 📚 **Next:** [Day 13 – RAM & ROM →](../Day13)
