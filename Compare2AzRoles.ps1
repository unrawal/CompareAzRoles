param(
    [string]$roleName1,
    [string]$roleName2
)

# Make sure you're connected to Azure
Connect-AzAccount

# Fetch role definitions from Azure using the provided role names
$role1 = Get-AzRoleDefinition $roleName1
$role2 = Get-AzRoleDefinition $roleName2

# Extract the permissions (actions) from each role
$role1Perms = $role1.Actions
$role2Perms = $role2.Actions

# Create an empty array to hold the output data
$output = @()

# Combine all permissions in a set to eliminate duplicates
$allPermissions = $role1Perms + $role2Perms | Sort-Object -Unique

# Generate the output data with permissions and role mappings
foreach ($perm in $allPermissions) {
    # Create an ordered dictionary to ensure the order of columns
    $rolePermissionMapping = [ordered]@{
        Permission = $perm
    }
    
    # Dynamically adding role names and their permissions to the dictionary
    $rolePermissionMapping[$roleName1] = $(if ($role1Perms -contains $perm) { "✔" } else { "" })
    $rolePermissionMapping[$roleName2] = $(if ($role2Perms -contains $perm) { "✔" } else { "" })
    
    # Add the dictionary as a new object to the output array
    $output += New-Object -TypeName PSCustomObject -Property $rolePermissionMapping
}

# Output the data in a table format
$output | Format-Table -Property Permission, $roleName1, $roleName2 -AutoSize
