$newPath = 'C:\dev\bin'
$oldPath = [Environment]::GetEnvironmentVariable('path', 'machine');
[Environment]::SetEnvironmentVariable('path', "$($newPath);$($oldPath)",'Machine');