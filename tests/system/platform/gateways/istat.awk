BEGIN { FS=";"; print "@prefix schema: <http://schema.org/> ." }
NR>1 { printf "<urn:istat:comune:%s> a schema:City; schema:name \"\"\"%s\"\"\".\n", $5, $6 }
