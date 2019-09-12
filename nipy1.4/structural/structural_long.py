# -*- coding: utf-8 -*-
"""
Created on Mon Feb  9 14:33:51 2015

@author: fbeyer
"""

'''
Main workflow for preprocessing of mprage data
===============================================
Uses file structure set up by conversion
'''
from nipype.pipeline.engine import Node, Workflow
import nipype.interfaces.io as nio
from reconall import create_reconall_pipeline
from mgzconvert import create_mgzconvert_pipeline
from ants import create_normalize_pipeline
import nipype.interfaces.utility as util


def create_structural():
 
    # main workflow
    struct_preproc = Workflow(name='anat_preproc')   
    #struct_preproc.config['execution']['crashdump_dir'] = struct_preproc.base_dir + "/crash_files"
    #inputnode
    inputnode=Node(util.IdentityInterface(fields=['subject','out_dir',
    'freesurfer_dir',
    'standard_brain'
    ]),
    name='inputnode')    
    
    #Use correct subject ID from long timepoint for MNI registration
    def change_subject_id(subject):
        import re
        [subj,ses]=re.split("_", subject)
    
        new_subject_id=subject+'.long.'+subj              
        return new_subject_id

    change_subject_id=Node(util.Function(input_names=["subject"],
              output_names=["new_subject_id"],
              function = change_subject_id), name="change_subject_id")
    
    outputnode=Node(util.IdentityInterface(fields=['brain','brainmask','anat2std_transforms','std2anat_transforms','anat2std',
                                                   'anat_head','wmseg','csfseg','wmedge', 'subject_id']),
    name='outputnode')      
    
    
    # workflow to get brain, head and wmseg from freesurfer and convert to nifti
    mgzconvert = create_mgzconvert_pipeline()
    
    normalize = create_normalize_pipeline()

    # sink to store files
    #sink = Node(nio.DataSink(parameterization=False,
    #                         substitutions=[
    #                             ('transform_Warped', 'T1_brain2mni')]),
    #            name='sink')

    # connections
    struct_preproc.connect(
        [(inputnode, change_subject_id,[('subject','subject')]),
         (change_subject_id, mgzconvert, [('new_subject_id', 'inputnode.fs_subject_id')]),
         (inputnode, mgzconvert, [('freesurfer_dir', 'inputnode.fs_subjects_dir')]),
         (inputnode, normalize, [('standard_brain', 'inputnode.standard')]),  
         (mgzconvert, normalize, [('outputnode.anat_brain', 'inputnode.anat')]),
         (normalize, outputnode, [('outputnode.anat2std', 'anat2std'),
                            ('outputnode.anat2std_transforms', 'anat2std_transforms'),
                            ('outputnode.std2anat_transforms', 'std2anat_transforms')]),
         (mgzconvert, outputnode, [('outputnode.anat_brain', 'brain')]),
         (mgzconvert, outputnode, [('outputnode.anat_brain_mask', 'brainmask')]),
         (mgzconvert, outputnode, [('outputnode.anat_head', 'anat_head')]),
         (mgzconvert, outputnode, [('outputnode.wmseg', 'wmseg')]),
         (mgzconvert, outputnode, [('outputnode.csfseg', 'csfseg')]),
         (mgzconvert, outputnode, [('outputnode.wmedge', 'wmedge')]),
         ])

    return struct_preproc