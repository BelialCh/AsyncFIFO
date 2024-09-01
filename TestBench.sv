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
//��������ģ��
TopFIFO TopFIFO (
                 .rdata(rdata),  .wdata(wdata), 
                 .wfull(wfull),  .rempty(rempty),  
                 .w_en(w_en),    .r_en(r_en),
                 .wclk(wclk),    .rclk(rclk), 
                 .wrst_n(wrst_n),    .rrst_n(rrst_n)
                );
 localparam CYCLE  = 10;
 localparam CYCLE1 = 30;
//��ʼ��1��
    initial begin//���дʱ��
         wclk = 0;//�ϵ�Ϊ��ƽ
         forever
         #(CYCLE/2)
         wclk=~wclk;//5ns��תһ��,ʱ������10ns����100MHzʱ��Ƶ��
    end 
    initial begin//��Զ�ʱ��
        rclk = 0;//�ϵ�Ϊ��ƽ
        forever
        #(CYCLE1/2)
        rclk=~rclk;//15ns��תһ�Σ�ʱ������30ns����33MHzʱ��Ƶ��
     end
     initial begin//���д��λ
         wrst_n = 1;//�ϵ��ƽ��Ч
         #2//��ʱ2ns
         wrst_n = 0;//��λ
         #(CYCLE*3)//��ʱ30ns
         wrst_n = 1;//��ƽ����ʱfifo��ʼ����
     end    
     initial begin
        rrst_n = 1;
        #2;
        rrst_n = 0;
        #(CYCLE*3);
        rrst_n = 1;
      end 
      initial begin
          w_en=0;//�ϵ�дʹ�ܹ�
          #5 w_en=1;//��ʱ5ns������д
      end 
     
      initial begin
         r_en=0;
          #5 r_en=1;
      end       
always 
#10 wdata= {$random}%10 ;//д��ÿ10���������
endmodule