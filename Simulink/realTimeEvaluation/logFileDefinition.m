function logFileDefinition(startingTime,endingTime,ID,currentLink)
    simulationStepTime=0;
    simulationStepTime=evalin('base','simulationStepTime');
    fid = fopen('logFile.txt', 'a'); 
    if fid == -1
      error('Cannot open log file.');
    end
    fprintf(fid, 'ID:%s Link:%.0f - Ending Time:%.2f sec - Starting Time:%.2f sec --->Queueing time:%.2f sec\n',ID,currentLink,endingTime*simulationStepTime,startingTime*simulationStepTime,(endingTime-startingTime)*simulationStepTime);
    fprintf(fid, '                In time instants: - Ending Time:%.0f steps - Starting Time:%.0f steps \n',endingTime,startingTime);
    fclose(fid);
end