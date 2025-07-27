`timescale 1ns / 1ps


module pwm_motor #(parameter N = 21, parameter MAX_COUNT = 99) (
    input wire clk,
    input wire reset,
    output reg pwm_out,
    output reg [$clog2(MAX_COUNT+1)-1:0] counter  // Counter width is log2(MAX_COUNT+1)
);

    // Memory interface
    wire [6:0] duty_cycle;
    reg [$clog2(N)-1:0] addr;  // Address width is log2(N)

    // Instantiate the memory module
    duty #(N) memory (
        .clk(clk),
        .addr(addr),
        .data_out(duty_cycle)
    );

    // Counter logic
    always @(posedge clk or posedge reset) begin
        if (reset)
            counter <= 0;  // Reset counter to 0
        else if (counter == MAX_COUNT)
            counter <= 0;  // Reset counter after reaching MAX_COUNT
        else
            counter <= counter + 1;  // Increment counter
    end

    // PWM generation logic
    always @(posedge clk or posedge reset) begin
        if (reset)
            pwm_out <= 1'b0;  // Reset PWM output to 0
        else if (counter < duty_cycle-1)
            pwm_out <= 1'b1;  // Set PWM output high when counter < duty_cycle
        else
            pwm_out <= 1'b0;  // Set PWM output low when counter >= duty_cycle
    end

    // Address generation logic (cycle through N addresses)
    always @(posedge clk or posedge reset) begin
        if (reset)
            addr <= 0;  // Start at address 0
        else if (counter == MAX_COUNT) begin
            if (addr == N-1)
                addr <= 0;  // Wrap around after reaching the last address
            else
                addr <= addr + 1;  // Increment address after each PWM cycle
        end
    end

endmodule