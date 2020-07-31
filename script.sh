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


  if test $Recommended_User_Umask != $User_Umask
  then
    Write_Report "--- Umask ---"
    Write_Report "Your user's Umask is $User_Umask."
    Write_Report "If it's 0022 (any file created is readable by all).
                  I recommend setting it to 0077 (any file created by a user is
                  readable and editable only by him)."
    Write_Report "On Debian the system umask can be directly modified in
                  /etc/init.d/rc and the users umask in/etc/login.defs."
    Write_Report "On CentOS the system umask can be directly modified in
                  /etc/sysconfig/init and the users umask in/etc/login.defs."

  else
    Write_Report "Your user's Umask is 0077. It's good"
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
  echo "Checking unowned files, this can take sometimes."

  Report_Name="Audit_Report_"$(date '+%d-%m-%y')

  Write_Report "--- Unowned files ---"
  Write_Report "Files without a known owner may be incorrectly assigned to a
                user when creating his account. Wemust therefore ensure that
                no file is in this situation on the system"
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

  Write_Report "--- Active processes ---"
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

  ps aux >> $Report_Name

  Write_Report "--- Processes listening on the network ---"
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
  echo "Checking directories rights"
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

  Write_Report "--- Files editable by everyone ---"
  Write_Report "No regular file needs to be modifiable by everyone. When a file
                needs to be editable by multiple users or programs at the same
                time, a group must be created and only this group must have
                write rights to the said file"
  Write_Report "Files editable by everyone: "

  find / -type f -perm -0002 -ls 2>/dev/null >> $Report_Name

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

  Check_Umask
  Check_Active_Processes
  Check_Files_Editable_By_Everyone
  Check_Directories_Rights
  Check_Unowned_Files
}

Main
