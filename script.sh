#!/bin/bash

#---------------------------------------------------------------------------
#-- Copyright (c) 2020 Lyaaaaaaaaaaaaaaa
#--
#-- Author : Lyaaaaaaaaaaaaaaa | https://github.com/Lyaaaaaaaaaaaaaaa
#--
#-- Portability Issues:
#--  - I'm actually testing this script with Fedora and CentOS. We might have
#--      to create a branch for other OS.
#--
#-- Implementation Notes:
#--  -
#--
#-- Changelog:
#--   30/07/2020 Lyaaaaa
#--     - Created file.
#--     - Created Check_Umask function
#--
#--   31/07/2020 Lyaaaaa
#--     - Implemented Check_Umask
#--     - Created the Main function
#--     - Created Write_Report function
#--     - Created Check_Unowned_Files
#--     - Created Check_Active_Processes
#--     - Created Check_Directories_Rights (Empty)
#--     - Created Check_Files_Editable_By_Everyone
#--
#--   03/08/2020 Lyaaaaa
#--     - Implemented Check_Directories_Rights
#--     - Created Check_Sensitive_Files
#--     - Updated Report readibility
#--     - Created Check_Executable_Setuid_Root
#--     - Created Write_Header and Write_Separator to make the report more
#--         readable.
#--     - All the functions now use Write_Header and Write_Separator when
#--         needed.
#---------------------------------------------------------------------------





#---------------------------------------------------------------------------
#-- Check_Umask
#--
#-- Portability Issues:
#--  -
#--
#-- Implementation Notes:
#--  -
#--
#-- Anticipated Changes:
#--  - Improve the report
#--  - Check the system global umask
#---------------------------------------------------------------------------

function  Check_Umask()
{
  echo "Checking the Umask"

  Recommended_User_Umask=0077
  User_Umask=$(umask)

  Write_Header "Umask"

  if test $Recommended_User_Umask != $User_Umask
  then

    Write_Report "Your user's Umask is $User_Umask."
    Write_Report "If it's 0022 (any file created is readable by all).
                  I recommend setting it to 0077 (any file created by a user is
                  readable and editable only by him)."
    Write_Report "On Debian the system umask can be directly modified in
                  /etc/init.d/rc and the users umask in/etc/login.defs."
    Write_Report "On CentOS the system umask can be directly modified in
                  /etc/sysconfig/init and the users umask in/etc/login.defs."
    Write_Report

  else
    Write_Report "Your user's Umask is 0077. It's good"
    Write_Report
  fi

}

#---------------------------------------------------------------------------
#-- Write_Report
#--
#-- Portability Issues:
#--  -
#--
#-- Implementation Notes:
#--  - The report's name has the date on it in case you have to run it multiple
#--      times.
#--
#-- Anticipated Changes:
#--  - Write a beautiful report with a header (copyright, project's name,
#--      authors), a well formatted explanation of the found vulnerabilities and
#--      advices about how to solve them. For each function call create a
#--      separator in the report with the function's name in it.
#---------------------------------------------------------------------------

function Write_Report()
{
  P_Report_Content=$1

  Report_Name="Audit_Report_"$(date '+%d-%m-%y')


  echo $P_Report_Content >> $Report_Name
}


#---------------------------------------------------------------------------
#-- Write_Header
#--
#-- Portability Issues:
#--  -
#--
#-- Implementation Notes:
#--  - Insert a nice header in the report to make it more readable.
#--
#-- Anticipated Changes:
#--  -
#---------------------------------------------------------------------------

function Write_Header()
{
  P_Header_Name=$1

  Write_Report
  Write_Report "----------------------------------------------------"
  Write_Report "--- $P_Header_Name"
  Write_Report "----------------------------------------------------"
  Write_Report

}


#---------------------------------------------------------------------------
#-- Write_Separator
#--
#-- Portability Issues:
#--  -
#--
#-- Implementation Notes:
#--  - Insert a nice separator in the report to make it more readable.
#--
#-- Anticipated Changes:
#--  -
#---------------------------------------------------------------------------
function Write_Separator()
{

  Write_Report
  Write_Report "----------------------------------------------------"
  Write_Report "---"
  Write_Report "----------------------------------------------------"
  Write_Report

}


#---------------------------------------------------------------------------
#-- Check_Unowned_Files
#--
#-- Portability Issues:
#--  -
#--
#-- Implementation Notes:
#--  -
#--
#-- Anticipated Changes:
#--  - Play an animation while executing the find command
#---------------------------------------------------------------------------

function Check_Unowned_Files()
{
  echo "Checking unowned files, this can take some times..."

  Report_Name="Audit_Report_"$(date '+%d-%m-%y')

  Write_Header "Unowned files"
  Write_Report "Files without a known owner may be incorrectly assigned to a
                user when creating his account. Wemust therefore ensure that
                no file is in this situation on the system"
  Write_Report

  Write_Report "Files with no owner or group assigned:"
  find / -type f \( -nouser -o -nogroup \) -ls 2>/dev/null >> $Report_Name
}


#---------------------------------------------------------------------------
#-- Check_Active_Processes
#--
#-- Portability Issues:
#--  -
#--
#-- Implementation Notes:
#--  -
#--
#-- Anticipated Changes:
#--  -
#---------------------------------------------------------------------------

function Check_Active_Processes()
{
  echo "Checking active processes"

  Report_Name="Audit_Report_"$(date '+%d-%m-%y')

  Write_Header "Active processes "

  Write_Report "I recommend disabling all unnecessary services and uninstalling
                them"
  Write_Report "For each of the remaining services:"
  Write_Report "1. Update the program."
  Write_Report "2. Activation of partitioning measures (chroot, containers,
                seccompfilters, etc."
  Write_Report "3. Removal of privileges when those of root are not required (by
                creating an account dedicated to the service and configuring
                it to use this account)."
  Write_Report "4. Any hardening guidelines documented for the program."
  Write_Report

  Write_Report "Actives processes:"

  ps aux >> $Report_Name

  Write_Separator
  Write_Header "Processes listening on the network"
  netstat -aelonptu >> $Report_Name

}



#---------------------------------------------------------------------------
#-- Check_Directories_Rights
#--
#-- Portability Issues:
#--  -
#--
#-- Implementation Notes:
#--  -
#--
#-- Anticipated Changes:
#--  -
#---------------------------------------------------------------------------

function Check_Directories_Rights()
{
  echo "Checking directories rights, this might take some times..."

  Report_Name="Audit_Report_"$(date '+%d-%m-%y')

  Write_Header "Directories editable by everyone "
  Write_Report "Root should be the owner of these directories, they should have
                sticky bit as well"
  Write_Report
  Write_Report "Directories editable by everyone:"

  find / -type d -perm -0002 -a \! -uid 0 -ls 2>/dev/null >> $Report_Name
}


#---------------------------------------------------------------------------
#-- Check_Files_Editable_By_Everyone
#--
#-- Portability Issues:
#--  -
#--
#-- Implementation Notes:
#--  -
#--
#-- Anticipated Changes:
#--  -
#---------------------------------------------------------------------------

function Check_Files_Editable_By_Everyone()
{
  echo "Checking files editables by everyone"

  Report_Name="Audit_Report_"$(date '+%d-%m-%y')

  Write_Header "Files editable by everyone "
  Write_Report "No regular file needs to be modifiable by everyone. When a file
                needs to be editable by multiple users or programs at the same
                time, a group must be created and only this group must have
                write rights to the said file"

  Write_Report
  Write_Report "Files editable by everyone: "

  find / -type f -perm -0002 -ls 2>/dev/null >> $Report_Name

}


#---------------------------------------------------------------------------
#-- Check_Sensitive_Files
#--
#-- Portability Issues:
#--  -
#--
#-- Implementation Notes:
#--  -
#--
#-- Anticipated Changes:
#--  - Check more file
#---------------------------------------------------------------------------

function Check_Sensitive_Files()
{
  echo "Checking sensitive content files"

  Report_Name="Audit_Report_"$(date '+%d-%m-%y')


  Write_Header "Permissions of sensitive content files"

  Write_Report "When these files contain passwords (or password fingerprints)
                they must only be readable by root."
  Write_Report "On the other hand, the public files that contain the list of
                users are readable by everyone, but are editable only by root."

  Write_Report
  Write_Report "Files that should be readable by root only:"
  ls -l /etc/gshadow >> $Report_Name
  ls -l /etc/shadow >> $Report_Name

  Write_Report
  Write_Report "Files that should be in read only for users:"
  ls -l /etc/passwd >> $Report_Name
}


#---------------------------------------------------------------------------
#-- Check_Executable_Setuid_Root
#--
#-- Portability Issues:
#--  -
#--
#-- Implementation Notes:
#--  -
#--
#-- Anticipated Changes:
#--  -
#---------------------------------------------------------------------------

function Check_Executable_Setuid_Root()
{
  echo "Checking executable with setuid and root as owner"

  Report_Name="Audit_Report_"$(date '+%d-%m-%y')

  Write_Header "Executable with setuid and root as owner"

  Write_Report "Setuid executables should be as few as possible. When it is
                expected that only the administrators of the machine execute
                them, the setuid bit must be removed and it is recommended to
                prefer using commands like su or sudo, which can be monitored"
  Write_Report
  Write_Report "List of your files with setuid/setgid bit: "

  find / -type f -perm /6000 -ls 2>/dev/null >> $Report_Name

  Write_Report
  Write_Report "To remove setuid or setgid rights do:"
  Write_Report "chmod u-s <file> #Remove the setuid bit"
  Write_Report "chmod g-s <file> #Remove the setgid bit"
  Write_Report
}


#---------------------------------------------------------------------------
#-- Main
#--
#-- Portability Issues:
#--  -
#--
#-- Implementation Notes:
#--  - The Main function's role is to call all the functions we need to audit
#--      the system.
#--
#-- Anticipated Changes:
#--  - Call the newly added functions to audit the system
#---------------------------------------------------------------------------

function Main()
{
  Write_Report "----------------------------------------------------"
  Write_Report "--- Copyright (c) 2020 Lyaaaaaaaaaaaaaaa"
  Write_Report "--- Github: https://github.com/Lyaaaaaaaaaaaaaaa"
  Write_Report "--- GNU-LINUX-Auto-Security-Audit"
  Write_Report "--- Report date: $(date '+%d-%m-%y %H:%m')"
  Write_Report "----------------------------------------------------"
  Write_Report

  Check_Umask
  Check_Active_Processes
  Check_Sensitive_Files
  Check_Executable_Setuid_Root
  Check_Files_Editable_By_Everyone
  Check_Directories_Rights
  Check_Unowned_Files
}

Main
