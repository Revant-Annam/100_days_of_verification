# ⚙️ Day 13 — RAM & ROM (Memory Modeling)

## 📘 Topics Understood

  * **Memory Modeling (2D Arrays)**
  * **Synchronous RAM** (Read/Write)
  * **ROM (Read-Only Memory)**
  * **Dual-Port RAM**
  * **Parameterized Memory** (DATA\_WIDTH, ADDR\_WIDTH)

-----

## 🧠 Description

**ROM (Read-Only Memory):** ROM is a non-volatile memory that holds fixed data. Even when the system is switched off, the memory is stored. It is implemented as a memory array where each address corresponds to a data word that is pre-initialised. When an address is provided, the ROM outputs the data stored at that location. As the name suggests, we can only read the data on the ROM; we cannot write on it.

**RAM (Random Access Memory):** RAM is a type of memory which supports both read and write operations. It is typically synchronous, meaning read and write operations occur on clock edges.

  * **Write:** When a write enable signal is active, the data input is stored at the specified address on a clock edge.
  * **Read:** On each clock cycle, the data at the addressed location is made available at the output.

This project implements a **Dual-Port RAM**. This is a memory model with two independent sets of ports (Port A and Port B). Each port has its own address, data in, data out, and write enable. This allows two different parts of a system (e.g., a CPU and a DMA controller) to access the memory at the *same time*.

-----

## 🧮 Timing Diagrams

  * **RAM Write Operation:**

<img width="561" height="274" alt="image" src="https://github.com/user-attachments/assets/480a2761-9db6-471c-b949-2f8f5a76fc49" />

  * **RAM Read Operation:**

<img width="697" height="355" alt="image" src="https://github.com/user-attachments/assets/b3367279-0514-4c0b-81c8-d0b74a4a38fe" />

  * **ROM Read Operation:**

<img width="608" height="427" alt="image" src="https://github.com/user-attachments/assets/9d3124b2-6a4e-43de-ba8e-26a7de95a3a5" />

-----

## 🧾 Verilog Design

  * **Dual-Port RAM — `Day13/RAM_dual.v`**

    ```verilog
    `timescale 1ns / 1ps
    module RAM_dual #(parameter DATA_WIDTH = 8, ADDR_WIDTH = 4) (
        input [ADDR_WIDTH-1:0] addr_a, addr_b, // Corrected size
        input [DATA_WIDTH-1:0] data_a,data_b,
        input wr_en_a,
        input wr_en_b,
        input clk,
        output reg [DATA_WIDTH-1:0] q_a,q_b
        );
        
        // 2D Array: [width] name [depth]
        reg [DATA_WIDTH-1:0] ram [0:(1<<ADDR_WIDTH)-1]; // Corrected size
        
        // Port A Logic
        always @(posedge clk) begin
            if(wr_en_a) 
                ram[addr_a] <= data_a; // Use non-blocking
            else 
                q_a <= ram[addr_a];
        end
        
        // Port B Logic
        always @(posedge clk) begin
            if(wr_en_b) 
                ram[addr_b] <= data_b; // Use non-blocking
            else 
                q_b <= ram[addr_b];
        end
    endmodule
    ```

  Here is the complete code for a **synchronous** ROM, where the data output is registered and only appears on the positive edge of the clock.

-----

### 1\. `rom.v` (The Synchronous ROM Design)

This Verilog file describes the ROM module. The only change is in the `always` block.

```verilog
`timescale 1ns / 1ps

module ROM #(
    parameter DATA_WIDTH = 8,
    parameter ADDR_WIDTH = 4
) (
    input                       clk,
    input [ADDR_WIDTH-1:0]    addr,
    output reg [DATA_WIDTH-1:0] data_out
);

    // Calculate the depth (e.g., 2^4 = 16)
    localparam DEPTH = 1 << ADDR_WIDTH;

    // Declare the 2D array for the memory
    // [width] name [depth]
    reg [DATA_WIDTH-1:0] rom_data [0:DEPTH-1];

    // Initialize the memory from an external file
    // This is synthesizable for BRAMs/ROMs
    initial begin
        $readmemh("rom_data.mem", rom_data);
    end

    // Synchronous read (output is registered)
    always @(posedge clk) begin
        data_out <= rom_data[addr];
    end

endmodule
```

-----

### 2\. `rom_data.mem` (The Data File)

This file is exactly the same as before.

```text
// rom_data.mem
// This file contains 16 8-bit hex values
// for the 16x8 ROM (ADDR_WIDTH = 4)

DE // Address 0
AD // Address 1
BE // Address 2
EF // Address 3
CA // Address 4
FE // Address 5
12 // Address 6
34 // Address 7
56 // Address 8
78 // Address 9
9A // Address 10
BC // Address 11
F0 // Address 12
0D // Address 13
42 // Address 14
11 // Address 15
```

-----

### 3\. `rom_tb.v` (The Testbench)

This testbench is modified to provide a clock to the ROM.

```verilog
`timescale 1ns / 1ps

module rom_tb;

    // Use the same parameters as the design
    localparam DATA_WIDTH = 8;
    localparam ADDR_WIDTH = 4;
    localparam DEPTH      = 1 << ADDR_WIDTH;

    // Testbench signals
    reg                       clk;
    reg  [ADDR_WIDTH-1:0]    addr;
    wire [DATA_WIDTH-1:0]   data_out;
    integer i;

    // Instantiate the ROM
    ROM #(
        .DATA_WIDTH(DATA_WIDTH),
        .ADDR_WIDTH(ADDR_WIDTH)
    ) dut (
        .clk(clk),
        .addr(addr),
        .data_out(data_out)
    );

    // Clock generator
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // 10ns period clock
    end

    // Test stimulus
    initial begin
        $monitor("Time=%t | Address = %h | Data Out = %h", $time, addr, data_out);
        
        // Loop through all addresses
        for (i = 0; i < DEPTH; i = i + 1) begin
            addr = i;
            @(posedge clk);
            // On this clock edge, the ROM samples the address 'i'
            // The data_out will appear on the *next* clock edge
        end
        
        @(posedge clk); // One extra cycle to see the last data
        $display("--- ROM Read Test Complete ---");
        $finish;
    end

endmodule
```

  * **Testbench (RAM) — `Day13/RAM_tb.v`**

    ```verilog
    `timescale 1ns / 1ps
    module RAM_tb();
        reg [3:0] addr_a, addr_b;
        reg [7:0] data_a, data_b;
        reg wr_en_a, wr_en_b, clk;
        wire [7:0] q_a, q_b;
        
        RAM_dual #(8, 4) ram_du( // Pass parameters
            .addr_a(addr_a), .addr_b(addr_b),
            .data_a(data_a), .data_b(data_b), 
            .wr_en_a(wr_en_a), .wr_en_b(wr_en_b),
            .clk(clk),
            .q_a(q_a), .q_b(q_b)
        );
        
        always #5 clk = ~clk; // Toggle clock every 5ns
        
        initial begin
            clk = 1;
            wr_en_a = 0; wr_en_b = 0;
            addr_a = 0; addr_b = 0;
            data_a = 0; data_b = 0;

        $monitor("Time=%t | A(en,addr,data,q): %b %h %h %h | B(en,addr,data,q): %b %h %h %h",
                  $time, wr_en_a, addr_a, data_a, q_a, wr_en_b, addr_b, data_b, q_b);
            
            // Write 3 to addr 0 via Port B
            @(posedge clk);
            wr_en_b = 1; addr_b = 0; data_b = 3;
            @(posedge clk); wr_en_b = 0;

            // Write Conflict: A and B write to addr 2. B wins.
            @(posedge clk);
            wr_en_a = 1; addr_a = 2; data_a = 8;
            wr_en_b = 1; addr_b = 2; data_b = 7;
            @(posedge clk); wr_en_a = 0; wr_en_b = 0;

            // Write 9 to addr 3 via Port B
            @(posedge clk);
            wr_en_b = 1; addr_b = 3; data_b = 9;
            @(posedge clk); wr_en_b = 0;

            // Write 12 to addr 4 via Port A
            @(posedge clk);
            wr_en_a = 1; addr_a = 4; data_a = 12;
            @(posedge clk); wr_en_a = 0;

            // Write Conflict: A and B write to addr 5. B wins.
            @(posedge clk);
            wr_en_a = 1; addr_a = 5; data_a = 18;
            wr_en_b = 1; addr_b = 5; data_b = 20;
            @(posedge clk); wr_en_a = 0; wr_en_b = 0;

            // Write 26 to addr 6 via Port B
            @(posedge clk);
            wr_en_b = 1; addr_b = 6; data_b = 26;
            @(posedge clk); wr_en_b = 0;

            // Write 26 to addr 7 via Port A
            @(posedge clk);
            wr_en_a = 1; addr_a = 7; data_a = 26;
            @(posedge clk); wr_en_a = 0;
            
            @(posedge clk);
            $finish; // End simulation
        end
    endmodule
    ```

-----

## ⚙️ RTL Design (Synthesis)

**Synthesis** is an automated process that "compiles" your Verilog RTL code into a **gate-level netlist** of basic logic gates and flip-flops.

  * The `reg [DATA_WIDTH-1:0] ram [0:(1<<ADDR_WIDTH)-1];` line is the key. Synthesis tools will **infer a RAM block** (often called a **Block RAM** or **BRAM** on an FPGA).
  * The two separate `always @(posedge clk)` blocks tell the tool to create a **True Dual-Port RAM**, with one write/read port for 'A' and a second, independent write/read port for 'B'.
  * The `if(wr_en_a)` logic synthesizes to a multiplexer that controls when the RAM block's write-enable pin is activated.

-----

## 📊 Waveform

A **Waveform** is a graph that visually represents the value (1 or 0) of your design's signals over time. It is the main tool used to debug a design.

The waveform will show `q_a` and `q_b` updating *after* the positive clock edge.

  * At `t=15ns` (the posedge *after* `wr_en_b=1`), the RAM is written. If Port B's address was then set to `0` with `wr_en_b=0`, `q_b` would show `3` at the *next* clock edge.
  * At `t=35ns`, `ram[2]` will contain `7`, as Port B's write likely "won" the write conflict.
  * At `t=95ns`, `ram[5]` will contain `20`, as Port B's write again "won" the conflict.

-----

## 🔍 Observations

  * **Correction:** The `RAM_dual` module's port and memory array declarations were corrected to use `[ADDR_WIDTH-1:0]` (4 bits) and `[0:(1<<ADDR_WIDTH)-1]` (16 locations), matching the testbench.
  * **Dual-Port RAM:** The two `always` blocks model two independent ports, allowing simultaneous access, which is crucial for high-performance systems.
  * **Write Conflict:** The testbench correctly identifies a critical design hazard: at `t=25ns` and `t=85ns` (the setup time for the *next* clock edge), both ports try to write to the *same address* (`2` and `5`). In a simulation, one write (usually the last in the code, Port B) will "win". In a real chip, this would corrupt the data.
  * **Read Logic:** The design `else q_a <= ram[addr_a]` implies a "read-on-no-write" behavior. This means a port can *either* read or write on a given cycle, not both.

-----

## 🧩 Industry Relevance

  * **RAM:** Core component of all computer systems. Used for CPU registers, caches (L1/L2), and scratchpad memory.
  * **ROM:** Used for storing fixed data like bootloaders, firmware, and **Lookup Tables (LUTs)** (e.g., for sine/cosine values or video color correction).
  * **Dual-Port RAM:** Extremely common for buffering data between two different clock domains or two different processing units (e.g., a CPU writing data into the RAM and a network processor reading it out).

-----

  * ✅ **Status:** Completed
  * 🗓 **Day:** 13 / 100
  * 📚 **Next:** [Day 14 – FIFO (Synchronous) →](../Day14)
