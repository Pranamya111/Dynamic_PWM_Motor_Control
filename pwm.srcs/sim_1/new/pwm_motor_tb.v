`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 17.03.2025 15:15:15
// Design Name: 
// Module Name: pwm_motor_tb
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

module pwm_motor_tb;

    // Parameters
    parameter N = 21;          // Number of duty cycle values
    parameter MAX_COUNT = 99;  // Maximum counter value (PWM resolution)

    // Inputs
    reg clk;
    reg reset;

    // Outputs
    wire pwm_out;
    wire [$clog2(MAX_COUNT+1)-1:0] counter;

    // Instantiate the Unit Under Test (UUT)
    pwm_motor #(N, MAX_COUNT) uut (
        .clk(clk),
        .reset(reset),
        .pwm_out(pwm_out),
        .counter(counter)
    );
    
    

    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk;  // Toggle clock every 5 time units (10ns period)
    end

    // Reset generation
    initial begin
        reset = 1; #10;
        reset = 0; #30400;
    reset = 1;  // (100 clock cycles=10050)(200=20100)
        $finish;
    end

    // Monitoring
    initial begin
        $monitor("Time: %0t | CLK: %b | Reset: %b | Counter: %d | PWM Out: %b", $time, clk, reset, counter, pwm_out);
    end
   
    
endmodule