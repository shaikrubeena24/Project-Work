% Initiliazation
    clear         % clear all workspace variables
    clc           % clear command window
    close all     % close all open figures
    mFileName     = mfilename;                              % Get mfile name
    mFileNameFull = mfilename('fullpath');                  % Get mfile full name
    mFileDirMain  = mFileNameFull(1:end-length(mFileName)); % Extract the dir of the mfile directory
    if ~isempty(mFileDirMain)
        cd(mFileDirMain)    % change matlab current folder to mfile directory
    end
    clear mFileName mFileNameFull mFileDirMain              % clear variables
    rng(0)                                                  % set the random seed to 0
    if exist('OFDM_Class','class') == 8                     % Check if OFDM_Class exits
        OFDM_Class.checkForUpdatedVersion();                % Check if the class is updated
    else
        fprintf('The OFDM_Class does not exist or its path is not added. You can download the class from this %s \n',...
                '<a href = "http://www.mathworks.com/matlabcentral/fileexchange/54070">Link</a>')
        return
    end

% Parameters
    Para1.NB                  = 2e0;     % Number of ofdm symbols per run
    Para1.I                   = 5e2;     % Number of iterations in each loop
    Para1.M                   =  4;      % Modulation order
    Para1.N                   = 64;      % Number of sybcarriers
    Para1.NFFT                = 128;     % Upsampling rate is 2, and FFT based interpolation is used
    Para1.ifDoRaylieghChannel = 1;       % No rayliegh channel
    Para1.ifDoAWGNChannel     = 1;       % Only AWGN Channel
    Para1.channL              = 4;
    % Second curve
    Para2 = Para1;                       % all parameters are the same as what defined in Para1 except the modulation order
    Para2.M                   = 16;      % Modulation order (16 QAM) it can be changed by user
    % Third curve
    Para3 = Para1;                       % all parameters are the same as what defined in Para1 except the modulation order
    Para3.M                   = 64;      % Modulation order (16 QAM) it can be changed by user
    
% Building class
    Obj1 = OFDM_Class(Para1);
    Obj2 = OFDM_Class(Para2);
    Obj3 = OFDM_Class(Para3);
% Loop Parameters
    Loop.EbN0dB    = 0:5:30;
    
    Loop.SNRdBVec1 = 10*log10(log2(Obj1.M))+Loop.EbN0dB;
    Loop.SNRdBVec2 = 10*log10(log2(Obj2.M))+Loop.EbN0dB;
    Loop.SNRdBVec3 = 10*log10(log2(Obj3.M))+Loop.EbN0dB;
    
    Loop.EbN0dBL   = length(Loop.EbN0dB);    
    Loop.Results   = zeros(Loop.EbN0dBL,Obj1.I,12);
    Loop.Cnt       = 0;
    
% Main Loop
    fprintf('-------------------------------------\n')
    for LoopCnt1 = 1 :  Loop.EbN0dBL 
        % Update parameters
        Obj1.channSNRdB = Loop.SNRdBVec1(LoopCnt1);
        Obj2.channSNRdB = Loop.SNRdBVec2(LoopCnt1);
        Obj3.channSNRdB = Loop.SNRdBVec3(LoopCnt1);
        for LoopCnt2 = 1 : Obj1.I
            % Transmitter
                Obj1.ofdmTransmitter();
                Obj2.ofdmTransmitter();
                Obj3.ofdmTransmitter();
            % Channel
                Obj1.ofdmChannel();
                Obj2.ofdmChannel();
                Obj3.ofdmChannel();
            % Receiver
                Obj1.ofdmReceiver();
                Obj2.ofdmReceiver();
                Obj3.ofdmReceiver();
           % BER calculation
                Obj1.ofdmBER();
                Obj2.ofdmBER();
                Obj3.ofdmBER();
                
            % Store the results for the first curve
                Loop.Results(LoopCnt1,LoopCnt2, 1) = Obj1.BER;
                Loop.Results(LoopCnt1,LoopCnt2, 2) = Obj1.DER;
                Loop.Results(LoopCnt1,LoopCnt2, 3) = Obj1.BERTheoryRayliegh;
                Loop.Results(LoopCnt1,LoopCnt2, 4) = Obj1.EbN0dB;
            % Store the results for the second curve
                Loop.Results(LoopCnt1,LoopCnt2, 5) = Obj2.BER;
                Loop.Results(LoopCnt1,LoopCnt2, 6) = Obj2.DER;
                Loop.Results(LoopCnt1,LoopCnt2, 7) = Obj2.BERTheoryRayliegh;
                Loop.Results(LoopCnt1,LoopCnt2, 8) = Obj2.EbN0dB;
            
            % Store the results for the third curve
                Loop.Results(LoopCnt1,LoopCnt2, 9) = Obj3.BER;
                Loop.Results(LoopCnt1,LoopCnt2,10) = Obj3.DER;
                Loop.Results(LoopCnt1,LoopCnt2,11) = Obj3.BERTheoryRayliegh;
                Loop.Results(LoopCnt1,LoopCnt2,12) = Obj3.EbN0dB;
            % Update loop Cnt
                Loop.Cnt = Loop.Cnt + 1;
        end
        % Display
        fprintf('%10.1f percent of the simulation is done.\n',Loop.Cnt*100/(Loop.EbN0dBL  * Obj1.I))
    end
    fprintf('-------------------------------------\n')
% Plots
    figure(1)
    clf
    semilogy(mean(Loop.Results(:,:, 4),2), mean(Loop.Results(:,:, 1),2),'bo:') % Simulation BER (first curve)
    hold on
    semilogy(mean(Loop.Results(:,:, 4),2), mean(Loop.Results(:,:, 3),2),'b-')  % Theory BER (first curve)
    semilogy(mean(Loop.Results(:,:, 8),2), mean(Loop.Results(:,:, 5),2),'rs:') % Simulation BER (second curve)
    semilogy(mean(Loop.Results(:,:, 8),2), mean(Loop.Results(:,:, 7),2),'r-')  % Theory BER (second curve)
    semilogy(mean(Loop.Results(:,:,12),2), mean(Loop.Results(:,:, 9),2),'md:') % Simulation BER (third curve)
    semilogy(mean(Loop.Results(:,:,12),2), mean(Loop.Results(:,:,11),2),'m-')  % Theory BER (third curve)
    grid on 
    xlabel('EbN0 [dB]')
    ylabel('BER')
    legend([Obj1.ModulationStr,'-Simulation'],[Obj1.ModulationStr,'-Theory'],...
           [Obj2.ModulationStr,'-Simulation'],[Obj2.ModulationStr,'-Theory'],...
           [Obj3.ModulationStr,'-Simulation'],[Obj3.ModulationStr,'-Theory'])
    title('OFDM system performance over fading channel')
