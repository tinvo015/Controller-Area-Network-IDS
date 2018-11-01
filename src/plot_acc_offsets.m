% TODO: Plot accumulated offset curves for both state-of-the-art and NTP-based IDSs.
function plot_acc_offsets(ids, mode)

if strcmp(mode, 'state-of-the-art')
    % ====================== Start of Your Code =========================
    % Example: Plot accumulated offset curve for 0x184. 
    figure();
    plot(ids.sota_184.elapsed_time_sec_hist, ids.sota_184.acc_offset_us_hist, ...
        'DisplayName', '0x184', 'LineWidth', 3, 'Color', 'black');
    xlabel("Elapsed Time (sec)");
    ylabel("Accumulated Offset (us)");
    title("Accumlated Offset Curve for State-of-the-Art IDS");
    hold on;
    plot(ids.sota_180.elapsed_time_sec_hist, ids.sota_180.acc_offset_us_hist, ...
        'DisplayName', '0x180', 'LineWidth', 3, 'Color', 'green');
    plot(ids.sota_3d1.elapsed_time_sec_hist, ids.sota_3d1.acc_offset_us_hist, ...
       'DisplayName', '0x3d1', 'LineWidth', 3, 'Color', 'blue');
    legend("0x184","0x180","0x3d1",'Location','northwest');
    hold off;
    
    % ====================== End of Your Code =========================
    
elseif strcmp(mode, 'ntp-based')
    % ====================== Start of Your Code =========================
    % Your code goes here.
    figure();
    plot(ids.ntp_184.elapsed_time_sec_hist, ids.ntp_184.acc_offset_us_hist, ...
                'DisplayName', '0x184', 'LineWidth', 3, 'Color', 'black');
    hold on;
    plot(ids.ntp_180.elapsed_time_sec_hist, ids.ntp_180.acc_offset_us_hist, ...
                'DisplayName', '0x180', 'LineWidth', 3, 'Color', 'green');
    plot(ids.ntp_3d1.elapsed_time_sec_hist, ids.ntp_3d1.acc_offset_us_hist, ...
               'DisplayName', '0x3d1', 'LineWidth', 3, 'Color', 'blue');
    xlabel("Elapsed Time (sec)");
    ylabel("Accumulated Offset (us)");
    title("Accumlated Offset Curve for NTP-Based IDS");
    legend("0x184","0x180","0x3d1",'Location','southwest');
    hold off;
    
    % ====================== End of Your Code =========================
    
else
    error('Error: Unknown IDS mode');
end