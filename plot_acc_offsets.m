% TODO: Plot accumulated offset curves for both state-of-the-art and NTP-based IDSs.
function plot_acc_offsets(ids, mode)

if strcmp(mode, 'state-of-the-art')
    % ====================== Start of Your Code =========================
    % Example: Plot accumulated offset curve for 0x184. 
    %       plot(ids.sota_184.elapsed_time_sec_hist, ids.sota_184.acc_offset_us_hist, ...
    %            'DisplayName', '0x184', 'LineWidth', 3, 'Color', 'black');
    
    % Your code goes here. 
    
    % ====================== End of Your Code =========================
    
elseif strcmp(mode, 'ntp-based')
    % ====================== Start of Your Code =========================
    
    % Your code goes here.
    
    % ====================== End of Your Code =========================
    
else
    error('Error: Unknown IDS mode');
end