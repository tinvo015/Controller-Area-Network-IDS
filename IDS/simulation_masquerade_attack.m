% TODO: Implement this simulation (N=20)
function simulation_masquerade_attack(mode)

if strcmp(mode, 'state-of-the-art')
    % The following code is provided as an example.
    % Simulate the masquerade attack
    data_184 = import_data('../data/184.txt');
    data_3d1 = import_data('../data/3d1.txt');
    
    T_sec = 0.1;
    N = 20;
    
    % Construct a new data-set with the first 1000 batches of data_184,
    % followed by 1000 batches of data_3d1. That is, the masquerade
    % attack occurs at the 1001-st batch.
    data_184 = data_184(1:1000*N) - data_184(1);
    data_3d1 = data_3d1(1:1000*N) - data_3d1(1);
    data = [data_184, data_184(end) + 0.1 + data_3d1];
    
    ids = IDS();
    ids = ids.init(T_sec, N, 'state-of-the-art');
    
    batch_num = 2000;
    for i = 1:batch_num
       batch = data(1+(i-1)*N:i*N);
       ids = ids.update(batch);
    end
    
    % Plot control limits
    figure;
    plot(ids.L_upper_hist, 'DisplayName', 'Upper Control Limit', ...
        'LineWidth', 3, 'Color', 'blue');
    hold on;
    plot(ids.L_lower_hist, 'DisplayName', 'Lower Control Limit', ...
        'LineWidth', 3, 'Color', 'red' );
    
    xlabel('Number of Batches');
    ylabel('Control Limits');
    title('Control Limits for State-of-the-Art IDS');
    legend('show', 'Location', 'northwest');
    
    hold off;
    
elseif strcmp(mode, 'ntp-based')
    % ====================== Start of Your Code =========================
    
    % Your code goes here.
    
    % ====================== End of Your Code =========================
    
else
   error('Error: Unknown IDS mode');  
end