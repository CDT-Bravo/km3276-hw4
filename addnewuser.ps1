Import-Module ActiveDirectory

# Define the path to the CSV file
$csvPath = "C:\Path\To\Users.csv"

# Import the CSV file
$users = Import-Csv -Path $csvPath

# Loop through each user in the CSV file
foreach ($user in $users) {
    try {
        # Define user parameters
        $username = $user.Username
        $password = ConvertTo-SecureString $user.Password -AsPlainText -Force
        $ou = $user.OU  # Organizational Unit where the user will be created
        $givenName = $user.FirstName
        $surname = $user.LastName
        $displayName = "$givenName $surname"
        $email = $user.Email
        $userPrincipalName = "$username@yourdomain.com"  # Modify domain accordingly
        
        # Create the new AD user
        New-ADUser -SamAccountName $username -UserPrincipalName $userPrincipalName -GivenName $givenName -Surname $surname -Name $displayName -EmailAddress $email -Path $ou -AccountPassword $password -Enabled $true -PassThru
        
        # Add the user to the "Domain Users" group
        Add-ADGroupMember -Identity "Domain Users" -Members $username
        
        Write-Host "Successfully created user: $username and added to Domain Users group" -ForegroundColor Green
    } catch {
        Write-Host "Failed to create user: $username. Error: $_" -ForegroundColor Red
    }
}
