clear all;%closing all before start the exec of this
rng('Shuffle');%Initializes generator based on the current time, resulting in a different sequence of randomnumbers after each call to rng. 
SNRdB=[1:5:45];
Nsub=512;%no of subcarriers
Ncp=round(Nsub/10);%no of cyclic prefixes
numBlocks=10000;% no of blocks
numTaps=2;;% no of taps or channel taps which comees through cyclic prefix
BER=zeros(size(SNRdB));
SNR=zeros(size(SNRdB));
for j=1:numBlocks
    bits=randi([0,1],[1,Nsub]);%generating bits upto Nsub subcarriers
    h=1/sqrt(2)*(randn(1,numTaps)+j*randn(1,numTaps));
    hFreq=fft(h,Nsub);%applying fft on channel
    ChNoise=(randn(1,numTaps+Nsub+Ncp-1)+j*randn(1,numTaps+Nsub+Ncp-1));
    for k=1:length(SNRdB)
        SNR(k)=10^(SNRdB(k)/10);
        Loaded_bits=sqrt(SNR(k))*(2*bits-1);%loading bits on to the subcarriers
        txSamples=ifft(Loaded_bits);%applying ifft(inversefast fourier transform to convert symbols into samples
        txSamplescp=[txSamples(Nsub-Ncp+1:Nsub),txSamples];%applying cyclic prefix
        Rxbits=conv(h,txSamplescp)+ChNoise;%received bits which consists of cyclic prefix
        Rxbits_withoutCp=Rxbits(Ncp+1:Ncp+Nsub);%using channel taps and got the received symbols without cyclic prefix
        Rxbits_fft=fft(Rxbits_withoutCp,Nsub);%applying fft(fast fourier transform
        Processed_bits=Rxbits_fft./hFreq;%bits received on each subcarrier
        Decoded_bits=((real(Processed_bits))>=0);%removing img part of bits
        BER(k)=BER(k)+sum(Decoded_bits~=bits);%getting bit error rate by comparing bits we transmitted and we received
    end
end
eSNR=numTaps*SNR/Nsub;
BER=BER/(numBlocks*Nsub);%bit error rate for all subcarriers and all blocks
semilogy(SNRdB,BER,'b s','linewidth',2.0);
hold on;
semilogy(SNRdB,0.5*(1-sqrt(eSNR./(2+eSNR))),'r-','linewidth',2.0);
axis tight;
grid on;
legend("OFDM",'Theory')
xlabel('SNR(dB)');
ylabel('BER');
title(' BER Vs SNR(dB)');