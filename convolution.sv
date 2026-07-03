module convolution #(
    parameter int scaleFactor = 0
    )   (
    input logic [7:0] left0,
    input logic [7:0] mid0, 
    input logic [7:0] right0,
    input logic [7:0] left1,
    input logic [7:0] mid1,
    input logic [7:0] right1,
    input logic [7:0] left2,
    input logic [7:0] mid2, 
    input logic [7:0] right2,
    output logic [9:0] x_edge_pixel,
    output logic [9:0] y_edge_pixel,
    output logic [10:0] edge_scaled
);

logic signed [10:0] sumx;
logic signed [10:0] sumy;
logic [7:0] edge_pixel;

always_comb begin
    sumx = -$signed({1'b0,left0}) + ($signed({1'b0,left1}) * -2) - $signed({1'b0,left2}) + $signed({1'b0,right0}) + ($signed({1'b0,right1}) * 2) + $signed({1'b0,right2});
    if (sumx < 0) begin
        x_edge_pixel = -sumx;
    end else begin
        x_edge_pixel = sumx;
    end

    sumy = -$signed({1'b0,left0}) + ($signed({1'b0,mid0}) * -2) - $signed({1'b0,right0}) + $signed({1'b0,left2}) + ($signed({1'b0,mid2}) * 2) + $signed({1'b0,right2});
    if (sumy < 0) begin
        y_edge_pixel = -sumy;
    end else begin
        y_edge_pixel = sumy;
    end
    edge_pixel = x_edge_pixel + y_edge_pixel;
    edge_scaled = edge_pixel >> scaleFactor;
    if (edge_scaled > 255) begin
        edge_scaled = 255;
    end else if (edge_scaled < 155) begin
        edge_scaled = 0;
    end



end
endmodule