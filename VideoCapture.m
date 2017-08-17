clear;
%connect to camera
cam = webcam;
if cam ~= 0
    preview(cam);

    %Create a New Directory
    PARENTDIR = 'CamVideo'; 
    FRAMESDIR = 'Frames';
    NEWDIR = datestr(now,'mmmm_dd_yyyy_HH_MM_SS_AM/');
    mkdir(PARENTDIR,NEWDIR);
    PARENTDIR2 = char(string('CamVideo/') + NEWDIR);
    mkdir(PARENTDIR2,FRAMESDIR);

    %Create a New video object
    vPath = string('CamVideo/')+ NEWDIR + string('video.avi');
    vidWriter = VideoWriter(char(vPath));
    open(vidWriter);

    %video Acussission and save to file system
    tic
    for index = 1:200
        img = snapshot(cam);
        writeVideo(vidWriter, img);
    end
    toc

    close(vidWriter);
    clear cam;

    %read the video and frame it
    vid = VideoReader(char(vPath));
    numFrames = vid.NumberOfFrames;
    n=numFrames;
    for i = 1:1:n
      fPath = char(string('CamVideo/')+ NEWDIR + FRAMESDIR+ string('/') + i + '.png');
      frames = read(vid,i);
      imwrite(frames, fPath);
      backgroundExt(fPath);
    end 
    msgbox('Video saved and Framed.', 'Operation Completed');
    disp('Video saved and Framed.');
else
    msgbox('No Camera Installed!', 'Operation Completed');
    disp('No Camera Installed!');
end