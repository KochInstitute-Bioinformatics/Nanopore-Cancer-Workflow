/*
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    NANOPORE CANCER ANALYSIS WORKFLOW
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
*/

// Include modules here as you develop them
// include { MODULE_NAME } from '../modules/local/module_name'

workflow NANOPORE_CANCER {
    
    take:
    // Define inputs here when you add them
    
    main:
    
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
    
    emit:
    // Define outputs here as you develop them
    // results = MODULE_NAME.out.results
}