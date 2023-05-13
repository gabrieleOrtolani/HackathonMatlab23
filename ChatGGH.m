clc 
clear all
close all
clearvars -global a;
latmax  = zeros(1,2);
longmax = zeros(1,2);
distot  = 0;
counter = 0;
oldta   = 0;
oldtp   = 0;
u = 1;
m = mobiledev;
m.Logging = 1;
m.PositionSensorEnabled = 1;
m.AccelerationSensorEnabled = 1;
m.AngularVelocitySensorEnabled = 1;
m.SampleRate = 10;
m.poslog;
m.accellog;
while 1
    %collecting data
    [lat, long, tp, speed, course, alt] = m.poslog;
    [a , ta] = m.accellog;
    [j,i] = size(tp);
    
    if j>2
        u = u + 1;

        lathistory(u,1) = lat(end);
        longhistory(u, 1) = long(end);
        althistory(u, 1) = alt(end);
        speedhistory(u,1)= speed(end);

        if oldta == ta(end)
            counter=counter+1;
            if counter >5;
               break;
            end
        else 
            counter = 0;
        end
        oldta = ta(end);
        oldtp = tp(end);
        figure(1);
        [latmax, longmax] = setLimits(lat,long, latmax, longmax);
        geolimits([latmax(1,1)-0.001 latmax(1,2)+0.001],[longmax(1,1)-0.001 longmax(1,2)+0.001])
        geoplot(lat(end),long(end),"-x")
        hold on;
        drawnow; 
        figure(2);
        subplot(3,1,1)
        plot(ta, a(:,1))
        subplot(3,1,2)
        plot(ta, a(:,2))
        subplot(3,1,3)
        plot(ta,a(:,3))
        drawnow; 


        figure(3);
        plot(tp, alt);
        dist = distance(lat(end), long(end), lat(end-1), long(end-1));
        distot = distot+dist;

        figure(4);
        plot(u,distot,"-x");
        hold on;
    
        steps = (distot)/(0.50); 
        disp(steps);
    end
end 

m.Logging = 0;
nome_file = 'variabile_salvata.txt';
% Apri il file in modalità di scrittura
file = fopen(nome_file, 'w');
% Verifica se il file è stato aperto correttamente
if file == -1
    error('Impossibile aprire il file.');
end


for i = 1:1:length(longhistory)
    nome_file = 'variabile_salvata.txt';
    % Apri il file in modalità di scrittura
    file = fopen(nome_file, 'w');
    % Verifica se il file è stato aperto correttamente
    if file == -1
        error('Impossibile aprire il file.');
    end
    % Scrivi la variabile nel file di testo
    fprintf(file, '%d   %d  %d  %d\n', lathistory, longhistory, althistory,speedhistory);
    % Chiudi il file
    fclose(file);
   
end

figure(5)
plot3(lathistory,longhistory,althistory);
disp("velocità media")
mean(speedhistory)
function [latmax, longmax] = setLimits(lat, long, latmax, longmax)
        for i = 1:1:width(lat)
            if lat(i) > latmax(1,1) || latmax(1,1) == 0
                latmax(1,1) = lat(i);
            end
            if lat(i) < latmax(1,2) || latmax(1,2) == 0
                latmax(1,2) = lat(i);
            end
    
            if long(i)>longmax(1,1) || longmax(1,1) == 0
                longmax(1,1) = long(i);
            end
            if long(i)<longmax(1,2) || longmax(1,2) == 0
                longmax(1,2) = long(i);
            end
        end
end