clear all;
rng('Shuffle');
SNRdB=[1:0.5:13];
blockLength=1000000;
bits=randi([0,1],[1,blockLength]);
BER=zeros(size(SNRdB));
chNoise=(randn(1,blockLength)+j*randn(1,blockLength));
for k=1:length(SNRdB)
	snr=10^(SNRdB(k)/10);
	Txbits=sqrt(snr)*(2*bits-1);
	Rxbits=Txbits+chNoise;
	DecodeBits=((real(Rxbits))>=0);
	BER(k)=sum(DecodeBits~=bits)/blockLength;
end
semilogy(SNRdB,BER,'bs','lineWidth',2.0);
hold on;
semilogy(SNRdB,qfunc(sqrt(10.^(SNRdB/10))),'r-.','lineWidth',2.0);
%axis title;
grid on;
legend('AWGN','theory')
xlabel('SNR(dB)');
ylabel('BER');
title('BER Vs SNR(dB)');