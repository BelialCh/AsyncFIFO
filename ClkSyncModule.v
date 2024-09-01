// Copyright (C) 2024 by Berial
// Module Name: Clock Synchronizing Module
/* Description: Module for clock synchornization between Write clock and Read clock.
   This Module contains two duplicate parts:one is to synchornize Write clock to ReadModule, 
   the other is opposite.Two of them have the same form of code.*/
module ClkSyncModule
//声明读地址位宽
#(parameter ADDRSIZE = 7)
//声明输入和输出变量
(
    output logic [ADDRSIZE:0] w2rptr,//来自写模块同步到读时钟的写指针
    output logic [ADDRSIZE:0] r2wptr,//来自读模块同步到写时钟的读指针
    input  [ADDRSIZE:0] wptr_gray,   //写指针格雷码形式
    input  [ADDRSIZE:0] rptr_gray,        //读指针格雷码形式
    input wclk,wrst_n,rclk,rrst_n    //写时钟,写复位,读时钟,读复位
);
//声明内部变量，考虑两个D触发器中第一级DFF的输出
    logic   [ADDRSIZE:0] wptr1;
    logic   [ADDRSIZE:0] rptr1;
//写指针同步到读时钟的二级DFF
always@(posedge rclk or negedge rrst_n)
    if(!rrst_n) begin wptr1<=0;w2rptr<=0; end
    else begin w2rptr<=wptr1;wptr1<=wptr_gray;end//写指针同步到读时钟，打两拍
//读指针同步到写时钟的二级DFF
always@(posedge wclk or negedge wrst_n)
    if(!wrst_n) begin rptr1<=0;r2wptr<=0; end
    else begin r2wptr<=rptr1;rptr1<=rptr_gray;end//读指针同步到写时钟，打两拍
endmodule
