($2 == "A" || $2 == "T" || $2 == "C" || $2 == "N" || $2 == "D") && \
    $3 != "_etext" && $3 != "_edata" && $3 != "_DYNAMIC" && $3 != "_init" && \
    $3 != "_fini" && $3 != "_lib_version" && $3 != "_GLOBAL_OFFSET_TABLE_" && \
    $3 != "_PROCEDURE_LINKAGE_TABLE_" \
    { print $3 }
