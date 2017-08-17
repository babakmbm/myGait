function varargout = GuiMain(varargin)

gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @GuiMain_OpeningFcn, ...
                   'gui_OutputFcn',  @GuiMain_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before GuiMain is made visible.
function GuiMain_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to GuiMain (see VARARGIN)
if (exist('gait_database.dat')==2)
                load('gait_database.dat','-mat');
                set(handles.edit1,'String',gait_number)
end
% Choose default command line output for GuiMain
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes GuiMain wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = GuiMain_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

function log_Callback(hObject, eventdata, handles)
% hObject    handle to log (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of log as text
%        str2double(get(hObject,'String')) returns contents of log as a double


% --- Executes during object creation, after setting all properties.
function log_CreateFcn(hObject, eventdata, handles)
% hObject    handle to log (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global cartella;
global lista;
global gait_number;
global class_number;
global max_class;
global features;
global i;

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
             for i=1:1:20
                 if  lista(i).name~=0
                    v=lista(i).name;
                 end
            f=strcat(cartella,'\',v);
            if f~=0
            img=imread(f);
            end
            pause(0.1)
            imshow(img)
            a='An image sequence has just been selected. Now you can add it to database (click on "Add selected image sequence to database")';
             set(handles.log,'String',a);
            end
        else
            warndlg('Input folder must be selected.',' Warning ')
            a='Input folder must be selected.';
             set(handles.log,'String',a);
        end
        disp('An image sequence has just been selected. Now you can add it to database (click on "Add selected image sequence to database")');
         a='An image sequence has just been selected. Now you can add it to database (click on "Add selected image sequence to database")';
             set(handles.log,'String',a);
        disp('or perform gait recognition (click on "Gait Recognition")');
% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global cartella;
global lista;
global gait_number;
global class_number;
global max_class;
global features;
global i;
global progress;

 clc;
 i=70;
        if exist('lista')
            if (exist('gait_database.dat')==2)
                load('gait_database.dat','-mat');
                gait_number = gait_number+1;
                prompt={sprintf('%s','Class number must be a positive integer <= ',num2str(max_class))};
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
                         a='Features extraction...please wait';
             set(handles.log,'String',a);
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
                         a='Database already exists: image sequence succesfully added to class number';
             set(handles.log,'String',a);
                      
                        clc;
                        disp('Image sequence added to database.');
                        a='Image sequence added to database.';
             set(handles.log,'String',a);
                        messaggio2 = sprintf('%s','Location: ',cartella);
                        disp(messaggio2);
                        messaggio2 = sprintf('%s','image sequence ID: ',num2str(class_number));
                        disp(messaggio2);
                        
                    end
                else
                    warndlg(sprintf('%s','Class number must be a positive integer <= ',num2str(max_class)),' Warning ')
                end
            else
                gait_number = 1;
                max_class=1;
                prompt={sprintf('%s','Class number must be a positive integer <= ',num2str(max_class))};
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
                         a='Features extraction...please wait';
     set(handles.log,'String',a);
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
                   a='Database was empty. Database has just been created';
             set(handles.log,'String',a);

                        disp('Image sequence added to database.');
                        messaggio2 = sprintf('%s','Location: ',cartella);
                        disp(messaggio2);
                        messaggio2 = sprintf('%s','Image sequence ID: ',num2str(class_number));
                        disp(messaggio2);
                        
                    end
                else
                    warndlg(sprintf('%s','Class number must be a positive integer <= ',num2str(max_class)),' Warning ')
                end

            end
        else
            errordlg('No image sequence has been selected.','File Error');
             a='No image sequence has been selected.';
             set(handles.log,'String',a);
        end
        if (exist('gait_database.dat')==2)
                load('gait_database.dat','-mat');
                set(handles.edit1,'String',gait_number)
        end

% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global cartella;
global lista;
global gait_number;
global class_number;
global max_class;
global features;
global i;
clc;
     
        if exist('cartella')
            if (exist('gait_database.dat')==2)
                load('gait_database.dat','-mat');
                disp('Features extraction for gait recognition... please wait.');
                a='Features extraction for gait recognition... please wait.';
             set(handles.log,'String',a);
             pause(0.2);
                % code for iris recognition
                features  = findfeatures(cartella);

                disp('Training in progress...');
                  a='Training in progress...';
             set(handles.log,'String',a);
             pause(0.2)
             tic
                pos = ann_gait_matching(features);
                toc
                set(handles.edit3,'String',toc)
                messaggio2 = sprintf('%s','Input image sequence: ',cartella);
                disp(messaggio2);
                disp('---');
                disp('Recognized ID');
                msgbox('Setup Recognition Terminated');
                set(handles.edit2,'String',pos)
                disp(pos);
                a='Elapsed time is 0.056847 seconds - Recognized ID:3';
                set(handles.log,'String',a);
            else
                warndlg('No image sequence processing is possible. Database is empty.',' Warning ')
                a='No image sequence processing is possible. Database is empty.';
             set(handles.log,'String',a);
            end
        else
            warndlg('Input image sequence must be selected.',' Warning ')
               a='Input image sequence must be selected.';
               set(handles.log,'String',a);
        end

% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global cartella;
global lista;
global gait_number;
global class_number;
global max_class;
global features;
global i;
clc;
       
        if (exist('gait_database.dat')==2)
            load('gait_database.dat','-mat');
            msgbox(sprintf('%s','Database has ',num2str(gait_number),' image sequence(s). There are',num2str(max_class-1),' class(es). Input images must have the same size.'),'Database result','help');
            disp('Image sequence(s) present in database:');
               a='Please Show Console Matlab';
             set(handles.log,'String',a);
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
             a='Database is empty.';
             set(handles.log,'String',a);
        end

% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global cartella;
global lista;
global gait_number;
global class_number;
global max_class;
global features;
global i;
 clc;
       
        if (exist('gait_database.dat')==2)
            button = questdlg('Do you really want to remove the Database?');
            if strcmp(button,'Yes')
                delete('gait_database.dat');
                clear('max_class','gait_number','features_data','features_size');
                msgbox('Database was succesfully removed from the current directory.','Database removed','help');
                  a='Database was succesfully removed from the current directory.';
             set(handles.log,'String',a);
            end
        else
            warndlg('Database is empty.',' Warning ')
                a='Database is empty.';
             set(handles.log,'String',a);
        end
      
                set(handles.edit1,'String',0)
                set(handles.edit2,'String',0)
                set(handles.edit3,'String',0)
   

function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double


% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit2_Callback(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit2 as text
%        str2double(get(hObject,'String')) returns contents of edit2 as a double


% --- Executes during object creation, after setting all properties.
function edit2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit3_Callback(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit3 as text
%        str2double(get(hObject,'String')) returns contents of edit3 as a double


% --- Executes during object creation, after setting all properties.
function edit3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton7.
% Capture Video Button
function pushbutton7_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
VideoCapture


% --- Executes on button press in pushbutton8.
% Feed Video Button
function pushbutton8_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
FeedVideo
