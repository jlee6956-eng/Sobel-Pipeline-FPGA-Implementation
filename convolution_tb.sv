`timescale 1ns/1ps

module convolution_tb;


logic [7:0] left0 = 8'b10101010;
logic [7:0] mid0 = 8'b10111010;
logic [7:0] right0 = 8'b10101010;
logic [7:0] left1 = 8'b00101010;
logic [7:0] mid1 = 8'b10101011;
logic [7:0] right1 = 8'b10101111;
logic [7:0] left2 = 8'b11101110;
logic [7:0] mid2 = 8'b10000010;
logic [7:0]right2 = 8'b00101010;

parameter int NUM_PIXELS = 33;

logic [7:0] pixels [0:9];

logic [9:0] x_edge_pixel;
logic [9:0] y_edge_pixel;
logic [10:0] edge_pixel;


convolution c_tb (
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
    .edge_pixel(edge_pixel)
);

initial begin
    #100
    $display("X Edge Pixel: %d, Y Edge Pixel: %d", x_edge_pixel, y_edge_pixel);
    if (edge_pixel == 242) begin
        $display("Success!");
    end else begin
        $display("Failure!, answer is 242 but output is %d", edge_pixel);
    end
    #100
    $finish;


end


endmodule