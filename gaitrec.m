function []=gaitrec()
clc;
chos=0;
possibility=8;

messaggio='Insert the number of class: each class determins a person. The ID number is a progressive, integer number. Each class should include a number of images for each person.';

while chos~=possibility,
    chos=menu('Gait Recognition System - Advanced Source Code .Com','Select image sequence','Add selected image sequence to database','Database Info','Gait Recognition','Delete Database','Program info',...
        'Source code for Gait Recognition System','Exit');
    %----------------
    if chos==1,
        clc;
        cartella = uigetdir('','Select the folder');
        if cartella~=0
            lista1 = dir(strcat(cartella,'\*.png'));
            lista2 = dir(strcat(cartella,'\*.bmp'));
            lista3 = dir(strcat(cartella,'\*.jpg'));
            lista4 = dir(strcat(cartella,'\*.tif'));
            lista5 = dir(strcat(cartella,'\*.tiff'));
            lista6 = dir(strcat(cartella,'\*.gif'));
            lista7 = dir(strcat(cartella,'\*.pgm'));

            lista = [lista1; lista2; lista3; lista4; lista5; lista6; lista7];
            for i=1:1:10
            v=lista(i).name;
            f=strcat(cartella,'\',v)
            img=imread(f);
            imshow(img)
            end
        else
            warndlg('Input folder must be selected.',' Warning ')
        end
        disp('An image sequence has just been selected. Now you can add it to database (click on "Add selected image sequence to database")');
        disp('or perform gait recognition (click on "Gait Recognition")');
    end
    %----------------
    if chos==2,
        clc;
        if exist('lista')
            if (exist('gait_database.dat')==2)
                load('gait_database.dat','-mat');
                gait_number = gait_number+1;
                prompt={sprintf('%s',messaggio,'Class number must be a positive integer <= ',num2str(max_class))};
                title='Class number';
                lines=1;
                def={'1'};
                answer=inputdlg(prompt,title,lines,def);
                zparameter=double(str2num(char(answer)));
                if size(zparameter,1)~=0
                    class_number=zparameter(1);
                    if (class_number<=0)||(class_number>max_class)||(floor(class_number)~=class_number)||(~isa(class_number,'double'))||(any(any(imag(class_number))))
                        warndlg(sprintf('%s','Class number must be a positive integer <= ',num2str(max_class)),' Warning ')
                    else
                        disp('Features extraction...please wait');
                        if class_number==max_class;
                            % this person (class) has never been added to
                            % database before this moment
                            max_class = class_number+1;
                            features  = findfeatures(cartella);
                        else
                            % this person (class) has already been added to
                            % database
                            features  = findfeatures(cartella);
                        end

                        features_data{features_size+1,1} = features;
                        features_data{features_size+1,2} = class_number;
                        features_data{features_size+1,3} = cartella;
                        features_size                    = size(features_data,1);
                        trained_system                   = 0;
                        clc;
                        save('gait_database.dat','gait_number','max_class','features_data','features_size','trained_system','-append');
                        msgbox(sprintf('%s','Database already exists: image sequence succesfully added to class number ',num2str(class_number)),'Database result','help');
                        close all;
                        clc;
                        disp('Image sequence added to database.');
                        messaggio2 = sprintf('%s','Location: ',cartella);
                        disp(messaggio2);
                        messaggio2 = sprintf('%s','image sequence ID: ',num2str(class_number));
                        disp(messaggio2);
                        clear('cartella');
                    end
                else
                    warndlg(sprintf('%s','Class number must be a positive integer <= ',num2str(max_class)),' Warning ')
                end
            else
                gait_number = 1;
                max_class=1;
                prompt={sprintf('%s',messaggio,'Class number must be a positive integer <= ',num2str(max_class))};
                title='Class number';
                lines=1;
                def={'1'};
                answer=inputdlg(prompt,title,lines,def);
                zparameter=double(str2num(char(answer)));
                if size(zparameter,1)~=0
                    class_number=zparameter(1);
                    if (class_number<=0)||(class_number>max_class)||(floor(class_number)~=class_number)||(~isa(class_number,'double'))||(any(any(imag(class_number))))
                        warndlg(sprintf('%s','Class number must be a positive integer <= ',num2str(max_class)),' Warning ')
                    else
                        disp('Features extraction...please wait');
                        max_class=2;
                        features  = findfeatures(cartella);
                        
                        features_data{1,1} = features;
                        features_data{1,2} = class_number;
                        features_data{1,3} = cartella;
                        features_size      = size(features_data,1);
                        trained_system     = 0;
                        save('gait_database.dat','gait_number','max_class','features_data','features_size','trained_system');
                        msgbox(sprintf('%s','Database was empty. Database has just been created. Image sequence succesfully added to class number ',num2str(class_number)),'Database result','help');
                        clc;
                        close all;

                        disp('Image sequence added to database.');
                        messaggio2 = sprintf('%s','Location: ',cartella);
                        disp(messaggio2);
                        messaggio2 = sprintf('%s','Image sequence ID: ',num2str(class_number));
                        disp(messaggio2);
                        clear('cartella');
                    end
                else
                    warndlg(sprintf('%s','Class number must be a positive integer <= ',num2str(max_class)),' Warning ')
                end

            end
        else
            errordlg('No image sequence has been selected.','File Error');
        end
    end
    %----------------
    if chos==3,
        clc;
        close all;
        clear('img');
        if (exist('gait_database.dat')==2)
            load('gait_database.dat','-mat');
            msgbox(sprintf('%s','Database has ',num2str(gait_number),' image sequence(s). There are',num2str(max_class-1),' class(es). Input images must have the same size.'),'Database result','help');
            disp('Image sequence(s) present in database:');
            disp('---');
            for ii=1:features_size
                messaggio2 = sprintf('%s','Location: ',features_data{ii,3});
                disp(messaggio2);
                messaggio2 = sprintf('%s','Image sequence ID: ',num2str(features_data{ii,2}));
                disp(messaggio2);
                disp('---');
            end
        else
            msgbox('Database is empty.','Database result','help');
        end
    end
    %----------------
    if chos==4,
        clc;
        close all;
        if exist('cartella')
            if (exist('gait_database.dat')==2)
                load('gait_database.dat','-mat');
                disp('Features extraction for gait recognition... please wait.');
                % code for iris recognition
                features  = findfeatures(cartella);

                disp('Training in progress...');
                pos = ann_gait_matching(features);
                messaggio2 = sprintf('%s','Input image sequence: ',cartella);
                disp(messaggio2);
                disp('---');
                disp('Recognized ID');
                disp(pos);
            else
                warndlg('No image sequence processing is possible. Database is empty.',' Warning ')
            end
        else
            warndlg('Input image sequence must be selected.',' Warning ')
        end
    end
    %----------------
    if chos==5,
        clc;
        close all;
        if (exist('gait_database.dat')==2)
            button = questdlg('Do you really want to remove the Database?');
            if strcmp(button,'Yes')
                delete('gait_database.dat');
                clear('max_class','gait_number','features_data','features_size');
                msgbox('Database was succesfully removed from the current directory.','Database removed','help');
            end
        else
            warndlg('Database is empty.',' Warning ')
        end
    end
    %----------------
    if chos==6,
        clc;
        close all;
        helpwin readme;
    end
    %----------------
    if chos==7,
        clc;
        close all;
        web http://matlab-recognition-code.com/gait-biometric-recognition-system-matlab-source-code/
        helpwin sourcecode;
    end
end
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
function [out] = findfeatures(cartella)
out = [];
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


for ii=1:L
    clc;
    disp('Reading image sequence. Please wait.');
    disp('Progress %');
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
disp('Completed.');
out = out';
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
function [out] = ann_gait_matching(features)
load('gait_database.dat','-mat');
% features_data{features_size+1,1} = features;
% features_data{features_size+1,2} = class_number;
% features_data{features_size+1,3} = strcat(pathname,namefile);
% features_size = size(features_data,1);
% max_class (classi presenti + 1)
if exist('trained_system')==0 || trained_system==0
    P = [];
    T = [];
    L = features_size;
    for ii=1:L
        C = features_data{ii,1};
        [dimx,dimy] = size(C);
        P = [P C'];
        t   = zeros(max_class-1,dimx);
        pos =  features_data{ii,2};
        for jj=1:(max_class-1)
            if jj==pos
                t(jj,:) = +0.90;
            else
                t(jj,:) = -0.90;
            end
        end
        T = [T t];
    end

    input_vector = features';
    AII = zeros(size(P,1),1);
    BII = zeros(size(P,1),1);
    %Normalization
    for ii=1:size(P,1)
        v = P(ii,:);
        v = v(:);
        bii = max([v;1]);
        aii = min([v;-1]);
        AII(ii) = aii;
        BII(ii) = bii;
        P(ii,:) = 2*(P(ii,:)-aii)/(bii-aii)-1;
        input_vector(ii,:) = 2*(input_vector(ii,:)-aii)/(bii-aii)-1;
    end
    [net]          = createnn(P,T);
    trained_system = 1;
    save('gait_database.dat','net','AII','BII','trained_system','-append');
else
    input_vector = features';
    for ii=1:size(input_vector,1)
        %v = P(ii,:);
        %v = v(:);
        %bii = max([v;1]);
        %aii = min([v;-1]);
        %AII(ii) = aii;
        %BII(ii) = bii;
        aii = AII(ii);
        bii = BII(ii);
        %P(ii,:) = 2*(P(ii,:)-aii)/(bii-aii)-1;
        input_vector(ii,:) = 2*(input_vector(ii,:)-aii)/(bii-aii)-1;
    end
end
risultato   = sim(net,input_vector);
[dimx,dimy] = size(risultato);
vettore     = zeros(dimy,1);
for jj=1:dimy
    c            = risultato(:,jj);
    [val,pos]    = max(c);
    vettore(pos) = vettore(pos)+1;
end
[val,pos] = max(vettore);
out       = pos;
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
function [net] = createnn(P,T)
alphabet = P;
targets  = T;

[R,Q]  = size(alphabet);
[S2,Q] = size(targets);
S1     = 100;
% traingda
net = newff(minmax(alphabet),[S1 S2],{'tansig' 'tansig'},'traingda');
net.LW{2,1}           = net.LW{2,1}*0.01;
net.b{2}              = net.b{2}*0.01;
net.performFcn        = 'mse';
net.trainParam.goal   = 0.000000001;
net.trainParam.show   = 100;
net.trainParam.epochs = 5000;
net.trainParam.mc     = 0.95;
P                     = alphabet;
T                     = targets;
[net,tr]              = train(net,P,T);
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
