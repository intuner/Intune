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
Detection LockScreen 
.DESCRIPTION
The script detects if the RegKey and file are present

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
$Version = "1.0"
$RegKeyPath = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\PersonalizationCSP"


 
#---------------------------------------------------------[Funktion]--------------------------------------------------------#>



#---------------------------------------------------------[Program]--------------------------------------------------------#>

# Checking if a file exists in Registry and App version
$pathReg = if (([version](Get-ItemPropertyValue -path $RegKeyPath -Name DisplayVersion -ea SilentlyContinue)) -ge $Version) 
{ $true } else { $false };
# Result of the detection rule
if ($pathReg) 
{ $true } else { $null };

# Checking if a file/folder exists
$pathFile = if (Test-Path -Path $FilePath+$AppFile) 
{ $true } else { $false };
# Result of the detection rule
if ($pathFile) 
{ $true } else { $null };
exit(0);
