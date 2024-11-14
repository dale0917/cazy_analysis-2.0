process STAR_ALIGN {
    tag "$meta.id"
    label 'process_high'

    // conda "${moduleDir}/environment.yml"
    container "${ workflow.containerEngine == 'singularity' && !task.ext.singularity_pull_docker_container ?
        'https://depot.galaxyproject.org/singularity/mulled-v2-1fa26d1ce03c295fe2fdcf85831a92fbcbd7e8c2:ded3841da0194af2701c780e9b3d653a85d27489-0' :
        'biocontainers/mulled-v2-1fa26d1ce03c295fe2fdcf85831a92fbcbd7e8c2:ded3841da0194af2701c780e9b3d653a85d27489-0' }"

    input:
    tuple val(meta), path(reads)
    path index

    output:
    tuple val(meta), path('*.Aligned.toTranscriptome.out.bam'), emit: bam
    tuple val(meta), path('*.Log.final.out')                  , emit: log_final
    path  "versions.yml"                                      , emit: versions
    path "*"                                                  , emit: other

    when:
    task.ext.when == null || task.ext.when

    script:
    def args = task.ext.args ?: ''
    def prefix = task.ext.prefix ?: "${meta.id}"
    
    """
    STAR \\
        --runThreadN $task.cpus \\
        --genomeDir $index \\
        --outFileNamePrefix $prefix. \\
		--readFilesIn $reads \\
		--outSAMtype BAM SortedByCoordinate \\
        $args


    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        star: \$(STAR --version | sed -e "s/STAR_//g")
    END_VERSIONS
    """

    stub:
    def prefix = task.ext.prefix ?: "${meta.id}"
    """
    touch ${prefix}Xd.out.bam
    touch ${prefix}.Log.final.out
    touch ${prefix}.Log.out
    touch ${prefix}.Log.progress.out
    touch ${prefix}.sortedByCoord.out.bam
    touch ${prefix}.toTranscriptome.out.bam
    touch ${prefix}.Aligned.unsort.out.bam
    touch ${prefix}.unmapped_1.fastq.gz
    touch ${prefix}.unmapped_2.fastq.gz
    touch ${prefix}.tab
    touch ${prefix}.Chimeric.out.junction
    touch ${prefix}.out.sam

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        star: \$(STAR --version | sed -e "s/STAR_//g")
    END_VERSIONS
    """
}

