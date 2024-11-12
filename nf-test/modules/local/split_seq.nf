process SPLITTED_SEQUENCES {
    input:
    path fastaFile  // Recibe el archivo fasta original
    
    output:
    path("splitted_sequences/*"), emit: 'splitted_sequences'

    //path 'versions.yml'         , emit: 'versions'
    //path('version')             , topic:'versions_topic' 
    eval('python --version')     , topic:'versions_topic_eval'

    script:
    """
    mkdir -p splitted_sequences
    splitfasta.py ${fastaFile} splitted_sequences 3

    # Collect Python version info (old school way)
    #cat <<-END_VERSIONS > versions.yml
    #"${task.process}":
    #  python: \$(python --version | sed 's/Python //g')
    #END_VERSIONS

    # Guarda la versión de Python como metadata
    #python --version > version

    """
}
