`timescale 1ns / 1ps

module duty #(parameter N = 21) (
    input wire clk,
    input wire [$clog2(N)-1:0] addr,  // Address to read from (log2(N) bits)
    output reg [6:0] data_out          // Duty cycle value read from memory
);

    // Memory array to store duty cycle values
    reg [6:0] memory [0:N-1];  // N locations, each 7 bits wide

    // Initialize memory from a file
    initial begin
        $readmemh("duty.mem", memory);  // Load duty cycle values from file
    end

    // Read from memory on the positive edge of the clock
    always @(posedge clk) begin
        data_out <= memory[addr];
    end

endmodule