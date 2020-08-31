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
from nipype import SelectFiles
import nipype.interfaces.io as nio

data_dir = '/nobackup/aventurin4/data_fbeyer/'
working_dir = '/nobackup/aventurin4/data_fbeyer/multiatlas/intermediate_template/wd/'
out_dir = '/nobackup/aventurin4/data_fbeyer/multiatlas/intermediate_template/labelfusionout/'

labelfusion = Workflow(name='labelfusion')   
labelfusion.base_dir = working_dir
labelfusion.config['execution']['crashdump_dir'] = labelfusion.base_dir + "/crash_files"


##selecting best subjects
all_subjects="/data/pt_life_hypothalamus_segmentation/segmentation/Subject_lists/atlas_with_325_participants/TEST_LIST_FOR_COMPARING_FINAL17.1_wo_4excluded.txt"
with open(all_subjects, 'r') as f:
    allsubjects = [line.strip() for line in f]




info = dict(
    atlas_input=[['','','multiatlas/intermediate_template/output/warpedhyp_per_subject/','target_id','/merged/anat_merged.nii.gz']],
    hyp_input=[['','','multiatlas/intermediate_template/output/warpedhyp_per_subject/','target_id','/merged/anat_merged.nii.gz']],
    orig=[['template_construction/btp_skullstripped_shorter/Subjects_T150/','target_id','/T150template0', 'target_id','_MPRAGE_t1_reorient_16bit_acpc_noz0_skullstrippedRepaired.nii.gz']]
    )
    
    
split1=Node(interface=fsl.Split(dimension='t'),  name="split1")   
split2=Node(interface=fsl.Split(dimension='t'),  name="split2")   
datasource = Node(
    interface=nio.DataGrabber(infields=['target_id'], outfields=['atlas_input','hyp_input','orig']),
    name='datasource')
datasource.inputs.base_directory = data_dir
datasource.inputs.target_id= 'LI00064232' #iterables=[('target_id',allsubjects)] 
datasource.inputs.template = '%s%s%s%s%s'
datasource.inputs.template_args = info
datasource.inputs.sort_filelist = True    



templates = dict(orig='template_construction/btp_skullstripped_shorter/Subjects_T150/{target_id}/T150template0{target_id}_MPRAGE_t1_reorient_16bit_acpc_noz0_skullstrippedRepaired.nii.gz')
sf = Node(interface=SelectFiles(templates), name="sf")
sf.inputs.force_lists=["orig"]
sf.inputs.target_id='LI00651916'
sf.inputs.base_directory=data_dir



antsjointfusion=Node(interface=ants.AntsJointFusion(), name="antsjointfusion")


labelfusion.connect(
[
(datasource, split1,[('atlas_input', 'in_file')]),
(split1,antsjointfusion, [('out_files', 'atlas_image')]),
(datasource, split2,[('hyp_input', 'in_file')]),
(split2,antsjointfusion, [('out_files', 'atlas_segmentation_image')]),
(sf, antsjointfusion, [('orig', 'target_image')])
])

labelfusion.run()

#sys.path.append('/data/pt_life_hypothalamus_segmentation/segmentation/Scripts/Staple/seg-apps')
#
#working_dir = '/nobackup/aventurin4/data_fbeyer/multiatlas/labelfusion/staple/wd'
##os.makedirs(working_dir)
#out_dir='/nobackup/aventurin4/data_fbeyer/multiatlas/labelfusion/staple/output_STEPS_unc_true_rank_ALL'
#
#staple_wf = Workflow(name='staple_wf')
#staple_wf.base_dir=working_dir
#
#
#staple = Node(niftyseg.LabelFusion(),name = 'staple')
#staple.inputs.classifier_type='STEPS' #'STAPLE'
#staple.inputs.in_file="/data/pt_life_hypothalamus_segmentation/segmentation/Subjects/LI00000031/coregisteredHYP/merged_li_HYP_bin.nii.gz"  
#staple.inputs.file_to_seg="/data/pt_life_hypothalamus_segmentation/segmentation/Subjects/LI00000031/hypoth/MPRAGE_t1_reorient_16bit_acpc_noz0_skullstripped.nii.gz"
#staple.inputs.prob_flag=False#set to false for staple and steps
#staple.inputs.unc=True#doesn't make a difference
##for STEPS input
#staple.inputs.template_file="/nobackup/aventurin4/data_fbeyer/multiatlas/labelfusion/staple/coregimages.nii.gz"
#staple.inputs.kernel_size=3
#staple.inputs.template_num=20
#staple.inputs.sm_ranking='ALL' #'GNCC' #-LNCC <k> <n> <img> <tmpl>
#	
#sink = Node(nio.DataSink(parameterization=False,
#base_directory=out_dir,
#substitutions=[]),
#name='sink')
#
#staple_wf.connect([
#(staple, sink, [('out_file', 'out_label')])
#])
#
#staple_wf.run(plugin='CondorDAGMan')#plugin='MultiProc') #)#)#