/*
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    NANOPORE CANCER ANALYSIS WORKFLOW
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
*/

// Include modules here as you develop them
// include { MODULE_NAME } from '../modules/local/module_name'
include { PREPARE_GENOME } from '../modules/local/prepare_genome'

workflow NANOPORE_CANCER {
    
    take:
        // Define inputs here when you add them
        ch_samplesheet // channel: samplesheet read in from --input
    
    main:
        ch_versions = Channel.empty()
        //
        // SUBWORKFLOW: Prepare reference genome
        //
        if (params.fasta) {
            // User provided custom reference
            ch_fasta = Channel.fromPath(params.fasta, checkIfExists: true)
            ch_gtf   = params.gtf ? Channel.fromPath(params.gtf, checkIfExists: true) : Channel.empty()
            ch_gff   = params.gff ? Channel.fromPath(params.gff, checkIfExists: true) : Channel.empty()
        } else {
            // Use default genome from params.genomes
            genome_url = params.genomes[params.genome].fasta
        
            PREPARE_GENOME(
                params.genome,
                genome_url
            )
        
            ch_fasta = PREPARE_GENOME.out.fasta
            ch_gtf   = PREPARE_GENOME.out.gtf
            ch_gff   = PREPARE_GENOME.out.gff
            ch_versions = ch_versions.mix(PREPARE_GENOME.out.versions)
        }
    
        //
        // Print information about samples and reference
        //
        ch_samplesheet
            .map { 
                log.info "Sample: ${it.sample_id}, FastQ: ${it.fastq_path}"
                return it
            }
            .set { ch_samples }
    
        ch_fasta.view { "Reference FASTA: $it" }
        ch_gtf.view { "Reference GTF: $it" }
    
    emit:
        // Define outputs here as you develop them
        // results = MODULE_NAME.out.results
        fasta    = ch_fasta
        gtf      = ch_gtf  
        gff      = ch_gff
        versions = ch_versions

        // Create input channel from samplesheet
        ch_input = Channel.fromPath(params.input, checkIfExists: true)
            .splitCsv(header: true)
            .map { row -> 
                [row.sample_id, file(row.fastq_path, checkIfExists: true)]
            }
    
        // Placeholder for your analysis steps
        // As you develop modules, add them here:
        // MODULE_NAME(ch_input)
    
        // For now, just print the input to verify it works
        ch_input.view { sample_id, fastq -> 
            "Sample: ${sample_id}, FASTQ: ${fastq}" 
        }
}