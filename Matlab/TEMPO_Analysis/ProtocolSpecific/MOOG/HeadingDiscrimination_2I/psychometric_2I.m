%-----------------------------------------------------------------------------------------------------------------------
%-- PSYCHOMETRIC_2I.m -- Plots psychometric function for 2-interval heading discrimination expt
%--	CRF, 2/21/06
%-----------------------------------------------------------------------------------------------------------------------

function Psychometric_2I(data, Protocol, Analysis, SpikeChan, StartCode, StopCode, BegTrial, EndTrial, StartOffset, StopOffset, PATH, FILE);

printfigs = 0;
closefigs = 0;

TEMPO_Defs;
Path_Defs;
ProtocolDefs; %contains protocol specific keywords - 1/4/01 BJP

%get the column of values for azimuth and elevation and stim_type
temp_azimuth = data.moog_params(AZIMUTH,:,MOOG);
temp_elevation = data.moog_params(ELEVATION,:,MOOG);
temp_stim_type = data.moog_params(STIM_TYPE,:,MOOG);
temp_heading   = data.moog_params(HEADING, :, MOOG);
% temp_amplitude = data.moog_params(AMPLITUDE,:,MOOG);
temp_amplitude = data.moog_params(AMPLITUDE,:,CAMERAS);    % changed to cameras amplitude, to reflect actual AND simulated motion  -CRF 4/2007
temp_num_sigmas = data.moog_params(NUM_SIGMAS,:,MOOG);
temp_motion_coherence = data.moog_params(COHERENCE,:,MOOG);
temp_outcome = data.misc_params(OUTCOME, :);
temp_swap_flag = data.moog_params(SWAP_FLAG,:,MOOG);
temp_reward_flag = data.moog_params(REWARD_FLAG,:,MOOG);

trials = 1:length(temp_heading);		% a vector of trial indices
select_trials = (trials >= BegTrial) & (trials <= EndTrial);

%use the target luminance multiplier values to exclude 1-target trials
two_targs = data.targ_params(TARG_LUM_MULT,:,2) & data.targ_params(TARG_LUM_MULT,:,3);
select_trials = select_trials & two_targs;

azimuth = temp_azimuth( select_trials );
elevation = temp_elevation( select_trials );
stim_type = temp_stim_type( select_trials );
heading = temp_heading( select_trials );
amplitude= temp_amplitude( select_trials );
num_sigmas= temp_num_sigmas( select_trials );
motion_coherence = temp_motion_coherence(select_trials);
outcome = temp_outcome(select_trials);
swap_flag = temp_swap_flag(select_trials);
reward_flag = temp_reward_flag(select_trials);

unique_azimuth = munique(azimuth');
unique_elevation = munique(elevation');
unique_stim_type = munique(stim_type');
unique_heading = munique(heading');
unique_amplitude = munique(amplitude');
unique_num_sigmas = munique(num_sigmas');
unique_motion_coherence = munique(motion_coherence');

if length(unique_heading) < 3 % to omit blocks (e.g. in a batch file) that cannot be fit by pfit
    disp('ERROR -- Too few headings to fit psychometric');
    return;
end

% ****************************************************************************************
% Enter parameters that vary for a given block

% in rare cases, coherence and stim type are varied, while azi/ele is constant
three_interleaved = 0;
if length(unique_motion_coherence) > 1 & length(unique_stim_type) > 1
    if length(unique_stim_type) == 3
        three_interleaved = 1;
    end
    
    condition = motion_coherence;
	con_txt = 'coherence';
    unique_condition = munique(condition');
    
	condition_2 = stim_type;
	con_txt_2 = 'stimtype';
	unique_condition_2 = munique(condition_2');
    
    not_condition_2 = unique_azimuth;
	not_con_txt_2 = 'azimuth';
    vary_amplitude = 0;

% other times we vary amplitude and either coherence or stim type (again azi/ele is constant)
elseif length(unique_amplitude) > 1
    condition = amplitude;
    con_txt = 'amplitude';
    unique_condition = munique(condition');
    if length(unique_motion_coherence) > 1
		condition_2 = motion_coherence;
		con_txt_2 = 'coherence';
        unique_condition_2 = munique(condition_2');
    else
        condition_2 = stim_type;
		con_txt_2 = 'stimtype';
		unique_condition_2 = munique(condition_2');
    end
    not_condition_2 = unique_azimuth;
    not_con_txt_2 = 'azimuth';
    vary_amplitude = 1;
        
% but normally, either azimuth or elevation is one variable, and the other is either coherence or stim type
else

	if unique_elevation == 0 % for now, only varying elevation OR azimuth, not both (i.e., azi is varied iff Elev = 0)
		condition = azimuth;
		con_txt = 'azimuth';
		unique_condition = munique(condition');
	else
		condition = elevation;
		con_txt = 'elevation';
		unique_condition = munique(condition');
	end
	
    if length(unique_motion_coherence) > 1
        condition_2 = motion_coherence;
		con_txt_2 = 'coherence';
		not_condition_2 = unique_stim_type;
		not_con_txt_2 = 'stimtype';
    else
        condition_2 = stim_type;
		con_txt_2 = 'stimtype';
		not_condition_2 = unique_motion_coherence;
		not_con_txt_2 = 'coherence';        
    end
    unique_condition_2 = munique(condition_2');
    vary_amplitude = 0;
    
end

% ****************************************************************************************

if ~three_interleaved
    one_repetition = length(unique_condition)*length(unique_condition_2)*length(unique_heading);
else % for all three conditions interleaved, but with no conflict
    one_repetition = length(unique_condition)*length(unique_heading) + ...  % combined
                     length(unique_condition)*length(unique_heading) + ...  % visual
                     length(unique_heading);  % vestibular
end
num_repetitions = floor( length(heading)/one_repetition ); % number of repetitions

% if num_repetitions*one_repetition ~= length(azimuth)
%     disp('********* WARNING: Extra trials included');
%     disp(['********* Current EndTrial = ' num2str(EndTrial)]);
%     disp(['********* But should be: ' num2str(num_repetitions*one_repetition)]);
%     yesno = input('********* Continue? [enter = yes, 0 = no]');
%     if ~isempty(yesno)
%         return
%     end
% end


% this will perform the entire analysis separately for normal and reversed-interval trials (t=0 and 1),
% as well as all trials pooled together (t=2):

%***** For some of Alvin's blocks, remove erroneous swap flag on a single trial***** 
if sum(swap_flag) == 1;
    swap_flag(swap_flag==1) = 0;
end

norm_rev{1} = 'Normal'; norm_rev{2} = 'Reversed'; norm_rev{3} = 'AllTrials';
if swap_flag == 0
    repeat_analysis = 0;
    printflag = [printfigs 0 0];
elseif swap_flag == 1
    repeat_analysis = 1;
    printflag = [0 printfigs 0];
else
    repeat_analysis = 0:2;
    printflag = [printfigs printfigs printfigs];
end

for t = repeat_analysis
% for t = 2

fit_data_psycho_cum = [];
right_pct = []; % to be computed from % correct, depending on whether heading was < or > 0
correct = (outcome==0); % '0' is tempo's tag for a correct trial
correct_pct = [];
for i = 1:length(unique_heading)
    for j = 1:length(unique_condition)   % <-- azimuth/elevation
        for k = 1:length(unique_condition_2)   % <-- stim_type
            if t == 2 % All Trials
                select = logical( (heading==unique_heading(i)) & (condition==unique_condition(j)) & (condition_2==unique_condition_2(k)));
            else % only Normal or Reversed trials
                select = logical( (swap_flag == t) & (heading==unique_heading(i)) & (condition==unique_condition(j)) & (condition_2==unique_condition_2(k)));
            end
            if sum(select) > 0
                num_reps(i,j,k) = sum(select);
                if unique_heading(i) < 0
                    right_pct{k,j}(i) = 1 - sum(correct(select))/sum(select);
                else
                    right_pct{k,j}(i) = sum(correct(select))/sum(select); 
                end
                correct_pct{k,j}(i) = sum(correct(select))/sum(select);
%                 % the next two if statements will remove any NaN's caused by staircase
%                 % (i.e., if the largest + or - heading angle was never run)
%                 if isnan(right_pct{k,j}(i))
%                     if i == 1
%                         right_pct{k,j}(i) = 0;
%                     elseif i == length(unique_heading)
%                         right_pct{k,j}(i) = 1;
%                     end
%                 end
%                 if isnan(correct_pct{k,j}(i))
%                     correct_pct{k,j}(i) = 1;
%                 end
                repeats = sum(select);
            else
                % this will remove any NaN's caused by staircase
                % (i.e., if the largest + or - heading angle was never run)
                if i == 1
                    right_pct{k,j}(i) = 0;
                    correct_pct{k,j}(i) = 1;
                elseif i == length(unique_heading)
                    right_pct{k,j}(i) = 1;
                    correct_pct{k,j}(i) = 1;
                else
                    right_pct{k,j}(i) = NaN;
                    correct_pct{k,j}(i) = NaN;
                    disp('non-edge NaN -- will be fixed by interpolation');
                end
                num_reps(i,j,k) = NaN;
                repeats = 1;
            end
            fit_data_psycho_cum{k,j}(i, 1) = unique_heading(i);
            fit_data_psycho_cum{k,j}(i, 2) = right_pct{k,j}(i);
            fit_data_psycho_cum{k,j}(i, 3) = repeats;
%             if sum(select) > 0  % also to account for staircase
%                 fit_data_psycho_cum{k,j}(i, 3) = sum(select);
%             else
%                 fit_data_psycho_cum{k,j}(i, 3) = 1;
%             end
        end
    end
end
% num_reps = mean(mean(mean(num_reps)));
num_reps = mean(num_reps(~isnan(num_reps)));

% a final fix for NaNs caused by staircase:
% in the rare case of a NaN that's not at the edges, interpolate the missing data
for i = 1:length(unique_heading)
    for j = 1:length(unique_condition)   % <-- azimuth/elevation
        for k = 1:length(unique_condition_2)   % <-- stim_type
            if isnan(right_pct{k,j}(i))
                right_pct{k,j}(i) = (right_pct{k,j}(i-1) + right_pct{k,j}(i+1)) / 2;
                correct_pct{k,j}(i) = (correct_pct{k,j}(i-1) + correct_pct{k,j}(i+1)) / 2;
                fit_data_psycho_cum{k,j}(i, 2) = right_pct{k,j}(i);
            end
        end
    end
end

%%%%%% use Wichman's MLE method to estimate threshold and bias
for j = 1:length(unique_condition)   % <-- azimuth/elevation
    for k = 1:length(unique_condition_2)   % <-- stim_type
        if ~isnan(right_pct{k,j})
            wichman_psy = pfit(fit_data_psycho_cum{k,j},'plot_opt','no plot','shape','cumulative gaussian','n_intervals',1,'sens',0,'compute_stats','false','verbose','false');  
            Thresh_psy{k,j} = wichman_psy.params.est(2);
            Bias_psy{k,j} = wichman_psy.params.est(1);
            psy_perf{k,j} = [wichman_psy.params.est(1),wichman_psy.params.est(2)];
        else
            Thresh_psy{k,j} = NaN;
            Bias_psy{k,j} = NaN;
            psy_perf{k,j} = [NaN NaN];
        end
	end
end

% plot psychometric function here
h{1,1} = 'bo'; h{2,1} = 'b^'; h{3,1} = 'bs'; f{1} = 'b-';
h{1,2} = 'r^'; h{2,2} = 'r^'; h{3,2} = 'rs'; f{2} = 'r-';
h{1,3} = 'gs'; h{2,3} = 'g^'; h{3,3} = 'gs'; f{3} = 'g-';
h{1,4} = 'co'; h{2,4} = 'c^'; h{3,4} = 'cs'; f{4} = 'c-';
h{1,5} = 'mo'; h{2,5} = 'm^'; h{3,5} = 'ms'; f{5} = 'm-';
h{1,6} = 'yo'; h{2,6} = 'y^'; h{3,6} = 'ys'; f{6} = 'y-';
h{1,7} = 'ko'; h{2,7} = 'k^'; h{3,7} = 'ks'; f{7} = 'k-';
 
figure(2+t);
set(2+t,'Position', [200,50 700,650], 'Name', 'Heading Discrimination-Vestibular');
axes('position',[0.2,0.25, 0.6,0.5] );
% fit data with cumulative gaussian and plot both raw data and fitted curve
legend_txt = [];

% xi = min(unique_heading) : 0.1 : max(unique_heading);
% instead, force x range to be symmetric about zero (for staircase)
xi = -max(abs(unique_heading)) : 0.1 : max(abs(unique_heading));

for j = 1:length(unique_condition)    % <-- azimuth/elevation
    for k = 1:length(unique_condition_2)  % <-- stim_type
        if ~isnan(right_pct{k,j})
            figure(2+t);
            plot(unique_heading, right_pct{k,j}(:), h{j,k},  xi, cum_gaussfit(psy_perf{k,j}, xi),  f{k} );
	%         plot(unique_heading, right_pct{k,j}(:), h{k,j},  xi, cum_gaussfit(psy_perf{k,j}, xi),  f{j} );
            xlabel('Heading Angle');   
            ylim([0,1]);
            ylabel('Percent Rightward Choices');
            hold on;
            legend_txt{j*2-1} = [num2str(unique_condition(j))];
            legend_txt{j*2} = [''];
        end
	end
end
% 
% [unique_heading right_pct{k,j}(:)]
% [xi' cum_gaussfit(psy_perf{k,j}, xi)']




% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% output some text of basic parameters in the figure
% axes('position',[0.2,0.8, 0.6,0.15] );
axes('position',[0.2,0.82, 0.6,0.15] );
xlim( [0,50] );
ylim( [2,10] );
text(0, 11, norm_rev{t+1});
text(35,11,date);
text(0, 10, FILE);
text(15,10,[not_con_txt_2 ' =']);
text(25,10,num2str(not_condition_2) );
text(30,10,'repetitions =');
text(40,10,num2str(num_reps) );
text(0,8.3, con_txt);
text(10,8.3, con_txt_2);
text(20,8.3, '  u                 sigma           %correct');
if ~vary_amplitude
    text(15,11,'amplitude =');
    text(25,11,num2str(unique_amplitude));
end 

step = 0;
for j = 1:length(unique_condition)    % <-- azimuth/elevation
    for k = 1:length(unique_condition_2)    % <-- stim_type
        text(0,7-step, num2str(unique_condition(j)));     
        text(10,7-step,num2str(unique_condition_2(k)));
        text(20,7-step,num2str(Bias_psy{k,j}) );
        text(30,7-step,num2str(Thresh_psy{k,j}) );
        text(40,7-step,num2str(mean(correct_pct{k,j})) );
        step = step + 1;
    end
end

axis off;
if printflag(t+1)
    print;
end
if closefigs
    close;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% sprint_txt = ['%s\t'];
% for i = 1 : 50 % this should be large enough to cover all the data that need to be exported
%      sprint_txt = [sprint_txt, ' %4.3f\t'];    
% end
sprint_txt = ['%s\t', '%4.3f\t', '%4.3f\t', '%4.3f\t', '%4.3f\t', '%4.3f\t', '%4.3f\t', '%4.3f\t', '%4.3f\t', '%4.3f\t', '%s\t']; % now must be adjusted when fields are added/changed

% outfile = [BASE_PATH 'ProtocolSpecific\MOOG\HeadingDiscrimination_2I\Psychometric_2I.dat'];
% outfile = [BASE_PATH 'ProtocolSpecific\MOOG\HeadingDiscrimination_2I\Psychometric_2I_coh.dat'];
% outfile = [BASE_PATH 'ProtocolSpecific\MOOG\HeadingDiscrimination_2I\Psychometric_2I_alvin.dat'];
outfile = [BASE_PATH 'ProtocolSpecific\MOOG\HeadingDiscrimination_2I\Psychometric_2I_new.dat'];

% another new output var: flag for whether multiple reference azimuths were interleaved
if length(unique_azimuth) > 1
    ref_interleave = 1;
else
    ref_interleave = 0;
end

% two new output vars: run number and normalized bias (for determining progress in 2I training)
run_num = str2num(FILE(strfind(FILE,'r') + 1 : strfind(FILE,'.') - 1));
for j = 1:length(unique_condition)
    for k = 1:length(unique_condition_2)
        if unique_condition(j) == 90
            norm_bias(k,j) = 9999;
        else
            norm_bias(k,j) = Bias_psy{k,j}/abs(unique_condition(j)-90);
        end
    end
end

createfile = 0;
if (exist(outfile, 'file') == 0)    %file does not yet exist
    createfile = 1;
end
fid = fopen(outfile, 'a');
if (createfile)   % change headings here if diff conditions varied
    fprintf(fid, 'FILE\t run_num\t azimuth\t stimtype\t bias\t norm_bias\t thresh\t pct_correct\t num_reps\t ref_interleave\t norm_rev');
    fprintf(fid, '\r\n');
end
for j = 1:length(unique_condition)
    for k = 1:length(unique_condition_2)
		buff = sprintf(sprint_txt, FILE, run_num, unique_condition(j), unique_condition_2(k), Bias_psy{k,j}, norm_bias(k,j), Thresh_psy{k,j}, mean(correct_pct{k,j}), num_reps, ref_interleave, norm_rev{t+1});
        fprintf(fid, '%s', buff);
        fprintf(fid, '\r\n');
    end
end
fclose(fid);
%---------------------------------------------------------------------------------------

% temporary, for Chris (comment this out if you get an error):
% fit_data{t+1} = fit_data_psycho_cum;

end % END repeating entire analysis for normal and reversed-interval trials

% temporary, for Chris (comment this out if you get an error):
% save(['C:\MATLAB6p5\work\tunde\' FILE '.mat'], 'fit_data', 'unique_azimuth', 'unique_condition', 'unique_condition_2');

return;