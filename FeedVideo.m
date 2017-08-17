clear all;
[filename, pathname, filterindex] = uigetfile({'*.avi', 'Video Files(*.avi)'}, 'Pick your video file');
if (filename ~= 0)
    
    %Create a New folder
    PARENTDIR = 'CamVideo'; 
    FRAMESDIR = 'Frames';
    NEWDIR = datestr(now,'mmmm_dd_yyyy_HH_MM_SS_AM/');
    mkdir(PARENTDIR,NEWDIR);
    PARENTDIR2 = char(string('CamVideo/') + NEWDIR);
    mkdir(PARENTDIR2,FRAMESDIR);
    
    %copy file in the new folder
    Source = string(pathname) + string(filename);
    Destination = string('CamVideo/')+ NEWDIR;
    copyfile (char(Source),char(Destination));
    vPath = Destination + filename;

    %read the video and frame it
    vid = VideoReader(char(vPath));
    numFrames = vid.NumberOfFrames;
    for i = 1:1:numFrames
      fPath = char(string('CamVideo/')+ NEWDIR + FRAMESDIR+ string('/') + i + '.jpg');
      frames = read(vid,i);
      imwrite(frames, fPath);
    end 
    disp('Video saved and Framed.');
    msgbox('Video saved and Framed.', 'Operation Completed');
else
    disp('No file chosen.');
end
