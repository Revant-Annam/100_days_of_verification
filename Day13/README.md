# ⚙️ Day 13 — RAM (DRAM Model) & Synchronous ROM

## 📘 Topics Understood

  * **Memory Modeling (2D Arrays)**: `reg [width] mem [rows][cols]`
  * **Synchronous RAM & ROM**
  * **Address Multiplexing**: Using one address port for both row and column.
  * **DRAM Control Signals**: Using `ras_b` (Row Strobe) and `cas_b` (Column Strobe).
  * **Coincident Decoding**: Modeling the 2D array structure of memory.
  * **Synthesizable Initialization**: Using `$readmemh` to load memory from a file.
  * **Synchronous Read Latency**: Understanding the one-cycle delay in registered outputs.

-----

## 🧠 Description

This project implements two different types of synchronous memory blocks.

1.  **Synchronous RAM (DRAM Model):** This models a RAM that uses **address multiplexing** to save pins. A single `addr` port is used to first latch a **row address** (using `ras_b`) and then provide a **column address** (using `cas_b`). This is called **coincident decoding**, where the final memory cell is selected by the intersection of a row and column. This model uses 8 bits for the row and 8 bits for the column, creating a 256x256 (65,536 locations) memory array.

2.  **Synchronous ROM:** This models a simple Read-Only Memory. Its key feature is that it is **initialized from an external file** (`rom_data.mem`) using the `$readmemh` system task. This is the standard, synthesizable method for initializing large memories, as it separates the hardware design (the Verilog code) from the data it contains. The output is registered, giving it a one-cycle read latency.

-----

## 🧮 Timing Diagrams

  * **DRAM Write Cycle:**

    1.  `ras_b` goes low, latching the `addr` bus as the `row_reg`.
    2.  `cas_b` goes low, `addr` bus is used as the column, and `read=0` causes the `data_in` to be written.

  * **DRAM Read Cycle:**

    1.  `ras_b` goes low, latching the `row_reg`.
    2.  `cas_b` goes low, `addr` bus is used as the column, and `read=1` accesses the memory.
    3.  The `data_out` appears on the bus after a 1-clock-cycle synchronous delay.

-----

## 🧾 Verilog Design

  * **DRAM Model — `Day13/RAM.v`**

    ```verilog
    `timescale 1ns / 1ps
    module RAM #(parameter N=8, K=8)(
        input [K-1:0] addr,     // 8-bit multiplexed address port
        input [N-1:0] data_in,
        input cas_b,            // Column Addr Strobe (Active LOW)
        input ras_b,            // Row Addr Strobe (Active LOW)
        input enable,           // Chip Enable
        input clk,
        input read,             // 1 = Read, 0 = Write
        output reg [N-1:0] data_out 
        );
        
        // 8-bit register to latch the row address
        reg [K-1:0] row_reg;
        
        // 2D RAM Array (256 rows x 256 columns)
        reg [N-1:0] ram [(1<<K)-1:0][(1<<K)-1:0];
        
        always @(posedge clk) begin
            if(enable) begin
                
                // --- Action 1: Row Latching ---
                // Latch the row address when ras_b is low
                if (~ras_b) begin
                    row_reg <= addr;
                end
                
                // --- Action 2: Column Operation (R/W) ---
                // This is triggered by cas_b
                if (~cas_b) begin
                    
                    // Perform the R/W using:
                    // 1. The *already-latched* row_reg
                    // 2. The *current* 'addr' bus (as the column address)
                    
                    if (read) begin
                        data_out <= ram[row_reg][addr]; 
                    end
                    else begin
                        ram[row_reg][addr] <= data_in;
                    end
                end
                
            end
            else
                data_out <= 0;
        end
           
    endmodule
    ```

  * **Testbench (RAM) — `Day13/RAM_tb.v`**

    ```verilog
    `timescale 1ns / 1ps
    module RAM_tb #(parameter N=8, K=8)();
        
        reg [K-1:0] addr;
        reg [N-1:0] data_in;
        reg cas_b, ras_b, enable, clk, read;
        wire [N-1:0] data_out;
     
        RAM #(.N(N), .K(K)) ram (
            .addr(addr), .data_in(data_in), .cas_b(cas_b), .ras_b(ras_b), 
            .enable(enable), .clk(clk), .read(read), .data_out(data_out)
        );
        
        always #5 clk = ~clk; // 10ns clock
        
        initial begin
            $monitor("Time=%t | en=%b ras=%b cas=%b read=%b | addr=%h | data_in=%h | data_out=%h",
                      $time, enable, ras_b, cas_b, read, addr, data_in, data_out);
            
            // --- Initialize ---
            clk = 0;
            enable = 0;
            data_in = 0;
            read = 0;
            cas_b = 1; // De-assert (active low)
            ras_b = 1; // De-assert (active low)
            
            @(negedge clk);
            enable = 1;
            
            // --- Write 8'hAA to (Row=8'hA4, Col=8'h73) ---
            @(negedge clk);
            read = 0; // Set to WRITE
            data_in = 8'hAA;
            addr = 8'hA4; // 1. Put Row address on bus
            ras_b = 0; // 2. Strobe Row
            
            @(negedge clk);
            ras_b = 1; // 3. De-assert
            
            @(negedge clk);
            addr = 8'h73; // 4. Put Col address on bus
            cas_b = 0; // 5. Strobe Col (and Write)
            
            @(negedge clk);
            cas_b = 1; // 6. De-assert
    t       
            // --- Read from (Row=8'hA4, Col=8'h73) ---
            @(negedge clk);
            read = 1; // Set to READ
            addr = 8'hA4; // 1. Put Row address on bus
    s       ras_b = 0; // 2. Strobe Row
            
            @(negedge clk);
            ras_b = 1; // 3. De-assert
        s   
            @(negedge clk);
            addr = 8'h73; // 4. Put Col address on bus
            cas_b = 0; // 5. Strobe Col (and Read)
            
            @(negedge clk);
            cas_b = 1; // 6. De-assert
            
            @(posedge clk); 
            @(posedge clk); 
    t       $display("--- Test Complete. Read data = %h ---", data_out);
            $finish;
        end
    endmodule
    ```

  * **Synchronous ROM — `Day13/ROM.v`**

    ```verilog
    `timescale 1ns / 1ps
    module ROM #(
        parameter DATA_WIDTH = 8,
        parameter ADDR_WIDTH = 4
    ) (
        input                       clk,
        input [ADDR_WIDTH-1:0]    addr,
        output reg [DATA_WIDTH-1:0] data_out
    );

        // Calculate the depth (e.g., 2^4 = 16)
        localparam DEPTH = 1 << ADDR_WIDTH;

        // Declare the 2D array for the memory
        // [width] name [depth]
        reg [DATA_WIDTH-1:0] rom_data [0:DEPTH-1];

    s   // Initialize the memory from an external file
        // This is synthesizable for BRAMs/ROMs
        initial begin
            $readmemh("rom_data.mem", rom_data);
        end

        // Synchronous read (output is registered)
        always @(posedge clk) begin
            data_out <= rom_data[addr];
      s end

    endmodule
    ```

  * **ROM Data File — `Day13/rom_data.mem`**

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

  * **ROM Testbench — `Day13/rom_tb.v`**

    ```verilog
    `timescale 1ns / 1ps
    module rom_tb;
        localparam DATA_WIDTH = 8;
        localparam ADDR_WIDTH = 4;
        localparam DEPTH      = 1 << ADDR_WIDTH;

        reg                       clk;
    s   reg  [ADDR_WIDTH-1:0]    addr;
        wire [DATA_WIDTH-1:0]   data_out;
        integer i;

        ROM #(.DATA_WIDTH(DATA_WIDTH), .ADDR_WIDTH(ADDR_WIDTH)) 
          dut (.clk(clk), .addr(addr), .data_out(data_out));

        initial begin
            clk = 0;
            forever #5 clk = ~clk; // 10ns period clock
    s   end

        initial begin
            $monitor("Time=%t | Address = %h | Data Out = %h", $time, addr, data_out);
            
            for (i = 0; i < DEPTH; i = i + 1) begin
                addr = i;
                @(posedge clk);
            end
            
            @(posedge clk); // One extra cycle to see the last data
    s       $display("--- ROM Read Test Complete ---");
            $finish;
        end
    endmodule
    ```

-----

## ⚙️ RTL Design (Synthesis)

**Synthesis** is an automated process that "compiles" your Verilog RTL code into a **gate-level netlist** of basic logic gates and flip-flops.

  * **RAM (DRAM Model):** The `reg [...] ram [...]` line synthesizes into a large **Block RAM (BRAM)**. The `always` block creates the logic around it.
      * `if (~ras_b)` synthesizes to a D-flip-flop (`row_reg`) with its enable pin connected to `~ras_b`.
      * `if (~cas_b)` synthesizes to the logic controlling the BRAM's read/write ports, using `row_reg` for the upper address bits and the `addr` port for the lower address bits.
  * **ROM (Sync):** The `reg [...] rom_data [...]` line also synthesizes to a BRAM, but in ROM mode. The `$readmemh` task is a **synthesis-time directive** that tells the tool to pre-load the BRAM with the data from `rom_data.mem`.

-----

## 📊 Waveform

A **Waveform** is a graph that visually represents the value (1 or 0) of your design's signals over time. It is the main tool used to debug a design.

  * **RAM Waveform:** The `RAM_tb.v` simulation will show `ras_b` going low, latching `addr=A4`. Then, `cas_b` goes low, and the `addr=73` is used as the column. The read/write happens at this point. For the read, `data_out` will show the data on the *next* clock edge.
  * **ROM Waveform:** The `rom_tb.v` simulation will show a **one-cycle read latency**. When the `addr` changes (e.g., to `3`), `data_out` will still show the data for `addr=2`. On the *next* clock edge, `data_out` will update to `EF` (the data for `addr=3`).

-----

## 🔍 Observations

  * **Robustness:** The DRAM model is now robust. By separating the `ras_b` (row latch) and `cas_b` (column operation) into independent `if` statements, we fix the race condition where we were trying to read from and write to the `row_reg` in the same cycle.
  * **Sequential Operation:** This design correctly models the multi-cycle nature of DRAM access: (1) latch row, (2) latch column and operate.
  * **Synthesizable Initialization:** The `$readmemh` method is the industry standard for initializing any on-chip memory (RAM or ROM) as it separates the hardware logic from the data.

-----

## 🧩 Industry Relevance

  * **High-Capacity RAM:** This is the **fundamental concept** behind all modern, high-capacity DRAM (like the DDR3/4/5 in your PC). Address multiplexing is essential for saving package pins.
  * **ROM:** Used for storing fixed data like bootloaders, firmware, and **Lookup Tables (LUTs)** (e.g., for sine/cosine values, filter coefficients, or video color correction).

-----

  * ✅ **Status:** Completed
  * 🗓 **Day:** 13 / 100
  * 📚 **Next:** [Day 14 – FIFO (Synchronous) →](https://www.google.com/search?q=../Day14)
