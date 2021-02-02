M = 64;                 % Modulation order
k = log2(M);            % Bits per symbol
EbNoVec = (5:15)';      % Eb/No values (dB)
numSymPerFrame = 100;   % Number of QAM symbols per frame
%Initialize the results vector.
berEst = zeros(size(EbNoVec));
%The main processing loop executes these steps.

%Generate binary data and convert to 64-ary symbols.

%QAM-modulate the data symbols.

%Pass the modulated signal through an AWGN channel.

%Demodulate the received signal.

%Convert the demodulated symbols into binary data.

%Calculate the number of bit errors.

%The while loop continues to process data until either 200 errors are encountered or 1e7 bits are transmitted.
for n = 1:length(EbNoVec)
    % Convert Eb/No to SNR
    snrdB = EbNoVec(n) + 10*log10(k);
    % Reset the error and bit counters
    numErrs = 0;
    numBits = 0;
    
    while numErrs < 200 && numBits < 1e7
        % Generate binary data and convert to symbols
        dataIn = randi([0 1],numSymPerFrame,k);
        dataSym = bi2de(dataIn);
        
        % QAM modulate using 'Gray' symbol mapping
        txSig = qammod(dataSym,M);
        
        % Pass through AWGN channel
        rxSig = awgn(txSig,snrdB,'measured');
        
        % Demodulate the noisy signal
        rxSym = qamdemod(rxSig,M);
        % Convert received symbols to bits
        dataOut = de2bi(rxSym,k);
        
        % Calculate the number of bit errors
        nErrors = biterr(dataIn,dataOut);
        
        % Increment the error and bit counters
        numErrs = numErrs + nErrors;
        numBits = numBits + numSymPerFrame*k;
    end
    
    % Estimate the BER
    berEst(n) = numErrs/numBits;
end

%Determine the theoretical BER curve by using the berawgn function.
berTheory = berawgn(EbNoVec,'qam',M);
%plot the estimated and theoretical BER data. The estimated BER data points are well aligned with the theoretical curve.
semilogy(EbNoVec,berEst,'*')
hold on
semilogy(EbNoVec,berTheory)
grid
legend('Estimated BER','Theoretical BER')
xlabel('Eb/No (dB)')
ylabel('Bit Error Rate')