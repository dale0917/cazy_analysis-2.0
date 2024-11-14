include { STAR_GENOMEGENERATE    } from '/home/zs-dalo/modules/modules/modules/zs/star/genomegenerate/main.nf'
include { RSEM_PREPAREREFERENCE  } from '/home/zs-dalo/modules/modules/modules/zs/prepare_reference/preparereference.nf'
include { STAR_ALIGN             } from '/home/zs-dalo/modules/modules/modules/zs/star/align/main.nf'

workflow FASTQ_ALIGN_STAR {

    take:
    ch_reads
    ch_index  // if not using, should pass a '[]' so that subworkflow can run and perform conditionals
    ch_fasta  // if not using, should pass a '[]' so that subworkflow can run and perform conditionals
    ch_gtf    // if not using, should pass a '[]' so that subworkflow can run and perform conditionals

    main:
    ch_versions    = Channel.empty()
    ch_final_index = Channel.empty()

    // Si no se proporciona un índice pre-construido
    
    if (!ch_index) {
        assert (ch_fasta && ch_gtf), "If not using a pre-built index, a fasta and gtf reference files are required for running the FASTQ_ALIGN_STAR subworkflow"

        // Genera el índice del genoma con STAR
        STAR_GENOMEGENERATE(
            ch_fasta,
            ch_gtf
        )
    }
    ch_versions = ch_versions.mix(STAR_GENOMEGENERATE.out.versions)

    if (!ch_index) {
        assert (ch_fasta && ch_gtf), "If not using a pre-built index, a fasta and gtf reference files are required for running the FASTQ_ALIGN_STAR subworkflow"

        RSEM_PREPAREREFERENCE (ch_fasta, ch_gtf)
        ch_final_index = RSEM_PREPAREREFERENCE.out.index

    } else {
        ch_final_index = Channel.value(file(index))
    }

    ch_versions = ch_versions.mix(RSEM_PREPAREREFERENCE.out.versions)

    STAR_ALIGN ( 
        ch_reads,
        ch_final_index
    )

    //ch_versions = ch_versions.mix(STAR_ALIGN.out.versions)

    emit:
    index     = ch_final_index
    bam       = STAR_ALIGN.out.bam
    log_final = STAR_ALIGN.out.log_final
    versions  = ch_versions
    

}

