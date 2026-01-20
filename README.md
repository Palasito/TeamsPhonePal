# TeamsPhonePal

A PowerShell module for automating Microsoft Teams Phone System deployment and configuration. TeamsPhonePal simplifies the process of configuring PSTN connectivity, voice routing, and telephony infrastructure for Microsoft Teams.

## Overview

TeamsPhonePal provides a comprehensive set of tools to automate the deployment and configuration of:
- Session Border Controllers (SBC)
- Voice Routes
- Voice Routing Policies
- PSTN Usages
- Network Regions, Sites, and Subnets
- Country-specific telephony configurations

## Features

- **Automated Deployment**: Deploy complete Teams Phone System configurations from CSV templates
- **Country Support**: Built-in validation and configuration for multiple countries with ISO code support
- **Flexible Routing**: Support for segregated routing (landline/mobile), international calling, and custom patterns
- **Network Configuration**: Automated setup of network regions, sites, and subnets
- **SBC Management**: Easy configuration and management of Session Border Controllers
- **Graph API Integration**: Automated authentication and domain validation

## Requirements

### Prerequisites
- PowerShell 5.1 or later
- **MicrosoftTeams** module (automatically checked by the module)
- Microsoft 365 tenant with appropriate permissions:
  - Teams Administrator or Global Administrator
  - Rights to manage Teams Phone System configuration

## Installation

### Option 1: Import from Local Path
\\\powershell
# Clone or download the repository
cd "C:\Path\To\TeamsPhonePal\Module"

# Import the module
Import-Module .\TeamsPhonePal\TeamsPhonePal.psd1
\\\

### Option 2: Copy to PowerShell Modules Directory
\\\powershell
# Copy the module to your PowerShell modules path
Copy-Item -Path ".\Module\TeamsPhonePal" -Destination "$env:USERPROFILE\Documents\PowerShell\Modules\" -Recurse

# Import the module
Import-Module TeamsPhonePal
\\\

## Quick Start

### 1. Basic Deployment from CSV

\\\powershell
# Import the module
Import-Module TeamsPhonePal

# Deploy configuration from CSV template
TeamsDeployment -PathtoCSV "C:\Path\To\Config.csv"
\\\

### 2. CSV Template Format

Create a CSV file with the following structure:

\\\csv
Country,SBCFQDN,Port,LandlineExample,MobileExample,Seggregation,International
Greece,sbc1.example.com,5061,2102724669,6977155869,yes,yes
Italy,sbc2.example.com,5062,0612345678,3331234567,no,yes
Spain,sbc3.example.com,5063,915551234,612345678,yes,no
\\\

**Column Descriptions:**
- **Country**: Full country name or ISO 2-letter code (e.g., "Greece" or "GR")
- **SBCFQDN**: Fully Qualified Domain Name of the SBC (multiple SBCs can be separated by pipe |)
- **Port**: SIP signaling port (typically 5060 or 5061)
- **LandlineExample**: Example landline number including country code (used to determine number pattern)
- **MobileExample**: Example mobile number including country code
- **Seggregation**: "yes" to create separate routes for landline/mobile, "no" for combined routing
- **International**: "yes" to enable international calling routes, "no" for domestic only

## Usage Examples

### Example 1: Deploy Single Country Configuration

\\\powershell
# Deploy Teams Phone configuration for Greece
TelDep -Country "Greece" \
       -SBCFQDN "sbc.contoso.com" \
       -Land "2102724669" \
       -Mob "6977155869" \
       -International \
       -Seggregation
\\\

This creates:
- Separate voice routes for landlines and mobiles
- International calling capabilities
- Appropriate PSTN usages and voice routing policies

### Example 2: Deploy Multiple Countries

\\\powershell
# Prepare CSV file with multiple countries
\ = "C:\Teams\Configs\MultiCountry.csv"

# Deploy all configurations
TeamsDeployment -PathtoCSV \
\\\

### Example 3: Configure SBC Only

\\\powershell
# Add a new Session Border Controller
SBCConf -FQDN "sbc.contoso.com" -Port 5061
\\\

### Example 4: Add Network Configuration

\\\powershell
# Add a network region
Add-Region -RegionID "EMEA-Central" -CentralSite "Athens-HQ"

# Add a network site
Add-Sites -SiteID "Athens-Office" \
          -Region "EMEA-Central" \
          -Address "123 Main Street, Athens, Greece"

# Add subnets to the site
Add-Subnet -SubnetID "10.10.10.0" \
           -MaskBits 24 \
           -SiteID "Athens-Office" \
           -Description "Athens Office Network"
\\\

### Example 5: Add PSTN Usage

\\\powershell
# Add PSTN usage for a country (domestic only)
Add-PSTNUsage -CountryCode "GR"

# Add PSTN usage with international calling
Add-PSTNUsage -CountryCode "IT" -International

# Add segregated PSTN usage (landline/mobile separate)
Add-PSTNUsage -CountryCode "ES" -Seggregation -International
\\\

### Example 6: Add Voice Routing Policy

\\\powershell
# Create voice routing policy for Greece with all features
Add-VRP -CountryCode "GR" -International -Seggregation
\\\

### Example 7: Skip Validation (Advanced)

\\\powershell
# Skip domain and prerequisite validation (use with caution)
TeamsDeployment -PathtoCSV "C:\Config.csv" -SkipValidation
\\\

## Function Reference

### Core Functions

#### TeamsDeployment
Main deployment function that processes CSV configuration files.

**Parameters:**
- \PathtoCSV\: Path to CSV configuration file
- \SkipValidation\: (Switch) Skip prerequisite and domain validation

#### TelDep
Deploy telephony configuration for a single country.

**Parameters:**
- \Country\: Country name or ISO code
- \SBCFQDN\: SBC Fully Qualified Domain Name
- \Land\: Landline example number
- \Mob\: Mobile example number
- \International\: (Switch) Enable international calling
- \Seggregation\: (Switch) Separate landline/mobile routing

#### SBCConf
Configure a Session Border Controller.

**Parameters:**
- \FQDN\: SBC Fully Qualified Domain Name
- \Port\: SIP signaling port

### Voice Routing Functions

#### Add-PSTNUsage
Create PSTN usage entries.

**Parameters:**
- \CountryCode\: ISO 2-letter country code
- \International\: (Switch) Include international calling
- \Seggregation\: (Switch) Separate landline/mobile

#### Add-VRP
Create Voice Routing Policy.

**Parameters:**
- \CountryCode\: ISO 2-letter country code
- \International\: (Switch) Include international calling
- \Seggregation\: (Switch) Separate landline/mobile

#### Add-VR
Create Voice Routes with number patterns.

**Parameters:**
- \SBC\: SBC FQDN
- \CountryCode\: ISO 2-letter country code
- \MinML\, \MaxML\: Min/Max mobile number length
- \MinLL\, \MaxLL\: Min/Max landline number length
- \Prefix\: Country calling code prefix
- \FDL\: First digit of landline numbers
- \FDM\: First digit of mobile numbers
- \Seggregation\: (Switch) Separate routes
- \International\: (Switch) International routes

### Network Configuration Functions

#### Add-Region
Create a network region.

**Parameters:**
- \RegionID\: Region identifier
- \CentralSite\: Central site for the region

#### Add-Sites
Create a network site.

**Parameters:**
- \SiteID\: Site identifier
- \Region\: Parent region ID
- \Address\: Physical address

#### Add-Subnet
Associate subnet with a site.

**Parameters:**
- \SubnetID\: Subnet address
- \MaskBits\: Subnet mask bits
- \SiteID\: Associated site ID
- \Description\: Subnet description

### Utility Functions

#### CountryValidation
Validate country name or ISO code.

#### CountryLookup
Look up country information by name.

#### CountryByISO
Get country calling code by ISO code.

#### ValidateDomain
Validate domain ownership and configuration.

#### GetGraphToken
Acquire Microsoft Graph API token.

#### PrerequisiteCheck
Verify required modules are installed.

## Advanced Configuration

### Multiple SBCs per Country

You can configure multiple SBCs for redundancy:

\\\csv
Country,SBCFQDN,Port,LandlineExample,MobileExample,Seggregation,International
Greece,sbc1.contoso.com|sbc2.contoso.com,5061,2102714669,6977155769,yes,yes
\\\

### Custom Number Patterns

The module automatically calculates number patterns based on the example numbers provided:
- Determines first digit of landline/mobile numbers
- Calculates min/max length (±2 digits from example)
- Adds country prefix automatically

### Routing Logic

**With Seggregation (yes):**
- Creates separate voice routes: \{Country}Landlines\ and \{Country}Mobiles\
- Creates separate PSTN usages: \{Country}LandlinesOnly\ and \{Country}MobilesOnly\

**Without Seggregation (no):**
- Creates single voice route: \{Country}\
- Creates single PSTN usage: \{Country}\

**With International (yes):**
- Adds \{Country}toInternational\ voice route
- Adds \{Country}International\ PSTN usage

## Troubleshooting

### Common Issues

**1. Module Not Found**
\\\powershell
# Verify module location
Get-Module -ListAvailable -Name TeamsPhonePal

# Import with full path if needed
Import-Module "C:\Full\Path\To\TeamsPhonePal.psd1"
\\\

**2. MicrosoftTeams Module Missing**
\\\powershell
# Install MicrosoftTeams module
Install-Module -Name MicrosoftTeams -Force -AllowClobber
\\\

**3. Authentication Failures**
\\\powershell
# Manually connect to Teams
Connect-MicrosoftTeams

# Verify connection
Get-CsTenant
\\\

**4. Voice Route Already Exists**
The module checks for existing configurations and warns without overwriting. To force recreation, manually remove existing objects first:

\\\powershell
# Remove existing voice route
Remove-CsOnlineVoiceRoute -Identity "GR"

# Remove existing PSTN usage
Set-CsOnlinePstnUsage -Identity Global -Usage @{Remove="GR"}
\\\

**5. Invalid Country Code**
Ensure country names are spelled correctly or use ISO 2-letter codes:
- Greece = GR
- Italy = IT
- Spain = ES
- United Kingdom = GB

## Best Practices

1. **Test in Development**: Always test configurations in a development tenant first
2. **CSV Validation**: Validate CSV file format before bulk deployment
3. **Backup Configuration**: Export existing configuration before making changes:
   \\\powershell
   Get-CsOnlineVoiceRoute | Export-Csv -Path "VoiceRoutes_Backup.csv"
   Get-CsOnlinePstnUsage | Export-Csv -Path "PSTNUsages_Backup.csv"
   \\\
4. **Incremental Deployment**: Deploy one country at a time for complex setups
5. **SBC Testing**: Verify SBC connectivity before creating routes
6. **Number Patterns**: Use real example numbers to ensure accurate pattern matching

## Project Structure

\\\
TeamsPhonePal/
├── Module/
│   └── TeamsPhonePal/
│       ├── TeamsPhonePal.psd1         # Module manifest
│       ├── TeamsPhonePal.psm1         # Module loader
│       └── Functions/
│           ├── TeamsDeployment.ps1    # Main deployment function
│           ├── TelDep.ps1             # Single country deployment
│           ├── SBCConf.ps1            # SBC configuration
│           ├── Add-PSTNUsage.ps1      # PSTN usage creation
│           ├── Add-VRP.ps1            # Voice routing policy
│           ├── Add-VR.ps1             # Voice routes
│           ├── Add-Region.ps1         # Network regions
│           ├── Add-Sites.ps1          # Network sites
│           ├── Add-Subnet.ps1         # Network subnets
│           ├── CountryValidation.ps1  # Country validation
│           ├── CountryLookup.ps1      # Country lookup
│           ├── CountryByISO.ps1       # ISO to calling code
│           ├── ValidateDomain.ps1     # Domain validation
│           ├── GetGraphToken.ps1      # Graph API auth
│           ├── PrerequisiteCheck.ps1  # Module validation
│           └── Get-FolderName.ps1     # UI helpers
└── RAW_Functions/                     # Development/testing scripts
    ├── template.csv                   # CSV template example
    ├── Teams_Template.xlsx            # Excel template
    └── *.ps1                          # Individual test scripts
\\\

## Support and Contribution

**Author**: cpalavouzis  
**Company**: SPWorxx SA  
**Version**: 1.0  
**Generated**: May 16, 2022  

For issues, questions, or contributions, please contact the author.

## License

Copyright (c) 2022 cpalavouzis. All rights reserved.

## Additional Resources

- [Microsoft Teams Phone System Documentation](https://learn.microsoft.com/en-us/microsoftteams/cloud-voice-landing-page)
- [Teams PowerShell Reference](https://learn.microsoft.com/en-us/powershell/teams/)
- [SBC Configuration Guide](https://learn.microsoft.com/en-us/microsoftteams/direct-routing-configure)

## Changelog

### Version 1.0
- Initial release
- Core deployment functions
- CSV-based bulk deployment
- Country validation and lookup
- Network configuration support
- SBC management
- Voice routing automation
