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
Remove LockScreen 
.DESCRIPTION
This script removes configuration of LockScreen for non-Windows Enterprise and Windows Education.
The image file is removed on the local device and the registry parameters are removed from the script.

minimum OS: Windows 10 1903 or later

.NOTES
Author:     Sven Krott
Authoremail sven.krott@acp.de
Website:    https://github.com/intuner
Initials:   SvKr

#---------------------------------------------------------[Hystory]--------------------------------------------------------

Date      	   Version   	   By	     Comments
05/10/2022     1.0             SvKr 	  Initial Version

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


write-log -logstring "Starting $AppName uninstall" -loglevel info -LogFile $LogFile

$exitcode = 0

# Remove File from $FilePath
try {
    Remove-Item -Path "$FilePath" -Force -Confirm:$false -ErrorAction Stop
    Start-Sleep -s 10

}
catch {
    write-log -logstring "Could $AppFile not remove from lokal System" -loglevel error -LogFile $LogFile
    write-log -logstring $Error[0].exception.message -loglevel error -LogFile $LogFile
    $exitcode = 1 
}

Start-Sleep -s 

# Remove RegKey

Write-Host "Remove registry path $($RegKeyPath)."
Remove-Item -Path $RegKeyPath -Recurse | Out-Null


RUNDLL32.EXE USER32.DLL, UpdatePerUserSystemParameters 1, True

Write-Log -logstring "Uninstalling of $AppName is completed" -loglevel info -LogFile $logfile
exit $exitcode

