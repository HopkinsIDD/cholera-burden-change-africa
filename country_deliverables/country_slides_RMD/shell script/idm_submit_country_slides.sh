#!/bin/bash
#SBATCH --job-name=country_slides
#SBATCH --output=sbatch_log/country_slides_%A_%a.log
#SBATCH --time=30-00:00
#SBATCH --mem=2G
#SBATCH --array=0%1
#SBATCH --nodelist=idmodeling2
#SBATCH -c 4

echo "Beginning of script"
date
TAXDIR=/home/cholera-mapping-pipeline #specify here
CONFIGDIR=Analysis/configs #specify a folder that has all the configs 
RSCRIPT=/opt/R/4.0.3/bin/Rscript

cd $TAXDIR
CONFIGNAMES=($(ls $TAXDIR/$CONFIGDIR | tr ' ' '\n'))

$RSCRIPT -e "
pandoc::pandoc_activate(version='2.7.3')
rmarkdown::render('Analysis/output/country_slides_0110.Rmd', 
                  params = list(cholera_directory = '$TAXDIR', config = '$CONFIGDIR/${CONFIGNAMES[$SLURM_ARRAY_TASK_ID]}'), 
                  output_file = paste0('country_slides_',yaml::read_yaml(paste0('$TAXDIR', '/', '$CONFIGDIR/${CONFIGNAMES[$SLURM_ARRAY_TASK_ID]}'))[['countries_name']],'.pptx')
                  ) " || exit 1

echo "End of script"
date
