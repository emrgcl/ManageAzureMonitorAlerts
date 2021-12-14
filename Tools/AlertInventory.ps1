$TenantInfo = @{

    'your-tenant-id1' = @('Tenant1-subscription-id1','Tenant1-subscription-id2','Tenant1-subscription-id3')
    'your-tenant-id2' = @('Tenant2-subscription-id1','Tenant2-subscription-id2')

}
$FilePath = 'C:\temp\Alerts.csv'
$AlertInfo = @()
$Severityhash = @{

    0 = 'Critical'
    1 = 'Error'
    2 = 'Warning'
    3 = 'Informational'
    4 = 'Verbose'

}

Foreach ($TenantID in $TenantInfo.Keys) {
    Connect-AzAccount -TenantID $TenantID | Out-Null
    $Tenant = Get-AzTenant -TenantId $TenantID
    Foreach ($subscriptionID in $TenantInfo.$TenantID ) {
    $Subscription = Get-AzSubscription -SubscriptionId $SubscriptionID
    Set-AzContext -SubscriptionObject $Subscription | Out-Null
    $MetricAlerts = Get-AzMetricAlertRuleV2
        Foreach ($MetricAlert in $MetricAlerts) {

        $AlertInfo+=[PscustomObject]@{
        Name = $MetricAlert.Name
        ActionGroups = @(($MetricAlert.Actions.ActionGroupID -split '/')[-1])
        ResourceGroup  = ($MetricAlert.Id -split '/')[4]
        Subscription = $Subscription.Name
        Tenant = $Tenant.Name
        Severity = $Severityhash.($MetricAlert.Severity)
        }
        }

    }
}

# please change the delimeter to except sth that is used in the csv itself. Forexample if delimeter in csv is ',' use ';' as the delimeter below.
$ConvertActionGroupToStr = @{

Name = 'ActionGroup'
Expression = {$_.ActionGroups -join ';'}

}
$AlertInfo | Select-object Name,Severity,ResourceGroup,Subscription,Tenant,$ConvertActionGroupToStr | Export-Csv -Path $FilePath -NoTypeInformation
