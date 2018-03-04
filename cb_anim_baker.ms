-- 3dsMax: Bake Animation Dialog 
-- By Carlos Breban
-- Use to match keyframes (baked) from one object to another on a given time range 
-- Also facilitates creating point cache
-- Usage: 
-- 	1. Load source and target nodes (selection based)
--	2. Change settings to your needs
--  3. Press "SHAKE & BAKE" button
--  OPTIONAL: press dropdown button "V" do show additional options

fn Cloner incNode = (	
	if(IsValidNode incNode)do(		
		local newNode	
		maxOps.CloneNodes incNode cloneType:#copy newNodes:&newNode
		if(newNode[1].modifiers.count>0)do
			for i =1 to newNode[1].modifiers.count do try(deleteModifier newNode[1] 1)catch()
		newNode.name = (incNode.name	+ "_pc")
	)
	return newNode	
)

	
fn PointCacheMaker incNode = (
	if(IsValidNode incNode)do(
		addModifier incNode (Point_Cache ())
		local cacheFile = cacheOps.RecordCache incNode.Point_Cache	
		if(cacheFile == false)do deleteModifier incNode 1
	)	
)	


fn XformBaker incSourceObj incTargetObj startTimeFrame endTimeFrame whichProg toolMode = (
	undo on(
		animate on(
			local totalLoops = endTimeFrame - startTimeFrame
			--TRANSFORM			
			if(toolMode[1] == 1)do(
				--WORLD				
				if(toolMode[2] == 1)do(	
					--ALL CONTROLLERS					
					if(toolMode[3] == true and toolMode[4] == true and toolMode[5] == true)then(
						for i = startTimeFrame to endTimeFrame do at time i (
							whichProg.value	=100.0*i/totalLoops
							incTargetObj.transform = incSourceObj.transform
						)
					)
					
					--POSITION
					if(toolMode[3] == true and toolMode[4] == false and toolMode[5] == false)then(
						for i = startTimeFrame to endTimeFrame do at time i (
							whichProg.value	=100.0*i/totalLoops
							incTargetObj.position = incSourceObj.position
						)
					)
					
					--POSITION, ROTATION		
					if(toolMode[3] == true and toolMode[4] == true and toolMode[5] == false)then(
						for i = startTimeFrame to endTimeFrame do at time i (
							whichProg.value	=100.0*i/totalLoops
							incTargetObj.position = incSourceObj.position
							local sourceRots = incSourceObj.transform.rotationpart as eulerangles	
							incTargetObj.rotation.x_rotation = sourceRots.x
							incTargetObj.rotation.y_rotation = sourceRots.y
							incTargetObj.rotation.z_rotation = sourceRots.z	
						)
					)
					
					--POSITION, SCALE
					if(toolMode[3] == true and toolMode[4] == false and toolMode[5] == true)then(
						for i = startTimeFrame to endTimeFrame do at time i (
							whichProg.value	=100.0*i/totalLoops
							incTargetObj.position = incSourceObj.position
							incTargetObj.scale = incSourceObj.scale
						)
					)	
					
					--ROTATION					
					if(toolMode[3] == false and toolMode[4] == true and toolMode[5] == false)then(
						for i = startTimeFrame to endTimeFrame do at time i (
							whichProg.value	=100.0*i/totalLoops
							local sourceRots = incSourceObj.transform.rotationpart as eulerangles	
							incTargetObj.rotation.x_rotation = sourceRots.x
							incTargetObj.rotation.y_rotation = sourceRots.y
							incTargetObj.rotation.z_rotation = sourceRots.z	
						)
					)
					
					--ROTATION, SCALE					
					if(toolMode[3] == false and toolMode[4] == true and toolMode[5] == true)then(
						for i = startTimeFrame to endTimeFrame do at time i (
							whichProg.value	=100.0*i/totalLoops
							local sourceRots = incSourceObj.transform.rotationpart as eulerangles	
							incTargetObj.rotation.x_rotation = sourceRots.x
							incTargetObj.rotation.y_rotation = sourceRots.y
							incTargetObj.rotation.z_rotation = sourceRots.z	
							incTargetObj.scale = incSourceObj.scale	
						)
					)
					
					--SCALE
					if(toolMode[3] == false and toolMode[4] == false and toolMode[5] == true)then(
						for i = startTimeFrame to endTimeFrame do at time i (
							whichProg.value	=100.0*i/totalLoops
							incTargetObj.scale = incSourceObj.scale
						)
					)	
				)
	
				--LOCAL				
				if(toolMode[2] == 2)do(	
					local srcParentXForm
					local trgParentXForm	
					local localXForm
						
					if(incSourceObj.parent == undefined )then srcParentXForm = Matrix3 1 
						else srcParentXForm = incSourceObj.parent.transform
						
					if(incTargetObj.parent == undefined )then trgParentXForm = Matrix3 1 
						else trgParentXForm = incTargetObj.parent.transform
						
					--POSITION, ROTATION, SCALE
					if(toolMode[3] == true and toolMode[4] == true and toolMode[5] == true)then(
						for i = startTimeFrame to endTimeFrame do at time i (
							whichProg.value	=100.0*i/totalLoops
							incTargetObj.transform = (incSourceObj.transform*inverse(srcParentXForm))*trgParentXForm
						)
					)
					
					--POSITION,
					if(toolMode[3] == true and toolMode[4] == false and toolMode[5] == false)then(
						for i = startTimeFrame to endTimeFrame do at time i (
							whichProg.value	=100.0*i/totalLoops
							localXForm = 	(incSourceObj.transform*inverse(srcParentXForm))*trgParentXForm
							incTargetObj.position = localXForm.position
						)
					)
						
					--POSITION, ROTATION,
					if(toolMode[3] == true and toolMode[4] == true and toolMode[5] == false)then(
						for i = startTimeFrame to endTimeFrame do at time i (
							whichProg.value	=100.0*i/totalLoops
							localXForm = 	(incSourceObj.transform*inverse(srcParentXForm))*trgParentXForm
							incTargetObj.position = localXForm.position
							incTargetObj.rotation.x_rotation = (localXForm.rotation as eulerangles).x		
							incTargetObj.rotation.y_rotation = (localXForm.rotation as eulerangles).y
							incTargetObj.rotation.z_rotation = (localXForm.rotation as eulerangles).z							
						)
					)	
					
					--POSITION SCALE
					if(toolMode[3] == true and toolMode[4] == false and toolMode[5] == true)then(
						for i = startTimeFrame to endTimeFrame do at time i (
							whichProg.value	=100.0*i/totalLoops
							localXForm = 	(incSourceObj.transform*inverse(srcParentXForm))*trgParentXForm
							incTargetObj.position = localXForm.position							
							incTargetObj.scale = localXForm.scale
						)
					)	
					
					--ROTATION,
					if(toolMode[3] == false and toolMode[4] == true and toolMode[5] == false)then(
						for i = startTimeFrame to endTimeFrame do at time i (
							whichProg.value	=100.0*i/totalLoops
							localXForm = 	(incSourceObj.transform*inverse(srcParentXForm))*trgParentXForm
							incTargetObj.rotation.x_rotation = (localXForm.rotation as eulerangles).x		
							incTargetObj.rotation.y_rotation = (localXForm.rotation as eulerangles).y
							incTargetObj.rotation.z_rotation = (localXForm.rotation as eulerangles).z				
						)
					)
					
					--ROTATION, SCALE
					if(toolMode[3] == false and toolMode[4] == true and toolMode[5] == true)then(
						for i = startTimeFrame to endTimeFrame do at time i (
							whichProg.value	=100.0*i/totalLoops
							localXForm = 	(incSourceObj.transform*inverse(srcParentXForm))*trgParentXForm
							incTargetObj.rotation.x_rotation = (localXForm.rotation as eulerangles).x		
							incTargetObj.rotation.y_rotation = (localXForm.rotation as eulerangles).y
							incTargetObj.rotation.z_rotation = (localXForm.rotation as eulerangles).z		
							incTargetObj.scale = localXForm.scale							
						)
					)
					
					--SCALE					
					if(toolMode[3] == false and toolMode[4] == false and toolMode[5] == true)then(
						for i = startTimeFrame to endTimeFrame do at time i (
							whichProg.value	=100.0*i/totalLoops
							localXForm = 	(incSourceObj.transform*inverse(srcParentXForm))*trgParentXForm
							incTargetObj.scale = localXForm.scale							
						)
					)				
				)
			)
		gc()
		)
	)
)	


FN VertBaker incSourceObj incTargetObj startTimeFrame endTimeFrame whichProg = (
	local totalLoops = endTimeFrame - startTimeFrame
	local incSrcObjClass = classof incSourceObj.baseObject
	local incTrgObjClass = classof incTargetObj.baseObject	
	if(incSrcObjClass	== Editable_Mesh)do incNodeVertCount = meshop.getNumVerts incSourceObj
	if(incSrcObjClass	== Editable_Poly)do incNodeVertCount = polyop.getNumVerts incSourceObj		
	if(incTrgObjClass	== Editable_Mesh)do targetVertCount = meshop.getNumVerts incTargetObj
	if(incTrgObjClass	== Editable_Poly)do targetVertCount = polyop.getNumVerts incTargetObj		
	if(incSrcObjClass !=	incTrgObjClass)do(
		if(incSrcObjClass	== Editable_Mesh)do convertTo incTargetObj Editable_Mesh
		if(incSrcObjClass	== Editable_Poly)do convertTo incTargetObj Editable_Poly	
	)
	
	undo on(	
		animate on(
			if(incNodeVertCount ==  targetVertCount)then(	
				--BOTH MESH					
				if(incSrcObjClass	== Editable_Mesh)do (	
					print "Both Editable Mesh..."	
					for i = startTimeFrame to endTimeFrame do at time i (
						for j= 1 to incNodeVertCount do(
							local vertPos = meshop.getvert incSourceObj j node:incSourceObj	
							meshop.setVert incTargetObj #{j} vertPos node:incTargetObj 	
						)	
						whichProg.value = 100.0*i/totalLoops							
					)
					gc()
				)
				
				--BOTH POLY				
				if(incSrcObjClass	== Editable_Poly)do (	
					print "Both Editable Poly..."	
					for i = startTimeFrame to endTimeFrame do at time i (
						for j = 1 to incNodeVertCount do(
							local vertPos = polyop.getvert incSourceObj j node:incSourceObj	
							polyop.setVert incTargetObj #{j} vertPos node:incTargetObj 
						)
						whichProg.value = 100.0*i/totalLoops	
					)	
					gc()
				)
			)
			else print "Vert count doesn't match."	
		)
	) 
)


if(objsToBake == undefined)do global objsToBake = #()
if(bakeDlgToolMode == undefined)do global bakeDlgToolMode = #(1,1,true,true,true,true)
if(BakerDialog == undefined)then(
	rollout BakerDialog "Bake Animation"(
		radioButtons rad_bakeMode labels:#("Transform","Verts") columns:2 pos:[10,10]  offsets:#([0,0], [0,0])
		on rad_bakeMode changed state do(
			bakeDlgToolMode[1]	= state
			if(state == 2)do(	
				BakerDialog.rad_xformSpace.enabled = false
				BakerDialog.chk_pos.enabled = false
				BakerDialog.chk_rot.enabled = false
				BakerDialog.chk_sca.enabled = false
				bakeDlgToolMode[6]	= false	
			)
			if(state == 1)do(	
				BakerDialog.rad_xformSpace.enabled = true
				BakerDialog.chk_pos.enabled = true
				BakerDialog.chk_rot.enabled = true
				BakerDialog.chk_sca.enabled = true	
				bakeDlgToolMode[6]	= true	
			)	
		)	
			
		radioButtons rad_xformSpace labels:#("World","Local") columns:2 pos:[10,30]  offsets:#([0,0], [13,0])
		on rad_xformSpace changed state do
			bakeDlgToolMode[2] = state				
			
		checkbox chk_pos "Pos" checked:true pos:[10,50]		
		on chk_pos changed state do
			bakeDlgToolMode[3] = state	
			
		checkbox chk_rot "Rot" checked:true pos:[50,50]	
		on chk_rot changed state do
			bakeDlgToolMode[4] = state	
			
		checkbox chk_sca "Sca" checked:true pos:[100,50]		
		on chk_sca changed state do
			bakeDlgToolMode[5] = state	
			
		button btn_sourceLoad "Load Source" width:130 pos:[10,70]
		editText edt_sourceObj "" fieldwidth:128 readonly:true pos:[btn_sourceLoad.pos.x-3,btn_sourceLoad.pos.y+25]
		on btn_sourceLoad pressed do(
			if(selection.count>0)do(
				BakerDialog.edt_sourceObj.text = selection[1].name
				objsToBake[1] = 	selection[1]
				BakerDialog.prg_progress.value = 0	
			)	
		)
			
		button btn_targetLoad "Load Target" width:130 pos:[edt_sourceObj.pos.x,edt_sourceObj.pos.y+25]		
		editText edt_targetObj "" fieldwidth:128 readonly:true pos:[btn_targetLoad.pos.x-3,btn_targetLoad.pos.y+25]
		on btn_targetLoad pressed do(
			if(selection.count>0)do(	
				BakerDialog.edt_targetObj.text = selection[1].name
				objsToBake[2] = selection[1]	
				BakerDialog.prg_progress.value = 0		
			)
		)	
		
		spinner spn_startTime "Start:" width:120 type:#integer range:[-1000000,1000000,0] pos:[0,edt_targetObj.pos.y+25]	
		spinner spn_endTime "End:" width:113 type:#integer range:[-1000000,1000000,0] pos:[7,edt_targetObj.pos.y+45]		
		button btn_matchTime "" width:15 height: 35 pos:[125,spn_startTime.pos.y]	
		on btn_matchTime pressed do(
			BakerDialog.spn_startTime.value =  ((animationrange.start as float)/TicksPerFrame) as integer
			BakerDialog.spn_endTime.value = ((animationrange.end as float)/TicksPerFrame) as integer		
		)
			
		progressBar prg_progress color:green width:130	height:15 pos:[10,spn_endTime.pos.y+20]

		button btn_goBake "SHAKE & BAKE" width:100 pos:[10,prg_progress.pos.y+20]	
		on btn_goBake pressed do(
			if(objsToBake != undefined and	objsToBake.count ==2)do(
				if(BakerDialog.rad_bakeMode.state == 1)do(
					XformBaker objsToBake[1] objsToBake[2] BakerDialog.spn_startTime.value BakerDialog.spn_endTime.value prg_progress bakeDlgToolMode 	
				)
				if(BakerDialog.rad_bakeMode.state == 2)do(
					VertBaker objsToBake[1] objsToBake[2] spn_startTime.value spn_endTime.value prg_progress
				)
			)
		)

		checkbutton btn_expand "v" width:30 highlightColor:green pos:[btn_goBake.pos.x+100,btn_goBake.pos.y] 
		on btn_expand changed theState do(
			if(theState == true)then BakerDialog.height = 350	
			else BakerDialog.height = 255	
		)

		button btn_clone "Clone Selected" width:130 pos:[10,btn_expand.pos.y+45]	
		on btn_clone pressed do(
			if(selection.count ==1)do (
				local clonedNode = Cloner selection[1]
				select clonedNode	
			)	
		)
			
		button btn_pointCache "Create Point Cache" width:130 pos:[btn_clone.pos.x,btn_clone.pos.y+25]
		on btn_pointCache pressed do(
			if(selection.count ==1)do PointCacheMaker selection[1]
		)
			
		button btn_deleteAnim "Delete Animation" width:130 pos:[btn_pointCache.pos.x,btn_pointCache.pos.y+25]	
		on btn_deleteAnim pressed do(
			if(selection.count ==1)do undo on(macros.run "Animation Tools" "DeleteSelectedAnimation")	
		)
			
		groupBox grp_pointCache "Point Cache" width:140 height:95 pos:[5,btn_expand.pos.y+25]	

	)
	
	try(destroyDialog BakerDialog)catch()
	createDialog BakerDialog width:150 height:255


	BakerDialog.spn_startTime.value =  ((animationrange.start as float)/TicksPerFrame) as integer
	BakerDialog.spn_endTime.value = ((animationrange.end as float)/TicksPerFrame) as integer

	BakerDialog.rad_bakeMode.state = bakeDlgToolMode[1]
	BakerDialog.rad_xformSpace.state = bakeDlgToolMode[2]
		BakerDialog.rad_xformSpace.enabled = bakeDlgToolMode[6]
	BakerDialog.chk_pos.checked = bakeDlgToolMode[3]
		BakerDialog.chk_pos.enabled = bakeDlgToolMode[6]
	BakerDialog.chk_rot.checked = bakeDlgToolMode[4]
		BakerDialog.chk_rot.enabled = bakeDlgToolMode[6]
	BakerDialog.chk_sca.checked = bakeDlgToolMode[5]
		BakerDialog.chk_sca.enabled = bakeDlgToolMode[6]

	if(objsToBake != undefined and objsToBake.count == 2)do(
		BakerDialog.edt_sourceObj.text = 	objsToBake[1].name		
		BakerDialog.edt_targetObj.text = 	objsToBake[2].name
	)
	clearListener()
)
else(
	try(destroyDialog BakerDialog)catch()
	createDialog BakerDialog width:150 height:255

	BakerDialog.spn_startTime.value =  ((animationrange.start as float)/TicksPerFrame) as integer
	BakerDialog.spn_endTime.value = ((animationrange.end as float)/TicksPerFrame) as integer

	BakerDialog.rad_bakeMode.state = bakeDlgToolMode[1]
	BakerDialog.rad_xformSpace.state = bakeDlgToolMode[2]
	BakerDialog.rad_xformSpace.enabled = bakeDlgToolMode[6]
	BakerDialog.chk_pos.checked = bakeDlgToolMode[3]
	BakerDialog.chk_pos.enabled = bakeDlgToolMode[6]
	BakerDialog.chk_rot.checked = bakeDlgToolMode[4]
	BakerDialog.chk_rot.enabled = bakeDlgToolMode[6]
	BakerDialog.chk_sca.checked = bakeDlgToolMode[5]
	BakerDialog.chk_sca.enabled = bakeDlgToolMode[6]

	if(objsToBake != undefined and objsToBake.count == 2 and isValidNode objsToBake[1] and isValidNode objsToBake[2])do(		
		BakerDialog.edt_sourceObj.text = objsToBake[1].name		
		BakerDialog.edt_targetObj.text = objsToBake[2].name
		)

	clearListener()
)
