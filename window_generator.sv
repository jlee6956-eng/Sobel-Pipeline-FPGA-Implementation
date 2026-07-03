module window_generator (
    input logic clk,
    input logic [7:0] pixel,
    input logic valid,
    input logic reset,
    output logic [7:0] left0,
    output logic [7:0] mid0, 
    output logic [7:0] right0,
    output logic [7:0] left1,
    output logic [7:0] mid1,
    output logic [7:0] right1,
    output logic [7:0] left2,
    output logic [7:0] mid2, 
    output logic [7:0] right2
);

logic [7:0] p_pixel;
logic [7:0] o_pixel;
logic [3:0] col_counter;
parameter int IMAGE_WIDTH = 8;

line_buffer prev_line (
    .clk(clk),
    .valid(valid),
    .reset(reset),
    .pixel(pixel),
    .col_counter(col_counter),
    .out_pixel(p_pixel)
);

line_buffer old_line (
    .clk(clk),
    .valid(valid),
    .reset(reset),
    .pixel(p_pixel),
    .col_counter(col_counter),
    .out_pixel(o_pixel)
);

always_ff @(posedge clk) begin
    if (reset) begin
        left0 <= 0;
        mid0 <= 0;
        right0 <= 0;
        left1 <= 0;
        mid1 <= 0;
        right1 <= 0;
        left2 <= 0;
        mid2 <= 0;
        right2 <= 0;
        col_counter <= 0;

    end else if (valid && col_counter > 0) begin
        left0 <= mid0;
        mid0 <= right0;
        right0 <= o_pixel;
        left1 <= mid1;
        mid1 <= right1;
        right1 <= p_pixel;
        left2 <= mid2;
        mid2 <= right2;
        right2 <= pixel;
        if (col_counter == IMAGE_WIDTH - 1) begin
            col_counter <= 0;
        end else begin
            col_counter <= col_counter + 1;
        end
    end else if (valid && col_counter == 0) begin
        left0 <= 0;
        mid0 <= 0;
        right0 <= o_pixel;
        left1 <= 0;
        mid1 <= 0;
        right1 <= p_pixel;
        left2 <= 0;
        mid2 <= 0;
        right2 <= pixel;
        col_counter <= col_counter + 1;
    end
end

endmodule