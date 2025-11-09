`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/02/2025 09:45:01 PM
// Design Name: 
// Module Name: ROM
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


module ROM #(
    parameter DATA_WIDTH = 8,
    parameter ADDR_WIDTH = 4
) (
    input                       clk,
    input [ADDR_WIDTH-1:0]      addr,
    output reg [DATA_WIDTH-1:0] data_out
);

    localparam DEPTH = 1 << ADDR_WIDTH;

    // Declare the 2D array for the memory
    reg [DATA_WIDTH-1:0] rom_data [0:DEPTH-1];

    // Initialize the memory from an external file
    initial begin
        $readmemh("rom_data.mem", rom_data);
    end

    // Synchronous read (output is registered)
    always @(posedge clk) begin
        data_out <= rom_data[addr];
    end

endmodule
