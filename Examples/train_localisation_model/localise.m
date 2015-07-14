function localise()
% Localisation example comparing two different HRTFs

warning('off','all');
startTwoEars();

% Different angles the sound source is placed at
sourceAngles = [30 88 160 257];

printLocalisationTableHeader();

for direction = sourceAngles

    % Localisation using QU KEMAR HRTFs
    sim = simulator.SimulatorConvexRoom('SceneDescriptionQU.xml');
    sim.Verbose = false;
    sim.Sources{1}.set('Azimuth', direction);
    sim.rotateHead(0, 'absolute');
    sim.Init = true;
    bbs = BlackboardSystem(0);
    bbs.setRobotConnect(sim);
    bbs.buildFromXml('BlackboardQU.xml');
    bbs.run();
    predictedLocations = bbs.blackboard.getData('perceivedLocations');
    predictedAzimuthQu = evaluateLocalisationResults(predictedLocations, direction);
    sim.ShutDown = true;

    % Localisation using MIT KEMAR HRTFs
    sim = simulator.SimulatorConvexRoom('SceneDescriptionQU.xml');
    sim.Verbose = false;
    sim.Sources{1}.set('Azimuth', direction);
    sim.rotateHead(0, 'absolute');
    sim.Init = true;
    bbs = BlackboardSystem(0);
    bbs.setRobotConnect(sim);
    bbs.buildFromXml('BlackboardMIT.xml');
    bbs.run();
    predictedLocations = bbs.blackboard.getData('perceivedLocations');
    predictedAzimuthMit = evaluateLocalisationResults(predictedLocations, direction);
    sim.ShutDown = true;

    printLocalisationTableColumn(direction, predictedAzimuthQu, predictedAzimuthMit);

end

printLocalisationTableFooter();


end % of main function

function printLocalisationTableHeader()
    fprintf(1, '\n');
    fprintf(1, '------------------------------------------------------------------\n');
    fprintf(1, 'Source direction        Model w QU HRTF       Model w MIT HRTF\n');
    fprintf(1, '------------------------------------------------------------------\n');
end

function printLocalisationTableColumn(direction, azimuth1, azimuth2)
    fprintf(1, '%4.0f \t\t\t %4.0f \t\t\t %4.0f\n', ...
            azimuthInPlusMinus180(direction), ...
            azimuthInPlusMinus180(azimuth1), ...
            azimuthInPlusMinus180(azimuth2));
end

function printLocalisationTableFooter()
    fprintf(1, '------------------------------------------------------------------\n');
end

% vim: set sw=4 ts=4 expandtab textwidth=90 :