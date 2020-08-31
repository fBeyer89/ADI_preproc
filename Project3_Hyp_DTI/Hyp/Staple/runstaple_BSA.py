# -*- coding: utf-8 -*-
"""
Created on Tue Jan  2 13:44:54 2018

@author: fbeyer
"""

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

sys.path.append('/data/pt_life_hypothalamus_segmentation/segmentation/Scripts/Staple/seg-apps')

#%working_dir = '/nobackup/aventurin4/data_fbeyer/multiatlas/labelfusion/staple/wd'
#os.makedirs(working_dir)
#out_dir='/nobackup/aventurin4/data_fbeyer/multiatlas/labelfusion/staple/output_STEPS_unc_true_rank_ALL'

data_dir = '/'
working_dir = '/nobackup/aventurin4/data_fbeyer/multiatlas/find_best_subjects/wd/'
out_dir = '/nobackup/aventurin4/data_fbeyer/multiatlas/find_best_subjects/results/labelfusionout/staple/'


staple_wf = Workflow(name='staple_wf')
staple_wf.base_dir=working_dir
staple_wf.config['execution']['crashdump_dir'] = staple_wf.base_dir + "/crash_files"


##selecting best subjects
all_subjects="/data/pt_life_hypothalamus_segmentation/segmentation/Subject_lists/atlas_with_325_participants/TEST_LIST_FOR_COMPARING_FINAL17.1_N47_for_20bestsubjects.txt"

with open(all_subjects, 'r') as f:
    allsubjects = [line.strip() for line in f]



info = dict(
    atlas_input=[['nobackup/aventurin4/data_fbeyer/multiatlas/','','find_best_subjects/results/transforms/','target_id','','/merged/anat_merged.nii.gz']],
    hyp_input=[['nobackup/aventurin4/data_fbeyer/multiatlas/find_best_subjects/results/transforms/','target_id','','/merged/','hemi','_merged.nii.gz']],
    orig=[['nobackup/aventurin4/data_fbeyer/','template_construction/btp_skullstripped_shorter/Subjects_T150/','target_id','/T150template0', 'target_id','_MPRAGE_t1_reorient_16bit_acpc_noz0_skullstrippedRepaired.nii.gz']],
    c1=[['data/pt_life_hypothalamus_segmentation/segmentation/Subjects/','target_id','/hypoth/c1MPRAGE_t1_reorient_16bit_acpc_noz0.nii','','','']]    
    )
    

datasource = Node(
    interface=nio.DataGrabber(infields=['target_id', 'hemi'], outfields=['atlas_input','hyp_input','orig','c1']),
    name='datasource')
datasource.inputs.base_directory = data_dir
#datasource.inputs.target_id= 'LI00651916' %'LI00145091' #iterables=[('target_id',allsubjects)] 
datasource.iterables=[('hemi',['lh','rh']), ('target_id', allsubjects)]
datasource.inputs.template = '%s%s%s%s%s%s'
datasource.inputs.template_args = info
datasource.inputs.sort_filelist = True  




                                            
                                   
                                            
binarize = Node(fsl.maths.MathsCommand(args='-bin'),
                                            name='binarize')
maths = Node(fsl.MultiImageMaths(op_string="-mul %s -thr 0.4 -bin"), name="maths")





staple = MapNode(niftyseg.LabelFusion(),name = 'staple', iterfield=['classifier_type'])
staple.inputs.classifier_type=['STEPS', 'STAPLE'] #'STAPLE'
staple.inputs.prob_flag=False#set to false for staple and steps
#staple.iterables=[('unc', [True,False]),('kernel_size',[1,2])] 
#KERNEL size doesn't seem to make a difference
#unc should be set to true
staple.inputs.unc=True
staple.inputs.kernel_size=3
#for STEPS input
staple.iterables=[('template_num', [10,43])]
#template number does not make a large difference.
#inputs.template_num=43
staple.inputs.sm_ranking='LNCC' # <k> <n> <img> <tmpl>



	
sink = Node(nio.DataSink(parameterization=True,
base_directory=out_dir,substitutions=[('_staple0', 'steps'),('_staple1','staple'), \
('lh_merged_maths_maths_steps','lh_hyp_steps'), \
('rh_merged_maths_maths_steps','rh_hyp_steps'), \
('lh_merged_maths_maths_staple','lh_hyp_staple'), \
('rh_merged_maths_maths_staple','rh_hyp_staple'), \
('_template_num_10','atlas_n10'),\
('_template_num_43','atlas_n43'),\
('_hemi_lh_','lh_'),\
('_hemi_rh_','rh_')]),
name='sink')

staple_wf.connect([
(datasource, binarize, [('hyp_input', 'in_file')]),
(binarize, maths, [('out_file', 'in_file')]),
(datasource, maths, [('c1','operand_files')]),
(maths, staple, [('out_file', 'in_file')]), 
(datasource, staple, [('orig','file_to_seg')]),
(datasource, staple, [('atlas_input','template_file')]),
(staple, sink, [('out_file', 'out_label')])
])

staple_wf.run(plugin='MultiProc')#plugin='CondorDAGMan')#plugin='MultiProc') #)#)#