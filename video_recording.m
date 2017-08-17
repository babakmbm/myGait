%% Set up Connection to Webcam
% Use the |webcam| function to create a connection to the camera. This
% example uses "Logitech HD Webcam C310" camera. 

% Connect to the webcam.
cam = webcam

%% Open Video File using VideoWriter
% Create the |VideoWriter| object to open an AVI file for writing. 
vidWriter = VideoWriter('frames.a
vi');
open(vidWriter);

%% Acquire and store frames
% The following loop writes the acquired frames to the specified AVI file
% for future processing. 

for index = 1:20
    % Acquire frame for processing
    img = snapshot(cam);
    
    % Write frame to video
    writeVideo(vidWriter, img);
end

%% Clean up
% Once the connection is no longer needed, clear the associated variable.
close(vidWriter);
clear cam