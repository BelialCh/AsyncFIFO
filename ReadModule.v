// Copyright (C) 2024 by Berial
// Module Name: ReadModule
// Description: Module for reading and empty flag generation including transmission of reading address to fifo_memory and binary to gray 
module ReadModule
//声明读地址位宽
#(parameter ADDRSIZE = 7)
//声明输入和输出变量
(
    output reg [ADDRSIZE:0] rptr_gray,   //读指针8位，转换成格雷码后赋予给它作为进位判断空信号
    output reg [ADDRSIZE-1:0] raddr,//读地址7位，用于顺序读取数据
    output reg rempty,              //读空信号标志位
    input  rclk,rrst_n,r_en,        //读时钟、读复位(低电平有效)、读使能
    input [ADDRSIZE:0] w2rptr       //由写模块同步到读时钟，用作与读指针格雷码比较判断空信号，此信号已经在WriteModule转换成格雷码
);
//声明内部变量，考虑读指针需要有二进制形式和格雷码形式
  reg [ADDRSIZE:0] rptr_bina;
//读指针+1运算
  always@(posedge rclk or negedge rrst_n)
  begin
    if(!rrst_n) rptr_bina<=0;
    else if(r_en&&!rempty) rptr_bina<=rptr_bina+1'b1;  
  end
//二进制转换成格雷码
  assign rptr_gray = (rptr_bina>>1)^rptr_bina;
//判断空信号是否产生，所有位数均相同代表空信号产生
  always@(posedge rclk or negedge rrst_n)
  begin
    if(!rrst_n) rempty<=1'b0;
    else if(rptr_gray == {w2rptr[ADDRSIZE:0]}) rempty<= 1;
    else rempty<=0;  
  end
//将读指针-1位后赋予给读地址
  assign raddr = rptr_bina[ADDRSIZE-1:0];
endmodule
