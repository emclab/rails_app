#assign SUBURI. For example, SUBURI='/emclab' for /emclab. 
if Rails.env.production?
  SUBURI = "/"
else
  SUBURI = ''
end
#set session timeout minutes
SESSION_TIMEOUT_MINUTES = 90
SESSION_WIPEOUT_HOURS = 12
#max record in sys_log
MAX_SYS_LOG_ENTRY = 1000