module MAC(
    input clk,
    input rst,
    // 乘累加长度
    input num_valid,
    input [31:0] num,
    output reg num_valid_r,
    output reg [31:0] num_r,
    // 纵向数据
    input w_valid,
    input signed [7:0] w_data,
    output reg w_valid_r,
    output reg signed [7:0] w_data_r,
    // 横向数据
    input f_valid,
    input [7:0] f_data,
    output reg f_valid_r,
    output reg [7:0] f_data_r,
    // 数据输出，纵向向上传播
    input valid_l,
    input signed [31:0] data_l,
    output reg valid_o,
    output reg signed [31:0] data_o // 输出数据需要经过选择
    );

// 乘累加长度
always @(posedge clk or posedge rst) begin
    if (rst) begin
        num_r <= 32'b0;
    end
    else if (num_valid) begin
        num_r <= num;
    end
    else begin
        num_r <= num_r;
    end
end
always @(posedge clk or posedge rst) begin
    if (rst) begin
        num_valid_r <= 1'b0;
    end
    else begin
        num_valid_r <= num_valid;
    end
end
// 纵向数据
always @(posedge clk or posedge rst) begin
    if (rst) begin
        w_data_r <= 32'b0;
    end
    else begin
        w_data_r <= w_data;
    end
end
always @(posedge clk or posedge rst) begin
    if (rst) begin
        w_valid_r <= 1'b0;
    end
    else begin
        w_valid_r <= w_valid;
    end
end
// 横向数据
always @(posedge clk or posedge rst) begin
    if (rst) begin
        f_data_r <= 32'b0;
    end
    else begin
        f_data_r <= f_data;
    end
end
always @(posedge clk or posedge rst) begin
    if (rst) begin
        f_valid_r <= 1'b0;
    end
    else begin
        f_valid_r <= f_valid;
    end
end
// 本级控制信号
reg [31:0] num_cnt;
wire valid;
wire last;
assign valid = w_valid & f_valid;
assign last = (num_cnt == num_r - 1'b1);
always @(posedge clk or posedge rst) begin
    if (rst) begin
        num_cnt <= 32'b0;
    end
    else if (valid) begin
        if (num_cnt == num_r - 1'b1) begin
            num_cnt <= 32'b0;
        end
        else begin
            num_cnt <= num_cnt + 1'b1;
        end
    end
    else begin
        num_cnt <= num_cnt;
    end
end
wire signed [15:0] sf_data;
assign sf_data = $signed({8'b0,f_data});
// 本级计算
reg signed [31:0] data_reg;
always @(posedge clk or posedge rst) begin
    if (rst) begin
        data_reg <= 32'b0;
    end
    else if (valid) begin
        if (last) begin
            data_reg <= 32'b0;
        end
        else begin
            data_reg <= data_reg + $signed(w_data)*$signed(sf_data);
        end
    end
    else begin
        data_reg <= data_reg;
    end
end
// 数据输出，纵向向上传播
always @(posedge clk or posedge rst) begin
    if (rst) begin
        data_o <= 32'b0;
    end
    else if (valid&last) begin
        data_o <= data_reg + $signed(w_data)*$signed(sf_data);
    end
    else if (valid_l) begin
        data_o <= data_l;
    end
    else begin
        data_o <= data_o;
    end
end
always @(posedge clk or posedge rst) begin
    if (rst) begin
        valid_o <= 32'b0;
    end
    else begin
        valid_o <= (valid&last)|valid_l;
    end
end

endmodule