function Get-PackageVersion($package)
{
    if($package -and $package.Version)
    {
        [convert]::ToInt32($package.Version.ToString().Replace("-beta", "").Replace(".", ""), 10)
    }
    else
    {
        return 0;
    }
}

function Get-BuildProject($project)
{
    return [Microsoft.Build.Evaluation.ProjectCollection]::GlobalProjectCollection.GetLoadedProjects($project.FullName) | Select-Object -First 1
}

function Update-References($project, $references)
{
    try
    {
        $hasNewReferences = $false

        $buildProject = Get-BuildProject $project

        foreach ($reference in $references) 
        {
            $item = $buildProject.Items | Where-Object { $_.ItemType -eq "Reference" -and $_.EvaluatedInclude.Split(",")[0] -eq $reference} | Select-Object -First 1
            
            if($item)
            {
                $hintPath = $item.Metadata | Where-Object { $_.Name -eq "HintPath"} | Select-Object -First 1
                if($hintPath)
                {
                    Write-Host "Updating reference $reference"
                    $buildProject.RemoveItem($item)
                    $buildProject.AddItem($item.ItemType, $item.EvaluatedInclude)
                    $hasNewReferences = $true
                }
            }
        }

        if($hasNewReferences)
        {
            Write-Host "Saving updated references"
            $buildProject.Save()
        }
    }
    catch
    {
        Write-Warning "Could not update references $references. Please remove these references manually or contact Sitefinity support."
    }
}

function Remove-References($project, $references)
{
    try
    {
        $hasNewReferences = $false

        $buildProject = Get-BuildProject $project

        foreach ($reference in $references) 
        {
            $item = $buildProject.Items | Where-Object { $_.ItemType -eq "Reference" -and $_.EvaluatedInclude.Split(",")[0] -eq $reference} | Select-Object -First 1
            
            if($item)
            {
                Write-Host "Removing reference $reference"
                $buildProject.RemoveItem($item)
                $hasNewReferences = $true
            }
        }

        if($hasNewReferences)
        {
            Write-Host "Saving updated references"
            $buildProject.Save()
        }
    }
    catch
    {
        Write-Warning "Could not remove references $references. Please remove these references manually or contact Sitefinity support."
    }
}

function Remove-Imports($project, $imports)
{
    try
    {
        $hasNewImports = $false
        $buildProject = Get-BuildProject $project

    
        foreach ($import in $imports) 
        {
            $item = $buildProject.Xml.Imports | Where-Object { $_.Project -eq $import } | Select-Object -First 1
            
            if($item)
            {
                Write-Host "Removing import $import"
                $buildProject.Xml.RemoveChild($item)
                $hasNewImports = $true
            }
        }

        if($hasNewImports)
        {
            Write-Host "Saving updated imports"
            $buildProject.Save()
        }
    }
    catch
    {
        Write-Warning "Could not remove imports $imports. Please remove these imports manually or contact Sitefinity support."
    }
}


# SIG # Begin signature block
# MIIM6wYJKoZIhvcNAQcCoIIM3DCCDNgCAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUrSCKj6bSrLUtkNspQgzLzeJ0
# 7D+gggogMIIEvzCCA6egAwIBAgIQFFmypJwM2SoI+cUDFc09ijANBgkqhkiG9w0B
# AQsFADB/MQswCQYDVQQGEwJVUzEdMBsGA1UEChMUU3ltYW50ZWMgQ29ycG9yYXRp
# b24xHzAdBgNVBAsTFlN5bWFudGVjIFRydXN0IE5ldHdvcmsxMDAuBgNVBAMTJ1N5
# bWFudGVjIENsYXNzIDMgU0hBMjU2IENvZGUgU2lnbmluZyBDQTAeFw0xNjAxMjgw
# MDAwMDBaFw0xNjEyMTYyMzU5NTlaMFcxCzAJBgNVBAYTAkJHMQ4wDAYDVQQIEwVT
# b2ZpYTEOMAwGA1UEBxMFU29maWExEzARBgNVBAoUClRFTEVSSUsgQUQxEzARBgNV
# BAMUClRFTEVSSUsgQUQwggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQC2
# V7n4yEjdJl8jT+u06w7eniMqaLLz72A7LzNvLoBpzD6+igEfIgQaHHeIve3kMKuC
# KojSG9Z0oNjj5ZgoAKHe5lGTu9RkvZFtp48HLO4tDzfMaBZ5TwIjPG5nT1paq3N0
# UarbzpEbIjbVKDjGiHOGcndtRtd+gysX/c1giFiX7/c92InG2NYeTyXpUvhVXE7Q
# Kroyoz6wczMjgzaJuTYZY3YOB3ZcTbmHzrz9BOgP9HlL4eZ4tYnberGcNyVWU7b/
# oFqCFH0uCGkrgqInps4Cl0fvE5Tm3GFtgQYXGfDXrXehMtUBHl1gYvSNg+14oUiH
# Pv3H8d3lE2iTTEbvXOW9AgMBAAGjggFdMIIBWTAJBgNVHRMEAjAAMA4GA1UdDwEB
# /wQEAwIHgDArBgNVHR8EJDAiMCCgHqAchhpodHRwOi8vc3Yuc3ltY2IuY29tL3N2
# LmNybDBhBgNVHSAEWjBYMFYGBmeBDAEEATBMMCMGCCsGAQUFBwIBFhdodHRwczov
# L2Quc3ltY2IuY29tL2NwczAlBggrBgEFBQcCAjAZDBdodHRwczovL2Quc3ltY2Iu
# Y29tL3JwYTATBgNVHSUEDDAKBggrBgEFBQcDAzBXBggrBgEFBQcBAQRLMEkwHwYI
# KwYBBQUHMAGGE2h0dHA6Ly9zdi5zeW1jZC5jb20wJgYIKwYBBQUHMAKGGmh0dHA6
# Ly9zdi5zeW1jYi5jb20vc3YuY3J0MB8GA1UdIwQYMBaAFJY7U/B5M5evfYPvLivM
# yreGHnJmMB0GA1UdDgQWBBR8iw7EhUnHTJJZK80l1viQALjq4zANBgkqhkiG9w0B
# AQsFAAOCAQEAB59WNzrfmV8qMZuF0E1idLvXGnbaR3wUoWL1i6K+Nv1eA3aGsPT+
# Xt0UOivJiQRgWpguLyGlntGp4IO/hfKEUDLeLQRrt6qrFGW2T+JnDV0OMrZwnXIK
# GSvoSxdMdnZs1T3bV/gALT86dFTKXvF+6RWCn0yCVzMnvXFpAp2MYoh0JaQI/cvj
# tW1CHKjbtfoYKHcBkjmDe//arKjwSzr2VZSJ7brlKtYwt2hv2n3fEd25uBOJ7PGt
# LnlLs1AwaVNST8zxtiGtjoJnew94zd4jzpxtOugA3fNVXuK7/JTMgSydHPTtALEd
# hq2LL9Dx2zyFAMk+R0vuB7BkbFP8W84ayjCCBVkwggRBoAMCAQICED141/l2SWCy
# YX308B7KhiowDQYJKoZIhvcNAQELBQAwgcoxCzAJBgNVBAYTAlVTMRcwFQYDVQQK
# Ew5WZXJpU2lnbiwgSW5jLjEfMB0GA1UECxMWVmVyaVNpZ24gVHJ1c3QgTmV0d29y
# azE6MDgGA1UECxMxKGMpIDIwMDYgVmVyaVNpZ24sIEluYy4gLSBGb3IgYXV0aG9y
# aXplZCB1c2Ugb25seTFFMEMGA1UEAxM8VmVyaVNpZ24gQ2xhc3MgMyBQdWJsaWMg
# UHJpbWFyeSBDZXJ0aWZpY2F0aW9uIEF1dGhvcml0eSAtIEc1MB4XDTEzMTIxMDAw
# MDAwMFoXDTIzMTIwOTIzNTk1OVowfzELMAkGA1UEBhMCVVMxHTAbBgNVBAoTFFN5
# bWFudGVjIENvcnBvcmF0aW9uMR8wHQYDVQQLExZTeW1hbnRlYyBUcnVzdCBOZXR3
# b3JrMTAwLgYDVQQDEydTeW1hbnRlYyBDbGFzcyAzIFNIQTI1NiBDb2RlIFNpZ25p
# bmcgQ0EwggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQCXgx4AFq8ssdII
# xNdok1FgHnH24ke021hNI2JqtL9aG1H3ow0Yd2i72DarLyFQ2p7z518nTgvCl8gJ
# cJOp2lwNTqQNkaC07BTOkXJULs6j20TpUhs/QTzKSuSqwOg5q1PMIdDMz3+b5sLM
# WGqCFe49Ns8cxZcHJI7xe74xLT1u3LWZQp9LYZVfHHDuF33bi+VhiXjHaBuvEXga
# mK7EVUdT2bMy1qEORkDFl5KK0VOnmVuFNVfT6pNiYSAKxzB3JBFNYoO2untogjHu
# Zcrf+dWNsjXcjCtvanJcYISc8gyUXsBWUgBIzNP4pX3eL9cT5DiohNVGuBOGwhud
# 6lo43ZvbAgMBAAGjggGDMIIBfzAvBggrBgEFBQcBAQQjMCEwHwYIKwYBBQUHMAGG
# E2h0dHA6Ly9zMi5zeW1jYi5jb20wEgYDVR0TAQH/BAgwBgEB/wIBADBsBgNVHSAE
# ZTBjMGEGC2CGSAGG+EUBBxcDMFIwJgYIKwYBBQUHAgEWGmh0dHA6Ly93d3cuc3lt
# YXV0aC5jb20vY3BzMCgGCCsGAQUFBwICMBwaGmh0dHA6Ly93d3cuc3ltYXV0aC5j
# b20vcnBhMDAGA1UdHwQpMCcwJaAjoCGGH2h0dHA6Ly9zMS5zeW1jYi5jb20vcGNh
# My1nNS5jcmwwHQYDVR0lBBYwFAYIKwYBBQUHAwIGCCsGAQUFBwMDMA4GA1UdDwEB
# /wQEAwIBBjApBgNVHREEIjAgpB4wHDEaMBgGA1UEAxMRU3ltYW50ZWNQS0ktMS01
# NjcwHQYDVR0OBBYEFJY7U/B5M5evfYPvLivMyreGHnJmMB8GA1UdIwQYMBaAFH/T
# ZafC3ey78DAJ80M5+gKvMzEzMA0GCSqGSIb3DQEBCwUAA4IBAQAThRoeaak396C9
# pK9+HWFT/p2MXgymdR54FyPd/ewaA1U5+3GVx2Vap44w0kRaYdtwb9ohBcIuc7pJ
# 8dGT/l3JzV4D4ImeP3Qe1/c4i6nWz7s1LzNYqJJW0chNO4LmeYQW/CiwsUfzHaI+
# 7ofZpn+kVqU/rYQuKd58vKiqoz0EAeq6k6IOUCIpF0yH5DoRX9akJYmbBWsvtMkB
# TCd7C6wZBSKgYBU/2sn7TUyP+3Jnd/0nlMe6NQ6ISf6N/SivShK9DbOXBd5EDBX6
# NisD3MFQAfGhEV0U5eK9J0tUviuEXg+mw3QFCu+Xw4kisR93873NQ9TxTKk/tYuE
# r2Ty0BQhMYICNTCCAjECAQEwgZMwfzELMAkGA1UEBhMCVVMxHTAbBgNVBAoTFFN5
# bWFudGVjIENvcnBvcmF0aW9uMR8wHQYDVQQLExZTeW1hbnRlYyBUcnVzdCBOZXR3
# b3JrMTAwLgYDVQQDEydTeW1hbnRlYyBDbGFzcyAzIFNIQTI1NiBDb2RlIFNpZ25p
# bmcgQ0ECEBRZsqScDNkqCPnFAxXNPYowCQYFKw4DAhoFAKB4MBgGCisGAQQBgjcC
# AQwxCjAIoAKAAKECgAAwGQYJKoZIhvcNAQkDMQwGCisGAQQBgjcCAQQwHAYKKwYB
# BAGCNwIBCzEOMAwGCisGAQQBgjcCARUwIwYJKoZIhvcNAQkEMRYEFK31FYx2EKMD
# lPkFC5fq2XgsSUjVMA0GCSqGSIb3DQEBAQUABIIBAJzgjy9FHiM5ZsC6e8WgecH/
# bGBM6o5jOkXJetDcJ8OdO7ENGwJtiKszTkSqn44ZdAIVqyozc7vU5CqMJvNRdeef
# Xmcrt+vbN1nEhTjUSIrr2hLcOzeohO3jOPf4bfqHOapYet0PdFTBhFgqtWwvXgq8
# 9Xs8Pyxvfixq94xWYkYW5Bc8ELcjzID3OYz9DMVo7E3DhUuNTNAcUljgUf2e2dlI
# cKKobW0Wl4W5mUgRE9amBlczqp9VjcRzkGZnpR4kLdy0xOoT+6iuoGoFRUpGASzb
# 2TvE6EXpaOHMTAbT5acBPEKIqTTqCCjO2NzZMR2obObSwK/58ohPQRziviRrvy4=
# SIG # End signature block
