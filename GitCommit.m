%This script is to run during your code that will commit and push all
%changes to current branch in Github

function GitCommit(message)
%CHECKS
    % Check if Git is installed
    [status, ~] = system('git --version');
    if status ~= 0
        error('Git is not installed or not in the system path.');
    end
    % Check if .git directory exists
    if ~exist('.git', 'dir')
        disp('Local Git repository does not exist.');
    end
    % Get user email associated with Git
    [status, ~] = system('git config user.email');
    if status ~= 0
        disp('No email is associated with Git');
    end
%=========================================================================%    
    %If all checks pass:
    system('git add .'); % Add all files to the Git repository
    
    command = (['git commit -m ' message]); % Commit the changes
    system(command); 
    
    system('git push -u origin HEAD'); % Push the committed changes to the 'master' branch
end