<#
.LICENSE
THE SOFTWARE IS PROVIDED AS IS, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.

.SYNOPSIS
    Kurzbeschreibung
.DESCRIPTION
    Lange Beschreibung
.NOTES
Author:     Sven Krott
Authoremail sven.krott@acp.de
Website:    https://github.com/intuner
Initials:   SvKr

#---------------------------------------------------------[Hystory]--------------------------------------------------------

Date      	   Version   	   By	     Comments
----------	   -------	      ---	    ----------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------


#---------------------------------------------------------[Variabele]--------------------------------------------------------#>

#Source Applicaton - Changeable - need to be changed
$AppName = "LockScreen"
$AppFile = "LockScreen.jpg"
$FilePath = "c:\windows\MEM\LockScreen\"

# Fixed Value - do not Change this
$LockScreenPath = "LockScreenImagePath"
$LockScreenStatus = "LockScreenImageStatus"
$LockScreenUrl = "LockScreenImageUrl"
$StatusValue = "1"
$LockScreenImageValue = "$FilePath" + "$AppFile"
$RegKeyPath = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\PersonalizationCSP"

# LogFile location - Changeable - need to be changed
$LogFile = "c:\windows\Logs\MEM\$appName.log"
 
#---------------------------------------------------------[Funktion]--------------------------------------------------------#>

# Creation Log File
Function Write-Log {
    Param(
        [parameter(Mandatory = $true)]
        [string]
        [ValidateNotNullOrEmpty()]
        $logstring,
        [parameter(Mandatory = $true)]
        [string]
        [ValidateNotNullOrEmpty()]
        [ValidateSet('info', 'warn', 'error')]
        $loglevel,
        [parameter(Mandatory = $true)]
        [string]
        [ValidateNotNullOrEmpty()]
        $LogFile
    )
    $nowDate = get-date -format yyyy.MM.dd
    $nowtime = get-date -format HH:mm:ss
    if (!(Test-Path (Split-Path $logfile))) {
        try {
            new-item -Path (split-path $logfile) -ItemType Directory -Force
        }
        catch {
            Write-Verbose "Could not Create LogFile - Exit" 
            exit 1
        }
    }
    Start-Sleep -Milliseconds 2
    $Message = "[$loglevel][$nowdate][$nowtime] - $logstring"
    Add-content $logfile -value $Message
    switch ($loglevel) {
        "warn" {
            $host.PrivateData.VerboseForegroundColor = "Yellow"
            Write-verbose $Message -Verbose
        }
        "info" {
            $host.PrivateData.VerboseForegroundColor = "Green"
            Write-verbose $Message -Verbose
        }
        "error" {
            $host.PrivateData.VerboseForegroundColor = "Red"
            Write-verbose $Message -Verbose
        }
    }
}

#---------------------------------------------------------[Program]--------------------------------------------------------#>


write-log -logstring "Starting $AppName Install" -loglevel info -LogFile $LogFile

$exitcode = 0

# Copy File to $FilePath
try {
    Copy-Item - Path ".\Data\$AppFile" -Destination "$FilePath\" -Force -Confirm:$false -ErrorAction Stop
    Start-Sleep -s 10

}
catch {
    write-log -logstring "Could not Copy '$AppFile'" -loglevel error -LogFile $LogFile
    write-log -logstring $Error[0].exception.message -loglevel error -LogFile $LogFile
    $exitcode = 1 
}

Start-Sleep -s 

# Set RegKey

if (!(Test-Path $RegKeyPath)) {
    Write-Host "Creating registry path $($RegKeyPath)."
    New-Item -Path $RegKeyPath -Force | Out-Null
}


New-ItemProperty -Path $RegKeyPath -Name $LockScreenStatus -Value $StatusValue -PropertyType DWORD -Force | Out-Null
New-ItemProperty -Path $RegKeyPath -Name $LockScreenPath -Value $LockScreenImageValue -PropertyType STRING -Force | Out-Null
New-ItemProperty -Path $RegKeyPath -Name $LockScreenUrl -Value $LockScreenImageValue -PropertyType STRING -Force | Out-Null

RUNDLL32.EXE USER32.DLL, UpdatePerUserSystemParameters 1, True

Write-Log -logstring "Installation of $AppName is completed" -loglevel info -LogFile $logfile
exit $exitcode