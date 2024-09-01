`timescale 1ns / 1ps
module TestBench
#(
    parameter DATASIZE = 64,
    parameter ADDRSIZE = 7
  )
(
    output logic [DATASIZE-1:0] rdata,
    output logic wfull,rempty,
    input reg [DATASIZE-1:0] wdata,
    input reg w_en, wclk, wrst_n,
    input reg r_en, rclk, rrst_n
);
//声明顶层模块
TopFIFO TopFIFO (
                 .rdata(rdata),  .wdata(wdata), 
                 .wfull(wfull),  .rempty(rempty),  
                 .w_en(w_en),    .r_en(r_en),
                 .wclk(wclk),    .rclk(rclk), 
                 .wrst_n(wrst_n),    .rrst_n(rrst_n)
                );
 localparam CYCLE  = 10;
 localparam CYCLE1 = 30;
//初始化1：
    initial begin//针对写时钟
         wclk = 0;//上电为低平
         forever
         #(CYCLE/2)
         wclk=~wclk;//5ns翻转一次,时钟周期10ns，即100MHz时钟频率
    end 
    initial begin//针对读时钟
        rclk = 0;//上电为低平
        forever
        #(CYCLE1/2)
        rclk=~rclk;//15ns翻转一次，时钟周期30ns，即33MHz时钟频率
     end
     initial begin//针对写复位
         wrst_n = 1;//上电高平无效
         #2//延时2ns
         wrst_n = 0;//复位
         #(CYCLE*3)//延时30ns
         wrst_n = 1;//高平，此时fifo开始工作
     end    
     initial begin
        rrst_n = 1;
        #2;
        rrst_n = 0;
        #(CYCLE*3);
        rrst_n = 1;
      end 
      initial begin
          w_en=0;//上电写使能关
          #5 w_en=1;//延时5ns后允许写
      end 
     
      initial begin
         r_en=0;
          #5 r_en=1;
      end       
always 
#10 wdata= {$random}%10 ;//写入每10以内随机数
endmodule