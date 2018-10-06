Import-Module PSWriteWord
Import-Module PSWriteExcel
Import-Module PSWinDocumentation -Force
Import-Module PSWriteColor
Import-Module PSSharedGoods
Import-Module DbaTools
Import-Module ActiveDirectory
Import-Module AWSPowerShell

$Document = [ordered]@{
    Configuration = [ordered] @{
        Prettify       = @{
            CompanyName        = 'Evotec'
            UseBuiltinTemplate = $true
            CustomTemplatePath = ''
            Language           = 'en-US'
        }
        Options        = @{
            OpenDocument = $true
            OpenExcel    = $true
        }
        DisplayConsole = @{
            ShowTime   = $false
            LogFile    = "$ENV:TEMP\PSWinDocumentationADTesting.log"
            TimeFormat = 'yyyy-MM-dd HH:mm:ss'
        }
        Debug          = @{
            Verbose = $false
        }
    }
    DocumentAD    = [ordered] @{
        Enable        = $true
        ExportWord    = $true
        ExportExcel   = $true
        ExportSql     = $false
        FilePathWord  = "$Env:USERPROFILE\Desktop\PSWinDocumentation-ADReportWithPasswords.docx"
        FilePathExcel = "$Env:USERPROFILE\Desktop\PSWinDocumentation-ADReportWithPasswords.xlsx"
        Configuration = [ordered] @{
            PasswordTests = @{
                Use                       = $true
                PasswordFilePathClearText = 'C:\Users\pklys\OneDrive - Evotec\Support\GitHub\PSWinDocumentation\Ignore\Passwords.txt'
                # Fair warning it will take ages if you use HaveIBeenPwned DB :-)
                UseHashDB                 = $false
                PasswordFilePathHash      = 'C:\Users\pklys\Downloads\pwned-passwords-ntlm-ordered-by-count\pwned-passwords-ntlm-ordered-by-count.txt'
            }
        }
        Sections      = [ordered] @{
            SectionForest = [ordered] @{
                SectionTOC                    = [ordered] @{
                    Use                  = $true
                    TocGlobalDefinition  = $true
                    TocGlobalTitle       = 'Table of content'
                    TocGlobalRightTabPos = 15
                    #TocGlobalSwitches    = 'A', 'C' #[TableContentSwitches]::C, [TableContentSwitches]::A
                    PageBreaksAfter      = 1
                }
                SectionForestIntroduction     = [ordered] @{
                    ### Enables section
                    Use             = $true

                    ### Decides how TOC should be visible
                    TocEnable       = $True
                    TocText         = 'Scope'
                    TocListLevel    = 0
                    TocListItemType = [ListItemType]::Numbered
                    TocHeadingType  = [HeadingType]::Heading1

                    ### Text is added before table/list
                    Text            = "This document provides a low-level design of roles and permissions for" `
                        + " the IT infrastructure team at <CompanyName> organization. This document utilizes knowledge from" `
                        + " AD General Concept document that should be delivered with this document. Having all the information" `
                        + " described in attached document one can start designing Active Directory with those principles in mind." `
                        + " It's important to know while best practices that were described are important in decision making they" `
                        + " should not be treated as final and only solution. Most important aspect is to make sure company has full" `
                        + " usability of Active Directory and is happy with how it works. Making things harder just for the sake of" `
                        + " implementation of best practices isn't always the best way to go."
                    TextAlignment   = [Alignment]::Both
                    PageBreaksAfter = 1

                }
                SectionForestSummary          = [ordered] @{
                    Use             = $true
                    TocEnable       = $True
                    TocText         = 'General Information - Forest Summary'
                    TocListLevel    = 0
                    TocListItemType = [ListItemType]::Numbered
                    TocHeadingType  = [HeadingType]::Heading1
                    TableData       = [ActiveDirectory]::ForestInformation
                    TableDesign     = [TableDesign]::ColorfulGridAccent5
                    TableTitleMerge = $true
                    TableTitleText  = "Forest Summary"
                    Text            = "Active Directory at <CompanyName> has a forest name <ForestName>." `
                        + " Following table contains forest summary with important information:"
                    ExcelExport     = $true
                    ExcelWorkSheet  = 'Forest Summary'
                    ExcelData       = [ActiveDirectory]::ForestInformation
                }
                SectionForestFSMO             = [ordered] @{
                    Use                   = $true
                    TableData             = [ActiveDirectory]::ForestFSMO
                    TableDesign           = 'ColorfulGridAccent5'
                    TableTitleMerge       = $true
                    TableTitleText        = 'FSMO Roles'
                    Text                  = 'Following table contains FSMO servers'
                    EmptyParagraphsBefore = 1
                    ExcelExport           = $true
                    ExcelWorkSheet        = 'Forest FSMO'
                    ExcelData             = [ActiveDirectory]::ForestFSMO
                }
                SectionForestOptionalFeatures = [ordered] @{
                    Use                   = $true
                    TableData             = [ActiveDirectory]::ForestOptionalFeatures
                    TableDesign           = [TableDesign]::ColorfulGridAccent5
                    TableTitleMerge       = $true
                    TableTitleText        = 'Optional Features'
                    Text                  = 'Following table contains optional forest features'
                    TextNoData            = "Following section should have table containing forest features. However no data was provided."
                    EmptyParagraphsBefore = 1
                    ExcelExport           = $true
                    ExcelWorkSheet        = 'Forest Optional Features'
                    ExcelData             = [ActiveDirectory]::ForestOptionalFeatures
                }
                SectionForestUPNSuffixes      = [ordered] @{
                    Use                   = $true
                    Text                  = "Following UPN suffixes were created in this forest:"
                    TextNoData            = "No UPN suffixes were created in this forest."
                    ListType              = 'Bulleted'
                    ListData              = [ActiveDirectory]::ForestUPNSuffixes
                    EmptyParagraphsBefore = 1
                    ExcelExport           = $true
                    ExcelWorkSheet        = 'Forest UPN Suffixes'
                    ExcelData             = [ActiveDirectory]::ForestUPNSuffixes
                }
                SectionForesSPNSuffixes       = [ordered] @{
                    Use                   = $true
                    Text                  = "Following SPN suffixes were created in this forest:"
                    TextNoData            = "No SPN suffixes were created in this forest."
                    ListType              = 'Bulleted'
                    ListData              = [ActiveDirectory]::ForestSPNSuffixes
                    EmptyParagraphsBefore = 1
                    ExcelExport           = $true
                    ExcelWorkSheet        = 'Forest SPN Suffixes'
                    ExcelData             = [ActiveDirectory]::ForestSPNSuffixes
                }
                SectionForestSites1           = [ordered] @{
                    Use             = $true
                    TocEnable       = $True
                    TocText         = 'General Information - Sites'
                    TocListLevel    = 1
                    TocListItemType = 'Numbered'
                    TocHeadingType  = 'Heading1'
                    TableData       = [ActiveDirectory]::ForestSites1
                    TableDesign     = 'ColorfulGridAccent5'
                    Text            = "Forest Sites list can be found below"
                    ExcelExport     = $false  ## Exported as one below
                    ExcelWorkSheet  = 'Forest Sites 1'
                    ExcelData       = [ActiveDirectory]::ForestSites1
                }
                SectionForestSites2           = [ordered] @{
                    Use                   = $true
                    TableData             = [ActiveDirectory]::ForestSites2
                    TableDesign           = 'ColorfulGridAccent5'
                    Text                  = "Forest Sites list can be found below"
                    EmptyParagraphsBefore = 1
                    ExcelExport           = $false ## Exported as one below
                    ExcelWorkSheet        = 'Forest Sites 2'
                    ExcelData             = [ActiveDirectory]::ForestSites2
                }
                SectionForestSites            = [ordered] @{
                    Use            = $true
                    ExcelExport    = $true
                    ExcelWorkSheet = 'Forest Sites'
                    ExcelData      = [ActiveDirectory]::ForestSites
                }
                SectionForestSubnets1         = [ordered] @{
                    Use                   = $true
                    TocEnable             = $True
                    TocText               = 'General Information - Subnets'
                    TocListLevel          = 1
                    TocListItemType       = 'Numbered'
                    TocHeadingType        = 'Heading1'
                    TableData             = [ActiveDirectory]::ForestSubnets1
                    TableDesign           = 'ColorfulGridAccent5'
                    Text                  = "Table below contains information regarding relation between Subnets and sites"
                    EmptyParagraphsBefore = 1
                    ExcelExport           = $true
                    ExcelWorkSheet        = 'Forest Subnets 1'
                    ExcelData             = [ActiveDirectory]::ForestSubnets1
                }
                SectionForestSubnets2         = [ordered] @{
                    Use                   = $true
                    TableData             = [ActiveDirectory]::ForestSubnets2
                    TableDesign           = 'ColorfulGridAccent5'
                    Text                  = "Table below contains information regarding relation between Subnets and sites"
                    EmptyParagraphsBefore = 1
                    ExcelExport           = $true
                    ExcelWorkSheet        = 'Forest Subnets 2'
                    ExcelData             = [ActiveDirectory]::ForestSubnets2
                }
                SectionForestSiteLinks        = [ordered] @{
                    Use             = $true
                    TocEnable       = $True
                    TocText         = 'General Information - Site Links'
                    TocListLevel    = 1
                    TocListItemType = 'Numbered'
                    TocHeadingType  = 'Heading1'
                    TableData       = [ActiveDirectory]::ForestSiteLinks
                    TableDesign     = 'ColorfulGridAccent5'
                    Text            = "Forest Site Links information is available in table below"
                    ExcelExport     = $true
                    ExcelWorkSheet  = 'Forest Site Links'
                    ExcelData       = [ActiveDirectory]::ForestSiteLinks
                }
            }
            SectionDomain = [ordered] @{
                SectionPageBreak                                  = [ordered] @{
                    Use              = $True
                    PageBreaksBefore = 1
                }
                SectionDomainStarter                              = [ordered] @{
                    Use             = $true
                    TocEnable       = $True
                    TocText         = 'General Information - Domain <Domain>'
                    TocListLevel    = 0
                    TocListItemType = [ListItemType]::Numbered
                    TocHeadingType  = [HeadingType]::Heading1
                }
                SectionDomainIntroduction                         = [ordered] @{
                    Use                   = $true
                    TocEnable             = $True
                    TocText               = 'General Information - Domain Summary'
                    TocListLevel          = 1
                    TocListItemType       = [ListItemType]::Numbered
                    TocHeadingType        = [HeadingType]::Heading1
                    Text                  = "Following domain exists within forest <ForestName>:"
                    ListBuilderContent    = "Domain <DomainDN>", 'Name for fully qualified domain name (FQDN): <Domain>', 'Name for NetBIOS: <DomainNetBios>'
                    ListBuilderLevel      = 0, 1, 1
                    ListBuilderType       = [ListItemType]::Bulleted, [ListItemType]::Bulleted, [ListItemType]::Bulleted
                    EmptyParagraphsBefore = 0
                }
                SectionDomainControllers                          = [ordered] @{
                    Use                 = $true
                    TocEnable           = $True
                    TocText             = 'General Information - Domain Controllers'
                    TocListLevel        = 1
                    TocListItemType     = 'Numbered'
                    TocHeadingType      = 'Heading2'
                    TableData           = [ActiveDirectory]::DomainControllers
                    TableDesign         = 'ColorfulGridAccent5'
                    TableMaximumColumns = 8
                    Text                = 'Following table contains domain controllers'
                    TextNoData          = ''
                    ExcelExport         = $true
                    ExcelWorkSheet      = '<Domain> - DCs'
                    ExcelData           = [ActiveDirectory]::DomainControllers
                }
                SectionDomainFSMO                                 = [ordered] @{
                    Use                   = $true
                    TableData             = [ActiveDirectory]::DomainFSMO
                    TableDesign           = 'ColorfulGridAccent5'
                    TableTitleMerge       = $true
                    TableTitleText        = "FSMO Roles for <Domain>"
                    Text                  = "Following table contains FSMO servers with roles for domain <Domain>"
                    EmptyParagraphsBefore = 1
                    ExcelExport           = $true
                    ExcelWorkSheet        = '<Domain> - FSMO'
                    ExcelData             = [ActiveDirectory]::DomainFSMO
                }
                SectionDomainDefaultPasswordPolicy                = [ordered] @{
                    Use             = $true
                    TocEnable       = $True
                    TocText         = 'General Information - Password Policies'
                    TocListLevel    = 1
                    TocListItemType = 'Numbered'
                    TocHeadingType  = 'Heading2'
                    TableData       = [ActiveDirectory]::DomainDefaultPasswordPolicy
                    TableDesign     = 'ColorfulGridAccent5'
                    TableTitleMerge = $True
                    TableTitleText  = "Default Password Policy for <Domain>"
                    Text            = 'Following table contains password policies for all users within <Domain>'
                    ExcelExport     = $true
                    ExcelWorkSheet  = '<Domain> - DefaultPasswordPolicy'
                    ExcelData       = [ActiveDirectory]::DomainDefaultPasswordPolicy
                }
                SectionDomainFineGrainedPolicies                  = [ordered] @{
                    Use                 = $true
                    TocEnable           = $True
                    TocText             = 'General Information - Fine Grained Password Policies'
                    TocListLevel        = 1
                    TocListItemType     = 'Numbered'
                    TocHeadingType      = 'Heading2'
                    TableData           = [ActiveDirectory]::DomainFineGrainedPolicies
                    TableDesign         = [TableDesign]::ColorfulGridAccent5
                    TableMaximumColumns = 8
                    TableTitleMerge     = $false
                    TableTitleText      = "Fine Grained Password Policy for <Domain>"
                    Text                = 'Following table contains fine grained password policies'
                    TextNoData          = "Following section should cover fine grained password policies. " `
                        + "There were no fine grained password polices defined in <Domain>. There was no formal requirement to have " `
                        + "them set up."
                    ExcelExport         = $true
                    ExcelWorkSheet      = '<Domain> - Password Policy (Grained)'
                    ExcelData           = [ActiveDirectory]::DomainFineGrainedPolicies
                }
                SectionDomainGroupPolicies                        = [ordered] @{
                    Use             = $true
                    TocEnable       = $True
                    TocText         = 'General Information - Group Policies'
                    TocListLevel    = 1
                    TocListItemType = 'Numbered'
                    TocHeadingType  = 'Heading2'
                    TableData       = [ActiveDirectory]::DomainGroupPolicies
                    TableDesign     = 'ColorfulGridAccent5'
                    Text            = "Following table contains group policies for <Domain>"
                    ExcelExport     = $true
                    ExcelWorkSheet  = '<Domain> - GroupPolicies'
                    ExcelData       = [ActiveDirectory]::DomainGroupPolicies
                }
                SectionDomainGroupPoliciesDetails                 = [ordered] @{
                    Use                 = $true
                    TocEnable           = $True
                    TocText             = 'General Information - Group Policies Details'
                    TocListLevel        = 1
                    TocListItemType     = 'Numbered'
                    TocHeadingType      = 'Heading2'
                    TableData           = [ActiveDirectory]::DomainGroupPoliciesDetails
                    TableMaximumColumns = 6
                    TableDesign         = 'ColorfulGridAccent5'
                    Text                = "Following table contains group policies for <Domain>"
                    ExcelExport         = $true
                    ExcelWorkSheet      = '<Domain> - GroupPolicies Details'
                    ExcelData           = [ActiveDirectory]::DomainGroupPoliciesDetails
                }
                SectionDomainGroupPoliciesACL                     = [ordered] @{
                    Use                 = $true
                    TocEnable           = $True
                    TocText             = 'General Information - Group Policies ACL'
                    TocListLevel        = 1
                    TocListItemType     = 'Numbered'
                    TocHeadingType      = 'Heading2'
                    TableData           = [ActiveDirectory]::DomainGroupPoliciesACL
                    TableMaximumColumns = 6
                    TableDesign         = 'ColorfulGridAccent5'
                    Text                = "Following table contains group policies ACL for <Domain>"
                    ExcelExport         = $true
                    ExcelWorkSheet      = '<Domain> - GroupPoliciesACL'
                    ExcelData           = [ActiveDirectory]::DomainGroupPoliciesACL
                }
                SectionDomainDNSSrv                               = [ordered] @{
                    Use                  = $true
                    TocEnable            = $True
                    TocText              = 'General Information - DNS A/SRV Records'
                    TocListLevel         = 1
                    TocListItemType      = 'Numbered'
                    TocHeadingType       = 'Heading2'
                    TableData            = [ActiveDirectory]::DomainDNSSRV
                    TableMaximumColumns  = 10
                    TableDesign          = 'ColorfulGridAccent5'
                    Text                 = "Following table contains SRV records for Kerberos and LDAP"
                    EmptyParagraphsAfter = 1
                    ExcelExport          = $true
                    ExcelWorkSheet       = '<Domain> - DNSSRV'
                    ExcelData            = [ActiveDirectory]::DomainDNSSRV
                }
                SectionDomainDNSA                                 = [ordered] @{
                    Use                 = $true
                    TableData           = [ActiveDirectory]::DomainDNSA
                    TableMaximumColumns = 10
                    TableDesign         = 'ColorfulGridAccent5'
                    Text                = "Following table contains A records for Kerberos and LDAP"
                    ExcelExport         = $true
                    ExcelWorkSheet      = '<Domain> - DNSA'
                    ExcelData           = [ActiveDirectory]::DomainDNSA
                }
                SectionDomainTrusts                               = [ordered] @{
                    Use                 = $true
                    TocEnable           = $True
                    TocText             = 'General Information - Trusts'
                    TocListLevel        = 1
                    TocListItemType     = 'Numbered'
                    TocHeadingType      = 'Heading2'
                    TableData           = [ActiveDirectory]::DomainTrusts
                    TableMaximumColumns = 6
                    TableDesign         = 'ColorfulGridAccent5'
                    Text                = "Following table contains trusts established with domains..."
                    ExcelExport         = $true
                    ExcelWorkSheet      = '<Domain> - DomainTrusts'
                    ExcelData           = [ActiveDirectory]::DomainTrusts
                }
                SectionDomainOrganizationalUnits                  = [ordered] @{
                    Use             = $true
                    TocEnable       = $True
                    TocText         = 'General Information - Organizational Units'
                    TocListLevel    = 1
                    TocListItemType = 'Numbered'
                    TocHeadingType  = 'Heading2'
                    TableData       = [ActiveDirectory]::DomainOrganizationalUnits
                    TableDesign     = 'ColorfulGridAccent5'
                    Text            = "Following table contains all OU's created in <Domain>"
                    ExcelExport     = $true
                    ExcelWorkSheet  = '<Domain> - OrganizationalUnits'
                    ExcelData       = [ActiveDirectory]::DomainOrganizationalUnits
                }
                SectionDomainPriviligedGroup                      = [ordered] @{
                    Use             = $False
                    TocEnable       = $True
                    TocText         = 'General Information - Priviliged Groups'
                    TocListLevel    = 1
                    TocListItemType = 'Numbered'
                    TocHeadingType  = 'Heading2'
                    TableData       = [ActiveDirectory]::DomainGroupsPriviliged
                    TableDesign     = 'ColorfulGridAccent5'
                    Text            = 'Following table contains list of priviliged groups and count of the members in it.'
                    ChartEnable     = $True
                    ChartTitle      = 'Priviliged Group Members'
                    ChartData       = [ActiveDirectory]::DomainGroupsPriviliged
                    ChartKeys       = 'Group Name', 'Members Count'
                    ChartValues     = 'Members Count'
                    ExcelExport     = $true
                    ExcelWorkSheet  = '<Domain> - PriviligedGroupMembers'
                    ExcelData       = [ActiveDirectory]::DomainGroupsPriviliged
                }
                SectionDomainAdministrators                       = [ordered] @{
                    Use             = $true
                    TocEnable       = $True
                    TocText         = 'General Information - Domain Administrators'
                    TocListLevel    = 1
                    TocListItemType = 'Numbered'
                    TocHeadingType  = 'Heading2'
                    TableData       = [ActiveDirectory]::DomainAdministratorsRecursive
                    TableDesign     = 'ColorfulGridAccent5'
                    Text            = 'Following users have highest priviliges and are able to control a lot of Windows resources.'
                    ExcelExport     = $true
                    ExcelWorkSheet  = '<Domain> - DomainAdministrators'
                    ExcelData       = [ActiveDirectory]::DomainAdministratorsRecursive
                }
                SectionEnterpriseAdministrators                   = [ordered] @{
                    Use             = $true
                    TocEnable       = $True
                    TocText         = 'General Information - Enterprise Administrators'
                    TocListLevel    = 1
                    TocListItemType = 'Numbered'
                    TocHeadingType  = 'Heading2'
                    TableData       = [ActiveDirectory]::DomainEnterpriseAdministratorsRecursive
                    TableDesign     = 'ColorfulGridAccent5'
                    Text            = 'Following users have highest priviliges across Forest and are able to control a lot of Windows resources.'
                    TextNoData      = 'No Enterprise Administrators users were defined for this domain.'
                    ExcelExport     = $true
                    ExcelWorkSheet  = '<Domain> - EnterpriseAdministrators'
                    ExcelData       = [ActiveDirectory]::DomainEnterpriseAdministratorsRecursive
                }
                SectionDomainUsersCount                           = [ordered] @{
                    Use             = $true
                    TocEnable       = $True
                    TocText         = 'General Information - Users Count'
                    TocListLevel    = 1
                    TocListItemType = 'Numbered'
                    TocHeadingType  = 'Heading2'
                    TableData       = [ActiveDirectory]::DomainUsersCount
                    TableDesign     = 'ColorfulGridAccent5'
                    TableTitleMerge = $False
                    TableTitleText  = 'Users Count'
                    Text            = "Following table and chart shows number of users in its categories"
                    ChartEnable     = $True
                    ChartTitle      = 'Users Count'
                    ChartData       = [ActiveDirectory]::DomainUsersCount
                    ChartKeys       = 'Keys'
                    ChartValues     = 'Values'
                    ExcelExport     = $true
                    ExcelWorkSheet  = '<Domain> - UsersCount'
                    ExcelData       = [ActiveDirectory]::DomainUsersCount
                }

                DomainPasswordClearTextPassword                   = [ordered] @{
                    Use             = $true
                    TocEnable       = $True
                    TocText         = 'General Information - DomainPasswordClearTextPassword'
                    TocListLevel    = 1
                    TocListItemType = 'Numbered'
                    TocHeadingType  = 'Heading2'
                    TableData       = [ActiveDirectory]::DomainPasswordClearTextPassword
                    TableDesign     = 'ColorfulGridAccent5'
                    Text            = 'DomainPasswordClearTextPassword'
                    TextNoData      = 'No DomainPasswordClearTextPassword'
                    ExcelExport     = $true
                    ExcelWorkSheet  = '<Domain> - ClearTextPassword'
                    ExcelData       = [ActiveDirectory]::DomainPasswordClearTextPassword
                }
                DomainPasswordLMHash                   = [ordered] @{
                    Use             = $true
                    TocEnable       = $True
                    TocText         = 'General Information - DomainPasswordLMHash'
                    TocListLevel    = 1
                    TocListItemType = 'Numbered'
                    TocHeadingType  = 'Heading2'
                    TableData       = [ActiveDirectory]::DomainPasswordLMHash
                    TableDesign     = 'ColorfulGridAccent5'
                    Text            = 'DomainPasswordLMHash'
                    TextNoData      = 'No DomainPasswordLMHash'
                    ExcelExport     = $true
                    ExcelWorkSheet  = '<Domain> - DomainPasswordLMHash'
                    ExcelData       = [ActiveDirectory]::DomainPasswordLMHash
                }
                DomainPasswordEmptyPassword                   = [ordered] @{
                    Use             = $true
                    TocEnable       = $True
                    TocText         = 'General Information - DomainPasswordEmptyPassword'
                    TocListLevel    = 1
                    TocListItemType = 'Numbered'
                    TocHeadingType  = 'Heading2'
                    TableData       = [ActiveDirectory]::DomainPasswordEmptyPassword
                    TableDesign     = 'ColorfulGridAccent5'
                    Text            = 'DomainPasswordEmptyPassword'
                    TextNoData      = 'No DomainPasswordEmptyPassword'
                    ExcelExport     = $true
                    ExcelWorkSheet  = '<Domain> - DomainPasswordEmptyPassword'
                    ExcelData       = [ActiveDirectory]::DomainPasswordEmptyPassword
                }
                DomainPasswordWeakPassword                   = [ordered] @{
                    Use             = $true
                    TocEnable       = $True
                    TocText         = 'General Information - DomainPasswordWeakPassword'
                    TocListLevel    = 1
                    TocListItemType = 'Numbered'
                    TocHeadingType  = 'Heading2'
                    TableData       = [ActiveDirectory]::DomainPasswordWeakPassword
                    TableDesign     = 'ColorfulGridAccent5'
                    Text            = 'DomainPasswordWeakPassword'
                    TextNoData      = 'No DomainPasswordWeakPassword'
                    ExcelExport     = $true
                    ExcelWorkSheet  = '<Domain> - DomainPasswordWeakPassword'
                    ExcelData       = [ActiveDirectory]::DomainPasswordWeakPassword
                }
                DomainPasswordDefaultComputerPassword                   = [ordered] @{
                    Use             = $true
                    TocEnable       = $True
                    TocText         = 'General Information - DomainPasswordDefaultComputerPassword'
                    TocListLevel    = 1
                    TocListItemType = 'Numbered'
                    TocHeadingType  = 'Heading2'
                    TableData       = [ActiveDirectory]::DomainPasswordDefaultComputerPassword
                    TableDesign     = 'ColorfulGridAccent5'
                    Text            = 'DomainPasswordDefaultComputerPassword'
                    TextNoData      = 'No DomainPasswordDefaultComputerPassword'
                    ExcelExport     = $true
                    ExcelWorkSheet  = '<Domain> - DomainPasswordDefaultComputerPassword'
                    ExcelData       = [ActiveDirectory]::DomainPasswordDefaultComputerPassword
                }
                DomainPasswordPasswordNotRequired                   = [ordered] @{
                    Use             = $true
                    TocEnable       = $True
                    TocText         = 'General Information - DomainPasswordPasswordNotRequired'
                    TocListLevel    = 1
                    TocListItemType = 'Numbered'
                    TocHeadingType  = 'Heading2'
                    TableData       = [ActiveDirectory]::DomainPasswordPasswordNotRequired
                    TableDesign     = 'ColorfulGridAccent5'
                    Text            = 'DomainPasswordPasswordNotRequired'
                    TextNoData      = 'No DomainPasswordPasswordNotRequired'
                    ExcelExport     = $true
                    ExcelWorkSheet  = '<Domain> - DomainPasswordPasswordNotRequired'
                    ExcelData       = [ActiveDirectory]::DomainPasswordPasswordNotRequired
                }
                DomainPasswordPasswordNeverExpires                   = [ordered] @{
                    Use             = $true
                    TocEnable       = $True
                    TocText         = 'General Information - DomainPasswordPasswordNeverExpires'
                    TocListLevel    = 1
                    TocListItemType = 'Numbered'
                    TocHeadingType  = 'Heading2'
                    TableData       = [ActiveDirectory]::DomainPasswordPasswordNeverExpires
                    TableDesign     = 'ColorfulGridAccent5'
                    Text            = 'DomainPasswordPasswordNeverExpires'
                    TextNoData      = 'No DomainPasswordPasswordNeverExpires'
                    ExcelExport     = $true
                    ExcelWorkSheet  = '<Domain> - DomainPasswordPasswordNeverExpires'
                    ExcelData       = [ActiveDirectory]::DomainPasswordPasswordNeverExpires
                }
                DomainPasswordAESKeysMissing                   = [ordered] @{
                    Use             = $true
                    TocEnable       = $True
                    TocText         = 'General Information - DomainPasswordAESKeysMissing'
                    TocListLevel    = 1
                    TocListItemType = 'Numbered'
                    TocHeadingType  = 'Heading2'
                    TableData       = [ActiveDirectory]::DomainPasswordAESKeysMissing
                    TableDesign     = 'ColorfulGridAccent5'
                    Text            = 'DomainPasswordAESKeysMissing'
                    TextNoData      = 'No DomainPasswordAESKeysMissing'
                    ExcelExport     = $true
                    ExcelWorkSheet  = '<Domain> - DomainPasswordAESKeysMissing'
                    ExcelData       = [ActiveDirectory]::DomainPasswordAESKeysMissing
                }
                DomainPasswordPreAuthNotRequired                   = [ordered] @{
                    Use             = $true
                    TocEnable       = $True
                    TocText         = 'General Information - DomainPasswordPreAuthNotRequired'
                    TocListLevel    = 1
                    TocListItemType = 'Numbered'
                    TocHeadingType  = 'Heading2'
                    TableData       = [ActiveDirectory]::DomainPasswordPreAuthNotRequired
                    TableDesign     = 'ColorfulGridAccent5'
                    Text            = 'DomainPasswordPreAuthNotRequired'
                    TextNoData      = 'No DomainPasswordPreAuthNotRequired'
                    ExcelExport     = $true
                    ExcelWorkSheet  = '<Domain> - DomainPasswordPreAuthNotRequired'
                    ExcelData       = [ActiveDirectory]::DomainPasswordPreAuthNotRequired
                }
                DomainPasswordDESEncryptionOnly                   = [ordered] @{
                    Use             = $true
                    TocEnable       = $True
                    TocText         = 'General Information - DomainPasswordDESEncryptionOnly'
                    TocListLevel    = 1
                    TocListItemType = 'Numbered'
                    TocHeadingType  = 'Heading2'
                    TableData       = [ActiveDirectory]::DomainPasswordDESEncryptionOnly
                    TableDesign     = 'ColorfulGridAccent5'
                    Text            = 'DomainPasswordDESEncryptionOnly'
                    TextNoData      = 'No DomainPasswordDESEncryptionOnly'
                    ExcelExport     = $true
                    ExcelWorkSheet  = '<Domain> - DomainPasswordDESEncryptionOnly'
                    ExcelData       = [ActiveDirectory]::DomainPasswordDESEncryptionOnly
                }
                DomainPasswordDelegatableAdmins                   = [ordered] @{
                    Use             = $true
                    TocEnable       = $True
                    TocText         = 'General Information - DomainPasswordDelegatableAdmins'
                    TocListLevel    = 1
                    TocListItemType = 'Numbered'
                    TocHeadingType  = 'Heading2'
                    TableData       = [ActiveDirectory]::DomainPasswordDelegatableAdmins
                    TableDesign     = 'ColorfulGridAccent5'
                    Text            = 'DomainPasswordDelegatableAdmins'
                    TextNoData      = 'No DomainPasswordDelegatableAdmins'
                    ExcelExport     = $true
                    ExcelWorkSheet  = '<Domain> - DomainPasswordDelegatableAdmins'
                    ExcelData       = [ActiveDirectory]::DomainPasswordDelegatableAdmins
                }
                DomainPasswordDuplicatePasswordGroups                   = [ordered] @{
                    Use             = $true
                    TocEnable       = $True
                    TocText         = 'General Information - DomainPasswordDuplicatePasswordGroups'
                    TocListLevel    = 1
                    TocListItemType = 'Numbered'
                    TocHeadingType  = 'Heading2'
                    TableData       = [ActiveDirectory]::DomainPasswordDuplicatePasswordGroups
                    TableDesign     = 'ColorfulGridAccent5'
                    Text            = 'DomainPasswordDuplicatePasswordGroups'
                    TextNoData      = 'No DomainPasswordDuplicatePasswordGroups'
                    ExcelExport     = $true
                    ExcelWorkSheet  = '<Domain> - DomainPasswordDuplicatePasswordGroups'
                    ExcelData       = [ActiveDirectory]::DomainPasswordDuplicatePasswordGroups
                }
                DomainPasswordHashesClearTextPassword                   = [ordered] @{
                    Use             = $true
                    TocEnable       = $True
                    TocText         = 'General Information - DomainPasswordHashesClearTextPassword'
                    TocListLevel    = 1
                    TocListItemType = 'Numbered'
                    TocHeadingType  = 'Heading2'
                    TableData       = [ActiveDirectory]::DomainPasswordHashesClearTextPassword
                    TableDesign     = 'ColorfulGridAccent5'
                    Text            = 'DomainPasswordHashesClearTextPassword'
                    TextNoData      = 'No DomainPasswordHashesClearTextPassword'
                    ExcelExport     = $true
                    ExcelWorkSheet  = '<Domain> - DomainPasswordHashesClearTextPassword'
                    ExcelData       = [ActiveDirectory]::DomainPasswordHashesClearTextPassword
                }
                DomainPasswordHashesLMHash                   = [ordered] @{
                    Use             = $true
                    TocEnable       = $True
                    TocText         = 'General Information - DomainPasswordHashesLMHash'
                    TocListLevel    = 1
                    TocListItemType = 'Numbered'
                    TocHeadingType  = 'Heading2'
                    TableData       = [ActiveDirectory]::DomainPasswordHashesLMHash
                    TableDesign     = 'ColorfulGridAccent5'
                    Text            = 'DomainPasswordHashesLMHash'
                    TextNoData      = 'No DomainPasswordHashesLMHash'
                    ExcelExport     = $true
                    ExcelWorkSheet  = '<Domain> - DomainPasswordHashesLMHash'
                    ExcelData       = [ActiveDirectory]::DomainPasswordHashesLMHash
                }
                DomainPasswordHashesEmptyPassword                   = [ordered] @{
                    Use             = $true
                    TocEnable       = $True
                    TocText         = 'General Information - DomainPasswordHashesEmptyPassword'
                    TocListLevel    = 1
                    TocListItemType = 'Numbered'
                    TocHeadingType  = 'Heading2'
                    TableData       = [ActiveDirectory]::DomainPasswordHashesEmptyPassword
                    TableDesign     = 'ColorfulGridAccent5'
                    Text            = 'DomainPasswordHashesEmptyPassword'
                    TextNoData      = 'No DomainPasswordHashesEmptyPassword'
                    ExcelExport     = $true
                    ExcelWorkSheet  = '<Domain> - DomainPasswordHashesEmptyPassword'
                    ExcelData       = [ActiveDirectory]::DomainPasswordHashesEmptyPassword
                }
                DomainPasswordHashesWeakPassword                   = [ordered] @{
                    Use             = $true
                    TocEnable       = $True
                    TocText         = 'General Information - DomainPasswordHashesWeakPassword'
                    TocListLevel    = 1
                    TocListItemType = 'Numbered'
                    TocHeadingType  = 'Heading2'
                    TableData       = [ActiveDirectory]::DomainPasswordHashesWeakPassword
                    TableDesign     = 'ColorfulGridAccent5'
                    Text            = 'DomainPasswordHashesWeakPassword'
                    TextNoData      = 'No DomainPasswordHashesWeakPassword'
                    ExcelExport     = $true
                    ExcelWorkSheet  = '<Domain> - DomainPasswordHashesWeakPassword'
                    ExcelData       = [ActiveDirectory]::DomainPasswordHashesWeakPassword
                }
                DomainPasswordHashesDefaultComputerPassword                   = [ordered] @{
                    Use             = $true
                    TocEnable       = $True
                    TocText         = 'General Information - DomainPasswordHashesDefaultComputerPassword'
                    TocListLevel    = 1
                    TocListItemType = 'Numbered'
                    TocHeadingType  = 'Heading2'
                    TableData       = [ActiveDirectory]::DomainPasswordHashesDefaultComputerPassword
                    TableDesign     = 'ColorfulGridAccent5'
                    Text            = 'DomainPasswordHashesDefaultComputerPassword'
                    TextNoData      = 'No DomainPasswordHashesDefaultComputerPassword'
                    ExcelExport     = $true
                    ExcelWorkSheet  = '<Domain> - DomainPasswordHashesDefaultComputerPassword'
                    ExcelData       = [ActiveDirectory]::DomainPasswordHashesDefaultComputerPassword
                }
                DomainPasswordHashesPasswordNotRequired                   = [ordered] @{
                    Use             = $true
                    TocEnable       = $True
                    TocText         = 'General Information - DomainPasswordHashesPasswordNotRequired'
                    TocListLevel    = 1
                    TocListItemType = 'Numbered'
                    TocHeadingType  = 'Heading2'
                    TableData       = [ActiveDirectory]::DomainPasswordHashesPasswordNotRequired
                    TableDesign     = 'ColorfulGridAccent5'
                    Text            = 'DomainPasswordHashesPasswordNotRequired'
                    TextNoData      = 'No DomainPasswordHashesPasswordNotRequired'
                    ExcelExport     = $true
                    ExcelWorkSheet  = '<Domain> - DomainPasswordHashesPasswordNotRequired'
                    ExcelData       = [ActiveDirectory]::DomainPasswordHashesPasswordNotRequired
                }
                DomainPasswordHashesPasswordNeverExpires                   = [ordered] @{
                    Use             = $true
                    TocEnable       = $True
                    TocText         = 'General Information - DomainPasswordHashesPasswordNeverExpires'
                    TocListLevel    = 1
                    TocListItemType = 'Numbered'
                    TocHeadingType  = 'Heading2'
                    TableData       = [ActiveDirectory]::DomainPasswordHashesPasswordNeverExpires
                    TableDesign     = 'ColorfulGridAccent5'
                    Text            = 'DomainPasswordHashesPasswordNeverExpires'
                    TextNoData      = 'No DomainPasswordHashesPasswordNeverExpires'
                    ExcelExport     = $true
                    ExcelWorkSheet  = '<Domain> - DomainPasswordHashesPasswordNeverExpires'
                    ExcelData       = [ActiveDirectory]::DomainPasswordHashesPasswordNeverExpires
                }
                DomainPasswordHashesAESKeysMissing                   = [ordered] @{
                    Use             = $true
                    TocEnable       = $True
                    TocText         = 'General Information - DomainPasswordHashesAESKeysMissing'
                    TocListLevel    = 1
                    TocListItemType = 'Numbered'
                    TocHeadingType  = 'Heading2'
                    TableData       = [ActiveDirectory]::DomainPasswordHashesAESKeysMissing
                    TableDesign     = 'ColorfulGridAccent5'
                    Text            = 'DomainPasswordHashesAESKeysMissing'
                    TextNoData      = 'No DomainPasswordHashesAESKeysMissing'
                    ExcelExport     = $true
                    ExcelWorkSheet  = '<Domain> - DomainPasswordHashesAESKeysMissing'
                    ExcelData       = [ActiveDirectory]::DomainPasswordHashesAESKeysMissing
                }
                DomainPasswordHashesPreAuthNotRequired                   = [ordered] @{
                    Use             = $true
                    TocEnable       = $True
                    TocText         = 'General Information - DomainPasswordHashesPreAuthNotRequired'
                    TocListLevel    = 1
                    TocListItemType = 'Numbered'
                    TocHeadingType  = 'Heading2'
                    TableData       = [ActiveDirectory]::DomainPasswordHashesPreAuthNotRequired
                    TableDesign     = 'ColorfulGridAccent5'
                    Text            = 'DomainPasswordHashesPreAuthNotRequired'
                    TextNoData      = 'No DomainPasswordHashesPreAuthNotRequired'
                    ExcelExport     = $true
                    ExcelWorkSheet  = '<Domain> - DomainPasswordHashesPreAuthNotRequired'
                    ExcelData       = [ActiveDirectory]::DomainPasswordHashesPreAuthNotRequired
                }
                DomainPasswordHashesDESEncryptionOnly                   = [ordered] @{
                    Use             = $true
                    TocEnable       = $True
                    TocText         = 'General Information - DomainPasswordHashesDESEncryptionOnly'
                    TocListLevel    = 1
                    TocListItemType = 'Numbered'
                    TocHeadingType  = 'Heading2'
                    TableData       = [ActiveDirectory]::DomainPasswordHashesDESEncryptionOnly
                    TableDesign     = 'ColorfulGridAccent5'
                    Text            = 'DomainPasswordHashesDESEncryptionOnly'
                    TextNoData      = 'No DomainPasswordHashesDESEncryptionOnly'
                    ExcelExport     = $true
                    ExcelWorkSheet  = '<Domain> - DomainPasswordHashesDESEncryptionOnly'
                    ExcelData       = [ActiveDirectory]::DomainPasswordHashesDESEncryptionOnly
                }
                DomainPasswordHashesDelegatableAdmins                   = [ordered] @{
                    Use             = $true
                    TocEnable       = $True
                    TocText         = 'General Information - DomainPasswordHashesDelegatableAdmins'
                    TocListLevel    = 1
                    TocListItemType = 'Numbered'
                    TocHeadingType  = 'Heading2'
                    TableData       = [ActiveDirectory]::DomainPasswordHashesDelegatableAdmins
                    TableDesign     = 'ColorfulGridAccent5'
                    Text            = 'DomainPasswordHashesDelegatableAdmins'
                    TextNoData      = 'No DomainPasswordHashesDelegatableAdmins'
                    ExcelExport     = $true
                    ExcelWorkSheet  = '<Domain> - DomainPasswordHashesDelegatableAdmins'
                    ExcelData       = [ActiveDirectory]::DomainPasswordHashesDelegatableAdmins
                }
                DomainPasswordHashesDuplicatePasswordGroups                   = [ordered] @{
                    Use             = $true
                    TocEnable       = $True
                    TocText         = 'General Information - DomainPasswordHashesDuplicatePasswordGroups'
                    TocListLevel    = 1
                    TocListItemType = 'Numbered'
                    TocHeadingType  = 'Heading2'
                    TableData       = [ActiveDirectory]::DomainPasswordHashesDuplicatePasswordGroups
                    TableDesign     = 'ColorfulGridAccent5'
                    Text            = 'DomainPasswordHashesDuplicatePasswordGroups'
                    TextNoData      = 'No DomainPasswordHashesDuplicatePasswordGroups'
                    ExcelExport     = $true
                    ExcelWorkSheet  = '<Domain> - DomainPasswordHashesDuplicatePasswordGroups'
                    ExcelData       = [ActiveDirectory]::DomainPasswordHashesDuplicatePasswordGroups
                }
                SectionExcelDomainOrganizationalUnitsBasicACL     = [ordered] @{
                    Use            = $true
                    ExcelExport    = $true
                    ExcelWorkSheet = '<Domain> - OU ACL Basic'
                    ExcelData      = [ActiveDirectory]::DomainOrganizationalUnitsBasicACL
                }
                SectionExcelDomainOrganizationalUnitsExtended     = [ordered] @{
                    Use            = $true
                    ExcelExport    = $true
                    ExcelWorkSheet = '<Domain> - OU ACL Extended'
                    ExcelData      = [ActiveDirectory]::DomainOrganizationalUnitsExtended
                }
                SectionExcelDomainUsers                           = [ordered] @{
                    Use            = $true
                    ExcelExport    = $true
                    ExcelWorkSheet = '<Domain> - Users'
                    ExcelData      = [ActiveDirectory]::DomainUsers
                }
                SectionExcelDomainUsersAll                        = [ordered] @{
                    Use            = $true
                    ExcelExport    = $true
                    ExcelWorkSheet = '<Domain> - Users All'
                    ExcelData      = [ActiveDirectory]::DomainUsersAll
                }
                SectionExcelDomainUsersSystemAccounts             = [ordered] @{
                    Use            = $true
                    ExcelExport    = $true
                    ExcelWorkSheet = '<Domain> - Users System'
                    ExcelData      = [ActiveDirectory]::DomainUsersSystemAccounts
                }
                SectionExcelDomainUsersNeverExpiring              = [ordered] @{
                    Use            = $true
                    ExcelExport    = $true
                    ExcelWorkSheet = '<Domain> - Never Expiring'
                    ExcelData      = [ActiveDirectory]::DomainUsersNeverExpiring
                }
                SectionExcelDomainUsersNeverExpiringInclDisabled  = [ordered] @{
                    Use            = $true
                    ExcelExport    = $true
                    ExcelWorkSheet = '<Domain> - Never Expiring incl Disabled'
                    ExcelData      = [ActiveDirectory]::DomainUsersNeverExpiringInclDisabled
                }
                SectionExcelDomainUsersExpiredInclDisabled        = [ordered] @{
                    Use            = $true
                    ExcelExport    = $true
                    ExcelWorkSheet = '<Domain> - Expired incl Disabled'
                    ExcelData      = [ActiveDirectory]::DomainUsersExpiredInclDisabled
                }
                SectionExcelDomainUsersExpiredExclDisabled        = [ordered] @{
                    Use            = $true
                    ExcelExport    = $true
                    ExcelWorkSheet = '<Domain> - Expired excl Disabled'
                    ExcelData      = [ActiveDirectory]::DomainUsersExpiredExclDisabled
                }
                SectionExcelDomainUsersFullList                   = [ordered] @{
                    Use            = $true
                    ExcelExport    = $true
                    ExcelWorkSheet = '<Domain> - Users List Full'
                    ExcelData      = [ActiveDirectory]::DomainUsersFullList
                }
                SectionExcelDomainComputersFullList               = [ordered] @{
                    Use            = $true
                    ExcelExport    = $true
                    ExcelWorkSheet = '<Domain> - Computers List'
                    ExcelData      = [ActiveDirectory]::DomainComputersFullList
                }
                SectionExcelDomainGroupsFullList                  = [ordered] @{
                    Use            = $true
                    ExcelExport    = $true
                    ExcelWorkSheet = '<Domain> - Groups List'
                    ExcelData      = [ActiveDirectory]::DomainGroupsFullList
                }
                SectionExcelDomainGroupsRest                      = [ordered] @{
                    Use            = $true
                    ExcelExport    = $true
                    ExcelWorkSheet = '<Domain> - Groups'
                    ExcelData      = [ActiveDirectory]::DomainGroups
                }
                SectionExcelDomainGroupsSpecial                   = [ordered] @{
                    Use            = $true
                    ExcelExport    = $true
                    ExcelWorkSheet = '<Domain> - Groups Special'
                    ExcelData      = [ActiveDirectory]::DomainGroupsSpecial
                }
                SectionExcelDomainGroupsPriviliged                = [ordered] @{
                    Use            = $true
                    ExcelExport    = $true
                    ExcelWorkSheet = '<Domain> - Groups Priv'
                    ExcelData      = [ActiveDirectory]::DomainGroupsPriviliged
                }
                SectionExcelDomainGroupMembers                    = [ordered] @{
                    Use            = $true
                    ExcelExport    = $true
                    ExcelWorkSheet = '<Domain> - Members'
                    ExcelData      = [ActiveDirectory]::DomainGroupsMembers
                }
                SectionExcelDomainGroupMembersSpecial             = [ordered] @{
                    Use            = $true
                    ExcelExport    = $true
                    ExcelWorkSheet = '<Domain> - Members Special'
                    ExcelData      = [ActiveDirectory]::DomainGroupsSpecialMembers
                }
                SectionExcelDomainGroupMembersPriviliged          = [ordered] @{
                    Use            = $true
                    ExcelExport    = $true
                    ExcelWorkSheet = '<Domain> - Members Priv'
                    ExcelData      = [ActiveDirectory]::DomainGroupsPriviligedMembers
                }
                SectionExcelDomainGroupMembersRecursive           = [ordered] @{
                    Use            = $true
                    ExcelExport    = $true
                    ExcelWorkSheet = '<Domain> - Members Rec'
                    ExcelData      = [ActiveDirectory]::DomainGroupsMembersRecursive
                }
                SectionExcelDomainGroupMembersSpecialRecursive    = [ordered] @{
                    Use            = $true
                    ExcelExport    = $true
                    ExcelWorkSheet = '<Domain> - Members RecSpecial'
                    ExcelData      = [ActiveDirectory]::DomainGroupsSpecialMembersRecursive
                }
                SectionExcelDomainGroupMembersPriviligedRecursive = [ordered] @{
                    Use            = $true
                    ExcelExport    = $true
                    ExcelWorkSheet = '<Domain> - Members RecPriv'
                    ExcelData      = [ActiveDirectory]::DomainGroupsPriviligedMembersRecursive
                }
            }
        }
    }
}

Start-Documentation -Document $Document -Verbose