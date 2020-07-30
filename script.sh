#!/bin/bash

#---------------------------------------------------------------------------
#-- Copyright (c) 2020 Lyaaaaaaaaaaaaaaa
#--
#-- Auteur : Lyaaaaaaaaaaaaaaa | https://github.com/Lyaaaaaaaaaaaaaaa
#--
#-- Portability Issues:
#--  -
#--
#-- Implementation Notes:
#--  -
#--
#-- Changelog:
#--   30/07/2020 Lyaaaaa
#--     - Created file.
#--     - Created Check_Umask function
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
#--  - Call the function to write into the report
#--  - Store into a variable the grep result and parse it to find the umask
#--      value
#---------------------------------------------------------------------------

function  Check_Umask()
{
  echo "Checking the Umask"
  grep umask /etc/profile
}

Check_Umask
