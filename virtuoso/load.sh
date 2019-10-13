#!/bin/bash
#
# Virtuoso			Bulk Loader Script
#
# Description: Bulk loader script for Virtuoso
# Usage: vload [virtuososo_allowed_directory] [data_file] [graph_uri] [log_file] [virtuoso_password]

# Get input arguments
args=("$@")
if [ $# -ne 5 ]; then
    echo "Wrong number of arguments. Correct usage: \"vload [virtuososo_allowed_directory] [data_file] [graph_uri] [log_file] [virtuoso_password]\""
else
    VAD=${args[0]}
    data_file=${args[1]}
    graph_uri=${args[2]}
    LOGFILE=${args[3]}
    VIRT_PSWD=${args[4]}

    # Status message
    echo "Loading triples into graph <$graph_uri>..."

    # Log into Virtuoso isql env
    isql_cmd="isql-v -U dba -P $VIRT_PSWD"
    isql_cmd_check="isql-v -U dba -P $VIRT_PSWD exec=\"checkpoint;\""
    # Build the Virtuoso commands
    load_func="ld_dir('$VAD', '$data_file', '$graph_uri');"
    run_func="rdf_loader_run();"
    select_func="select * from DB.DBA.load_list WHERE ll_file LIKE '%${VAD}%';"
   
    # Run the Virtuoso commands
    ${isql_cmd} << EOF &> ${LOGFILE}
	    $load_func
            $run_func
            $select_func   
            exit;
    ${isql_cmd_check}

EOF

    # Write the load commands to the log 
    echo "----------" >> ${LOGFILE}
    echo $load_func >> ${LOGFILE}
    echo $run_func >> ${LOGFILE}
    echo ${select_func} >> ${LOGFILE}
    echo "----------" >> ${LOGFILE}
    
    # Print out the log file
    cat ${LOGFILE}

    result=$?

    if [ $result != 0 ]
    then
        "Failed to load! Check ${LOGFILE} for details."
        exit 1
    fi

    # Status message
    echo "Loading finished! Check ${LOGFILE} for details."
    exit 0
fi

