% HW4 QBSH
clc;
clear;
close all;

tic;

addpath('C:\Users\Toshiba\Documents\MIRtoolbox1.6.1\MIRtoolbox1.6.1\MIRToolbox');
TestingDataset = getAllFiles('C:\Users\Toshiba\Documents\FourUp\MMSP\ComputerAssignment4\CA5files\Training Data');
M = zeros(length(TestingDataset), length(TestingDataset));
I = zeros(length(TestingDataset), length(TestingDataset));

for p = 1:length(TestingDataset)

	filename = TestingDataset{p};


%% Pitch Tracking

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


	DTWtable = cell(length(TrainingDataList), 3);
	DTWpath = zeros(length(TrainingDataList), 3);
	DTWtableNew = cell(length(TrainingDataList), 3);
	DTWpathNew = zeros(length(TrainingDataList), 3);
	
	DTWpathFinal = zeros(length(TrainingDataList), 1);
	
	
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

	
		n = min(round(m), sum(DurationSegment));
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
		
		%s0
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
		
		
		semitoneZeroMean = semitoneZeroMean + 4;
		%MIDIpitchChosen = MIDIpitchChosen+4;
		%s1
		DTWtable{i, 2} = zeros(m, n);
		for a = 1:m
			for b = 1:n
				
				if (a>1&&b==1) %boundary condition
						DTWtable{i, 2}(a, b) = inf; % A large number 
				elseif (a==1)	%boundary condition
						DTWtable{i, 2}(a, b) = abs( MIDIpitchChosen(b) - semitoneZeroMean(a));
				else
					compareSet = [];
					if a>2
						compareSet = [DTWtable{i, 2}(a-2, b-1)];
					end
						compareSet = [ compareSet DTWtable{i, 2}(a-1, b-1)];
					if b>2
						compareSet = [ compareSet DTWtable{i, 2}(a-1, b-2)];
					end
					
					DTWtable{i, 2}(a, b) = abs( MIDIpitchChosen(b) - semitoneZeroMean(a)) + min(compareSet);
				end
			end
		end
		%[M, I]  = min(DTWtable{i,1}(a, :));
		%MatchIndex(i, 1) = I;
		DTWpath(i, 2) = min(DTWtable{i,2}(m, :));
		
		semitoneZeroMean = semitoneZeroMean - 8;
		%MIDIpitchChosen = MIDIpitchChosen - 8;
		
		%s-1
		DTWtable{i, 3} = zeros(m, n);
		for a = 1:m
			for b = 1:n
				
				if (a>1&&b==1) %boundary condition
						DTWtable{i, 3}(a, b) = inf; % A large number 
				elseif (a==1)	%boundary condition
						DTWtable{i, 3}(a, b) = abs( MIDIpitchChosen(b) - semitoneZeroMean(a));
				else
					compareSet = [];
					if a>2
						compareSet = [DTWtable{i, 3}(a-2, b-1)];
					end
						compareSet = [ compareSet DTWtable{i, 3}(a-1, b-1)];
					if b>2
						compareSet = [ compareSet DTWtable{i, 3}(a-1, b-2)];
					end
					
					DTWtable{i, 3}(a, b) = abs( MIDIpitchChosen(b) - semitoneZeroMean(a)) + min(compareSet);
				end
			end
		end
		%[M, I]  = min(DTWtable{i,1}(a, :));
		%MatchIndex(i, 1) = I;
		DTWpath(i, 3) = min(DTWtable{i,3}(m, :));
		
		semitoneZeroMean = semitoneZeroMean + 4;
		%MIDIpitchChosen = MIDIpitchChosen+8;
		
		[centerMin centerIndex] = min(DTWpath(i,:));
		
		switch centerIndex
		case  1
		semitoneZeroMeanNew = semitoneZeroMean;
		%MIDIpitchChosenNew = MIDIpitchChosen;
		case  2
		semitoneZeroMeanNew = semitoneZeroMean + 4;
		%MIDIpitchChosenNew = MIDIpitchChosen + 4;
		case  3
		semitoneZeroMeanNew = semitoneZeroMean - 4;
		%MIDIpitchChosenNew = MIDIpitchChosen - 4;
		otherwise
		end
		
		DTWtableNew{i, 1} = DTWtable{i, centerIndex};
		DTWpathNew(i, 1) = DTWpath(i, centerIndex);
		
		
		semitoneZeroMeanNew = semitoneZeroMeanNew -2;
		%MIDIpitchChosenNew = MIDIpitchChosenNew - 2;
		%s1_2
		DTWtableNew{i, 2} = zeros(m, n);
		for a = 1:m
			for b = 1:n
				
				if (a>1&&b==1) %boundary condition
						DTWtableNew{i, 2}(a, b) = inf; % A large number 
				elseif (a==1)	%boundary condition
						DTWtableNew{i, 2}(a, b) = abs( MIDIpitchChosen(b) - semitoneZeroMean(a));
				else
					compareSet = [];
					if a>2
						compareSet = [DTWtableNew{i, 2}(a-2, b-1)];
					end
						compareSet = [ compareSet DTWtableNew{i, 2}(a-1, b-1)];
					if b>2
						compareSet = [ compareSet DTWtableNew{i, 2}(a-1, b-2)];
					end
					
					DTWtableNew{i, 2}(a, b) = abs( MIDIpitchChosen(b) - semitoneZeroMean(a)) + min(compareSet);
				end
			end
		end
		%[M, I]  = min(DTWtable{i,1}(a, :));
		%MatchIndex(i, 1) = I;
		DTWpathNew(i, 2) = min(DTWtableNew{i,2}(m, :));
		

		semitoneZeroMeanNew = semitoneZeroMean + 4;
		%MIDIpitchChosenNew = MIDIpitchChosenNew + 4;
		
		%s-1_2
		DTWtableNew{i, 3} = zeros(m, n);
		for a = 1:m
			for b = 1:n
				
				if (a>1&&b==1) %boundary condition
						DTWtableNew{i, 3}(a, b) = inf; % A large number 
				elseif (a==1)	%boundary condition
						DTWtableNew{i, 3}(a, b) = abs( MIDIpitchChosen(b) - semitoneZeroMean(a));
				else
					compareSet = [];
					if a>2
						compareSet = [DTWtableNew{i, 3}(a-2, b-1)];
					end
						compareSet = [ compareSet DTWtableNew{i, 3}(a-1, b-1)];
					if b>2
						compareSet = [ compareSet DTWtableNew{i, 3}(a-1, b-2)];
					end
					
					DTWtableNew{i, 3}(a, b) = abs( MIDIpitchChosen(b) - semitoneZeroMean(a)) + min(compareSet);
				end
			end
		end
		%[M, I]  = min(DTWtable{i,1}(a, :));
		%MatchIndex(i, 1) = I;
		DTWpathNew(i, 3) = min(DTWtableNew{i,3}(m, :));
		
		DTWpathFinal(i, 1) = min(DTWpathNew(i,:));
	end
	
	[M(p, :), I(p, :)]  = sort(DTWpathFinal);
	%[M(p), I(p)]  = min(DTWpath);
end

toc;