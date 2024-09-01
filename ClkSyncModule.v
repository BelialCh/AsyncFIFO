// Copyright (C) 2024 by Berial
// Module Name: Clock Synchronizing Module
/* Description: Module for clock synchornization between Write clock and Read clock.
   This Module contains two duplicate parts:one is to synchornize Write clock to ReadModule, 
   the other is opposite.Two of them have the same form of code.*/
module ClkSyncModule
//��������ַλ��
#(parameter ADDRSIZE = 7)
//����������������
(
    output logic [ADDRSIZE:0] w2rptr,//����дģ��ͬ������ʱ�ӵ�дָ��
    output logic [ADDRSIZE:0] r2wptr,//���Զ�ģ��ͬ����дʱ�ӵĶ�ָ��
    input  [ADDRSIZE:0] wptr_gray,   //дָ���������ʽ
    input  [ADDRSIZE:0] rptr_gray,        //��ָ���������ʽ
    input wclk,wrst_n,rclk,rrst_n    //дʱ��,д��λ,��ʱ��,����λ
);
//�����ڲ���������������D�������е�һ��DFF�����
    logic   [ADDRSIZE:0] wptr1;
    logic   [ADDRSIZE:0] rptr1;
//дָ��ͬ������ʱ�ӵĶ���DFF
always@(posedge rclk or negedge rrst_n)
    if(!rrst_n) begin wptr1<=0;w2rptr<=0; end
    else begin w2rptr<=wptr1;wptr1<=wptr_gray;end//дָ��ͬ������ʱ�ӣ�������
//��ָ��ͬ����дʱ�ӵĶ���DFF
always@(posedge wclk or negedge wrst_n)
    if(!wrst_n) begin rptr1<=0;r2wptr<=0; end
    else begin r2wptr<=rptr1;rptr1<=rptr_gray;end//��ָ��ͬ����дʱ�ӣ�������
endmodule
