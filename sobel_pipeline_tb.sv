`timescale 1ns/1ps

module sobel_pipeline_tb #(
    parameter int HEIGHT = 8,
    parameter int WIDTH = 8,
    parameter int NUM_PIXELS = HEIGHT * WIDTH,
);

logic clk;
logic reset;
logic [7:0] pixels [0:NUM_PIXELS];
logic valid;
int i;
logic [7:0] edge_values [0:NUM_PIXELS];

logic [7:0] in_pixel;
logic [7:0] left0;
logic [7:0] mid0;
logic [7:0] right0;
logic [7:0] left1;
logic [7:0] mid1;
logic [7:0] right1;
logic [7:0] left2;
logic [7:0] mid2;
logic [7:0] right2;
logic [9:0] x_edge_pixel;
logic [9:0] y_edge_pixel;
logic [10:0] edge_scaled;


window_generator wg_tb (
    .clk(clk),
    .pixel(in_pixel),
    .valid(valid),
    .reset(reset),
    .left0(left0),
    .mid0(mid0),
    .right0(right0),
    .left1(left1),
    .mid1(mid1),
    .right1(right1),
    .left2(left2),
    .mid2(mid2),
    .right2(right2)
);

convolution convolution_tb (
    .left0(left0),
    .mid0(mid0),
    .right0(right0),
    .left1(left1),
    .mid1(mid1),
    .right1(right1),
    .left2(left2),
    .mid2(mid2),
    .right2(right2),
    .x_edge_pixel(x_edge_pixel),
    .y_edge_pixel(y_edge_pixel),
    .edge_scaled(edge_scaled)
);

initial begin
    clk = 0;
    forever #5 clk = ~clk;
end

initial begin
    $readmemb("image.mem", pixels);
end


initial begin
    reset = 1;
    valid = 0;
    #12;
    reset = 0;
    valid = 1;
    for (i = 0; i < NUM_PIXELS; i = i + 1) begin
        @(negedge clk)
        in_pixel = pixels[i];
        @(negedge clk);
        $display ("t=%0t in=%b | top=%b %b %b | mid=%b %b %b | bot=%b %b %b",
        $time, in_pixel,
        left0, mid0, right0,
        left1, mid1, right1,
        left2, mid2, right2);
        $display("X Edge Pixel: %d, Y Edge Pixel: %d, Edge Scaled: %d", x_edge_pixel, y_edge_pixel, edge_scaled);
    end

    @(negedge clk);
    valid = 0;
    in_pixel = 0;

    @(posedge clk);
    $finish;
end

initial begin
    $dumpfile("wave.vcd");
    $dumpvars(0, sobel_pipeline_tb);
end

initial begin
    $display("started!");
end

    

endmodule