Run the command line command to get the sid for the SPOT user:

wmic useraccount where name='%username%' get sid

Replace the SID in the WIN_SCP registry file, then merge it into the registry


