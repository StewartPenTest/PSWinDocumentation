function Start-Documentation {
    [CmdletBinding()]
    param (
        [System.Object] $Document
    )
    Test-ModuleAvailability
    Test-ForestConnectivity
    Test-Configuration -Document $Document

    if ($Document.DocumentAD.Enable) {
        $Forest = Get-WinADForestInformation

        ### Starting WORD
        $WordDocument = Get-DocumentPath -Document $Document -FinalDocumentLocation $Document.DocumentAD.FilePathWord

        ### Start Sections
        $ADSectionsForest = Get-ObjectKeys -Object $Document.DocumentAD.Sections.SectionForest
        foreach ($Section in $ADSectionsForest) {
            Write-Verbose "Generating WORD Section for [$Section]"
            $WordDocument = $WordDocument | New-ADDocumentBlock -Section $Document.DocumentAD.Sections.SectionForest.$Section -Forest $Forest
        }
        foreach ($Domain in $Forest.Domains) {
            $ADSectionsDomain = Get-ObjectKeys -Object $Document.DocumentAD.Sections.SectionDomain
            foreach ($Section in $ADSectionsDomain) {
                Write-Verbose "Generating WORD Section for [$Domain - $Section]"
                $WordDocument = $WordDocument | New-ADDocumentBlock -Section $Document.DocumentAD.Sections.SectionDomain.$Section -Forest $Forest -Domain $Domain
            }
        }
        ### End Sections

        ### Ending WORD
        $FilePath = Save-WordDocument -WordDocument $WordDocument `
            -Language $Document.Configuration.Prettify.Language `
            -FilePath $Document.DocumentAD.FilePathWord `
            -Supress $True `
            -OpenDocument:$Document.Configuration.Options.OpenDocument
    }
    return

    Write-Verbose 'Start-ActiveDirectoryDocumentation - Working...2'
    foreach ($Domain in $ForestInformation.Domains) {
        $WordDocument | Add-WordPageBreak -Supress $True
        Write-Verbose 'Start-ActiveDirectoryDocumentation - Getting domain information'
        $DomainInformation = Get-WinADDomainInformation -Domain $Domain

        $SectionDomainSummary = $WordDocument | Add-WordTocItem -Text "General Information - Domain $Domain" -ListLevel 0 -ListItemType Numbered -HeadingType Heading1
        ### Section - Domain Summary
        $SectionDomainSummary = $WordDocument | Add-WordTocItem -Text "General Information - Domain Summary" -ListLevel 1 -ListItemType Numbered -HeadingType Heading2
        $SectionDomainSummary = $WordDocument | Get-DomainSummary -Paragraph $SectionDomainSummary -ActiveDirectorySnapshot $DomainInformation.ADSnapshot -Domain $Domain


        if ($FilePathExcel) {
            $ForestInformation.ForestInformation | Export-Excel -AutoSize -Path $FilePathExcel -AutoFilter -Verbose -WorkSheetname 'Forest Information' -ClearSheet -FreezeTopRow
            $ForestInformation.FSMO | Export-Excel -AutoSize -Path $FilePathExcel -AutoFilter -WorkSheetname 'Forest FSMO' -FreezeTopRow
            foreach ($Domain in $ForestInformation.Domains) {
                $DomainInformation = Get-WinADDomainInformation -Domain $Domain
                $DomainInformation.DomainControllers  | Export-Excel -AutoSize -Path $FilePathExcel -AutoFilter -WorkSheetname "$Domain DCs" -ClearSheet -FreezeTopRow
                $DomainInformation.GroupPoliciesDetails | Export-Excel -AutoSize -Path $FilePathExcel -AutoFilter -WorksheetName "$Domain GPOs Details" -ClearSheet -FreezeTopRow -NoNumberConversion SSDL, GUID, ID, ACLs
                $DomainInformation.GroupPoliciesDetails | fl *
            }

        }
    }
}