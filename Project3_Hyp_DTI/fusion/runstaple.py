# -*- coding: utf-8 -*-
"""
Created on Mon Feb  9 12:27:06 2015

@author: fbeyer
"""
'''
Workflow to run staple algorithm
'''
import sys
import os
from nipype.pipeline.engine import MapNode, Node, Workflow
import nipype.interfaces.utility as util
import nipype.interfaces.fsl as fsl
import nipype.interfaces.ants as ants
import nipype.interfaces.utility as util
from nipype.interfaces import niftyseg
import nipype.interfaces.io as nio
from nipype.interfaces.io import DataFinder


##USE environment newpy2 for these function.
##Here, you need to append the path to the "seg-apps"-folder from niftyseg (https://github.com/KCL-BMEIS/NiftySeg)
#This folder contains the function seg_LabFusion which is
#wrapped by the nipype package: https://nipype.readthedocs.io/en/latest/interfaces/generated/interfaces.niftyseg/label_fusion.html#labelfusion
sys.path.append('/data/pt_life_hypothalamus_segmentation/segmentation/scripts/multiatlas_segmentation/post_labelfusion/Staple/seg-apps')
print(sys.path)

#first merge the outputfiles from the labelpropagation step (replace bash-script)
data_dir="/data/pt_02161/"
working_dir = '/data/pt_02161/wd/'
out_dir = '/data/pt_02161/preprocessed/hypothalamus/'

##selecting target subjects for which the hypothalami should be fusioned
#all_subjects="/data/pt_02161/hypothalamus_segmentation/scripts/testlist.txt"
#
#with open(all_subjects, 'r') as f:
#    targetsubjects = [line.strip() for line in f]

targetsubjects=["ADI014_fu"]

def create_regexp(subject, image_type, side):
    if image_type=="hyp":
            regex='preprocessed/hypothalamus/preprocessing/warped/%s/%s/coreg_atlas_*/Hyp_%s/*_hyp_%s_swapped_RAS_trans.nii.gz' %(subject, subject, side, side)
    else:
            regex='preprocessed/hypothalamus/preprocessing/warped/%s/%s/coreg_atlas_*/anat/*_MPRAGE_t1_reorient_16bit_acpc_noz0_skullstrippedRepaired_trans.nii.gz' %(subject, subject)
    return regex

regexp_anat=Node(util.Function(input_names=['subject', "image_type", "side"], 
                            output_names=['regex'],
                            function = create_regexp), name="regexp_anat")  
regexp_anat.inputs.image_type="anat"
regexp_anat.inputs.side="xx"
regexp_anat.iterables=[("subject", targetsubjects)]


regexp_hyp=Node(util.Function(input_names=['subject', "image_type", "side"], 
                            output_names=['regex'],
                            function = create_regexp), name="regexp_hyp")  
regexp_hyp.inputs.image_type="hyp"
regexp_hyp.iterables=[("subject", targetsubjects),('side', ['re', 'li'])]


datasource_anat = Node(nio.DataGrabber(sort_filelist = True), name='datasource_anat')
datasource_anat.inputs.base_directory = data_dir

datasource_hyp = Node(nio.DataGrabber(sort_filelist = True), name='datasource_hyp')
datasource_hyp.inputs.base_directory = data_dir

###########################################################################
merge_anat=Node(fsl.Merge(dimension='t'), name="merge_anat")
merge_hyp=Node(fsl.Merge(dimension='t'), name="merge_hyp")

#need to binarize hyp
bin_hyp=Node(fsl.ImageMaths(op_string='-bin'), name='bin_hyp')

staple_wf = Workflow(name='staple_wf')
staple_wf.base_dir=working_dir
staple_wf.config['execution']['crashdump_dir'] = staple_wf.base_dir + "/crash_files"


info = dict(
    orig=[['preprocessed/hypothalamus/preprocessing/orig/', 'subject', '/', 'subject', '/brainmask_out.nii.gz']]   
    )

datasource = Node(
    interface=nio.DataGrabber(infields=['subject'], outfields=['orig']),
    name='datasource')
datasource.inputs.base_directory = data_dir
datasource.iterables=[('subject', targetsubjects)]
datasource.inputs.template = '%s%s%s%s%s'
datasource.inputs.template_args = info
datasource.inputs.sort_filelist = True  

staple = MapNode(niftyseg.LabelFusion(),name = 'staple', iterfield=['classifier_type'])
staple.inputs.classifier_type=['STAPLE'] 
staple.inputs.prob_flag=False
staple.inputs.unc=True
staple.inputs.kernel_size=3
staple.inputs.template_num=44
staple.inputs.sm_ranking='LNCC'



	
sink = Node(nio.DataSink(parameterization=True,
base_directory=out_dir,substitutions=[
('lh_merged_maths_maths_steps','lh_hyp_steps'), \
('rh_merged_maths_maths_steps','rh_hyp_steps'), \
('lh_merged_maths_maths_staple','lh_hyp_staple'), \
('rh_merged_maths_maths_staple','rh_hyp_staple'), \
('_hemi_lh_','lh_'),\
('_hemi_rh_','rh_'),\
('subject_', ''),\
('subj1_', ''),\
('_side_',''), \
('_staple0', 'staple'),('_staple1','staple'), \
('_swapped_RAS_trans_merged_maths_staple','')]),
name='sink')


staple_wf.connect([
(regexp_anat, datasource_anat, [('regex', 'template')]),
(datasource_anat, merge_anat, [('outfiles', 'in_files')]),
(regexp_hyp, datasource_hyp, [('regex', 'template')]),
(datasource_hyp, merge_hyp, [('outfiles', 'in_files')]),
(merge_hyp, bin_hyp, [('merged_file', 'in_file')]),
(bin_hyp, staple, [('out_file', 'in_file')]),
(datasource, staple, [('orig','file_to_seg')]),
(merge_anat, staple, [('merged_file','template_file')]),
(staple, sink, [('out_file', 'preprocessing.staple.out_label')])
])

staple_wf.run(plugin='MultiProc')#plugin='CondorDAGMan')#plugin='MultiProc') #)#)#
