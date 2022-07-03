% File name SetUpL11_4vAcquireRF.m
% - Synchronous acquisition into a single RcvBuffer frame.
clear all

P.startDepth = 0;   % Acquisition depth in wavelengths
P.endDepth = 200;   % This should preferrably be a multiple of 128 samples.

% Specify system parameters.
Resource.Parameters.numTransmit = 128;  % number of transmit channels.
Resource.Parameters.numRcvChannels = 128;  % number of receive channels.
Resource.Parameters.speedOfSound = 1540;
Resource.Parameters.verbose = 2;
Resource.Parameters.initializeOnly = 0;
Resource.Parameters.simulateMode = 0;
%  Resource.Parameters.simulateMode = 1 forces simulate mode, even if hardware is present.
%  Resource.Parameters.simulateMode = 2 stops sequence and processes RcvData continuously.

% Specify media points
Media.MP(1,:) = [0,0,100,1.0]; % [x, y, z, reflectivity]

% Specify Trans structure array.
Trans.name = 'P4-1';
Trans.units = 'wavelengths'; % required in Gen3 to prevent default to mm units
Trans = computeTrans(Trans);
Trans.maxHighVoltage = 10;  % set maximum high voltage limit for pulser supply.

% Specify PData structure array.
PData(1).PDelta = [Trans.spacing, 0, 0.5];
PData(1).Size(1) = ceil((P.endDepth-P.startDepth)/PData(1).PDelta(3)); % startDepth, endDepth and pdelta set PData(1).Size.
PData(1).Size(2) = ceil((Trans.numelements*Trans.spacing)/PData(1).PDelta(1));
PData(1).Size(3) = 1;      % single image page
PData(1).Origin = [-Trans.spacing*(Trans.numelements-1)/2,0,P.startDepth]; % x,y,z of upper lft crnr.
% No PData.Region specified, so a default Region for the entire PData array will be created by computeRegions.


% Specify Resource buffers.
Resource.RcvBuffer(1).datatype = 'int16';
Resource.RcvBuffer(1).rowsPerFrame = 2048;
Resource.RcvBuffer(1).colsPerFrame = Resource.Parameters.numRcvChannels;
Resource.RcvBuffer(1).numFrames = 1;       % 100 frames used for RF cineloop.
Resource.InterBuffer(1).numFrames = 1;  % one intermediate buffer needed.
Resource.ImageBuffer(1).numFrames = 1;
Resource.DisplayWindow(1).Title = 'P4-1';
Resource.DisplayWindow(1).pdelta = 0.35;
ScrnSize = get(0,'ScreenSize');
DwWidth = ceil(PData(1).Size(2)*PData(1).PDelta(1)/Resource.DisplayWindow(1).pdelta);
DwHeight = ceil(PData(1).Size(1)*PData(1).PDelta(3)/Resource.DisplayWindow(1).pdelta);
Resource.DisplayWindow(1).Position = [250,(ScrnSize(4)-(DwHeight+150))/2, ...  % lower left corner position
                                      DwWidth, DwHeight];
Resource.DisplayWindow(1).ReferencePt = [PData(1).Origin(1),0,PData(1).Origin(3)];   % 2D imaging is in the X,Z plane
Resource.DisplayWindow(1).Type = 'Verasonics';
Resource.DisplayWindow(1).numFrames = 10;
Resource.DisplayWindow(1).AxesUnits = 'mm';
Resource.DisplayWindow(1).Colormap = gray(256);

% Specify Transmit waveform structure. 
TW(1).type = 'parametric';
TW(1).Parameters = [5.208,0.67,2,1]; % A, B, C, D

% Specify TX structure array. 
TX(1).waveform = 1; % use 1st TW structure.
TX(1).focus = 0;
TX(1).Apod = ones(1,Trans.numelements);
TX(1).Delay = computeTXDelays(TX(1));

% Specify TGC Waveform structure.
TGC(1).CntrlPts = [500,590,650,710,770,830,890,950];
TGC(1).rangeMax = 200;
TGC(1).Waveform = computeTGCWaveform(TGC);

% Specify Receive structure array.
Receive(1).Apod = ones(1,Trans.numelements); % if 64ch Vantage, = [ones(1,64) zeros(1,64)];
Receive(1).startDepth = 0;
Receive(1).endDepth = 200;
Receive(1).TGC = 1; % Use the first TGC waveform defined above
Receive(1).mode = 0;
Receive(1).bufnum = 1;
Receive(1).framenum = 1;
Receive(1).acqNum = 1;
Receive(1).sampleMode = 'NS200BW';
Receive(1).LowPassCoef = [];
Receive(1).InputFilter = [];
Receive(1).callMediaFunc = 1;

% Specify Recon structure arrays.
Recon = struct('senscutoff', 0.6, ...
               'pdatanum', 1, ...
               'rcvBufFrame', -1, ...     % use most recently transferred frame
               'IntBufDest', [1,1], ...
               'ImgBufDest', [1,-1], ...  % auto-increment ImageBuffer each recon
               'RINums', 1);

% Define ReconInfo structures.
ReconInfo = struct('mode', 'replaceIntensity', ...
                   'txnum', 1, ...
                   'rcvnum', 1, ...
                   'regionnum', 1);



% Specify an external processing event.
Process(1).classname = 'External';
Process(1).method = 'Scan_Motor';
Process(1).Parameters = {'srcbuffer','none',... % name of buffer to process.
'dstbuffer','none'};

% Specify an external processing event.
Process(2).classname = 'External';
Process(2).method = 'save_receive';
Process(2).Parameters = {'srcbuffer','receive',... % name of buffer to process.
'srcbufnum',1,...
'srcframenum',-1,...
'dstbuffer','none'};

% Specify an external processing event.
Process(3).classname = 'External';
Process(3).method = 'save_inter';
Process(3).Parameters = {'srcbuffer','inter',... % name of buffer to process.
'srcbufnum',1,...
'srcframenum',1,...
'dstbuffer','none'};

% Specify an external processing event.
Process(4).classname = 'External';
Process(4).method = 'save_image';
Process(4).Parameters = {'srcbuffer','image',... % name of buffer to process.
'srcbufnum',1,...
'srcframenum',-1,...
'dstbuffer','none'};


Process(5).classname = 'Image';
Process(5).method = 'imageDisplay';
Process(5).Parameters = {'imgbufnum',1,...   % number of buffer to process.
                         'framenum',-1,...   % (-1 => lastFrame)
                         'pdatanum',1,...    % number of PData structure to use
                         'pgain',1.0,...            % pgain is image processing gain
                         'reject',2,...      % reject level
                         'persistMethod','none',...
                         'interpMethod','4pt',...
                         'grainRemoval','none',...
                         'processMethod','none',...
                         'averageMethod','none',...
                         'compressMethod','power',...
                         'compressFactor',40,...
                         'mappingMethod','full',...
                         'display',1,...      % display image after processing
                         'displayWindow',1};

                     
                     

SeqControl(3).command = 'waitForTransferComplete';
SeqControl(3).argument = 2;
SeqControl(4).command = 'markTransferProcessed';
SeqControl(4).argument = 2;
SeqControl(5).command = 'sync';

%Specify sequence events.


Event(1).info = 'Acquire RF Data.';
Event(1).tx = 1; % use 1st TX structure.
Event(1).rcv = 1; % use 1st Rcv structure.
Event(1).recon = 0; % no reconstruction.
Event(1).process = 0; % no processing
Event(1).seqControl = [1,2];
 SeqControl(2).command = 'transferToHost';
 SeqControl(2).condition = 'waitForProcessing';
 SeqControl(2).argument = 2;
 
Event(2).info = 'Reconstruct';
Event(2).tx = 0;
Event(2).rcv = 0;
Event(2).recon = 1;
Event(2).process = 5;


Event(3).info = 'Call external Processing function2.';
Event(3).tx = 0; % no TX structure.
Event(3).rcv = 0; % no Rcv structure.
Event(3).recon = 0; % no reconstruction.
Event(3).process = 2; % call processing function


 
Event(4).info = 'Call external Processing function3.';
Event(4).tx = 0; % no TX structure.
Event(4).rcv = 0; % no Rcv structure.
Event(4).recon = 0; % no reconstruction.
Event(4).process = 3; % call processing function 


Event(5).info = 'Call external Processing function3.';
Event(5).tx = 0; % no TX structure.
Event(5).rcv = 0; % no Rcv structure.
Event(5).recon = 0; % no reconstruction.
Event(5).process = 4; % call processing function

Event(6).info = 'Call external Processing function1.';
Event(6).tx = 0; % no TX structure.
Event(6).rcv = 0; % no Rcv structure.
Event(6).recon = 0; % no reconstruction.
Event(6).process = 1; % call processing function
Event(1).seqControl = 5;

Event(7).info = 'Jump back to Event 1.';
Event(7).tx = 0; % no TX structure.
Event(7).rcv = 0; % no Rcv structure.
Event(7).recon = 0; % no reconstruction.
Event(7).process = 0; % no processing
Event(7).seqControl = 6; % jump back to Event 1
 SeqControl(6).command = 'jump';
 SeqControl(6).argument = 1;
 
% Create UI control for channel selection
nr = Resource.Parameters.numRcvChannels;
UI(1).Control = {'UserB1','Style','VsSlider',...
 'Label','Plot Channel',... 
 'SliderMinMaxVal',[1,128,32],... 
 'SliderStep', [1/nr,8/nr],... 
 'ValueFormat', '%3.0f'};

UI(1).Callback = text2cell('%CB#1');
% Create External function for plotting channel data
%EF(1).Function = text2cell('%EF#1');

% Save all the structures to a .mat file.
save('Synchronous_SetUpP4_1AcquireRF2');
return % Place this return to prevent executing code below

%CB#1
assignin('base', 'myPlotChnl', round(UIValue));
%CB#1
