clc 
clear all
close all

load("dataSensor1.mat")


distot = 0;

m.SampleRate = 10;


figure(1);
for i=1:size(Position.latitude)-1
    geoplot(Position.latitude(i),Position.longitude(i),"-x")
    hold on;
    drawnow; 
    drawnow; 
    dist = distance(Position.latitude(i), Position.longitude(i), Position.latitude(i+1), Position.longitude(i+1));
    distot = distot+dist;
%     figure(2)
%     plot(i,Position.altitude)

end 

for i = 1:size(Acceleration)
    figure(3);
    subplot(3,1,1)
    plot(Acceleration.Timestamp, Acceleration.X)
    subplot(3,1,2)
    plot(Acceleration.Timestamp, Acceleration.Y)
    subplot(3,1,3)
    plot(Acceleration.Timestamp, Acceleration.Z)
    

end