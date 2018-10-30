function data = import_data(filename)
formatSpec = '%f%[^\n\r]';
fileID = fopen(filename,'r');
dataArray = textscan(fileID, formatSpec, 'Delimiter', '', 'EmptyValue' ,NaN, 'ReturnOnError', false);
fclose(fileID);
data = dataArray{:, 1};