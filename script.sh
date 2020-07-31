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
#--
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
  Check_Umask
}

Main
