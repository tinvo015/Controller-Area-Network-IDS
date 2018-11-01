clear all;
close all;

%% Import data
data_184 = import_data('../data/184.txt');
data_3d1 = import_data('../data/3d1.txt');
data_180 = import_data('../data/180.txt');

data_184 = data_184 - data_184(1);
data_3d1 = data_3d1 - data_3d1(1);
data_180 = data_180 - data_180(1);

%% If you correctly implement IDS, the code below should run without errors.
T_sec = 0.1;    % period
N = 30;         % batch size. Change N here in Task 4.

% Create IDS for messages 184, 3d1 and 180.
% ids is a structure. 
ids.sota_184 = IDS();
ids.sota_184 = ids.sota_184.init(T_sec, N, 'state-of-the-art');
ids.ntp_184 = IDS();
ids.ntp_184 = ids.ntp_184.init(T_sec, N, 'ntp-based');

ids.sota_3d1 = IDS();
ids.sota_3d1 = ids.sota_3d1.init(T_sec, N, 'state-of-the-art');
ids.ntp_3d1 = IDS();
ids.ntp_3d1 = ids.ntp_3d1.init(T_sec, N, 'ntp-based');

ids.sota_180 = IDS();
ids.sota_180 = ids.sota_180.init(T_sec, N, 'state-of-the-art');
ids.ntp_180 = IDS();
ids.ntp_180 = ids.ntp_180.init(T_sec, N, 'ntp-based');

% Feed batches to IDSs
if N == 20
    batch_num = 6000;
elseif N == 30
    batch_num = 4000;
else
    batch_num = 6000;
end

for i = 1:batch_num
    batch_184 = data_184(1+(i-1)*N : i*N);
    ids.sota_184 = ids.sota_184.update(batch_184);
    ids.ntp_184 = ids.ntp_184.update(batch_184);
    
    batch_3d1 = data_3d1(1+(i-1)*N : i*N);
    ids.sota_3d1 = ids.sota_3d1.update(batch_3d1);
    ids.ntp_3d1 = ids.ntp_3d1.update(batch_3d1);
    
    batch_180 = data_180(1+(i-1)*N : i*N);
    ids.sota_180 = ids.sota_180.update(batch_180);
    ids.ntp_180 = ids.ntp_180.update(batch_180);
end

%% TODO - Complete the following tasks.
% Task 2: Plot accumulated offset curves for 0x184, 0x3d1, and 0x180, for the state-of-the-art IDS.
plot_acc_offsets(ids, 'state-of-the-art');

% Task 3: Plot accumulated offset curves for 0x184, 0x3d1, and 0x180, for the NTP-based IDS.
plot_acc_offsets(ids, 'ntp-based');

% Task 4: Change N to 30, and repeat Tasks 2 and 3.
% plot_acc_offsets(ids, 'state-of-the-art');
% plot_acc_offsets(ids, 'ntp-based');

% Task 5: Simulate the masquerade attack, and plot upper/lower control limits.
simulation_masquerade_attack('state-of-the-art');
simulation_masquerade_attack('ntp-based');

% Task 6: Simulate the cloaking attack, and plot upper/lower control limits.
simulation_cloaking_attack('state-of-the-art');
simulation_cloaking_attack('ntp-based');
