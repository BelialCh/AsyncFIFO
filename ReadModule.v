// Copyright (C) 2024 by Berial
// Module Name: ReadModule
// Description: Module for reading and empty flag generation including transmission of reading address to fifo_memory and binary to gray 
module ReadModule
//��������ַλ��
#(parameter ADDRSIZE = 7)
//����������������
(
    output reg [ADDRSIZE:0] rptr_gray,   //��ָ��8λ��ת���ɸ�������������Ϊ��λ�жϿ��ź�
    output reg [ADDRSIZE-1:0] raddr,//����ַ7λ������˳���ȡ����
    output reg rempty,              //�����źű�־λ
    input  rclk,rrst_n,r_en,        //��ʱ�ӡ�����λ(�͵�ƽ��Ч)����ʹ��
    input [ADDRSIZE:0] w2rptr       //��дģ��ͬ������ʱ�ӣ��������ָ�������Ƚ��жϿ��źţ����ź��Ѿ���WriteModuleת���ɸ�����
);
//�����ڲ����������Ƕ�ָ����Ҫ�ж�������ʽ�͸�������ʽ
  reg [ADDRSIZE:0] rptr_bina;
//��ָ��+1����
  always@(posedge rclk or negedge rrst_n)
  begin
    if(!rrst_n) rptr_bina<=0;
    else if(r_en&&!rempty) rptr_bina<=rptr_bina+1'b1;  
  end
//������ת���ɸ�����
  assign rptr_gray = (rptr_bina>>1)^rptr_bina;
//�жϿ��ź��Ƿ����������λ������ͬ������źŲ���
  always@(posedge rclk or negedge rrst_n)
  begin
    if(!rrst_n) rempty<=1'b0;
    else if(rptr_gray == {w2rptr[ADDRSIZE:0]}) rempty<= 1;
    else rempty<=0;  
  end
//����ָ��-1λ���������ַ
  assign raddr = rptr_bina[ADDRSIZE-1:0];
endmodule
