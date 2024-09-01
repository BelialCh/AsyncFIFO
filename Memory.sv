// Copyright (C) 2024 by Berial
// Module Name: fifo_memory
// Description: memory for fifo, define read and write operation
module fifo_memory
//定义数据宽度和地址宽度
 #(
    parameter DATASIZE=64,
    parameter ADDRSIZE=7
  )
//声明输出输入变量
  (
    output reg [DATASIZE-1:0] rdata,
    input  [DATASIZE-1:0] wdata,
    input  [ADDRSIZE-1:0] raddr,
    input  [ADDRSIZE-1:0] waddr,
    input  wclk,
    input  w_en,
    input  wfull
  );
//声明数据深度，即mem可以存多少个数据项
  localparam DATADEP = 1<<ADDRSIZE;
//定义64位的mem，数据深度为2^7=128
  reg [DATASIZE-1:0] MEM [0:DATADEP-1];
//读数据操作
    assign rdata = MEM[raddr];
//写数据操作，需在写时钟上升沿进行，且需判断写满位无效和写使能有效
  always@(posedge wclk)
     if(!wfull && w_en) MEM[waddr]<=wdata;
endmodule
