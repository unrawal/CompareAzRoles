param(
    [string]$roleName1,
    [string]$roleName2
)

# Function to select a role from a list
function Select-Role {
    param([string[]]$RoleNames)
    
    for ($i = 0; $i -lt $RoleNames.Length; $i++) {
        Write-Host "$($i + 1): $($RoleNames[$i])"
    }

    $choice = Read-Host "Select a role by number"
    while ($choice -notmatch '^\d+$' -or [int]$choice -le 0 -or [int]$choice -gt $RoleNames.Length) {
        $choice = Read-Host "Invalid selection, please select a role by number"
    }

    return $RoleNames[[int]$choice - 1]
}

# List of roles (replace with the actual roles available)
$availableRoles = @('Reader', 'Contributor', 'Owner', 'User Access Administrator', 'Deloitte Custom Role Administrator', 'Deloitte Custom Contributor')

# Let the user select the roles
$selectedRole1 = Select-Role -RoleNames $availableRoles
$selectedRole2 = Select-Role -RoleNames $availableRoles

# Now you have $selectedRole1 and $selectedRole2 to use in your role comparison logic
Write-Host "Comparing roles: $selectedRole1 and $selectedRole2"

# Here, you would call your role comparison logic...
