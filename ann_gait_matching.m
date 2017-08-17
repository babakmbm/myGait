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
%----------------------------------------------------