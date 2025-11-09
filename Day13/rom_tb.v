`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/02/2025 10:13:06 PM
// Design Name: 
// Module Name: rom_tb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


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
            @(posedge clk); //at each posedge the data is read
        end
        
        @(posedge clk); // One extra cycle to see the last data
        $finish;
    end

endmodule
