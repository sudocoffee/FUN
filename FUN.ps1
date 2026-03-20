param (
    [string]$ConfigFilePath
)


# Define category names
$CategoryNames = @{
    0 = "Unrated"
    1 = "Drug Abuse"
    2 = "Alternative Beliefs"
    3 = "Hacking"
    4 = "Illegal or Unethical"
    5 = "Discrimination"
    6 = "Explicit Violence"
    7 = "Abortion"
    8 = "Other Adult Materials"
    9 = "Advocacy Organizations"
    11 = "Gambling"
    12 = "Extremist Groups"
    13 = "Nudity and Risque"
    14 = "Pornography"
    15 = "Dating"
    16 = "Weapons (Sales)"
    17 = "Advertising"
    18 = "Brokerage and Trading"
    19 = "Freeware and Software Downloads"
    20 = "Games"
    23 = "Web-based Email"
    24 = "File Sharing and Storage"
    25 = "Streaming Media and Download"
    26 = "Malicious Websites"
    28 = "Entertainment"
    29 = "Arts and Culture"
    30 = "Education"
    31 = "Finance and Banking"
    33 = "Health and Wellness"
    34 = "Job Search"
    35 = "Medicine"
    36 = "News and Media"
    37 = "Social Networking"
    38 = "Political Organizations"
    39 = "Reference"
    40 = "Global Religion"
    41 = "Search Engines and Portals"
    42 = "Shopping"
    43 = "General Organizations"
    44 = "Society and Lifestyles"
    46 = "Sports"
    47 = "Travel"
    48 = "Personal Vehicles"
    49 = "Business"
    50 = "Information and Computer Security"
    51 = "Government and Legal Organizations"
    52 = "Information Technology"
    53 = "Armed Forces"
    54 = "Dynamic Content"
    55 = "Meaningless Content"
    56 = "Web Hosting"
    57 = "Marijuana"
    58 = "Folklore"
    59 = "Proxy Avoidance"
    61 = "Phishing"
    62 = "Plagiarism"
    63 = "Sex Education"
    64 = "Alcohol"
    65 = "Tobacco"
    66 = "Lingerie and Swimsuit"
    67 = "Sports Hunting and War Games"
    68 = "Web Chat"
    69 = "Instant Messaging"
    70 = "Newsgroups and Message Boards"
    71 = "Digital Postcards"
    72 = "Peer-to-peer File Sharing"
    75 = "Internet Radio and TV"
    76 = "Internet Telephony"
    77 = "Child Education"
    78 = "Real Estate"
    79 = "Restaurant and Dining"
    80 = "Personal Websites and Blogs"
    81 = "Secure Websites"
    82 = "Content Servers"
    83 = "Child Sexual Abuse"
    84 = "Web-based Applications"
    85 = "Domain Parking"
    86 = "Spam URLs"
    87 = "Personal Privacy"
    88 = "Dynamic DNS"
    89 = "Auction"
    90 = "Newly Observed Domain"
    91 = "Newly Registered Domain"
    92 = "Charitable Organizations"
    93 = "Remote Access"
    94 = "Web Analytics"
    95 = "Online Meeting"
    96 = "Terrorism"
    97 = "URL Shortening"
    98 = "Crypto Mining"
    99 = "Potentially Unwanted Program"
    100 = "Artificial Intelligence Technology"
    101 = "Cryptocurrency"
    140 = "custom1"
    141 = "custom2"
}


# This function sparks joy
function Format-Rainbow([switch] $Random) {
	#$colors = 2, 3, 4, 6, 8, 10, 11, 12, 13, 14, 15
    $colors = "Red", "DarkYellow", "Yellow", "Green", "Cyan", "Blue", "Magenta"
	$i = 0
	$input | Out-String -Stream | % {
		$chars = $_.TrimEnd() -split ''
		foreach($char in $chars) {
			if($random) {
				$color = Get-Random $colors
			} else {
				$color = $colors[$i % $colors.Length]
			}
			Write-Host -ForegroundColor $color $char -NoNewline -BackgroundColor Black
			$i++
		}
		Write-Host
	}
}


# Function to process the content of a single config file
function Process-ConfigFile {
    param (
        [string]$Path
    )
    

    # Automatically populate the list of all valid category numbers that should appear in the output from the keys in the CategoryNames hashtable
    $AllCategories = $CategoryNames.Keys

    # Read the config file
    $ConfigContent = Get-Content -Path $Path

    # Get the current date and time for the timestamp
    $timestamp = Get-Date -Format "yyyy-MM-dd_HHmm"

    # Get the category list name from the config file
    $CategoryListName = $null
    foreach ($Line in $ConfigContent) {
        if ($Line.Trim() -imatch 'edit "(.+)"') {
            $CategoryListName = $Matches[1]
            break
        }
        }
        if (-not $CategoryListName) {
            # Provide a default name if the category list name is not found in the config file
            $CategoryListName = 'DefaultCategoryList'
        }

    # Defines your enjoyment
    $enJoy = "Your CSV file for $CategoryListName is ready!  Thank you for enjoying FUN!"

    # Define the output CSV file path
    $outputCsvPath = "$CategoryListName" + "_" + "$timestamp" + ".csv"

    # Initialize a hashtable to store the actions for each category
    $CategoryActions = @{}

    # Loop through each line in the config content
    foreach ($Line in $ConfigContent) {
        # Check if the line contains a category definition
        if ($Line -match 'set category (\d+)') {
            # Store the category number
            $CategoryNumber = [int]$Matches[1]

            # Assume 'Allow' action by default
            $Action = 'Allow'

            # Check if the next line defines an action
            if ($ConfigContent[$ConfigContent.IndexOf($Line) + 1] -match 'set action (\w+)') {
                # Store the defined action
                $Action = $Matches[1]
            }

            # Store the action in the hashtable
            $CategoryActions[$CategoryNumber] = $Action
        }
    }

    # Initialize an empty array to hold the results
    $Results = @()

    # Loop through each category in the predefined list
    foreach ($CategoryNumber in $AllCategories) {
        # Get the action from the hashtable, assuming 'Allow' if not found
        $Action = $CategoryActions[$CategoryNumber]
        if (-not $Action) {
            $Action = 'Allow'
        }

        # Create a custom object with the category name and action
        $Results += [PSCustomObject]@{
            'FortiGuard Category' = "Category $CategoryNumber ($($CategoryNames[$CategoryNumber]))"
            'FortiGate Action' = $Action
        }
    }

    # Export the results to a CSV file, using the category list name in the file name
    $enJoy | Format-Rainbow
    $Results | Export-Csv -Path $outputCsvPath -NoTypeInformation

}


# Check if a config file path was provided as a parameter
if ($ConfigFilePath) {
    # If a config file path was provided, process only that file
    Process-ConfigFile -Path $ConfigFilePath
} else {
    # If no config file path was provided, process all .txt files in the script's directory
    $ScriptDirectory = Split-Path -Path $MyInvocation.MyCommand.Definition -Parent
    $TextFiles = Get-ChildItem -Path $ScriptDirectory -Filter *.txt
    
    foreach ($TextFile in $TextFiles) {
        Process-ConfigFile -Path $TextFile.FullName
    }
}



#Pauses to let user review log.
Write-Host ""
Write-Host ""
$pressKey = "Press any key to continue..."
$pressKey | Format-Rainbow
$Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
