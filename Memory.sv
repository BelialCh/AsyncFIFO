// Copyright (C) 2024 by Berial
// Module Name: fifo_memory
// Description: memory for fifo, define read and write operation
module fifo_memory
//�������ݿ�Ⱥ͵�ַ���
 #(
    parameter DATASIZE=64,
    parameter ADDRSIZE=7
  )
//��������������
  (
    output reg [DATASIZE-1:0] rdata,
    input  [DATASIZE-1:0] wdata,
    input  [ADDRSIZE-1:0] raddr,
    input  [ADDRSIZE-1:0] waddr,
    input  wclk,
    input  w_en,
    input  wfull
  );
//����������ȣ���mem���Դ���ٸ�������
  localparam DATADEP = 1<<ADDRSIZE;
//����64λ��mem���������Ϊ2^7=128
  reg [DATASIZE-1:0] MEM [0:DATADEP-1];
//�����ݲ���
    assign rdata = MEM[raddr];
//д���ݲ���������дʱ�������ؽ��У������ж�д��λ��Ч��дʹ����Ч
  always@(posedge wclk)
     if(!wfull && w_en) MEM[waddr]<=wdata;
endmodule
