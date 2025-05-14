clc;
clear;
% particleTypes is a matrix containing mass (kg), diameter (m), concentration (micrograms*m^-3), and charge (Coulombs) for the common pollutants PM10, PM2.5, NO2, SO2, O3, and CO 
e = 1.602*10^-19;
particleTypes = [2.12*(10^-18), 6.5*(10^-6), 29.9, e; 1.38*(10^-19), 2*(10^-6), 17.3, e; 7.6396*(10^-26), 2.5*(10^-6), 35.6, e; 1.0638*(10^-25), 2.5 *(10^-6), 3.1, e; 7.9705*(10^-26), 2.5*(10^-6), 53.5, e; 4.6513*(10^-26), 2.5 *(10^-6), 573.7, e]; 

%PM10 and PM2.5 particles: (come back to this later w/real charges possibly) [2.12*(10^-18), 6.5*(10^-6), 29.9; 1.38*(10^-19), 2*(10^-6), 17.3;] 

velocities = [1,1.5,1.75,1.9,2,2.1,2.2,2.3,2.4,2.5,2.75,3,3.5,4];
%wind velos centered at avg speed
width = 10;
%width of machine
col = 0; 
row = 0; 
initial = 2 *10^-15; 
final = 1 * 10^-11;
step = 2* 10^-15;
%looping charge density
zeroCol = ((final - initial) / step)  + 1;
zeroCol = round(zeroCol);
%amount of cols needed for matrix
effectiveVal = 0;
%value that is inputted in matrix after loops
effectiveMat = zeros(30, zeroCol);
%matrix to store effectiveness
for avgDist = .1:.1:3
    row = row + 1;
    %each row is used for a different plate and mesh seperation
    for sigma = initial:step:final 
        effectiveVal = 0; 
        col = col + 1;
        %each col a diff charge density
        for numParticle = 1:length(particleTypes)
            %looping thru smog particles
            mass = particleTypes(numParticle,1);
            dia = particleTypes(numParticle,2);
            charge = particleTypes(numParticle,4);
            for velo = 1:length(velocities) 
                velocity = velocities(1,velo);
                %air velos
                if(netForce(mass,dia,velocity,charge,sigma,avgDist, width) == 1) 
                    effectiveVal = effectiveVal + 1;
                    %if success in removing smog, add one to eVal
                end
            end
        end
        effectiveMat(row,col) = effectiveVal;
        %add to matrix and reset to 0 at start of new loop
    end   
    col = 0;
    %reset col place for a new plate and mesh seperation
end

outputMat = effectiveMat(20,:);
%used to find the optimal value from the loops above
%the effectiveMat matrix has values stored of effectiveness at different
%charges and plate seperation
for col = 1:length(outputMat)
    if(outputMat(1,col) == 56)
        outputIndex = col;
        break;
    end
end
outputCharge = (outputIndex * step) + initial
distance = 2

% radius (m)
%values for an average particle
mass = 7.6396*(10^-26);
diameter = 2.5*(10^-6);
velocity = 2.3;
%inital wind speed (m/s)
charge = e;
sigma = outputCharge;
%uses the value deemed optimal
width = 10;
%dim of machine chosen
avgDist = 2;
veloX = 0;
%velo in plane of plate
val = 0;
%reutrn val
t = 0;
distTraveled = 0;
timeStep = .05;
viscosity = 0.00001834; 
timeMax = width /velocity;
pi = 3.1415;
r = diameter/2; 
     
while (t <= timeMax)
    drag = -(6*pi*r*viscosity*veloX); 
    % electricField 
    electricField = 9*(10^9)*(charge*sigma); 
    % gravity 
    %gravity = -(mass*g); 
    % brownian (accounts for random motion) 
    brownian = mass*veloX + drag*veloX; 
    force = drag + electricField + brownian;
    accel = force / mass;
    veloX = veloX + (accel * timeStep);
    distTraveled = distTraveled + (veloX * timeStep);
    t = t + timeStep;
    if distTraveled >= avgDist
        break;    
    end
end

avgTime = t;
p = 1.186;
%air density
volume = 50.265 * 7;
%amount of space between mesh and plate
totalMass = p * volume;
%mass of air in device
hourSec = 3600 * 24;
refillTime = hourSec / t;
airTaken = totalMass * refillTime
volumeCleaned = airTaken / p
PM2 = (volumeCleaned * 17.3) / (1*(10^9))
PM10 = (volumeCleaned * 29.9) / (1*(10^9))
O3 = (volumeCleaned * 53.5) / (1*(10^9))
NO2 = (volumeCleaned * 35.6) / (1*(10^9))
SO2 = (volumeCleaned * 3.1) / (1*(10^9))
CO2 = (volumeCleaned * 573.7) / (1*(10^9))
totalSmog = PM2 + PM10 + O3 + NO2 + SO2 + CO2
surfaceArea = 1.114 * (10^9);
%area of HK
strat = 10000;
%vert meters of atmosphere
totalVol = surfaceArea * strat;
percentageOfAtmosphere = (volumeCleaned / totalVol) * 100
%with one tower it would take below time in years
timeCleanTotalYears = (1 / (percentageOfAtmosphere / 100)) / 365

function[val] = netForce (mass, diameter, velocity, charge, sigma, avgDist, width) 
    % radius (m)
    veloX = 0;
    %direction in plane of plate
    val = 0;
    %return val
    t = 0;
    %time
    distTraveled = 0;
    %used to check how much particle has moved
    timeStep = .05;
    timeMax = width /velocity;
    %amount of time the particle would have before exiting machine
    pi = 3.1415;
    r = diameter/2;
    % dynamic viscosity of the air at 76 F (Pa * s) 
    viscosity = 0.00001834; 
    %v here is the velocity of the particle moving through the air -> wind speed 
    while (t <= timeMax)
        drag = -(6*pi*r*viscosity*veloX); 
        % electricField 
        electricField = 9*(10^9)*(charge*sigma); 
        brownian = mass*veloX + drag*veloX; 
        force = drag + electricField + brownian;
        accel = force / mass;
        veloX = veloX + (accel * timeStep);
        distTraveled = distTraveled + (veloX * timeStep);
        t = t + timeStep;
        if distTraveled >= avgDist
            val = 1;
            %returns 1 if success
            break;
        end
    end
end

