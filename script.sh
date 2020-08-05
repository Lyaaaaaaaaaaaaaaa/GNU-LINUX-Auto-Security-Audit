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
#--     - Added in Check_Executable_Setuid_Root a link to the table of
#--         recommendation for 41 executables with setuid root.
#--     - Created Check_Accounts
#--     - Created Check_Session_Expiration
#--
#--   04/08/2020 Lyaaaaa
#--     - Implemented Check_Session_Expiration
#--     - Improved readability (reduced line length)
#--     - Added another information about editing the Umask
#--     - Wrote another command in Check_Executable_Setuid_Root's report
#--
#--   05/08/2020 Lyaaaaa
#--     - Created Check_For_Automatic_Update
#--     - Created Check_Repositories
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
      Write_Report "You also can edit it in /etc/profile"
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
                user when creating his account."
  Write_Report "We must therefore ensure that no file is in this situation on
                the system"
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
                seccompfilters, etc)."
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
  Write_Report "No regular file needs to be modifiable by everyone."
  Write_Report "When a file needs to be editable by multiple users or programs
                at the same time, a group must be created and only this group
                must have write rights to the said file"

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

  Write_Report "Setuid executables should be as few as possible."
  Write_Report "When it is expected that only the administrators of the machine
                execute them, the setuid bit must be removed."
  Write_Report "It is recommended to prefer using commands like su or sudo,
                which can be monitored"
  Write_Report
  Write_Report "List of your files with setuid/setgid bit: "

  find / -type f -perm /6000 -ls 2>/dev/null >> $Report_Name

  Write_Report
  Write_Report "To remove setuid or setgid rights do:"
  Write_Report "chmod u-s <file> #Remove the setuid bit"
  Write_Report "chmod g-s <file> #Remove the setgid bit"
  Write_Report "To remove both at same time:"
  Write_Report "chmod gu-s <file>"
  Write_Report
  Write_Report "Here is a list of recommendation from the ANSSI:"
  Write_Report "https://github.com/Lyaaaaaaaaaaaaaaa/GNU-LINUX-Auto-Security-Audit/blob/master/Executables_Setuid_Root_Recommendation.md"
  Write_Report
}


#---------------------------------------------------------------------------
#-- Check_Accounts
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

function Check_Accounts()
{
  echo "Checking accounts"

  Report_Name="Audit_Report_"$(date '+%d-%m-%y')

  Write_Header "Accounts"
  Write_Report "Service accounts must be disabled"
  Write_Report "Disabling these accounts has no practical effect on the use of
                the associated credentials (UID)."
  Write_Report "This measure avoids the opening of a user session by a service
                account."
  Write_Report "It is important to note that some services can be declared with
                the nobody account."
  Write_Report "When they are many to adopt such behavior,
                they find themselves sharing the same account (and privileges)
                at the operating system level."
  Write_Report "A web server and a directory using nobody can therefore control
                each other and alter the execution of the other:"
  Write_Report "configuration modification, sending signals, ptrace privileges,
                etc."
  Write_Report
  Write_Report "List of accounts:"

  cat /etc/passwd >> $Report_Name

  Write_Report
  Write_Report "You can disable an account with the following command:"
  Write_Report "sudo usermod --expiredate 1 peter"
}


#---------------------------------------------------------------------------
#-- Check_Session_Expiration
#--
#-- Portability Issues:
#--  -
#--
#-- Implementation Notes:
#--  - If the environnement variable TMOUT is not set, then the script guess
#--      there is no session's expiration.
#--
#-- Anticipated Changes:
#--  -
#---------------------------------------------------------------------------

function Check_Session_Expiration()
{
  echo "Checking session timeout"
  Write_Header "Session timeout"

  Timeout=$(printenv TMOUT)

  if (test ! $Timeout)
    then
      Write_Report "You didn't set TMOUT."
      Write_Report "You can set a timeout by doing this command and rebooting:"
      Write_Report "echo TMOUT=120 >> /etc/environment"
      Write_Report "You can set TMOUT to any time you want in secondes."

  elif (test $Timeout -eq 0)
    then
      Write_Report "You disabled session timeout, you should re-activate it."
      Write_Report "You can set a timeout by doing this command and rebooting:"
      Write_Report "echo TMOUT=120 >> /etc/environment"
      Write_Report "You can set TMOUT to any time you want in secondes."

  elif (test $Timeout -gt 1000)
    then
      Write_Report "Your timeout is greater than 1000 secondes. You should
                    reduce it."

  else
    Write_Report "Your timeout is $Timeout seconds, it's correctly set"

  fi

}


#---------------------------------------------------------------------------
#-- Check_For_Automatic_Update
#--
#-- Portability Issues:
#--  -
#--
#-- Implementation Notes:
#--  -
#--
#-- Anticipated Changes:
#--  - Add a check for apt equivalent
#---------------------------------------------------------------------------

function Check_For_Automatic_Update()
{

  echo "Checking for automatic update (yum-cron or dnf-automatic)."
  Write_Header "Automatic updates"

  if [ -f /etc/yum/yum-cron.conf ]
    then
      Write_Report "It looks like you have yum-cron installed."
      Write_Report "Be sure to check the configuration files"

  elif [ -f /etc/dnf/automatic.conf ]
    then
      Write_Report "It looks like you have dnf-automatic installed."
      Write_Report "Be sure to check the configuration files and enable
                    dnf-automatic.timer"

  else
    Write_Report "It looks like you don't have any automatic update."
    Write_Report "It is recommended to have a regular update procedure."
    Write_Report
    Write_Report "If you are on CentOS8 check dnf-automatic."
    Write_Report "If you are on CentOS7 check for yum-cron."

  fi
}


#---------------------------------------------------------------------------
#-- Check_Repositories
#--
#-- Portability Issues:
#--  -
#--
#-- Implementation Notes:
#--  -
#--
#-- Anticipated Changes:
#--  - Add a check for apt equivalent
#---------------------------------------------------------------------------

function Check_Repositories()
{
  echo "Checking repositories."
  Write_Header "Installed repositories"

  Report_Name="Audit_Report_"$(date '+%d-%m-%y')

  if [ -f /etc/dnf/dnfff.conf ]
    then
    dnf repolist >> $Report_Name
  else
    yum repolist >> $Report_Name
  fi

  Write_Report
  Write_Report "Only up-to-date official repositories of the distribution
                must be used."

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
  Check_Accounts
  Check_Session_Expiration
  Check_For_Automatic_Update
  Check_Repositories
  Check_Files_Editable_By_Everyone
  Check_Directories_Rights
  Check_Unowned_Files
}

Main
