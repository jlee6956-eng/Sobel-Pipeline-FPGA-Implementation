module line_buffer #(
    parameter int IMAGE_WIDTH = 8
    )  (
    input logic clk,
    input logic valid,
    input logic reset,
    input logic [7:0] pixel,
    input logic [3:0] col_counter,
    output logic [7:0] out_pixel
);

logic [7:0] last_row [0:IMAGE_WIDTH-1];
int i;
assign out_pixel = last_row[col_counter];

always_ff @(posedge clk) begin
    if (reset) begin
        for (i = 0; i < IMAGE_WIDTH; i = i + 1) begin
            last_row[i] <= 0;
        end
    end

    else if (valid) begin      
        last_row[col_counter] <= pixel;
    end
end

endmodule