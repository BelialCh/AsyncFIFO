// Copyright (C) 2024 by Berial
// Module Name: WriteModule
// Description: Module for writing and full flag generation including transmission to fifo_memory and binary to gray 
module WriteModule
//声明写地址位数
#(parameter ADDRSIZE = 7)
//根据结构框图，声明输入和输出变量
(
  output reg [ADDRSIZE:0]   wptr_gray, //写指针8位，转换成格雷码后赋予给它作为进位判断满信号
  output logic [ADDRSIZE-1:0] waddr,   //写地址7位，用于顺序写数据
  output reg wfull,                   //写满信号标志位
  input  wclk,wrst_n,w_en,            //写时钟、写复位(低电平有效)、写使能
  input  wire [ADDRSIZE:0]   r2wptr  //由读子模块同步到写时钟用作与写时针格雷码比较判断满信号，此信号已经在ReadModule转换成格雷码
);
//声明内部变量，考虑写指针需要有二进制形式和格雷码形式
  reg [ADDRSIZE:0] wptr_bina;
//写指针+1运算
  always@(posedge wclk or negedge wrst_n)
  begin
    if(!wrst_n) wptr_bina<=0;
    else if(w_en&&!wfull) wptr_bina<=wptr_bina+1'b1;  
  end
//将写指针-1位后赋予给写地址
  assign waddr = wptr_bina[ADDRSIZE-1:0];
//二进制转换成格雷码
  assign wptr_gray = (wptr_bina>>1)^wptr_bina;
//判断满信号是否产生，最高位和次高位不同，其他位均相同代表满信号产生
  always@(posedge wclk or negedge wrst_n)
  begin
    if(!wrst_n) 
         wfull<=0;
    else 
    if(wptr_gray == {~r2wptr[ADDRSIZE:ADDRSIZE-1],r2wptr[ADDRSIZE-2:0]}) 
         wfull<= 1;  
    else wfull<=0;
   end
endmodule
