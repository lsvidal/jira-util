#!/bin/bash

# Fix the CSV generated bu Auditor for Jira for Excel to read it.
#
# Usage: fix-audit-log-csv.sh < <input file> > <output file>
#
# The first lines of the original CSV are like this due to line breaking in "Event Parameters" field
# "Event ID","Event Time","Event Type","User Name","IP Address","Event Parameters"
# "48634","2017-09-15 10:05:18.570","Project version added","Leo","10.0.0.30","Project name = Mars exploration
# Version name = 2017-09-15
# Project key = MARS
# Version description = null
# Start date = null
# Release date = 15/Set/17
# "
# "48628","2017-09-14 16:00:05.514","Project roles changed","Leo","10.0.0.30","Project name = Mars exploration
# Project role = Developers
# Group names = []
# User names = [""Joe"",""John"",""Jill"",""Jack"",""Jules""]
# "
#
# The fixed file will lok like this
# "Event ID";"Event Time";"Event Type";"User Name";"IP Address";"Event Parameters"
# "48634";"2017-09-15 10:05:18.570";"Project version added";"Leo";"10.0.0.30";"Project name = Mars exploration|Version name = 2017-09-15|Project key = MARS|Version description = null|Start date = null|Release date = 15/Set/17"
# "48628";"2017-09-14 16:00:05.514";"Project roles changed";"Leo";"10.0.0.30";"Project name = Mars exploration|Project role = Developers|Group names = []|User names = ['Joe','John','Jill','Jack','Jules']"

tr '\r\n' '|'                                 `# Joins the lines separating then with a pipe symbol` \
  | sed -e 's/"|"/"\r\n"/g'                   `# Inserts back the correct line breaks identified by the pattern "|"` \
        -e 's/\([^"]\)","\([^"]\)/\1";"\2/g'  `# Converts commas separating columns into semicolons without affecting lists in "Event Parameters"` \
        -e 's/|"/"/g'                         `# Removes unecessary pipe symbols in the end of "Event Parameters" column` \
  | sed s/\"\"/\'/g                           `# Converts double double quotes in lists in "Event Parameters" into single quotes`
