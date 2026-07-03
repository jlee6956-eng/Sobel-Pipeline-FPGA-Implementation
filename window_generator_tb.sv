`timescale 1ns/1ps

module window_generator_tb;

logic clk;
logic reset;
logic [7:0] pixels [0:32];
logic valid;
int i;

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


parameter int dimension = 3;


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

initial begin
    clk = 0;
    forever #5 clk = ~clk;
end

initial begin
    reset = 1;
    valid = 0;
    pixels[0] = 8'b10101010;
    pixels[1] = 8'b10111010;
    pixels[2] = 8'b10101010;
    pixels[3] = 8'b00101010;
    pixels[4] = 8'b10101011;
    pixels[5] = 8'b10101111;
    pixels[6] = 8'b11101110;
    pixels[7] = 8'b10000010;
    pixels[8] = 8'b00101010;
    pixels[9] = 8'b10110110;
    pixels[10] = 8'b10110110;
    pixels[11] = 8'b10011010;
    pixels[12] = 8'b10001010;
    pixels[13] = 8'b00101010;
    pixels[14] = 8'b11101010;
    pixels[15] = 8'b10101001;
    pixels[16] = 8'b10101011;
    pixels[17] = 8'b11001110;
    pixels[18] = 8'b10011010;
    pixels[19] = 8'b10101010;
    pixels[20] = 8'b10001110;
    pixels[21] = 8'b00000110;
    pixels[22] = 8'b10011010;
    pixels[23] = 8'b10011010;
    pixels[24] = 8'b11101010;
    pixels[25] = 8'b11101010;
    pixels[26] = 8'b10001011;
    pixels[27] = 8'b10101100;
    pixels[28] = 8'b11101000;
    pixels[29] = 8'b10010010;
    pixels[30] = 8'b00110010;
    pixels[31] = 8'b11010110;
    pixels[32] = 8'b11110110;
    #12;
    reset = 0;
    valid = 1;
    for (i = 0; i < 33; i = i + 1) begin
        @(posedge clk);
        in_pixel = pixels[i];
        @(negedge clk);
        $display ("t=%0t in=%b | top=%b %b %b | mid=%b %b %b | bot=%b %b %b",
        $time, in_pixel,
        left0, mid0, right0,
        left1, mid1, right1,
        left2, mid2, right2);
    end

    @(negedge clk);
    valid = 0;
    in_pixel = 0;

    @(posedge clk);
    $finish;

end

initial begin
    $display("started!");
end

    

endmodule