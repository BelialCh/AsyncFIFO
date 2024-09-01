// Copyright (C) 2024 by Berial
// Module Name: TopFIFO
// Description: Top module for Port declaration and Module declaration,i.e. the connector among all the modules.
module TopFIFO//����ģ�飬���ж˿�������ģ������
//�������ݿ�Ⱥ͵�ַ���
 #(
    parameter DATASIZE=64,
    parameter ADDRSIZE=7
  )
//������ϵͳ��ͼ�����������������
(
    output [DATASIZE-1:0] rdata,
    output wfull,rempty,
    output [ADDRSIZE:0] wptr_gray,
    output [ADDRSIZE:0] rptr_gray,
    output [ADDRSIZE:0] r2wptr,
    output [ADDRSIZE:0] w2rptr,
    input  [DATASIZE-1:0] wdata,
    input wclk,wrst_n,w_en,
    input rclk,rrst_n,r_en
);
//������ϵͳ��ͼ�������ڲ�����
    logic [ADDRSIZE-1:0] waddr,raddr;
//memģ������
fifo_memory fifo_memory
  (
    .wclk(wclk),
    .wfull(wfull),
    .wdata(wdata),.rdata(rdata),
    .raddr(raddr),.waddr(waddr),
    .w_en(w_en)
  );
//дģ������
WriteModule WriteModule 
  (
    .wclk(wclk),.wrst_n(wrst_n),.w_en(w_en),.r2wptr(r2wptr),.wfull(wfull),.wptr_gray(wptr_gray),.waddr(waddr)
  );
// ��ģ������
ReadModule ReadModule 
  (
    .rclk(rclk),.rrst_n(rrst_n),.r_en(r_en),.w2rptr(w2rptr),.rempty(rempty),.rptr_gray(rptr_gray),.raddr(raddr)
  );
//ͬ��ģ������
ClkSyncModule ClkSyncModule
  (
    .wclk(wclk),.wrst_n(wrst_n),.rptr_gray(rptr_gray),.w2rptr(w2rptr),.r2wptr(r2wptr),.rclk(rclk),.rrst_n(rrst_n),.wptr_gray(wptr_gray)
  );
endmodule
