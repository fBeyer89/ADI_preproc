# -*- coding: utf-8 -*-
"""
Created on Mon Feb  9 12:26:20 2015

@author: fbeyer
"""

from nipype.pipeline.engine import Node, Workflow
import nipype.interfaces.utility as util
import nipype.interfaces.fsl as fsl
import nipype.interfaces.freesurfer as fs


'''
Main workflow to correct freesurfer output
====================================================
'''

fsl.FSLCommand.set_default_output_type('NIFTI_GZ')
wd="/data/pt_02161/wd/"
fs_dir="/data/p_02161/ADI_studie/BIDS/derivatives/freesurfer/"


subjectlist=['ADI004_fu2','ADI006_bl','ADI006_fu2','ADI006_fu','ADI008_bl','ADI009_bl', 
 'ADI009_fu', 'ADI013_bl', 'ADI013_fu', 'ADI013_fu2',
 'ADI025_bl', 'ADI025_fu','ADI026_bl','ADI029_fu','ADI029_fu2','ADI032_bl' ,
 'ADI036_bl', 'ADI036_fu2', 'ADI041_fu','ADI045_bl','ADI045_fu','ADI045_fu2',
 'ADI047_fu','ADI047_fu2','ADI048_bl','ADI048_fu','ADI048_fu2',
 'ADI063_fu','ADI064_bl','ADI068_bl','ADI068_fu',
 'ADI068_fu2','ADI069_bl','ADI069_fu','ADI072_bl','ADI072_fu','ADI072_fu2',
 'ADI080_bl','ADI087_fu','ADI087_fu2','ADI088_fu','ADI089_bl','ADI091_fu',
 'ADI097_bl','ADI097_fu','ADI097_fu2','ADI102_bl','ADI102_fu','ADI107_bl',
 'ADI107_fu','ADI118_bl','ADI124_fu2','ADI136_bl']

#['ADI063_bl']
# main workflow
fs_rerun = Workflow(name='fs_rerun')
fs_rerun.base_dir = wd
fs_rerun.config['execution']['crashdump_dir'] = fs_rerun.base_dir + "/crash_files"



subjects_node = Node(name="subs_node",
            interface=util.IdentityInterface(
                    fields=["subject"]))
subjects_node.iterables = ("subject", subjectlist)

# run reconall
recon_all = Node(fs.ReconAll(directive="autorecon-pial", parallel=True, openmp=4), #correct wrong pial placement.
name="recon_all")
recon_all.inputs.subjects_dir=fs_dir

fs_rerun.plugin_args={'submit_specs': 'request_memory = 9000'}
fs_rerun.connect([
        (subjects_node, recon_all, [('subject',  'subject_id')])
])



fs_rerun.write_graph(dotfilename='direct_preproc.dot', graph2use='colored', format='pdf', simple_form=True)
fs_rerun.run(plugin='MultiProc', plugin_args={'initial_specs': 'request_memory = 1500'})
#fs_rerun.run(plugin='CondorDAGMan', plugin_args={'initial_specs': 'request_memory = 1500'})
    
    #
