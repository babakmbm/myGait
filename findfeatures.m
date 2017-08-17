function [out] = findfeatures(cartella)
out = [];
global progress;
% suono             = double(ingresso);
% fsnew             = 8000;
% [normalized,slot] = findvoice(suono,fs,fsnew);
% C = [];
% L = size(slot,1);
% for ii=1:L
%     if slot(ii,2)-slot(ii,1)>=128
%         s = normalized(slot(ii,1):slot(ii,2));
%         c = melcepst(s,fsnew,[],40);
%         C = [C;c];
%     end
% end
% out = C;
lista = dir(strcat(cartella,'\*.png'));
L     = length(lista);
    disp('Reading image sequence. Please wait.');
    disp('Progress %');
    clc
    T1='Please wait..';
    T2='Progress: ';
    
h=msgbox(sprintf('%s','Database has ',T1));
set(findobj(h,'style','pushbutton'),'Visible','off')
for ii=1:L
    clc;

   % pause(0.01)
    progress=ii/L*100;
  v=strcat(T1,T2,num2str(progress),'%');
     
    set(findobj(h,'Tag','MessageBox'),'String',v);
    disp(ii/L*100);
    nomefile = lista(ii).name;
    percorso = strcat(cartella,'\',nomefile);

    img = imread(percorso);
    if ndims(img)==3
        img = rgb2gray(img);
    end
    I = double(img);
    %----------------------------------------------------------------------
    F     = I;
    [M,N] = size(F);
    [x,y] = meshgrid(1:N,1:M);
    x     = x(:);
    y     = y(:);
    F     = F(:);
    m.m00 = sum(F);
    if(m.m00==0)
        m.m00 = eps;
    end
    m.m10 = sum(x.*F);
    m.m01 = sum(y.*F);
    xbar  = m.m10/m.m00;
    ybar  = m.m01/m.m00;

    posizioni = find(I);
    mask      = zeros(size(I));
    mask(round(ybar),round(xbar)) = 1;
    D         = bwdist(mask);
    distanze  = D(posizioni);
    % distanze = distanze/max(distanze);
    % distribuzione = hist(distanze,100);
    distribuzione = hist(distanze,[1:150]);
    out          = [out distribuzione(:)];
    %----------------------------------------------------------------------
    %     [X,Y]   = find(I);
    %     x0      = min(X);
    %     x1      = max(X);
    %     y0      = min(Y);
    %     y1      = max(Y);
    %     I       = I(x0:x1,y0:y1);
    %     % Resize to fix length
    %     I       = imresize(I,[50,25]);
    %     [Lx,Ly] = size(I);
    %
    %     projection     = sum(I,1)/Lx;
    %     lower_envelope = zeros(Ly,1);
    %     upper_envelope = zeros(Ly,1);
    %     mean_vector    = zeros(Ly,1);
    %     median_vector  = zeros(Ly,1);
    %     for ii=1:Ly
    %         colonna            = I(:,ii);
    %         pos                = find(colonna);
    %
    %         if length(pos)>0
    %             lower_envelope(ii) = pos(end)/Lx;
    %             upper_envelope(ii) = pos(1)/Lx;
    %             mean_vector(ii)    = mean(pos)/Lx;
    %             median_vector(ii)  = median(pos)/Lx;
    %         else
    %             lower_envelope(ii) = 0;
    %             upper_envelope(ii) = 0;
    %             mean_vector(ii)    = 0;
    %             median_vector(ii)  = 0;
    %         end
    %     end
    %     feat1 = [projection(:) lower_envelope(:) upper_envelope(:) ...
    %         mean_vector(:) median_vector(:)];
    %
    %     %     I       = I';
    %     %     [Lx,Ly] = size(I);
    %     %
    %     %     projection     = sum(I,1)/Lx;
    %     %     lower_envelope = zeros(Ly,1);
    %     %     upper_envelope = zeros(Ly,1);
    %     %     mean_vector    = zeros(Ly,1);
    %     %     median_vector  = zeros(Ly,1);
    %     %     for ii=1:Ly
    %     %         colonna            = I(:,ii);
    %     %         pos                = find(colonna);
    %     %
    %     %         lower_envelope(ii) = pos(end)/Lx;
    %     %         upper_envelope(ii) = pos(1)/Lx;
    %     %         mean_vector(ii)    = mean(pos)/Lx;
    %     %         median_vector(ii)  = median(pos)/Lx;
    %     %     end
    %     %     feat2 = [projection(:) lower_envelope(:) upper_envelope(:) ...
    %     %         mean_vector(:) median_vector(:)];
    %     %
    %     %     tot_feat = [feat1;feat2];
    %     tot_feat = feat1;
    %     out      = [out tot_feat];
    %----------------------------------------------------------------------
    %imshow(img),hold on,plot(xbar,ybar,'X'),hold off,pause;close all;
    pause(0.1);
end
delete (h);
disp('Completed.');
out = out';
%--------------------------------------------------------------------------