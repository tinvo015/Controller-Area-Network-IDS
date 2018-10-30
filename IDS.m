classdef IDS
    properties
        mode = ''; % 'state-of-the-art' or 'ntp-based'
        
        k = 0;  % Current batch
        N = 0;  % Batch size
        T_sec = 0.0;    % Nominal period in sec
        
        mu_T_sec = 0;           % Average inter-arrival time in the current batch (sec)
        batch_end_time_sec = 0; % End time of every batch (sec)
        init_time_sec = 0;      % Arrival time of the 1st message in the 2nd batch (sec)
        elapsed_time_sec = 0;   % Elapsed time since the 1st message in the 2nd batch (sec)

        acc_offset_us = 0;  % Most recent accumulated offset (us)
        avg_offset_us = 0;  % Most recent average offset (us)
        skew = 0;           % Most recent estimated skew (ppm)
        P = 1;              % Parameter used in RLS

        mu_T_sec_hist = [];
        batch_end_time_sec_hist = [];
        elapsed_time_sec_hist = [];
        acc_offset_us_hist = [];
        avg_offset_us_hist = [];
        skew_hist = [];
        error_hist = [];
        
        % CUSUM
        is_detected = 0;

        n_init = 50;  % Number of error samples for initializing mu_e and sigma_e
        k_CUSUM_start = 51;  % CUSUM starts after mu and sigma are initialized

        Gamma = 5;  % Control limit threshold
        gamma = 4;  % Update threshold
        kappa = 8;  % Sensitivity parameter in CUSUM

        L_upper = 0;  % Most recent upper control limit
        L_lower = 0;  % Most recent upper control limit
        e_ref = [];   % Reference (un-normalized) error samples; used to compute mu_e and sigma_e

        L_upper_hist = [];
        L_lower_hist = [];
    end
    
    methods
        % Initialize an IDS
        function obj = init(obj, T_sec, N, mode)
            if ~(strcmp(mode, 'state-of-the-art') || strcmp(mode, 'ntp-based'))
                error('Error: Unknown IDS mode');
            end
            
            obj.T_sec = T_sec;
            obj.N = N;
            obj.mode = mode;
        end
        
        % `a` is a 1-by-N vector that contains arrival timestamps of the latest batch.
        function obj = update(obj, a)
            if length(a) ~= obj.N
                error('Error: Inconsistent batch size')
            end
            
            obj.k = obj.k+1;
            obj.batch_end_time_sec_hist = [obj.batch_end_time_sec_hist, a(end)];
            
            if obj.k == 1   % Initialize something in the first batch
                if strcmp(obj.mode, 'state-of-the-art')
                    obj.mu_T_sec = mean(a(2:end) - a(1:end-1));
                end
                return;
            end
            
            % CIDS officially starts from the second batch
            if obj.k == 2
                obj.init_time_sec = a(1);
            end
            
            if obj.k >= 2
                [obj, curr_avg_offset_us, curr_acc_offset_us] = obj.estimate_offset(a);
                [obj, curr_error_sample] = obj.update_clock_skew(curr_avg_offset_us, curr_acc_offset_us);
                obj = obj.update_cusum(curr_error_sample);
            end
        end
        
        function [obj, curr_avg_offset_us, curr_acc_offset_us] = estimate_offset(obj, a)
            obj.elapsed_time_sec = a(end) - obj.init_time_sec;
            obj.elapsed_time_sec_hist = [obj.elapsed_time_sec_hist, obj.elapsed_time_sec];
            
            prev_mu_T_sec = obj.mu_T_sec;   % You will use it later.
            obj.mu_T_sec = mean(a(2:end) - a(1:end-1));
            obj.mu_T_sec_hist = [obj.mu_T_sec_hist, obj.mu_T_sec];
            
            prev_acc_offset_us = obj.acc_offset_us;  % You will use it later.
            a0 = obj.batch_end_time_sec_hist(end-1); % Arrival timestamp of the last message in the previous batch
                                                     % You will use it later.
            
            curr_avg_offset_us = 0;
            curr_acc_offset_us = 0;
            
            if strcmp(obj.mode, 'state-of-the-art')
                % ====================== Start of Your Code =========================
                % TODO: Compute curr_avg_offset_us and curr_acc_offset_us for state-of-the-art IDS.
                
                % Your code goes here.
                
                % ====================== End of Your Code =========================
                
            elseif strcmp(obj.mode, 'ntp-based')
                % ====================== Start of Your Code =========================
                % TODO: Compute curr_avg_offset_us and curr_acc_offset_us for NTP-based IDS.
                
                % Your code goes here.
                
                % ====================== End of Your Code =========================
            end
        end
        
        function [obj, curr_error] = update_clock_skew(obj, curr_avg_offset_us, curr_acc_offset_us)
           prev_skew = obj.skew; 
           prev_P = obj.P;
           
           % Compute identification error
           time_elapsed_sec = obj.elapsed_time_sec;
           curr_error = curr_acc_offset_us - prev_skew*time_elapsed_sec;
           
           % ====================== Start of Your Code =========================
           % RLS algorithm
           % Inputs:
           %   t[k] -> time_elapsed_sec
           %   P[k-1] -> prev_P
           %   S[k-1] -> prev_skew
           %   e[k] -> curr_error
           %   lambda -> lambda
           %
           % Outputs:
           %   P[k] -> curr_P
           %   S[k] -> curr_skew
           
           % TODO: Implement the RLS algorithm
           
           % Your code goes here.
           
           % ====================== End of Your Code =========================
           
           % Update the state of IDS
           obj.avg_offset_us = curr_avg_offset_us;
           obj.acc_offset_us = curr_acc_offset_us;
           obj.skew = curr_skew;
           obj.P = curr_P;
           
           obj.avg_offset_us_hist = [obj.avg_offset_us_hist, curr_avg_offset_us];
           obj.acc_offset_us_hist = [obj.acc_offset_us_hist, curr_acc_offset_us];
           obj.skew_hist = [obj.skew_hist, curr_skew];
           obj.error_hist = [obj.error_hist, curr_error];
        end
        
        function obj = update_cusum(obj, curr_error_sample)
            if obj.k <= obj.k_CUSUM_start
                obj.e_ref = [obj.e_ref, curr_error_sample];
                return;
            end
            
            prev_L_upper = obj.L_upper;
            prev_L_lower = obj.L_lower;
            
            % Compute mu_e and sigma_e
            mu_e = mean(obj.e_ref);
            sigma_e = std(obj.e_ref);
            
            % ====================== Start of Your Code =========================
            % TODO: 1) Normalize curr_error_sample, 2) compute curr_L_upper and curr_L_lower
            % - Store the normalized error in `normalized_error`
            % - Use obj.kappa as the kappa value
            
            % Your code goes here.
            
            % ====================== End of Your Code =========================
            
            if max(curr_L_upper, curr_L_lower) > obj.Gamma
                obj.is_detected = true;
            end
            
            % Store valid (un-normalized) error sample
            if abs(normalized_error) < obj.gamma
               obj.e_ref = [obj.e_ref, curr_error_sample]; 
            end
            
            % Update the state of CUSUM
            obj.L_upper = curr_L_upper;
            obj.L_lower = curr_L_lower;
            
            obj.L_upper_hist = [obj.L_upper_hist, curr_L_upper];
            obj.L_lower_hist = [obj.L_lower_hist, curr_L_lower];
        end
    end
    
end