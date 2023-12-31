`timescale 1ns/1ps
`include "C:/Architecture/Intelligent-Architecture/Lab5-Naive-TPU/lab5_proj/rtl/define.v"

module MM_top_tb();

reg                   clk                      ; 
reg                   rst                      ; 
reg                   arst_n                   ; 
// connect BRAM_FM32
wire    [  31:   0]   BRAM_FM32_addr           ; 
wire                  BRAM_FM32_clk            ; // clk
wire    [  31:   0]   BRAM_FM32_wrdata         ; // 'b0
wire    [  31:   0]   BRAM_FM32_rddata         ; 
wire                  BRAM_FM32_en             ; // 1'b1
wire                  BRAM_FM32_rst            ; // rst
wire    [   3:   0]   BRAM_FM32_we             ; // 'b0
// connect BRAM_WM32
wire    [  31:   0]   BRAM_WM32_addr           ; 
wire                  BRAM_WM32_clk            ; // clk
wire    [  31:   0]   BRAM_WM32_wrdata         ; // 'b0
wire    [  31:   0]   BRAM_WM32_rddata         ; 
wire                  BRAM_WM32_en             ; // 1'b1
wire                  BRAM_WM32_rst            ; // rst
wire    [   3:   0]   BRAM_WM32_we             ; // 'b0
// connect BRAM_CTRL
wire    [  31:   0]   BRAM_CTRL_addr           ; 
wire                  BRAM_CTRL_clk            ; // clk
wire    [  31:   0]   BRAM_CTRL_wrdata         ; 
wire    [  31:   0]   BRAM_CTRL_rddata         ; 
wire                  BRAM_CTRL_en             ; // 1'b1
wire                  BRAM_CTRL_rst            ; // rst
wire    [   3:   0]   BRAM_CTRL_we             ; 
// connect BRAM_OUT
wire    [  31:   0]   BRAM_OUT_addr            ; 
wire                  BRAM_OUT_clk             ; // clk
wire    [  31:   0]   BRAM_OUT_wrdata          ; 
wire    [  31:   0]   BRAM_OUT_rddata          ; 
wire                  BRAM_OUT_en              ; // 1'b1
wire                  BRAM_OUT_rst             ; // rst
wire    [   3:   0]   BRAM_OUT_we              ; 

reg                   arm_clk                  ;
reg                   arm_work                 ; 
reg     [   3:   0]   arm_BRAM_FM32_wea        ; // input wire [3 : 0] wea
reg     [  15:   0]   arm_BRAM_FM32_addra      ; // input wire [15 : 0] addra
reg     [  31:   0]   arm_BRAM_FM32_dina       ; // input wire [31 : 0] dina
wire    [  31:   0]   arm_BRAM_FM32_douta      ; // output wire [31 : 0] douta
reg     [   3:   0]   arm_BRAM_WM32_wea        ; // input wire [3 : 0] wea
reg     [  15:   0]   arm_BRAM_WM32_addra      ; // input wire [15 : 0] addra
reg     [  31:   0]   arm_BRAM_WM32_dina       ; // input wire [31 : 0] dina
wire    [  31:   0]   arm_BRAM_WM32_douta      ; // output wire [31 : 0] douta
reg     [   3:   0]   arm_BRAM_CTRL_wea        ; // input wire [3 : 0] wea
reg     [  15:   0]   arm_BRAM_CTRL_addra      ; // input wire [15 : 0] addra
reg     [  31:   0]   arm_BRAM_CTRL_dina       ; // input wire [31 : 0] dina
wire    [  31:   0]   arm_BRAM_CTRL_douta      ; // output wire [31 : 0] douta
reg     [   3:   0]   arm_BRAM_OUT_wea         ; // input wire [3 : 0] wea
reg     [  15:   0]   arm_BRAM_OUT_addra       ; // input wire [15 : 0] addra
reg     [  31:   0]   arm_BRAM_OUT_dina        ; // input wire [31 : 0] dina
wire    [  31:   0]   arm_BRAM_OUT_douta       ; // output wire [31 : 0] douta

wire    [  31:   0]   BRAM_FM32_addr_change    ; 
wire    [  31:   0]   BRAM_WM32_addr_change    ; 
wire    [  31:   0]   BRAM_CTRL_addr_change    ; 
wire    [  31:   0]   BRAM_OUT_addr_change     ; 

integer file_FM;
integer file_WM;
integer file_para;

integer fp_w;

integer line_FM;
integer line_WM;
integer line_para;
integer line_MMout;

reg FM_reg_valid,WM_reg_valid;
reg [7:0] FM_reg0,FM_reg1,FM_reg2,FM_reg3;
reg [7:0] WM_reg0,WM_reg1,WM_reg2,WM_reg3;

reg [15:0] M,N,P;

reg [15:0] cnt;
reg [15:0] cnt_f1;
reg [15:0] cnt_f2;
reg [15:0] cnt_f3;

localparam IDLE       = 8'b0000_0001;
localparam WRITE_FM   = 8'b0000_0010;
localparam WRITE_WM   = 8'b0000_0100;
localparam WRITE_COM  = 8'b0000_1000;
localparam WRITE_FLAG = 8'b0001_0000;
localparam WAIT_FLAG  = 8'b0010_0000;
localparam READ_OUT   = 8'b0100_0000;
localparam FINISH     = 8'b1000_0000;

reg [7:0] c_state;
reg [7:0] c_state_f1;
reg [7:0] c_state_f2;
reg [7:0] c_state_f3;
reg [7:0] n_state;

always @(posedge arm_clk or posedge rst) begin
    if (rst) begin
        c_state <= IDLE;
    end
    else begin
        c_state <= n_state;
    end
end

always @(*) begin
    case(c_state)
    IDLE: begin
        if (arm_work)
            n_state = WRITE_FM;
        else
            n_state = c_state;
    end
    WRITE_FM: begin
        if (cnt == N*((M-1)/4+1) - 'b1)
            n_state = WRITE_WM;
        else
            n_state = c_state;
    end
    WRITE_WM: begin
        if (cnt == N*((P-1)/4+1) - 'b1)
            n_state = WRITE_COM;
        else
            n_state = c_state;
    end
    WRITE_COM: begin
        if (cnt == 'd1)
            n_state = WRITE_FLAG;
        else
            n_state = c_state;
    end
    WRITE_FLAG: begin
        n_state = WAIT_FLAG;
    end
    WAIT_FLAG: begin
        if (arm_BRAM_CTRL_douta==`FLAG_FINISH)
            n_state = READ_OUT;
        else
            n_state = c_state;
    end
    READ_OUT: begin
        if (cnt == M*P-1)
            n_state = FINISH;
        else
            n_state = c_state;
    end
    FINISH: begin
        // n_state = IDLE;
        n_state = finish_sig ? IDLE : FINISH;
    end
    default: n_state = IDLE;
    endcase
end

always @(posedge arm_clk or posedge rst) begin
    if (rst) begin
        cnt_f1 <= 'b0;
        cnt_f2 <= 'b0;
        cnt_f3 <= 'b0;
        c_state_f1 <= IDLE;
        c_state_f2 <= IDLE;
        c_state_f3 <= IDLE;
    end
    else begin
        cnt_f1 <= cnt;
        cnt_f2 <= cnt_f1;
        cnt_f3 <= cnt_f2;
        c_state_f1 <= c_state;
        c_state_f2 <= c_state_f1;
        c_state_f3 <= c_state_f2;
    end
end

always @(posedge arm_clk or posedge rst) begin
    if (rst) begin
        cnt <= 'b0;
    end
    else if (c_state==WRITE_FM) begin
        if (cnt == N*((M-1)/4+1) - 'b1)
            cnt <= 'b0;
        else
            cnt <= cnt + 1'b1;
    end
    else if (c_state==WRITE_WM) begin
        if (cnt == N*((P-1)/4+1) - 'b1)
            cnt <= 'b0;
        else
            cnt <= cnt + 1'b1;
    end
    else if (c_state==WRITE_COM) begin
        if (cnt == 'd1)
            cnt <= 'b0;
        else
            cnt <= cnt + 1'b1;
    end
    else if (c_state==READ_OUT) begin
        if (cnt == M*P-1)
            cnt <= 'b0;
        else
            cnt <= cnt + 1'b1;
    end
    else begin
        cnt <= cnt;
    end
end

reg[0:7] feature[0:200][0:200];
reg[0:7] weight[0:200][0:200];
reg signed [0:31] std_result;
reg [0:31] sim_result[0:40000];
reg flag;

integer i, j, k, r;

reg finish_sig;

initial begin
    while(1) begin
        // file_FM = $fopen("C:/Architecture/Intelligent-Architecture/Lab5-Naive-TPU/lab5_proj/tb/test1/FM.txt","r");
        wait(c_state==WRITE_FM);
        // while(!$feof(file_FM)) begin
        //     @(posedge arm_clk)
        //     FM_reg_valid = 1'b1;
        //     line_FM = $fscanf(file_FM,"%d,%d,%d,%d,",FM_reg0,FM_reg1,FM_reg2,FM_reg3);
        // end
        for(j = 0; j < N; j = j + 1) begin
            for(i = 0; i < M; i =i + 4) begin
                @(posedge arm_clk)
                FM_reg_valid = 1'b1;
                {FM_reg0, FM_reg1, FM_reg2, FM_reg3} = $random;
                if(i + 1 >= M) begin
                    FM_reg1 = 0;
                    FM_reg2 = 0;
                    FM_reg3 = 0;
                end 
                else if(i + 2 >= M) begin
                    FM_reg2 = 0;
                    FM_reg3 = 0;
                end 
                else if(i + 3 >= M) begin
                    FM_reg3 = 0;
                end
                
                feature[i][j] = FM_reg0;
                feature[i + 1][j] = FM_reg1;
                feature[i + 2][j] = FM_reg2;
                feature[i + 3][j] = FM_reg3;
            end
        end
        // FM_reg_valid = 1'b0;
        // FM_reg0 = 'b0;
        // FM_reg1 = 'b0;
        // FM_reg2 = 'b0;
        // FM_reg3 = 'b0;
        // file_FM = $fopen("C:/Architecture/Intelligent-Architecture/Lab5-Naive-TPU/lab5_proj/tb/test2/FM.txt","r");
        // wait(c_state==WRITE_FM);
        // while(!$feof(file_FM)) begin
        //     @(posedge arm_clk)
        //     FM_reg_valid = 1'b1;
        //     line_FM = $fscanf(file_FM,"%d,%d,%d,%d,",FM_reg0,FM_reg1,FM_reg2,FM_reg3);
        // end
    end
end

initial begin
    while (1) begin
        // file_WM = $fopen("C:/Architecture/Intelligent-Architecture/Lab5-Naive-TPU/lab5_proj/tb/test1/WM.txt","r");
        wait(c_state==WRITE_WM);
        // while(!$feof(file_WM)) begin
        //     @(posedge arm_clk)
        //     WM_reg_valid = 1'b1;
        //     line_WM = $fscanf(file_WM,"%d,%d,%d,%d,",WM_reg0,WM_reg1,WM_reg2,WM_reg3);
        // end
        for(i = 0; i < N; i = i + 1) begin
            for(j = 0; j < P; j = j + 4) begin
                @(posedge arm_clk)
                WM_reg_valid = 1'b1;
                {WM_reg0, WM_reg1, WM_reg2, WM_reg3} = $random;

                if(j + 1 >= M) begin
                    WM_reg1 = 0;
                    WM_reg2 = 0;
                    WM_reg3 = 0;
                end else if(j + 2 >= M) begin
                    WM_reg2 = 0;
                    WM_reg3 = 0;
                end else if(j + 2 >= M) begin
                    WM_reg3 = 0;
                end
                weight[i][j] = WM_reg0;
                weight[i][j+1] = WM_reg1;
                weight[i][j+2] = WM_reg2;
                weight[i][j+3] = WM_reg3;
            end
        end
        r = 0;
        // WM_reg_valid = 1'b0;
        // WM_reg0 = 'b0;
        // WM_reg1 = 'b0;
        // WM_reg2 = 'b0;
        // WM_reg3 = 'b0;
        // file_WM = $fopen("C:/Architecture/Intelligent-Architecture/Lab5-Naive-TPU/lab5_proj/tb/test2/WM.txt","r");
        // wait(c_state==WRITE_WM);
        // while(!$feof(file_WM)) begin
        //     @(posedge arm_clk)
        //     WM_reg_valid = 1'b1;
        //     line_WM = $fscanf(file_WM,"%d,%d,%d,%d,",WM_reg0,WM_reg1,WM_reg2,WM_reg3);
        // end
    end
end

reg signed [0:31] cur_res_A;
reg signed [0:31] cur_res_B;

initial begin
    while (1) begin
        // file_para = $fopen("C:/Architecture/Intelligent-Architecture/Lab5-Naive-TPU/lab5_proj/tb/test1/para.txt","r");
        wait(c_state==IDLE);
        $display("~ Begin test ~");
        // while(!$feof(file_para)) begin
        //     line_para = $fscanf(file_para,"%d",M);
        //     line_para = $fscanf(file_para,"%d",N);
        //     line_para = $fscanf(file_para,"%d",P);
        // end
        M = {$random} % 10 + 1;
        N = {$random} % 10 + 1;
        P = {$random} % 10 + 1;
        // wait(c_state==FINISH);
        // file_para = $fopen("C:/Architecture/Intelligent-Architecture/Lab5-Naive-TPU/lab5_proj/tb/test2/para.txt","r");
        // wait(c_state==IDLE);
        // while(!$feof(file_para)) begin
        //     line_para = $fscanf(file_para,"%d",M);
        //     line_para = $fscanf(file_para,"%d",N);
        //     line_para = $fscanf(file_para,"%d",P);
        // end
        // wait(c_state==FINISH);
       
        FM_reg_valid = 1'b0;
        FM_reg0 = 'b0;
        FM_reg1 = 'b0;
        FM_reg2 = 'b0;
        FM_reg3 = 'b0;
        WM_reg_valid = 1'b0;
        WM_reg0 = 'b0;
        WM_reg1 = 'b0;
        WM_reg2 = 'b0;
        WM_reg3 = 'b0;
        finish_sig = 1'b0;
        wait(c_state==FINISH);
        wait(r == M * P)
        arm_work = 1'b0;
        flag = 1'b1;
        for (i = 0; i < M && flag; i = i + 1) begin
            for (j = 0; j < P && flag; j = j + 1) begin
                //@(posedge arm_clk)
                std_result = 'b0;
                for (k = 0; k < N; k = k + 1) begin
                    std_result = std_result + $signed({8'b0,feature[i][k]}) * $signed(weight[k][j]);
                end
                cur_res_A = std_result;
                cur_res_B = sim_result[i * P + j];
                if (std_result != sim_result[i * P + j]) begin
                    $display("Error: %d  !=  %d", std_result, sim_result[i * P + j]);
                    flag = 1'b0;
                end
            end
        end
        if (flag) begin
            $display("~ Pass test ~");
        end
        arm_work = 1'b1;
        finish_sig = 1;
    end
end

// initial begin
//     fp_w = $fopen("C:/Architecture/Intelligent-Architecture/Lab5-Naive-TPU/lab5_proj/tb/tb_MMout.txt","w");
// end

initial begin
    clk = 1'b0;
    arm_clk = 1'b0;
    rst = 1'b1;
    arst_n = 1'b0;
    arm_work = 1'b0;
    # 100
    rst = 1'b0;
    arst_n = 1'b1;
    # 100
    arm_work = 1'b1;
end

always #5 clk = ~clk;
always #7.5 arm_clk = ~arm_clk;

assign BRAM_FM32_addr_change = (BRAM_FM32_addr - `SADDR_F_MEM)>>2;
assign BRAM_WM32_addr_change = (BRAM_WM32_addr - `SADDR_W_MEM)>>2;
assign BRAM_CTRL_addr_change = (BRAM_CTRL_addr - `ADDR_FLAG)>>2;
assign BRAM_OUT_addr_change = (BRAM_OUT_addr - `SADDR_O_MEM)>>2;

parameter SIMULATOR = "VivadoSimulator"; // "VivadoSimulator" | "ModelsimSimulator"
// parameter SIMULATOR = "ModelsimSimulator"; 
reg FM_reg_valid_sim,WM_reg_valid_sim;
reg [7:0] FM_reg0_sim,FM_reg1_sim,FM_reg2_sim,FM_reg3_sim;
reg [7:0] WM_reg0_sim,WM_reg1_sim,WM_reg2_sim,WM_reg3_sim;
generate
    if (SIMULATOR == "VivadoSimulator") begin
        always @(posedge arm_clk) begin
            {FM_reg_valid_sim,WM_reg_valid_sim} <= {FM_reg_valid,WM_reg_valid};
            {FM_reg0_sim,FM_reg1_sim,FM_reg2_sim,FM_reg3_sim} <= {FM_reg0,FM_reg1,FM_reg2,FM_reg3};
            {WM_reg0_sim,WM_reg1_sim,WM_reg2_sim,WM_reg3_sim} <= {WM_reg0,WM_reg1,WM_reg2,WM_reg3};
        end
    end
    else if (SIMULATOR == "ModelsimSimulator") begin
        always @(*) begin
            {FM_reg_valid_sim,WM_reg_valid_sim} = {FM_reg_valid,WM_reg_valid};
            {FM_reg0_sim,FM_reg1_sim,FM_reg2_sim,FM_reg3_sim} = {FM_reg0,FM_reg1,FM_reg2,FM_reg3};
            {WM_reg0_sim,WM_reg1_sim,WM_reg2_sim,WM_reg3_sim} = {WM_reg0,WM_reg1,WM_reg2,WM_reg3};
        end
    end
endgenerate

always @(posedge arm_clk or posedge rst) begin
    if (rst) begin
        arm_BRAM_FM32_wea <= 'b0;
    end
    else begin
        arm_BRAM_FM32_wea <= {4{FM_reg_valid_sim}};
    end
end
always @(posedge arm_clk or posedge rst) begin
    if (rst) begin
        arm_BRAM_FM32_addra <= 'b0;
    end
    else if (c_state_f1==WRITE_FM) begin
        arm_BRAM_FM32_addra <= cnt_f1;
    end
end
always @(posedge arm_clk or posedge rst) begin
    if (rst) begin
        arm_BRAM_FM32_dina <= 'b0;
    end
    else begin
        arm_BRAM_FM32_dina <= {FM_reg3_sim,FM_reg2_sim,FM_reg1_sim,FM_reg0_sim};
    end
end
always @(posedge arm_clk or posedge rst) begin
    if (rst) begin
        arm_BRAM_WM32_wea <= 'b0;
    end
    else begin
        arm_BRAM_WM32_wea <= {4{WM_reg_valid_sim}};
    end
end
always @(posedge arm_clk or posedge rst) begin
    if (rst) begin
        arm_BRAM_WM32_addra <= 'b0;
    end
    else if (c_state_f1==WRITE_WM) begin
        arm_BRAM_WM32_addra <= cnt_f1;
    end
end
always @(posedge arm_clk or posedge rst) begin
    if (rst) begin
        arm_BRAM_WM32_dina <= 'b0;
    end
    else begin
        arm_BRAM_WM32_dina <= {WM_reg3_sim,WM_reg2_sim,WM_reg1_sim,WM_reg0_sim};
    end
end
always @(posedge arm_clk or posedge rst) begin
    if (rst) begin
        arm_BRAM_CTRL_wea <= 'b0;
    end
    else if (c_state_f1==WRITE_COM||c_state_f1==WRITE_FLAG) begin
        arm_BRAM_CTRL_wea <= {4{1'b1}};
    end
    else begin
        arm_BRAM_CTRL_wea <= 'b0;
    end
end
always @(posedge arm_clk or posedge rst) begin
    if (rst) begin
        arm_BRAM_CTRL_addra <= 'b0;
    end
    else if (c_state_f1==WRITE_COM) begin
        if (cnt_f1 == 'b0)
            arm_BRAM_CTRL_addra <= (`ADDR_COM1 - `ADDR_FLAG) >> 2;
        else if (cnt_f1 == 'b1)
            arm_BRAM_CTRL_addra <= (`ADDR_COM2 - `ADDR_FLAG) >> 2;
    end
    else if (c_state_f1==WRITE_FLAG) begin
        arm_BRAM_CTRL_addra <= (`ADDR_FLAG - `ADDR_FLAG) >> 2;
    end
    else if (c_state==WAIT_FLAG) begin
        arm_BRAM_CTRL_addra <= (`ADDR_FLAG - `ADDR_FLAG) >> 2;
    end
end
always @(posedge arm_clk or posedge rst) begin
    if (rst) begin
        arm_BRAM_CTRL_dina <= 'b0;
    end
    else if (c_state_f1==WRITE_COM) begin
        if (cnt_f1 == 'b0)
            arm_BRAM_CTRL_dina <= {P,M};
        else if (cnt_f1 == 'b1)
            arm_BRAM_CTRL_dina <= {16'b0,N};
    end
    else if (c_state_f1==WRITE_FLAG) begin
        arm_BRAM_CTRL_dina <= `FLAG_START;
    end
end
always @(posedge arm_clk or posedge rst) begin
    if (rst) begin
        arm_BRAM_OUT_wea <= 'b0;
    end
    else begin
        arm_BRAM_OUT_wea <= 'b0;
    end
end
always @(posedge arm_clk or posedge rst) begin
    if (rst) begin
        arm_BRAM_OUT_addra <= 'b0;
    end
    else if (c_state_f1==READ_OUT) begin
        arm_BRAM_OUT_addra <= cnt_f1;
    end
end
always @(posedge arm_clk or posedge rst) begin
    if (rst) begin
        arm_BRAM_OUT_dina <= 'b0;
    end
    else begin
        arm_BRAM_OUT_dina <= 'b0;
    end
end

always @(posedge arm_clk) begin
    if (c_state_f3==READ_OUT) begin
        // $fwrite(fp_w,"%d\n",$signed(arm_BRAM_OUT_douta));
        // sim_result[cnt_f3] = $signed(arm_BRAM_OUT_douta);
        sim_result[r] = arm_BRAM_OUT_douta;
		r = r + 1;
    end
end

tb_ram BRAM_FM32 (
  .clka(arm_clk),    // input wire clka
  .wea(arm_BRAM_FM32_wea),      // input wire [3 : 0] wea
  .addra(arm_BRAM_FM32_addra[15:0]),  // input wire [15 : 0] addra
  .dina(arm_BRAM_FM32_dina),    // input wire [31 : 0] dina
  .douta(arm_BRAM_FM32_douta),  // output wire [31 : 0] douta
  .clkb(BRAM_FM32_clk),    // input wire clkb
  .web(BRAM_FM32_we),      // input wire [3 : 0] web
  .addrb(BRAM_FM32_addr_change[15:0]),  // input wire [15 : 0] addrb
  .dinb(BRAM_FM32_wrdata),    // input wire [31 : 0] dinb
  .doutb(BRAM_FM32_rddata)  // output wire [31 : 0] doutb
);

tb_ram BRAM_WM32 (
  .clka(arm_clk),    // input wire clka
  .wea(arm_BRAM_WM32_wea),      // input wire [3 : 0] wea
  .addra(arm_BRAM_WM32_addra[15:0]),  // input wire [15 : 0] addra
  .dina(arm_BRAM_WM32_dina),    // input wire [31 : 0] dina
  .douta(arm_BRAM_WM32_douta),  // output wire [31 : 0] douta
  .clkb(BRAM_WM32_clk),    // input wire clkb
  .web(BRAM_WM32_we),      // input wire [3 : 0] web
  .addrb(BRAM_WM32_addr_change[15:0]),  // input wire [15 : 0] addrb
  .dinb(BRAM_WM32_wrdata),    // input wire [31 : 0] dinb
  .doutb(BRAM_WM32_rddata)  // output wire [31 : 0] doutb
);

tb_ram BRAM_CTRL (
  .clka(arm_clk),    // input wire clka
  .wea(arm_BRAM_CTRL_wea),      // input wire [3 : 0] wea
  .addra(arm_BRAM_CTRL_addra[15:0]),  // input wire [15 : 0] addra
  .dina(arm_BRAM_CTRL_dina),    // input wire [31 : 0] dina
  .douta(arm_BRAM_CTRL_douta),  // output wire [31 : 0] douta
  .clkb(BRAM_CTRL_clk),    // input wire clkb
  .web(BRAM_CTRL_we),      // input wire [3 : 0] web
  .addrb(BRAM_CTRL_addr_change[15:0]),  // input wire [15 : 0] addrb
  .dinb(BRAM_CTRL_wrdata),    // input wire [31 : 0] dinb
  .doutb(BRAM_CTRL_rddata)  // output wire [31 : 0] doutb
);

tb_ram BRAM_OUT (
  .clka(arm_clk),    // input wire clka
  .wea(arm_BRAM_OUT_wea),      // input wire [3 : 0] wea
  .addra(arm_BRAM_OUT_addra[15:0]),  // input wire [15 : 0] addra
  .dina(arm_BRAM_OUT_dina),    // input wire [31 : 0] dina
  .douta(arm_BRAM_OUT_douta),  // output wire [31 : 0] douta
  .clkb(BRAM_OUT_clk),    // input wire clkb
  .web(BRAM_OUT_we),      // input wire [3 : 0] web
  .addrb(BRAM_OUT_addr_change[15:0]),  // input wire [15 : 0] addrb
  .dinb(BRAM_OUT_wrdata),    // input wire [31 : 0] dinb
  .doutb(BRAM_OUT_rddata)  // output wire [31 : 0] doutb
);

MM_TOP U_MM_TOP(
    .clk                 (clk                ),
    .arst_n              (arst_n             ),
    .BRAM_FM32_addr      (BRAM_FM32_addr     ),
    .BRAM_FM32_clk       (BRAM_FM32_clk      ),
    .BRAM_FM32_wrdata    (BRAM_FM32_wrdata   ),
    .BRAM_FM32_rddata    (BRAM_FM32_rddata   ),
    .BRAM_FM32_en        (BRAM_FM32_en       ),
    .BRAM_FM32_rst       (BRAM_FM32_rst      ),
    .BRAM_FM32_we        (BRAM_FM32_we       ),
    .BRAM_WM32_addr      (BRAM_WM32_addr     ),
    .BRAM_WM32_clk       (BRAM_WM32_clk      ),
    .BRAM_WM32_wrdata    (BRAM_WM32_wrdata   ),
    .BRAM_WM32_rddata    (BRAM_WM32_rddata   ),
    .BRAM_WM32_en        (BRAM_WM32_en       ),
    .BRAM_WM32_rst       (BRAM_WM32_rst      ),
    .BRAM_WM32_we        (BRAM_WM32_we       ),
    .BRAM_CTRL_addr      (BRAM_CTRL_addr     ),
    .BRAM_CTRL_clk       (BRAM_CTRL_clk      ),
    .BRAM_CTRL_wrdata    (BRAM_CTRL_wrdata   ),
    .BRAM_CTRL_rddata    (BRAM_CTRL_rddata   ),
    .BRAM_CTRL_en        (BRAM_CTRL_en       ),
    .BRAM_CTRL_rst       (BRAM_CTRL_rst      ),
    .BRAM_CTRL_we        (BRAM_CTRL_we       ),
    .BRAM_OUT_addr       (BRAM_OUT_addr      ),
    .BRAM_OUT_clk        (BRAM_OUT_clk       ),
    .BRAM_OUT_wrdata     (BRAM_OUT_wrdata    ),
    .BRAM_OUT_rddata     (BRAM_OUT_rddata    ),
    .BRAM_OUT_en         (BRAM_OUT_en        ),
    .BRAM_OUT_rst        (BRAM_OUT_rst       ),
    .BRAM_OUT_we         (BRAM_OUT_we        )
);

endmodule
