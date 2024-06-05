% This script commits and pushes all changes to the current branch in a GitHub repository.

function GitCommit(message)
% CHECKS
[status1, cmdout1] = system('git --version');         % Check if Git is installed
status2 = ~exist('.git', 'dir');                      % Check if .git directory exists to confirm it's a Git repository
[status3, cmdout3] = system('git config user.email'); % Get user email associated with Git to confirm configuration

if status1 ~= 0 || status2 ~= 0 || status3 ~= 0
    if status1 ~= 0
        disp(cmdout1);
    elseif status2 ~= 0
        disp('.git directory does not exist.');
    elseif status3 ~= 0
        disp(cmdout3);
    end
end
%=========================================================================% 
    % If all checks pass:
    system('git pull') %pull any recent changes from online
    system('git add .'); % Add all files to the staging area for commit
    
    % Construct the Git commit command with the provided message
    command = ['git commit -m "' message '"']; 
    system(command); % Execute the commit command
    
    % Get the name of the current branch
    [~, currBranch] = system('git rev-parse --abbrev-ref HEAD');
    currBranch = strtrim(currBranch); % Remove any leading/trailing whitespace
    
    % Ask the user if they want to push changes to the current branch
    pushCurrBranch = input(['Do you want to push changes to the current branch: ', currBranch, '? (Y/N): '], 's');
    if strcmpi(pushCurrBranch, 'Y')
        % Push the committed changes to the current branch on the remote repository
        system('git push -u origin HEAD'); 
        disp(['Changes pushed to branch ', currBranch]);
    else
        % List all available branches
        [~, branchOutput] = system('git branch');
        branches = textscan(branchOutput, '%s', 'Delimiter', '\n');
        branches = branches{1};
        
        % Display branches with associated index numbers
        disp('Available branches:');
        for i = 1:numel(branches)
            disp([num2str(i), ': ', branches{i}]);
        end
        
        % Ask the user if they want to push changes to any other available branch
        pushOtherBranch = input('Do you want to push changes to any other available branch? (Y/N): ', 's');
        if strcmpi(pushOtherBranch, 'Y')
            % Prompt the user to select a branch by index number
            branchIndex = input('Enter the index number of the branch to push changes to: ');
            
            % Validate the input
            if isscalar(branchIndex) && branchIndex >= 1 && branchIndex <= numel(branches)
                branchName = branches{branchIndex};
                % Switch to the selected branch
                system(['git checkout ', branchName]);
                % Push changes to the selected branch on the remote repository
                system(['git push -u origin ', branchName]);
                disp(['Changes pushed to branch ', branchName]);
            else
                disp('Invalid branch index.');
            end
        else
            disp('No changes were pushed.');
        end
    end
end
