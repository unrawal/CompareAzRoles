param(
    [string]$roleName1,
    [string]$roleName2
)

# Make sure you're connected to Azure
Connect-AzAccount

# Fetch role definitions from Azure using the provided role names
$role1 = Get-AzRoleDefinition $roleName1
$role2 = Get-AzRoleDefinition $roleName2

# Function to generate table for a given set of permissions
function Generate-PermissionTable {
    param(
        [string[]]$role1Perms,
        [string[]]$role2Perms,
        [string]$permissionType
    )

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
    Write-Host ("`n$permissionType Permissions:")
    $output | Format-Table -Property Permission, $roleName1, $roleName2 -AutoSize
}

# Generate tables for Actions
Generate-PermissionTable $role1.Actions $role2.Actions "Action"

# Generate tables for NotActions
Generate-PermissionTable $role1.NotActions $role2.NotActions "NotAction"

# Generate tables for DataActions
Generate-PermissionTable $role1.DataActions $role2.DataActions "DataAction"

# Generate tables for NotDataActions
Generate-PermissionTable $role1.NotDataActions $role2.NotDataActions "NotDataAction"
