process CREATEBLASTPDB {
    container 'community.wave.seqera.io/library/blast:2.16.0--d1fdc6c729a5827c'

    //publishDir "/workspace/new_features/results", mode: 'copy'

    input:
    path fastaFile

    output:
    path("output_db/*"),           emit:  'blast_db'
    //path 'versions.yml',           emit:  'versions'
    
    //path('version')    ,           topic: 'versions_topic'
    //tuple eval('makeblastdb -version'), eval("blastdbcmd -db output_db/${fastaFile.baseName}_blastp_db -info | grep 'sequences' | awk '{print \$3}'"), topic: 'versions_topic_eval'
    
    
    script:
    // Obtenemos el nombre base del archivo (sin la extensión) para usarlo en la salida
    def fileName = fastaFile.baseName
    """
    
    mkdir -p output_db
    makeblastdb -in $fastaFile -dbtype prot -out output_db/${fileName}_blastp_db 

    # Collect makeblastdb version info (old school way)
    #cat <<-END_VERSIONS > versions.yml
    #"${task.process}":
    #  makeblastdb: \$(makeblastdb -version | head -n 1 | sed 's/makeblastdb: //g')
    #END_VERSIONS

    # Collect makeblastdb version for topic channel
    # makeblastdb -version > version

    """
}

