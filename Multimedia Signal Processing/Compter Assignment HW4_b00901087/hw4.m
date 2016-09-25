% HW4 QBSH
clc;
clear;
close all;


	addpath('C:\Users\Toshiba\Documents\MIRtoolbox1.6.1\MIRtoolbox1.6.1\MIRToolbox');
	TestingDataset = getAllFiles('C:\Users\Toshiba\Documents\FourUp\MMSP\ComputerAssignment4\CA5files\Training Data');
	M = zeros(length(TestingDataset), length(TestingDataset));
	I = zeros(length(TestingDataset), length(TestingDataset));

	
	
for p = 1:length(TestingDataset)
	filename = TestingDataset{p};
	% Pitch Tracking
    pitch = mirpitch(filename,'Frame', 0.5, 0.125,'Mono');
%% Return Numerical Data
    pitch_data = mirgetdata(pitch);
%% Semitone
	semitone = 12*log2(pitch_data/440)  + 69;	
%% Pitch Smoothing
	for j = 1:length(semitone)
		if	semitone(j) > 84 || isnan(semitone(j))
			semitone(j) = 0;
		end
	end
	
	judge = 0;
	semitoneMinusZero = [];
	for j = 1:length(semitone)
		if (semitone(j) ~= 0 && judge ==0)
			semitoneMinusZero = [semitoneMinusZero semitone(j)];
			judge = 1;
		elseif (judge==1&&semitone(j)==0)
			semitoneMinusZero = [semitoneMinusZero semitoneMinusZero(end)];
		elseif (judge==1&&semitone(j)~=0)
			semitoneMinusZero = [semitoneMinusZero semitone(j)];
		end
		
	end
	
	MeanSemitone = mean(semitoneMinusZero);
	semitoneZeroMean = semitoneMinusZero - MeanSemitone;
	m = length(semitoneMinusZero);
	
	
	TrainingDataList = getAllFiles('C:\Users\Toshiba\Documents\FourUp\MMSP\ComputerAssignment4\CA5files\midi');


	DTWtable = cell(length(TrainingDataList), 1);
	DTWpath = zeros(length(TrainingDataList), 1);
	%length(TrainingDataList)
	for i = 1:length(TrainingDataList)
		filename = TrainingDataList{i};

		[nmat,z] = midi2nmat(filename);

		MIDIpitch = nmat(:,4);
		Duration = nmat(:,7);
	
		MeanMIDIpitch = sum((MIDIpitch.*Duration))/sum(Duration);
		%MeanMIDIpitch = mean(MIDIpitch);
		MIDIpitchZeroMean = MIDIpitch - MeanMIDIpitch;
	
		%To segment the MIDIpitch to match 1/16
	
		DurationSegment = round(Duration*16);
		DurationIndex = 1;
		Order = 1;

	
		n = min(round(m*1.4), sum(DurationSegment));
		MIDIpitchChosen = zeros(n, 1);
		for o = 1 : n
		
			MIDIpitchChosen(o) = MIDIpitchZeroMean(DurationIndex);
			
			if (Order == DurationSegment(DurationIndex))
				DurationIndex = DurationIndex + 1;
				Order = 1;
			else
				Order = Order + 1;
			end
			
		end
	
		
		%DTWtable
	
		%n = length(MIDIpitchChosen);
		%DTWtable{i, 1} = zeros(m, n);
	
		%n2 = min(n, round(1.4*m));
		DTWtable{i, 1} = zeros(m, n);
	
	
		for a = 1:m
			for b = 1:n
				
				if (a>1&&b==1) %boundary condition
						DTWtable{i, 1}(a, b) = inf; % A large number 
				elseif (a==1)	%boundary condition
						DTWtable{i, 1}(a, b) = abs( MIDIpitchChosen(b) - semitoneZeroMean(a));
				else
					compareSet = [];
					if a>2
						compareSet = [DTWtable{i, 1}(a-2, b-1)];
					end
						compareSet = [ compareSet DTWtable{i, 1}(a-1, b-1)];
					if b>2
						compareSet = [ compareSet DTWtable{i, 1}(a-1, b-2)];
					end
					
					DTWtable{i, 1}(a, b) = abs( MIDIpitchChosen(b) - semitoneZeroMean(a)) + min(compareSet);
				end
			end
		end
	
		%[M, I]  = min(DTWtable{i,1}(a, :));
		%MatchIndex(i, 1) = I;
		DTWpath(i, 1) = min(DTWtable{i,1}(m, :));
	
	end
	
	[M(p, :), I(p, :)]  = sort(DTWpath);
	%[M(p), I(p)]  = min(DTWpath);
end

