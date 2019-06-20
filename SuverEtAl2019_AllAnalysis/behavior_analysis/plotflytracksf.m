function plotflytracksf (oneFlydata,type, trials)

% plotflytracks (oneFlydata, trial)
%
% Plots the trajectory of a fly in different trials, given that "oneFlydata"
% is a structure with several trials accumulated in the columns of
% matrices. "trial" is an optional argument that allows to specify a single
% trial, or a specific set of trials, to be plotted. 

%AM: syntax to run this is plotflytracksf(set.stimuliname(1))

lims = [0 40 0 142]; % Sets the limits of the axes

if nargin == 3 % In case there is a single trial specified...
    
    figure('color','white','position',[0 0 1440 700]);
      
    for ene = 1:numel(trials)
        
        trial = trials(ene); % Selects the current trial specified
        if type==1
        stim = find(oneFlydata.stimulus(:,trial)>=0.5); % Detects the time of the stimulus
        else
            stim = find(oneFlydata.lightstimulus(:,trial)>=0.5);
        end
        windstim = find(oneFlydata.windstimulus(:,trial)==0);
        windstim=windstim(1:end-2);
        
        if (isempty(stim) && isempty(windstim)) % If there is no stimulus it plots a black trajectory
            subplot(1,numel(trials),ene); 
            plot(oneFlydata.xfilt(:,trial),oneFlydata.yfilt(:,trial),'k','linewidth',3);
            hold on;
            plot(oneFlydata.xfilt(end-1:end,trial),oneFlydata.yfilt(end-1:end,trial),'c','linewidth',3);
            set(gca,'dataaspectratio',[1 1 1]);
            axis(lims); title([num2str(trial), ' - ', num2str(oneFlydata.timeline(trial))]);
        elseif (isempty(stim))
            subplot(1,numel(trials),ene);
            title([num2str(trial), ' - ', num2str(oneFlydata.timeline(trial))]); hold on
            plot(oneFlydata.xfilt(:,trial),oneFlydata.yfilt(:,trial),'k','linewidth',3);
            plot(oneFlydata.xfilt(windstim(1):windstim(end),trial),oneFlydata.yfilt(windstim(1):windstim(end),trial),...
                'm','linewidth',3);
            plot(oneFlydata.xfilt(windstim(end):end,trial),oneFlydata.yfilt(windstim(end):end,trial),...
                'c','linewidth',3);
            set(gca,'dataaspectratio',[1 1 1]);
            axis(lims); 
        else
            subplot(1,numel(trials),ene);
            title([num2str(trial), ' - ', num2str(oneFlydata.timeline(trial))]); hold on
            plot(oneFlydata.xfilt(:,trial),oneFlydata.yfilt(:,trial),'k','linewidth',3);
            plot(oneFlydata.xfilt(stim(1):stim(end),trial),oneFlydata.yfilt(stim(1):stim(end),trial),...
                'r','linewidth',3);
            plot(oneFlydata.xfilt(stim(end):end,trial),oneFlydata.yfilt(stim(end):end,trial),...
                'b','linewidth',3);
            set(gca,'dataaspectratio',[1 1 1]);
            axis(lims); 
        end
    end
    return
end

xdata=oneFlydata.xfilt;
n = size(xdata,2);


if n <= 10
    figure('color','white','position',[0 0 1440 900]);
    for i = 1:n
        
        if type==1
        stim = find(oneFlydata.stimulus(:,i)>=0.5);
        else
            stim = find(oneFlydata.lightstimulus(:,i)>0.5);
        end
        windstim = find(oneFlydata.windstimulus(:,i)==0);
        windstim = windstim(1:end-2);
        if (isempty(stim)&&isempty(windstim))
            subplot(1,n,i); 
            plot(oneFlydata.xfilt(:,i),oneFlydata.yfilt(:,i),'k','linewidth',3);
            hold on;
            plot(oneFlydata.xfilt(end-1:end,i),oneFlydata.yfilt(end-1:end,i),'c','linewidth',3);
            title([num2str(i), ' - ', num2str(oneFlydata.timeline(i))]); 
            set(gca,'dataaspectratio',[1 1 1]);
            axis(lims);
        elseif (isempty(stim))%%wind only
            subplot(1,n,i); title([num2str(i), ' - ', num2str(oneFlydata.timeline(i))]); hold on
            plot(oneFlydata.xfilt(:,i),oneFlydata.yfilt(:,i),'k','linewidth',3);
            plot(oneFlydata.xfilt(windstim(1):windstim(end),i),oneFlydata.yfilt(windstim(1):windstim(end),i),...
                'm','linewidth',3);
            plot(oneFlydata.xfilt(windstim(end):end,i),oneFlydata.yfilt(windstim(end):end,i),...
                'c','linewidth',3);
            set(gca,'dataaspectratio',[1 1 1]);
            axis(lims); 
        else%case when there is odour
            subplot(1,n,i); title([num2str(i), ' - ', num2str(oneFlydata.timeline(i))]); hold on
            plot(oneFlydata.xfilt(:,i),oneFlydata.yfilt(:,i),'k','linewidth',3);
            plot(oneFlydata.xfilt(stim(1):stim(end),i),oneFlydata.yfilt(stim(1):stim(end),i),...
                'r','linewidth',3);
            plot(oneFlydata.xfilt(stim(end):end,i),oneFlydata.yfilt(stim(end):end,i),...
                'b','linewidth',3);
            set(gca,'dataaspectratio',[1 1 1]);
            axis(lims); 
        end
    end
           
elseif n > 10
    figure('color','white','position',[0 0 1920 1080]);
    for k = 1:n
        filas = ceil(n/10);
        if type==1
            stim = find(oneFlydata.stimulus(:,k)>=0.5);
        else
            stim = find(oneFlydata.lightstimulus(:,k)>=0.5);
        end
        windstim = find(oneFlydata.windstimulus(:,k)==0);
        windstim = windstim(1:end-2);
        if (isempty(stim)&&isempty(windstim))
            subplot(filas,10,k);
            plot(oneFlydata.xfilt(:,k),oneFlydata.yfilt(:,k),'k','linewidth',3);
            hold on;
            plot(oneFlydata.xfilt(end-1:end,k),oneFlydata.yfilt(end-1:end,k),'c','linewidth',3);
            title([num2str(k), ' - ', num2str(oneFlydata.timeline(k))]);
            set(gca,'dataaspectratio',[1 1 1]);
            axis(lims);
        elseif (isempty(stim))
            subplot(filas,10,k); title([num2str(k), ' - ', num2str(oneFlydata.timeline(k))]); hold on
            plot(oneFlydata.xfilt(:,k),oneFlydata.yfilt(:,k),'k','linewidth',3);
            plot(oneFlydata.xfilt(windstim(1):windstim(end),k),oneFlydata.yfilt(windstim(1):windstim(end),k),...
                'm','linewidth',3);
            plot(oneFlydata.xfilt(windstim(end):end,k),oneFlydata.yfilt(windstim(end):end,k),...
                'c','linewidth',3);
            set(gca,'dataaspectratio',[1 1 1]);
            axis(lims);
        else
            subplot(filas,10,k); title([num2str(k), ' - ', num2str(oneFlydata.timeline(k))]); hold on
            plot(oneFlydata.xfilt(:,k),oneFlydata.yfilt(:,k),'k','linewidth',3);
            plot(oneFlydata.xfilt(stim(1):stim(end),k),oneFlydata.yfilt(stim(1):stim(end),k),...
                'r','linewidth',3);
            plot(oneFlydata.xfilt(stim(end):end,k),oneFlydata.yfilt(stim(end):end,k),...
                'b','linewidth',3);
            set(gca,'dataaspectratio',[1 1 1]);
            axis(lims);
        end
    end
end

set(gcf,'PaperPositionMode','auto');