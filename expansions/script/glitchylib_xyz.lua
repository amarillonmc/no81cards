if EFFECT_ALLOW_EXTRA_XYZ_MATERIAL then return end

EFFECT_ALLOW_EXTRA_XYZ_MATERIAL = 33720330
--EFFECT_EXTRA_XYZ_MATERIAL		= will be implemented when needed

EVENT_XYZATTACH					= EVENT_CUSTOM+33720369

local add_xyz_proc, add_xyz_proc_nlv, duel_overlay, card_is_xyz_level, duel_check_xyz_mat, duel_select_xyz_mat, _XyzLevelFreeGoal =
Auxiliary.AddXyzProcedure, Auxiliary.AddXyzProcedureLevelFree, Duel.Overlay, Card.IsXyzLevel, Duel.CheckXyzMaterial, Duel.SelectXyzMaterial, Auxiliary.XyzLevelFreeGoal

Duel.Overlay=function(xyz,mat)
	local og,oct
	if xyz:IsLocation(LOCATION_MZONE) then
		og=xyz:GetOverlayGroup()
		oct=#og
	end
	local res=duel_overlay(xyz,mat)
	if oct and xyz:GetOverlayCount()>oct then
		Duel.RaiseEvent(mat,EVENT_XYZATTACH,nil,0,0,xyz:GetControler(),xyz:GetOverlayCount()-oct)
	end
	return res
end

--

function Auxiliary.XyzMaterialComplete(c,sc,lv,tp)
	if not c:IsCanBeXyzMaterial(sc) then return false end
	if c:IsLocation(LOCATION_MZONE) then
		return c:IsFaceup() and (c:IsControler(tp) or c:IsHasEffect(EFFECT_XYZ_MATERIAL))
	else
		for _,ce in ipairs({sc:IsHasEffect(EFFECT_ALLOW_EXTRA_XYZ_MATERIAL)}) do
			local val=ce:Evaluate(c,sc)
			if val then
				return true
			end
		end
		-- for _,ce in ipairs({c:IsHasEffect(EFFECT_EXTRA_XYZ_MATERIAL)}) do
			-- local val=ce:Evaluate(c,sc,tp)
			-- if val then
				-- return true
			-- end
		-- end
		return false
	end
end
Duel.CheckXyzMaterial=function(sc,f,lv,min,max,mg)
	local res=duel_check_xyz_mat(sc,f,lv,min,max,mg)
	if mg~=nil then return res end
	if res then
		return true
	elseif self_reference_effect then
		local extramats=Duel.GetMatchingGroup(Auxiliary.XyzMaterialComplete,0,0xff,0xff,nil,sc,lv,self_reference_effect:GetHandlerPlayer())
		return duel_check_xyz_mat(sc,f,lv,min,max,extramats)
	end
	return res
end
Duel.SelectXyzMaterial=function(p,sc,f,lv,min,max,mg)
	if mg~=nil then
		return duel_select_xyz_mat(p,sc,f,lv,min,max,mg)
	else
		local extramats=Duel.GetMatchingGroup(Auxiliary.XyzMaterialComplete,0,0xff,0xff,nil,sc,lv,p)
		return duel_select_xyz_mat(p,sc,f,lv,min,max,extramats)
	end
end

Auxiliary.XyzLevelFreeGoal = function(g,tp,xyzc,gf)
	return (not gf or gf(g,tp,xyzc)) and Duel.GetLocationCountFromEx(tp,tp,g,xyzc)>0
end

--Regular Xyz Procedure mods
local _XyzConditionAlter, _XyzTargetAlter = Auxiliary.XyzConditionAlter, Auxiliary.XyzTargetAlter

function Auxiliary.XyzConditionAlter(f,lv,minct,maxct,alterf,alterdesc,alterop)
	return	function(e,c,og,min,max)
				if not aux.EnableXyzMods then
					return _XyzConditionAlter(f,lv,minct,maxct,alterf,alterdesc,alterop)(e,c,og,min,max)
				end
				if c==nil then return true end
				if c:IsType(TYPE_PENDULUM) and c:IsFaceup() then return false end
				local tp=c:GetControler()
				local mg=nil
				if og then
					mg=og
				else
					mg=Duel.GetFieldGroup(tp,LOCATION_MZONE,0)
				end
				
				--Handle extra Xyz Materials
				aux.IsUsingAlternativeXyzProcedure=true
				local exg=Duel.GetMatchingGroup(aux.ExtraXyzMaterialFilter,tp,LOCATION_ALL,LOCATION_ALL,nil,c,tp)
				if #exg>0 then
					mg:Merge(exg)
				end
				aux.IsUsingAlternativeXyzProcedure=false
				
				if (not min or min<=1) and mg:IsExists(Auxiliary.XyzAlterFilter,1,nil,alterf,c,e,tp,alterop) then
					return true
				end
				local minc=minct
				local maxc=maxct
				if min then
					if min>minc then minc=min end
					if max<maxc then maxc=max end
					if minc>maxc then return false end
				end
				return Duel.CheckXyzMaterial(c,f,lv,minc,maxc,og)
			end
end
function Auxiliary.XyzTargetAlter(f,lv,minct,maxct,alterf,alterdesc,alterop)
	return	function(e,tp,eg,ep,ev,re,r,rp,chk,c,og,min,max)
				if not aux.EnableXyzMods then
					return _XyzTargetAlter(f,lv,minct,maxct,alterf,alterdesc,alterop)(e,tp,eg,ep,ev,re,r,rp,chk,c,og,min,max)
				end
				if og and not min then
					return true
				end
				local minc=minct
				local maxc=maxct
				if min then
					if min>minc then minc=min end
					if max<maxc then maxc=max end
				end
				local mg=nil
				if og then
					mg=og
				else
					mg=Duel.GetFieldGroup(tp,LOCATION_MZONE,0)
				end
				
				aux.IsUsingAlternativeXyzProcedure=true
				--Handle extra Xyz Materials
				local exg=Duel.GetMatchingGroup(aux.ExtraXyzMaterialFilter,tp,LOCATION_ALL,LOCATION_ALL,nil,c,tp)
				if #exg>0 then
					mg:Merge(exg)
				end
				aux.IsUsingAlternativeXyzProcedure=false
				--
				
				local altg=mg:Filter(Auxiliary.XyzAlterFilter,nil,alterf,c,e,tp,alterop)
				local b1=Duel.CheckXyzMaterial(c,f,lv,minc,maxc,og)
				local b2=(not min or min<=1) and #altg>0
				local g=nil
				local cancel=Duel.IsSummonCancelable()
				if b2 and (not b1 or Duel.SelectYesNo(tp,alterdesc)) then
					aux.IsUsingAlternativeXyzProcedure=true
					e:SetLabel(1)
					Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
					local tc=altg:SelectUnselect(nil,tp,false,cancel,1,1)
					if tc then
						g=Group.FromCards(tc)
						if alterop then alterop(e,tp,1,tc) end
					end
					aux.IsUsingAlternativeXyzProcedure=false
				else
					e:SetLabel(0)
					g=Duel.SelectXyzMaterial(tp,c,f,lv,minc,maxc,og)
				end
				if g then
					g:KeepAlive()
					e:SetLabelObject(g)
					return true
				else return false end
			end
end

--LevelFree Procedure Mods
local _XyzLevelFreeCondition, _XyzLevelFreeTarget, _XyzLevelFreeConditionAlter, _XyzLevelFreeTargetAlter =
Auxiliary.XyzLevelFreeCondition, Auxiliary.XyzLevelFreeTarget, Auxiliary.XyzLevelFreeConditionAlter, Auxiliary.XyzLevelFreeTargetAlter

function Auxiliary.ExtraXyzMaterialFilter(c,xyzc,tp)
	if not c:IsCanBeXyzMaterial(xyzc) then return false end
	for _,ce in ipairs({xyzc:IsHasEffect(EFFECT_ALLOW_EXTRA_XYZ_MATERIAL)}) do
		local val=ce:Evaluate(c,xyzc,tp)
		if val then
			return true
		end
	end
	-- for _,ce in ipairs({c:IsHasEffect(EFFECT_EXTRA_XYZ_MATERIAL)}) do
		-- local val=ce:Evaluate(c,xyzc,tp)
		-- if val then
			-- return true
		-- end
	-- end
	return false
end

function Auxiliary.XyzLevelFreeCondition(f,gf,minct,maxct)
	return	function(e,c,og,min,max)
				if not aux.EnableXyzLevelFreeMods then
					return _XyzLevelFreeCondition(f,gf,minct,maxct)(e,c,og,min,max)
				end
				if c==nil then return true end
				if c:IsType(TYPE_PENDULUM) and c:IsFaceup() then return false end
				local tp=c:GetControler()
				local minc=minct
				local maxc=maxct
				if min then
					minc=math.max(minc,min)
					maxc=math.min(maxc,max)
				end
				if maxc<minc then return false end
				local mg=nil
				if og then
					mg=og:Filter(Auxiliary.XyzLevelFreeFilter,nil,c,f)
				else
					mg=Duel.GetMatchingGroup(Auxiliary.XyzLevelFreeFilter,tp,LOCATION_MZONE,0,nil,c,f)
				end
				
				--Handle extra Xyz Materials
				local exg=Duel.GetMatchingGroup(aux.ExtraXyzMaterialFilter,tp,LOCATION_ALL,LOCATION_ALL,nil,c,tp)
				if #exg>0 then
					mg:Merge(exg)
				end
				
				--
				
				local sg=Duel.GetMustMaterial(tp,EFFECT_MUST_BE_XMATERIAL)
				if sg:IsExists(Auxiliary.MustMaterialCounterFilter,1,nil,mg) then return false end
				Duel.SetSelectedCard(sg)
				Auxiliary.GCheckAdditional=Auxiliary.TuneMagicianCheckAdditionalX(EFFECT_TUNE_MAGICIAN_X)
				local res=mg:CheckSubGroup(Auxiliary.XyzLevelFreeGoal,minc,maxc,tp,c,gf)
				Auxiliary.GCheckAdditional=nil
				return res
			end
end
function Auxiliary.XyzLevelFreeConditionAlter(f,gf,minct,maxct,alterf,alterdesc,alterop)
	return	function(e,c,og,min,max)
				if not aux.EnableXyzLevelFreeMods then
					return _XyzLevelFreeConditionAlter(f,gf,minct,maxct,alterf,alterdesc,alterop)(e,c,og,min,max)
				end
				if c==nil then return true end
				if c:IsType(TYPE_PENDULUM) and c:IsFaceup() then return false end
				local tp=c:GetControler()
				local mg=nil
				if og then
					mg=og
				else
					mg=Duel.GetFieldGroup(tp,LOCATION_MZONE,0)
				end
				
				--Handle extra Xyz Materials
				aux.IsUsingAlternativeXyzProcedure=true
				local exg=Duel.GetMatchingGroup(aux.ExtraXyzMaterialFilter,tp,LOCATION_ALL,LOCATION_ALL,nil,c,tp)
				if #exg>0 then
					mg:Merge(exg)
				end
				aux.IsUsingAlternativeXyzProcedure=false
				
				local altg=mg:Filter(Auxiliary.XyzAlterFilter,nil,alterf,c,e,tp,alterop)
				if (not min or min<=1) and altg:GetCount()>0 then
					return true
				end
				local minc=minct
				local maxc=maxct
				if min then
					if min>minc then minc=min end
					if max<maxc then maxc=max end
					if minc>maxc then return false end
				end
				mg=mg:Filter(Auxiliary.XyzLevelFreeFilter,nil,c,f)
				local sg=Duel.GetMustMaterial(tp,EFFECT_MUST_BE_XMATERIAL)
				if sg:IsExists(Auxiliary.MustMaterialCounterFilter,1,nil,mg) then return false end
				Duel.SetSelectedCard(sg)
				Auxiliary.GCheckAdditional=Auxiliary.TuneMagicianCheckAdditionalX(EFFECT_TUNE_MAGICIAN_X)
				local res=mg:CheckSubGroup(Auxiliary.XyzLevelFreeGoal,minc,maxc,tp,c,gf)
				Auxiliary.GCheckAdditional=nil
				return res
			end
end
function Auxiliary.XyzLevelFreeTarget(f,gf,minct,maxct)
	return	function(e,tp,eg,ep,ev,re,r,rp,chk,c,og,min,max)
				if not aux.EnableXyzLevelFreeMods then
					return _XyzLevelFreeTarget(f,gf,minct,maxct)(e,tp,eg,ep,ev,re,r,rp,chk,c,og,min,max)
				end
				if og and not min then
					return true
				end
				local minc=minct
				local maxc=maxct
				if min then
					if min>minc then minc=min end
					if max<maxc then maxc=max end
				end
				local mg=nil
				if og then
					mg=og:Filter(Auxiliary.XyzLevelFreeFilter,nil,c,f)
				else
					mg=Duel.GetMatchingGroup(Auxiliary.XyzLevelFreeFilter,tp,LOCATION_MZONE,0,nil,c,f)
				end
				
				--Handle extra Xyz Materials
				local exg=Duel.GetMatchingGroup(aux.ExtraXyzMaterialFilter,tp,LOCATION_ALL,LOCATION_ALL,nil,c,tp)
				if #exg>0 then
					mg:Merge(exg)
				end
				--
				
				local sg=Duel.GetMustMaterial(tp,EFFECT_MUST_BE_XMATERIAL)
				Duel.SetSelectedCard(sg)
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
				local cancel=Duel.IsSummonCancelable()
				Auxiliary.GCheckAdditional=Auxiliary.TuneMagicianCheckAdditionalX(EFFECT_TUNE_MAGICIAN_X)
				local g=mg:SelectSubGroup(tp,Auxiliary.XyzLevelFreeGoal,cancel,minc,maxc,tp,c,gf)
				Auxiliary.GCheckAdditional=nil
				if g and g:GetCount()>0 then
					g:KeepAlive()
					e:SetLabelObject(g)
					return true
				else return false end
			end
end
function Auxiliary.XyzLevelFreeTargetAlter(f,gf,minct,maxct,alterf,alterdesc,alterop)
	return	function(e,tp,eg,ep,ev,re,r,rp,chk,c,og,min,max)
				if not aux.EnableXyzLevelFreeMods then
					return _XyzLevelFreeTargetAlter(f,gf,minct,maxct,alterf,alterdesc,alterop)(e,tp,eg,ep,ev,re,r,rp,chk,c,og,min,max)
				end
				if og and not min then
					return true
				end
				local minc=minct
				local maxc=maxct
				if min then
					if min>minc then minc=min end
					if max<maxc then maxc=max end
				end
				local mg=nil
				if og then
					mg=og
				else
					mg=Duel.GetFieldGroup(tp,LOCATION_MZONE,0)
				end
				
				--Handle extra Xyz Materials
				aux.IsUsingAlternativeXyzProcedure=true
				local exg=Duel.GetMatchingGroup(aux.ExtraXyzMaterialFilter,tp,LOCATION_ALL,LOCATION_ALL,nil,c,tp)
				if #exg>0 then
					mg:Merge(exg)
				end
				aux.IsUsingAlternativeXyzProcedure=false
				--
				
				local sg=Duel.GetMustMaterial(tp,EFFECT_MUST_BE_XMATERIAL)
				local altg=mg:Filter(Auxiliary.XyzAlterFilter,nil,alterf,c,e,tp,alterop)
				local mg2=mg:Filter(Auxiliary.XyzLevelFreeFilter,nil,c,f)
				Duel.SetSelectedCard(sg)
				local b1=mg2:CheckSubGroup(Auxiliary.XyzLevelFreeGoal,minc,maxc,tp,c,gf)
				local b2=(not min or min<=1) and #altg>0
				local g=nil
				local cancel=Duel.IsSummonCancelable()
				if b2 and (not b1 or Duel.SelectYesNo(tp,alterdesc)) then
					aux.IsUsingAlternativeXyzProcedure=true
					e:SetLabel(1)
					Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
					local tc=altg:SelectUnselect(nil,tp,false,cancel,1,1)
					if tc then
						g=Group.FromCards(tc)
						if alterop then alterop(e,tp,1,tc) end
					end
					aux.IsUsingAlternativeXyzProcedure=false
				else
					e:SetLabel(0)
					Duel.SetSelectedCard(sg)
					Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
					Auxiliary.GCheckAdditional=Auxiliary.TuneMagicianCheckAdditionalX(EFFECT_TUNE_MAGICIAN_X)
					g=mg2:SelectSubGroup(tp,Auxiliary.XyzLevelFreeGoal,cancel,minc,maxc,tp,c,gf)
					Auxiliary.GCheckAdditional=nil
				end
				if g and g:GetCount()>0 then
					g:KeepAlive()
					e:SetLabelObject(g)
					return true
				else return false end
			end
end