// Copyright (C) 2024 by Berial
// Module Name: WriteModule
// Description: Module for writing and full flag generation including transmission to fifo_memory and binary to gray 
module WriteModule
//����д��ַλ��
#(parameter ADDRSIZE = 7)
//���ݽṹ��ͼ������������������
(
  output reg [ADDRSIZE:0]   wptr_gray, //дָ��8λ��ת���ɸ�������������Ϊ��λ�ж����ź�
  output logic [ADDRSIZE-1:0] waddr,   //д��ַ7λ������˳��д����
  output reg wfull,                   //д���źű�־λ
  input  wclk,wrst_n,w_en,            //дʱ�ӡ�д��λ(�͵�ƽ��Ч)��дʹ��
  input  wire [ADDRSIZE:0]   r2wptr  //�ɶ���ģ��ͬ����дʱ��������дʱ�������Ƚ��ж����źţ����ź��Ѿ���ReadModuleת���ɸ�����
);
//�����ڲ�����������дָ����Ҫ�ж�������ʽ�͸�������ʽ
  reg [ADDRSIZE:0] wptr_bina;
//дָ��+1����
  always@(posedge wclk or negedge wrst_n)
  begin
    if(!wrst_n) wptr_bina<=0;
    else if(w_en&&!wfull) wptr_bina<=wptr_bina+1'b1;  
  end
//��дָ��-1λ�����д��ַ
  assign waddr = wptr_bina[ADDRSIZE-1:0];
//������ת���ɸ�����
  assign wptr_gray = (wptr_bina>>1)^wptr_bina;
//�ж����ź��Ƿ���������λ�ʹθ�λ��ͬ������λ����ͬ�������źŲ���
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
