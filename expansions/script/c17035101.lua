Chikichikibanban={}
chiki=Chikichikibanban
POS_FACEUP_DEFENCE=POS_FACEUP_DEFENSE
POS_FACEDOWN_DEFENCE=POS_FACEDOWN_DEFENSE
RACE_CYBERS=RACE_CYBERSE

--Synchro monster, 1 tuner + min to max monsters
function Chikichikibanban.AddSynchroProcedure(c,f1,f2,minc,loc1,loc2,maxc,op)
	if maxc==nil then maxc=99 end
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(1164)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCondition(Chikichikibanban.SynCondition(f1,f2,minc,loc1,loc2,maxc,op))
	e1:SetTarget(Chikichikibanban.SynTarget(f1,f2,minc,loc1,loc2,maxc,op))
	e1:SetOperation(Chikichikibanban.SynOperation(f1,f2,minc,loc1,loc2,maxc,op))
	e1:SetValue(SUMMON_TYPE_SYNCHRO)
	c:RegisterEffect(e1)
end
function Chikichikibanban.SynCondition(f1,f2,minc,loc1,loc2,maxc,op)
	return  function(e,c,smat,mg,min,max)
				if c==nil then return true end
				if c:IsType(TYPE_PENDULUM) and c:IsFaceup() then return false end
				local minc=minc
				local maxc=maxc
				if min then
					if min>minc then minc=min end
					if max<maxc then maxc=max end
					if minc>maxc then return false end
				end
				local exg=Duel.GetFieldGroup(c:GetControler(),loc1+LOCATION_MZONE,loc2)
				if not mg then
					mg=exg
				else
					mg:Merge(exg)
				end
				if smat and smat:IsType(TYPE_TUNER) and (not f1 or f1(smat)) then
					return Duel.CheckTunerMaterial(c,smat,f1,f2,minc,maxc,mg) end
				return Duel.CheckSynchroMaterial(c,f1,f2,minc,maxc,smat,mg)
			end
end
function Chikichikibanban.SynTarget(f1,f2,minc,loc1,loc2,maxc,op)
	return  function(e,tp,eg,ep,ev,re,r,rp,chk,c,smat,mg,min,max)
				local minc=minc
				local maxc=maxc
				if min then
					if min>minc then minc=min end
					if max<maxc then maxc=max end
					if minc>maxc then return false end
				end
				local g=nil
				local exg=Duel.GetFieldGroup(c:GetControler(),loc1+LOCATION_MZONE,loc2)
				if not mg then
					mg=exg
				else
					mg:Merge(exg)
				end
				if smat and smat:IsType(TYPE_TUNER) and (not f1 or f1(smat)) then
					g=Duel.SelectTunerMaterial(c:GetControler(),c,smat,f1,f2,minc,maxc,mg)
				else
					g=Duel.SelectSynchroMaterial(c:GetControler(),c,f1,f2,minc,maxc,smat,mg)
				end
				if op then op(e,tp,1,g:GetFirst()) end
				if g then
					g:KeepAlive()
					e:SetLabelObject(g)
					return true
				else return false end
			end
end
function Chikichikibanban.SynOperation(f1,f2,minc,loc1,loc2,maxc,op)
	return  function(e,tp,eg,ep,ev,re,r,rp,c,smat,mg,min,max)
				local g=e:GetLabelObject()
				c:SetMaterial(g)
				Duel.SendtoGrave(g,REASON_MATERIAL+REASON_SYNCHRO)
				g:DeleteGroup()
			end
end

--Xyz monster, lv k*n
function Chikichikibanban.AddXyzProcedure(c,f,lv,ct,loc1,loc2,alterf,desc,maxc,op)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(1165)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_EXTRA)
	if not maxc then maxc=ct end
	if alterf then
		e1:SetCondition(Chikichikibanban.XyzCondition2(f,lv,ct,loc1,loc2,maxc,alterf,desc,op))
		e1:SetTarget(Chikichikibanban.XyzTarget2(f,lv,ct,loc1,loc2,maxc,alterf,desc,op))
		e1:SetOperation(Chikichikibanban.XyzOperation2(f,lv,ct,loc1,loc2,maxc,alterf,desc,op))
	else
		e1:SetCondition(Chikichikibanban.XyzCondition(f,lv,ct,loc1,loc2,maxc))
		e1:SetTarget(Chikichikibanban.XyzTarget(f,lv,ct,loc1,loc2,maxc))
		e1:SetOperation(Chikichikibanban.XyzOperation(f,lv,ct,loc1,loc2,maxc))
	end
	e1:SetValue(SUMMON_TYPE_XYZ)
	c:RegisterEffect(e1)
end
--Xyz Summon(normal)
function Chikichikibanban.XyzCondition(f,lv,minc,loc1,loc2,maxc)
	--og: use special material
	return  function(e,c,og,min,max)
				if c==nil then return true end
				if c:IsType(TYPE_PENDULUM) and c:IsFaceup() then return false end
				local tp=c:GetControler()
				local minc=minc
				local maxc=maxc
				if min then
					if min>minc then minc=min end
					if max<maxc then maxc=max end
					if minc>maxc then return false end
				end
				local mg=Group.CreateGroup()
				if og then
					mg:Merge(og)
				end
				local exg=Duel.GetFieldGroup(tp,loc1+LOCATION_MZONE,loc2)
				mg:Merge(exg)
				return Duel.CheckXyzMaterial(c,f,lv,minc,maxc,mg)
			end
end
function Chikichikibanban.XyzTarget(f,lv,minc,loc1,loc2,maxc)
	return  function(e,tp,eg,ep,ev,re,r,rp,chk,c,og,min,max)
				if og and not min then
					return true
				end
				local minc=minc
				local maxc=maxc
				if min then
					if min>minc then minc=min end
					if max<maxc then maxc=max end
				end
				local mg=Group.CreateGroup()
				local exg=Duel.GetFieldGroup(tp,loc1+LOCATION_MZONE,loc2)
				mg:Merge(exg)
				if og then
					mg:Merge(og)
				end
				local g=Duel.SelectXyzMaterial(tp,c,f,lv,minc,maxc,mg)
				if g then
					g:KeepAlive()
					e:SetLabelObject(g)
					return true
				else return false end
			end
end
function Chikichikibanban.XyzOperation(f,lv,minc,loc1,loc2,maxc)
	return  function(e,tp,eg,ep,ev,re,r,rp,c,og,min,max)
				if og and not min then
					local sg=Group.CreateGroup()
					local tc=og:GetFirst()
					while tc do
						local sg1=tc:GetOverlayGroup()
						sg:Merge(sg1)
						tc=og:GetNext()
					end
					Duel.SendtoGrave(sg,REASON_RULE)
					c:SetMaterial(og)
					Duel.Overlay(c,og)
				else
					local mg=e:GetLabelObject()
					local sg=Group.CreateGroup()
					local tc=mg:GetFirst()
					while tc do
						local sg1=tc:GetOverlayGroup()
						sg:Merge(sg1)
						tc=mg:GetNext()
					end
					Duel.SendtoGrave(sg,REASON_RULE)
					c:SetMaterial(mg)
					Duel.Overlay(c,mg)
					mg:DeleteGroup()
				end
			end
end
--Xyz summon(alterf)
function Chikichikibanban.XyzCondition2(f,lv,minc,loc1,loc2,maxc,alterf,desc,op)
	return  function(e,c,og,min,max)
				if c==nil then return true end
				if c:IsType(TYPE_PENDULUM) and c:IsFaceup() then return false end
				local tp=c:GetControler()
				local mg=nil
				if og then
					mg=og
				else
					mg=Duel.GetFieldGroup(tp,LOCATION_MZONE+loc1,loc2)
				end
				if (not min or min<=1) and mg:IsExists(Auxiliary.XyzAlterFilter,1,nil,alterf,c,e,tp,op) then
					return true
				end
				local minc=minc
				local maxc=maxc
				if min then
					if min>minc then minc=min end
					if max<maxc then maxc=max end
					if minc>maxc then return false end
				end
				return Duel.CheckXyzMaterial(c,f,lv,minc,maxc,mg)
			end
end
function Chikichikibanban.XyzTarget2(f,lv,minc,loc1,loc2,maxc,alterf,desc,op)
	return  function(e,tp,eg,ep,ev,re,r,rp,chk,c,og,min,max)
				if og and not min then
					return true
				end
				local minc=minc
				local maxc=maxc
				if min then
					if min>minc then minc=min end
					if max<maxc then maxc=max end
				end
				local mg=nil
				if og then
					mg=og
				else
					mg=Duel.GetFieldGroup(tp,LOCATION_MZONE+loc1,loc2)
				end
				local b1=Duel.CheckXyzMaterial(c,f,lv,minc,maxc,mg)
				local b2=(not min or min<=1) and mg:IsExists(Auxiliary.XyzAlterFilter,1,nil,alterf,c,e,tp,op)
				local g=nil
				if b2 and (not b1 or Duel.SelectYesNo(tp,desc)) then
					e:SetLabel(1)
					Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
					g=mg:FilterSelect(tp,Auxiliary.XyzAlterFilter,1,1,nil,alterf,c,e,tp,op)
					if op then op(e,tp,1,g:GetFirst()) end
				else
					e:SetLabel(0)
					g=Duel.SelectXyzMaterial(tp,c,f,lv,minc,maxc,mg)
				end
				if g then
					g:KeepAlive()
					e:SetLabelObject(g)
					return true
				else return false end
			end
end
function Chikichikibanban.XyzOperation2(f,lv,minc,loc1,loc2,maxc,alterf,desc,op)
	return  function(e,tp,eg,ep,ev,re,r,rp,c,og,min,max)
				if og and not min then
					local sg=Group.CreateGroup()
					local tc=og:GetFirst()
					while tc do
						local sg1=tc:GetOverlayGroup()
						sg:Merge(sg1)
						tc=og:GetNext()
					end
					Duel.SendtoGrave(sg,REASON_RULE)
					c:SetMaterial(og)
					Duel.Overlay(c,og)
				else
					local mg=e:GetLabelObject()
					if e:GetLabel()==1 then
						local mg2=mg:GetFirst():GetOverlayGroup()
						if mg2:GetCount()~=0 then
							Duel.Overlay(c,mg2)
						end
					else
						local sg=Group.CreateGroup()
						local tc=mg:GetFirst()
						while tc do
							local sg1=tc:GetOverlayGroup()
							sg:Merge(sg1)
							tc=mg:GetNext()
						end
						Duel.SendtoGrave(sg,REASON_RULE)
					end
					c:SetMaterial(mg)
					Duel.Overlay(c,mg)
					mg:DeleteGroup()
				end
			end
end

--Xyz Summon(free)
function Chikichikibanban.AddXyzProcedureLevelFree(c,f,gf,minc,loc1,loc2,maxc,alterf,desc,op)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(1165)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_EXTRA)
	if alterf then
		e1:SetCondition(Chikichikibanban.XyzLevelFreeCondition2(f,gf,minc,loc1,loc2,maxc,alterf,desc,op))
		e1:SetTarget(Chikichikibanban.XyzLevelFreeTarget2(f,gf,minc,loc1,loc2,maxc,alterf,desc,op))
		e1:SetOperation(Chikichikibanban.XyzLevelFreeOperation2(f,gf,minc,loc1,loc2,maxc,alterf,desc,op))
	else
		e1:SetCondition(Chikichikibanban.XyzLevelFreeCondition(f,gf,minc,loc1,loc2,maxc))
		e1:SetTarget(Chikichikibanban.XyzLevelFreeTarget(f,gf,minc,loc1,loc2,maxc))
		e1:SetOperation(Chikichikibanban.XyzLevelFreeOperation(f,gf,minc,loc1,loc2,maxc))
	end
	e1:SetValue(SUMMON_TYPE_XYZ)
	c:RegisterEffect(e1)
end
--Xyz Summon(level free)
function Chikichikibanban.XyzLevelFreeFilter(c,xyzc,f)
	return (c:IsFaceup() or not c:IsLocation(LOCATION_ONFIELD)) and c:IsCanBeXyzMaterial(xyzc) and (not f or f(c,xyzc))
end
function Chikichikibanban.XyzLevelFreeGoal(g,tp,xyzc,gf)
	return (not gf or gf(g)) and Duel.GetLocationCountFromEx(tp,tp,g,xyzc)>0
end
function Chikichikibanban.XyzLevelFreeCondition(f,gf,minc,loc1,loc2,maxc)
	return  function(e,c,og,min,max)
				if c==nil then return true end
				if c:IsType(TYPE_PENDULUM) and c:IsFaceup() then return false end
				local tp=c:GetControler()
				local minc=minc
				local maxc=maxc
				if not maxc then maxc=minc end
				if min then
					minc=math.max(minc,min)
					maxc=math.min(maxc,max)
				end
				if maxc<minc then return false end
				local mg=nil
				if og then
					mg=og:Filter(Chikichikibanban.XyzLevelFreeFilter,nil,c,f)
				else
					mg=Duel.GetMatchingGroup(Chikichikibanban.XyzLevelFreeFilter,tp,LOCATION_MZONE,0,nil,c,f)
				end
				local exg=Duel.GetMatchingGroup(Chikichikibanban.XyzLevelFreeFilter,tp,loc1,loc2,nil,c,f)
				mg:Merge(exg)
				local sg=Auxiliary.GetMustMaterialGroup(tp,EFFECT_MUST_BE_XMATERIAL)
				if sg:IsExists(Auxiliary.MustMaterialCounterFilter,1,nil,mg) then return false end
				Duel.SetSelectedCard(sg)
				Auxiliary.GCheckAdditional=Auxiliary.TuneMagicianCheckAdditionalX(EFFECT_TUNE_MAGICIAN_X)
				local res=mg:CheckSubGroup(Chikichikibanban.XyzLevelFreeGoal,minc,maxc,tp,c,gf)
				Auxiliary.GCheckAdditional=nil
				return res
			end
end
function Chikichikibanban.XyzLevelFreeTarget(f,gf,minc,loc1,loc2,maxc)
	return  function(e,tp,eg,ep,ev,re,r,rp,chk,c,og,min,max)
				if og and not min then
					return true
				end
				local minc=minc
				local maxc=maxc
				if not maxc then maxc=minc end
				if min then
					if min>minc then minc=min end
					if max<maxc then maxc=max end
				end
				local mg=nil
				if og then
					mg=og:Filter(Chikichikibanban.XyzLevelFreeFilter,nil,c,f)
				else
					mg=Duel.GetMatchingGroup(Chikichikibanban.XyzLevelFreeFilter,tp,LOCATION_MZONE,0,nil,c,f)
				end
				local exg=Duel.GetMatchingGroup(Chikichikibanban.XyzLevelFreeFilter,tp,loc1,loc2,nil,c,f)
				mg:Merge(exg)
				local sg=Auxiliary.GetMustMaterialGroup(tp,EFFECT_MUST_BE_XMATERIAL)
				Duel.SetSelectedCard(sg)
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
				local cancel=Duel.IsSummonCancelable()
				Auxiliary.GCheckAdditional=Auxiliary.TuneMagicianCheckAdditionalX(EFFECT_TUNE_MAGICIAN_X)
				local g=mg:SelectSubGroup(tp,Chikichikibanban.XyzLevelFreeGoal,cancel,minc,maxc,tp,c,gf)
				Auxiliary.GCheckAdditional=nil
				if g and g:GetCount()>0 then
					g:KeepAlive()
					e:SetLabelObject(g)
					return true
				else return false end
			end
end
function Chikichikibanban.XyzLevelFreeOperation(f,gf,minc,loc1,loc2,maxc)
	return  function(e,tp,eg,ep,ev,re,r,rp,c,og,min,max)
				if og and not min then
					local sg=Group.CreateGroup()
					local tc=og:GetFirst()
					while tc do
						local sg1=tc:GetOverlayGroup()
						sg:Merge(sg1)
						tc=og:GetNext()
					end
					Duel.SendtoGrave(sg,REASON_RULE)
					c:SetMaterial(og)
					Duel.Overlay(c,og)
				else
					local mg=e:GetLabelObject()
					if e:GetLabel()==1 then
						local mg2=mg:GetFirst():GetOverlayGroup()
						if mg2:GetCount()~=0 then
							Duel.Overlay(c,mg2)
						end
					else
						local sg=Group.CreateGroup()
						local tc=mg:GetFirst()
						while tc do
							local sg1=tc:GetOverlayGroup()
							sg:Merge(sg1)
							tc=mg:GetNext()
						end
						Duel.SendtoGrave(sg,REASON_RULE)
					end
					c:SetMaterial(mg)
					Duel.Overlay(c,mg)
					mg:DeleteGroup()
				end
			end
end
--Xyz summon(level free&alterf)
function Chikichikibanban.XyzLevelFreeCondition2(f,gf,minc,loc1,loc2,maxc,alterf,desc,op)
	return  function(e,c,og,min,max)
				if c==nil then return true end
				if c:IsType(TYPE_PENDULUM) and c:IsFaceup() then return false end
				local tp=c:GetControler()
				local mg=nil
				if og then
					mg=og
				else
					mg=Duel.GetFieldGroup(tp,LOCATION_MZONE+loc1,loc2)
				end
				local altg=mg:Filter(Auxiliary.XyzAlterFilter,nil,alterf,c,e,tp,op):Filter(Auxiliary.MustMaterialCheck,nil,tp,EFFECT_MUST_BE_XMATERIAL)
				if (not min or min<=1) and altg:GetCount()>0 then
					return true
				end
				local minc=minc
				local maxc=maxc
				if min then
					if min>minc then minc=min end
					if max<maxc then maxc=max end
					if minc>maxc then return false end
				end
				mg=mg:Filter(Chikichikibanban.XyzLevelFreeFilter,nil,c,f)
				local sg=Auxiliary.GetMustMaterialGroup(tp,EFFECT_MUST_BE_XMATERIAL)
				if sg:IsExists(Auxiliary.MustMaterialCounterFilter,1,nil,mg) then return false end
				Duel.SetSelectedCard(sg)
				Auxiliary.GCheckAdditional=Auxiliary.TuneMagicianCheckAdditionalX(EFFECT_TUNE_MAGICIAN_X)
				local res=mg:CheckSubGroup(Chikichikibanban.XyzLevelFreeGoal,minc,maxc,tp,c,gf)
				Auxiliary.GCheckAdditional=nil
				return res
			end
end
function Chikichikibanban.XyzLevelFreeTarget2(f,gf,minc,loc1,loc2,maxc,alterf,desc,op)
	return  function(e,tp,eg,ep,ev,re,r,rp,chk,c,og,min,max)
				if og and not min then
					return true
				end
				local minc=minc
				local maxc=maxc
				if min then
					if min>minc then minc=min end
					if max<maxc then maxc=max end
				end
				local mg=nil
				if og then
					mg=og
				else
					mg=Duel.GetFieldGroup(tp,LOCATION_MZONE+loc1,loc2)
				end
				local sg=Auxiliary.GetMustMaterialGroup(tp,EFFECT_MUST_BE_XMATERIAL)
				local mg2=mg:Filter(Chikichikibanban.XyzLevelFreeFilter,nil,c,f)
				Duel.SetSelectedCard(sg)
				local b1=mg2:CheckSubGroup(Chikichikibanban.XyzLevelFreeGoal,minc,maxc,tp,c,gf)
				local b2=(not min or min<=1) and mg:IsExists(Auxiliary.XyzAlterFilter,1,nil,alterf,c,e,tp,op)
				local g=nil
				if b2 and (not b1 or Duel.SelectYesNo(tp,desc)) then
					e:SetLabel(1)
					Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
					g=mg:FilterSelect(tp,Auxiliary.XyzAlterFilter,1,1,nil,alterf,c,e,tp,op)
					if op then op(e,tp,1,g:GetFirst()) end
				else
					e:SetLabel(0)
					Duel.SetSelectedCard(sg)
					Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
					local cancel=Duel.IsSummonCancelable()
					Auxiliary.GCheckAdditional=Auxiliary.TuneMagicianCheckAdditionalX(EFFECT_TUNE_MAGICIAN_X)
					g=mg2:SelectSubGroup(tp,Chikichikibanban.XyzLevelFreeGoal,cancel,minc,maxc,tp,c,gf)
					Auxiliary.GCheckAdditional=nil
				end
				if g and g:GetCount()>0 then
					g:KeepAlive()
					e:SetLabelObject(g)
					return true
				else return false end
			end
end
function Chikichikibanban.XyzLevelFreeOperation2(f,gf,minc,loc1,loc2,maxc,alterf,desc,op)
	return  function(e,tp,eg,ep,ev,re,r,rp,c,og,min,max)
				if og and not min then
					local sg=Group.CreateGroup()
					local tc=og:GetFirst()
					while tc do
						local sg1=tc:GetOverlayGroup()
						sg:Merge(sg1)
						tc=og:GetNext()
					end
					Duel.SendtoGrave(sg,REASON_RULE)
					c:SetMaterial(og)
					Duel.Overlay(c,og)
				else
					local mg=e:GetLabelObject()
					if e:GetLabel()==1 then
						local mg2=mg:GetFirst():GetOverlayGroup()
						if mg2:GetCount()~=0 then
							Duel.Overlay(c,mg2)
						end
					else
						local sg=Group.CreateGroup()
						local tc=mg:GetFirst()
						while tc do
							local sg1=tc:GetOverlayGroup()
							sg:Merge(sg1)
							tc=mg:GetNext()
						end
						Duel.SendtoGrave(sg,REASON_RULE)
					end
					c:SetMaterial(mg)
					Duel.Overlay(c,mg)
					mg:DeleteGroup()
				end
			end
end


--Fake dark synchro
function Chikichikibanban.FakeDarkSynchroProcedure(c,f,gf,minc,maxc,op,self_location,opponent_location,mat_operation,...)
	local self_location=self_location or 0
	local opponent_location=opponent_location or 0
	local operation_params={...}
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCondition(Chikichikibanban.FakeDarkSynchroCondition(f,gf,minc,maxc,op,self_location,opponent_location))
	e1:SetTarget(Chikichikibanban.FakeDarkSynchroTarget(f,gf,minc,maxc,op,self_location,opponent_location))
	e1:SetOperation(Chikichikibanban.FakeDarkSynchroOperation(f,gf,minc,maxc,op,self_location,opponent_location,mat_operation,operation_params))
	c:RegisterEffect(e1)
end
function Chikichikibanban.FakeDarkSynchroMaterialFilter(c,sc,f)
	return (not f or f(c,sc)) 
end
function Chikichikibanban.FakeDarkSynchroFreeGoal(g,tp,sc,gf)
	return (not gf or gf(g)) and Duel.GetLocationCountFromEx(tp,tp,g,sc)>0
end
function Chikichikibanban.FakeDarkSynchroMaterialFilter2(c,sc,e,tp,op)
	return (not op or op(e,tp,0,c))
end
function Chikichikibanban.FakeDarkSynchroCondition(f,gf,minc,maxc,op,self_location,opponent_location)
	return  function(e,c,og)
				if c==nil then return true end
				local minc=minc
				local maxc=maxc
				local tp=c:GetControler()
				local mg=Duel.GetFieldGroup(tp,self_location,opponent_location)
				local sg=mg:Filter(Chikichikibanban.FakeDarkSynchroMaterialFilter,nil,c,f)
				return sg:CheckSubGroup(Chikichikibanban.FakeDarkSynchroFreeGoal,minc,maxc,tp,c,gf)
					and sg:IsExists(Chikichikibanban.FakeDarkSynchroMaterialFilter2,1,nil,c,e,tp,op)
			end
end
function Chikichikibanban.FakeDarkSynchroTarget(f,gf,minc,maxc,op,self_location,opponent_location)
	return  function(e,tp,eg,ep,ev,re,r,rp,chk,c,og,lmat)
				local minc=minc
				local maxc=maxc
				local tp=c:GetControler()
				local mg=Duel.GetFieldGroup(tp,self_location,opponent_location)
				local sg=mg:Filter(Chikichikibanban.FakeDarkSynchroMaterialFilter,nil,c,f)
				local cancel=Duel.IsSummonCancelable()
				local tg=sg:SelectSubGroup(tp,Chikichikibanban.FakeDarkSynchroFreeGoal,cancel,minc,maxc,tp,c,gf)
				if tg then
					if op then op(e,tp,1,tg:GetFirst()) end
					tg:KeepAlive()
					e:SetLabelObject(tg)
					return true
				else return false end
			end
end
function Chikichikibanban.FakeDarkSynchroOperation(f,gf,minc,maxc,op,self_location,opponent_location,mat_operation,operation_params)
	return  function(e,tp,eg,ep,ev,re,r,rp,c)
				local tg=e:GetLabelObject()
				c:SetMaterial(tg)
				mat_operation(tg,table.unpack(operation_params))
				tg:DeleteGroup()
			end
end




--special summon procedure
function Chikichikibanban.SpecialSummonProcedure(c,f,gf,minc,maxc,op,c_location,self_location,opponent_location,mat_operation,...)
	local c_location=c_location or 0
	local self_location=self_location or 0
	local opponent_location=opponent_location or 0
	local operation_params={...}
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(c_location)
	e1:SetCondition(Chikichikibanban.SpecialSummonProcedureCondition(f,gf,minc,maxc,op,self_location,opponent_location))
	e1:SetTarget(Chikichikibanban.SpecialSummonProcedureTarget(f,gf,minc,maxc,op,self_location,opponent_location))
	e1:SetOperation(Chikichikibanban.SpecialSummonProcedureOperation(f,gf,minc,maxc,op,self_location,opponent_location,mat_operation,operation_params))
	c:RegisterEffect(e1)
	return e1
end
function Chikichikibanban.SpecialSummonProcedureMaterialFilter(c,sc,f)
	return (not f or f(c,sc)) 
end
function Chikichikibanban.SpecialSummonProcedureFreeGoal(g,tp,sc,gf)
	return (not gf or gf(g)) and ((Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and not sc:IsLocation(LOCATION_EXTRA)) or
		(sc:IsLocation(LOCATION_EXTRA) and Duel.GetLocationCountFromEx(tp,tp,g,sc)>0))
end
function Chikichikibanban.SpecialSummonProcedureMaterialFilter2(c,sc,e,tp,op)
	return (not op or op(e,tp,0,c))
end
function Chikichikibanban.SpecialSummonProcedureCondition(f,gf,minc,maxc,op,self_location,opponent_location)
	return  function(e,c,og,min,max)
				if c==nil then return true end
				if og and not min then return true end
				local minc=minc
				local maxc=maxc
				if min then
					if min>minc then minc=min end
					if max<maxc then maxc=max end
				end
				local tp=c:GetControler()
				local mg=Duel.GetFieldGroup(tp,self_location,opponent_location)
				local sg=mg:Filter(Chikichikibanban.SpecialSummonProcedureMaterialFilter,nil,c,f)
				return sg:CheckSubGroup(Chikichikibanban.SpecialSummonProcedureFreeGoal,minc,maxc,tp,c,gf)
					and sg:IsExists(Chikichikibanban.SpecialSummonProcedureMaterialFilter2,1,nil,c,e,tp,op)
			end
end
function Chikichikibanban.SpecialSummonProcedureTarget(f,gf,minc,maxc,op,self_location,opponent_location)
	return  function(e,tp,eg,ep,ev,re,r,rp,chk,c,og,lmat,min,max)
				if og and not min then
					return true
				end
				local minc=minc
				local maxc=maxc
				if min then
					if min>minc then minc=min end
					if max<maxc then maxc=max end
				end
				local tp=c:GetControler()
				local mg=Duel.GetFieldGroup(tp,self_location,opponent_location)
				local sg=mg:Filter(Chikichikibanban.SpecialSummonProcedureMaterialFilter,nil,c,f)
				local cancel=Duel.IsSummonCancelable()
				local tg=sg:SelectSubGroup(tp,Chikichikibanban.SpecialSummonProcedureFreeGoal,cancel,minc,maxc,tp,c,gf)
				if tg then
					if op then op(e,tp,1,tg:GetFirst()) end
					tg:KeepAlive()
					e:SetLabelObject(tg)
					return true
				else return false end
			end
end
function Chikichikibanban.SpecialSummonProcedureOperation(f,gf,minc,maxc,op,self_location,opponent_location,mat_operation,operation_params)
	return  function(e,tp,eg,ep,ev,re,r,rp,c)
				local tg=e:GetLabelObject()
				c:SetMaterial(tg)
				mat_operation(tg,table.unpack(operation_params))
				tg:DeleteGroup()
			end
end

--special summon procedure(nomal)
function Chikichikibanban.SpecialSummonProcedureN(c,c_location,c_condition,op)
	local c_location=c_location or 0
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(c_location)
	e1:SetCondition(Chikichikibanban.SpecialSummonProcedureConditionN(c_condition,op))
	e1:SetOperation(Chikichikibanban.SpecialSummonProcedureOperationN(c_condition,op))
	c:RegisterEffect(e1)
	return e1
end
function Chikichikibanban.SpecialSummonProcedureConditionN(c_condition,op)
	return function(e,c)
			if c==nil then return true end
			local tp=c:GetControler()
			return (not c_condition or c_condition(e,c)) and (not op or op(e,tp,0,c)) end
end
function Chikichikibanban.SpecialSummonProcedureOperationN(c_condition,op)
	return  function(e,tp,eg,ep,ev,re,r,rp,c)
				if op then op(e,tp,1,e:GetHandler()) end
			end
end

--special summon procedure(special)
function Chikichikibanban.SpecialSummonProcedureS(c,c_location,c_pos,c_condition,op)
	local c_location=c_location or 0
	local c_pos=c_pos or 0
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetTargetRange(c_pos,1)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_SPSUM_PARAM)
	e1:SetRange(c_location)
	e1:SetCondition(Chikichikibanban.SpecialSummonProcedureConditionS(c_condition,op))
	e1:SetOperation(Chikichikibanban.SpecialSummonProcedureOperationS(c_condition,op))
	c:RegisterEffect(e1)
	return e1
end
function Chikichikibanban.SpecialSummonProcedureConditionS(c_condition,op)
	return function(e,c)
			if c==nil then return true end
			local tp=c:GetControler()
			return (not c_condition or c_condition(e,c)) and (not op or op(e,tp,0,c)) end
end
function Chikichikibanban.SpecialSummonProcedureOperationS(c_condition,op)
	return  function(e,tp,eg,ep,ev,re,r,rp,c)
				if op then op(e,tp,1,e:GetHandler()) end
			end
end
function Chikichikibanban.releasablehspfilter(c,sc,f)
	return (not f or f(c,sc)) and c:IsReleasable()
end
function Chikichikibanban.releasablehspcon(self_location,opponent_location,controler,f,gf,minc,maxc)
	return  function(e,c)
				if c==nil then return true end
				local minc=minc
				if not minc then minc=1 end
				local maxc=maxc
				if not maxc then maxc=minc end
				if min then
					if min>minc then minc=min end
					if max<maxc then maxc=max end
				end
				local tp=c:GetControler()
				local g=Duel.GetFieldGroup(tp,self_location,opponent_location)
				local sg=g:Filter(Chikichikibanban.releasablehspfilter,nil,c,f)
				return sg:CheckSubGroup(Chikichikibanban.SpecialSummonProcedureFreeGoal,minc,maxc,controler,c,gf)
			end
end
function Chikichikibanban.releasablehspop(self_location,opponent_location,controler,f,gf,minc,maxc)
	return  function(e,tp,chk)
				if chk==0 then return true end
				local minc=minc
				if not minc then minc=1 end
				local maxc=maxc
				if not maxc then maxc=minc end
				if min then
					if min>minc then minc=min end
					if max<maxc then maxc=max end
				end
				local g=Duel.GetFieldGroup(tp,self_location,opponent_location)
				local sg=g:Filter(Chikichikibanban.SpecialSummonProcedureMaterialFilter,nil,c,f)
				local tg=sg:SelectSubGroup(tp,Chikichikibanban.SpecialSummonProcedureFreeGoal,false,minc,maxc,controler,e:GetHandler(),gf)
				Duel.Release(tg,REASON_COST)
			end
end
function Chikichikibanban.togravehspfilter(c,sc,f)
	return (not f or f(c,sc)) and c:IsAbleToGraveAsCost() 
end
function Chikichikibanban.togravehspcon(self_location,opponent_location,controler,f,gf,minc,maxc)
	return  function(e,c)
			if c==nil then return true end
				local minc=minc
				if not minc then minc=1 end
				local maxc=maxc
				if not maxc then maxc=minc end
				if min then
					if min>minc then minc=min end
					if max<maxc then maxc=max end
				end
				local tp=c:GetControler()
				local g=Duel.GetFieldGroup(tp,self_location,opponent_location)
				local sg=g:Filter(Chikichikibanban.togravehspfilter,nil,c,f)
				return sg:CheckSubGroup(Chikichikibanban.SpecialSummonProcedureFreeGoal,minc,maxc,controler,c,gf)
			end
end
function Chikichikibanban.togravehspop(self_location,opponent_location,controler,f,gf,minc,maxc)
	return  function(e,tp,chk)
				if chk==0 then return true end
				local minc=minc
				if not minc then minc=1 end
				local maxc=maxc
				if not maxc then maxc=minc end
				if min then
					if min>minc then minc=min end
					if max<maxc then maxc=max end
				end
				local g=Duel.GetFieldGroup(tp,self_location,opponent_location)
				local sg=g:Filter(Chikichikibanban.togravehspfilter,nil,c,f)
				local tg=sg:SelectSubGroup(tp,Chikichikibanban.SpecialSummonProcedureFreeGoal,false,minc,maxc,controler,e:GetHandler(),gf)
				Duel.SendtoGrave(tg,REASON_COST)
			end
end
function Chikichikibanban.todeckhspfilter(c,sc,f)
	return (not f or f(c,sc)) and c:IsAbleToDeckAsCost() 
end
function Chikichikibanban.todeckhspcon(self_location,opponent_location,controler,f,gf,minc,maxc)
	return  function(e,c)
				if c==nil then return true end
				local minc=minc
				if not minc then minc=1 end
				local maxc=maxc
				if not maxc then maxc=minc end
				if min then
					if min>minc then minc=min end
					if max<maxc then maxc=max end
				end
				local tp=c:GetControler()
				local g=Duel.GetFieldGroup(tp,self_location,opponent_location)
				local sg=g:Filter(Chikichikibanban.todeckhspfilter,nil,c,f)
				return sg:CheckSubGroup(Chikichikibanban.SpecialSummonProcedureFreeGoal,minc,maxc,controler,c,gf)
			end
end
function Chikichikibanban.todeckhspop(self_location,opponent_location,controler,f,gf,minc,maxc)
	return  function(e,tp,chk)
				if chk==0 then return true end
				local minc=minc
				if not minc then minc=1 end
				local maxc=maxc
				if not maxc then maxc=minc end
				if min then
					if min>minc then minc=min end
					if max<maxc then maxc=max end
				end
				local g=Duel.GetFieldGroup(tp,self_location,opponent_location)
				local sg=g:Filter(Chikichikibanban.todeckhspfilter,nil,c,f)
				local tg=sg:SelectSubGroup(tp,Chikichikibanban.SpecialSummonProcedureFreeGoal,false,minc,maxc,controler,e:GetHandler(),gf)
				Duel.SendtoDeck(tg,nil,SEQ_DECKSHUFFLE,REASON_COST)
			end
end
function Chikichikibanban.removehspfilter(c,sc,f)
	return (not f or f(c,sc)) and c:IsAbleToRemoveAsCost() 
end
function Chikichikibanban.removehspcon(self_location,opponent_location,controler,f,gf,minc,maxc)
	return  function(e,c)
				if c==nil then return true end
				local minc=minc
				if not minc then minc=1 end
				local maxc=maxc
				if not maxc then maxc=minc end
				if min then
					if min>minc then minc=min end
					if max<maxc then maxc=max end
				end
				local tp=c:GetControler()
				local g=Duel.GetFieldGroup(tp,self_location,opponent_location)
				local sg=g:Filter(Chikichikibanban.removehspfilter,nil,c,f)
				return sg:CheckSubGroup(Chikichikibanban.SpecialSummonProcedureFreeGoal,minc,maxc,controler,c,gf)
			end
end
function Chikichikibanban.removehspop(self_location,opponent_location,pos,controler,f,gf,minc,maxc)
	return  function(e,tp,chk)
				if chk==0 then return true end
				local minc=minc
				if not minc then minc=1 end
				local maxc=maxc
				if not maxc then maxc=minc end
				if min then
					if min>minc then minc=min end
					if max<maxc then maxc=max end
				end
				local g=Duel.GetFieldGroup(tp,self_location,opponent_location)
				local sg=g:Filter(Chikichikibanban.removehspfilter,nil,c,f)
				local tg=sg:SelectSubGroup(tp,Chikichikibanban.SpecialSummonProcedureFreeGoal,false,minc,maxc,controler,e:GetHandler(),gf)
				Duel.Remove(g,pos,REASON_COST)
			end
end
function Chikichikibanban.handspfilter(c,e,tp,f)
	return (not f or f(c,sc)) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
	and ((Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and not c:IsLocation(LOCATION_EXTRA)) or
		(c:IsLocation(LOCATION_EXTRA) and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0))
end
function Chikichikibanban.handsptg(self_location,opponent_location,op,controler,f,minc,maxc,gf)
	return  function(e,tp,eg,ep,ev,re,r,rp,chk)
				local minc=minc
				if not minc then minc=1 end
				local maxc=maxc
				if not maxc then maxc=minc end
				local controler=controler
				if not controler then controler=tp end
				local g=Duel.GetFieldGroup(tp,self_location,opponent_location)
				local sg=g:Filter(Chikichikibanban.handspfilter,nil,e,controler,f)
				if chk==0 then return (not op or op(e,tp,eg,ep,ev,re,r,rp,0,e:GetHandler()))
					and sg:CheckSubGroup(Chikichikibanban.SpecialSummonProcedureFreeGoal2,minc,maxc,controler,gf) end
				Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,controler,self_location+opponent_location)
			end
end
function Chikichikibanban.SpecialSummonProcedureFreeGoal2(g,tp,gf)
	return (not gf or gf(g))
end
function Chikichikibanban.handspop(self_location,opponent_location,op,controler,f,minc,maxc,gf)
	return  function(e,tp,eg,ep,ev,re,r,rp)
				local minc=minc
				if not minc then minc=1 end
				local maxc=maxc
				if not maxc then maxc=minc end
				local controler=controler
				if not controler then controler=tp end 
				if Duel.GetLocationCount(controler,LOCATION_MZONE,tp)<minc then return end
				if minc>=2 and Duel.IsPlayerAffectedByEffect(tp,59822133) then return end
				local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
				if ft<=0 then return end
				if ft>maxc then ft=maxc elseif Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
				if minc>ft then minc=ft end
				local g=Duel.GetFieldGroup(tp,self_location,opponent_location)
				local sg=g:Filter(Chikichikibanban.handspfilter,nil,e,controler,f)
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
				local tg=sg:SelectSubGroup(tp,Chikichikibanban.SpecialSummonProcedureFreeGoal2,false,minc,ft,controler,gf)
				if tg:GetCount()>0 then
					Duel.SpecialSummon(tg,0,tp,controler,false,false,POS_FACEUP)
					if op then Duel.BreakEffect() op(e,tp,eg,ep,ev,re,r,rp,1,e:GetHandler()) end
				end
			end
end
function Chikichikibanban.dccost(minc)
	return  function(e,tp,eg,ep,ev,re,r,rp,chk)
				local minc=minc
				if not minc then minc=1 end
				if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,e:GetHandler()) end
				Duel.DiscardHand(tp,Card.IsDiscardable,minc,minc,REASON_COST+REASON_DISCARD,e:GetHandler())
			end
end
function Chikichikibanban.rscost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_COST)
end

--special summon procedure(special)
function Chikichikibanban.reposcon(c,c_location,tg,op,con,etype,gategory,...)
	local c_location=c_location
	if not c_location then c_location=LOCATION_HAND end
	local tg=tg 
	if not tg then tg=Chikichikibanban.sptg end
	local op=op 
	if not op then op=Chikichikibanban.spop end
	if not gategory then gategory=CATEGORY_SPECIAL_SUMMON end
	if not etype then etype=EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O end
	local limt={...}
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(gategory)
	e1:SetType(etype)
	e1:SetCode(EVENT_RECOVER)
	e1:SetRange(c_location)
	if limt then
		e1:SetCountLimit(limt)
	end
	if con then
		e1:SetCondition(con)
	end
	e1:SetTarget(tg)
	e1:SetOperation(op)
	c:RegisterEffect(e1)
	return e1
end
function Chikichikibanban.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function Chikichikibanban.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
end
function Chikichikibanban.pocfilter(c)
	return c:GetAttackAnnouncedCount()>0
end
function Chikichikibanban.poccon(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsExistingMatchingCard(Chikichikibanban.pocfilter,tp,LOCATION_MZONE,0,1,nil)
end
--tohand
function Chikichikibanban.thfilter(c,f)
	return (not f or f(c)) and c:IsAbleToHand()
end
function Chikichikibanban.thtg(f)
	return  function(e,tp,eg,ep,ev,re,r,rp,chk)
				if chk==0 then return Duel.IsExistingMatchingCard(Chikichikibanban.thfilter,tp,LOCATION_DECK,0,1,nil,f) end
				Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
			end
end
function Chikichikibanban.thop(f,op1,op2)
	return  function(e,tp,eg,ep,ev,re,r,rp)
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
				local g=Duel.SelectMatchingCard(tp,Chikichikibanban.thfilter,tp,LOCATION_DECK,0,1,1,nil,f)
				if g:GetCount()>0 then
					Duel.SendtoHand(g,nil,REASON_EFFECT)
					Duel.ConfirmCards(1-tp,g)
					if op1 then op1(e,tp,eg,ep,ev,re,r,rp,1,e:GetHandler()) end
				end
				if op2 then op2(e,tp,eg,ep,ev,re,r,rp,1,e:GetHandler()) end
			end
end
function Chikichikibanban.reposcost(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_ATTACK)
	e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_OATH)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end


function Chikichikibanban.filter(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function Chikichikibanban.tgsptg(self_location,opponent_location,op,controler,f,minc,maxc,gf)
	return  function(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
				local minc=minc
				if not minc then minc=1 end
				local maxc=maxc
				if not maxc then maxc=minc end
				local controler=controler
				if not controler then controler=tp end
				local g=Duel.GetFieldGroup(tp,self_location,opponent_location)
				local sg=g:Filter(Chikichikibanban.handspfilter,nil,e,controler,f)
				if chkc then return chkc:IsControler(controler) and chkc:IsLocation(loc) and Chikichikibanban.handspfilter(chkc,e,tp,f) end
				if chk==0 then return (not op or op(e,tp,eg,ep,ev,re,r,rp,0,e:GetHandler()))
					and sg:CheckSubGroup(Chikichikibanban.SpecialSummonProcedureFreeGoal2,minc,maxc,controler,gf) end
				local ft=maxc
				if Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
				ft=math.min(ft,(Duel.GetLocationCount(tp,LOCATION_MZONE)))
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
				local tg=sg:SelectSubGroup(tp,Chikichikibanban.SpecialSummonProcedureFreeGoal2,false,minc,maxc,controler,gf)
				Duel.SetTargetCard(tg)
				Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,tg,tg:GetCount(),0,0)
			end
end
function Chikichikibanban.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end
function Chikichikibanban.tgspop1(op)
	return  function(e,tp,eg,ep,ev,re,r,rp)
				local tc=Duel.GetFirstTarget()
				if tc:IsRelateToEffect(e) then
					Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
					if op then Duel.BreakEffect() op(e,tp,eg,ep,ev,re,r,rp,1,e:GetHandler()) end
				end
			end
end
function Chikichikibanban.tgspop2(op)
	return  function(e,tp,eg,ep,ev,re,r,rp)
				local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
				if ft<=0 then return end
				local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
				if g:GetCount()>1 and Duel.IsPlayerAffectedByEffect(tp,59822133) then return end
				if g:GetCount()>ft then
					Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
					sg=g:Select(tp,ft,ft,nil)
					Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
					if op then Duel.BreakEffect() op(e,tp,eg,ep,ev,re,r,rp,1,e:GetHandler()) end
				end
			end
end


--evolion synchro summon
function Chikichikibanban.SpecialSummonProcedureS(c,c_location,c_pos,c_condition,op)
	local c_location=c_location or 0
	local c_pos=c_pos or 0
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(aux.Stringid(17061330,0))
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_SPSUMMON_PROC)
	e0:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e0:SetRange(LOCATION_EXTRA)
	e0:SetCondition(Chikichikibanban.syncon)
	e0:SetTarget(Chikichikibanban.syntg)
	e0:SetOperation(Chikichikibanban.synop)
	e0:SetValue(SUMMON_TYPE_SYNCHRO)
	c:RegisterEffect(e0)
	return e1
end
function Chikichikibanban.CheckGroupRecursive(c,sg,g,f,min,max,ext_params)
	sg:AddCard(c)
	local ct=sg:GetCount()
	local res=(ct>=min and f(sg,table.unpack(ext_params)))
		or (ct<max and g:IsExists(Chikichikibanban.CheckGroupRecursive,1,sg,sg,g,f,min,max,ext_params))
	sg:RemoveCard(c)
	return res
end
function Chikichikibanban.CheckGroup(g,f,cg,min,max,...)
	local min=min or 1
	local max=max or g:GetCount()
	if min>max then return false end
	local ext_params={...}
	local sg=Group.CreateGroup()
	if cg then sg:Merge(cg) end
	local ct=sg:GetCount()
	if ct>=min and ct<max and f(sg,...) then return true end
	return g:IsExists(Chikichikibanban.CheckGroupRecursive,1,sg,sg,g,f,min,max,ext_params)
end
function Chikichikibanban.val(c,syncard)
	local slv=c:GetSynchroLevel(syncard)
	if c:IsSynchroType(TYPE_PENDULUM) and c:IsLocation(LOCATION_PZONE) and c:IsSetCard(0x37f6) then
		slv=c:GetLeftScale()*65536+slv
	end
	return slv
end
function Chikichikibanban.SelectGroup(tp,desc,g,f,cg,min,max,...)
	local min=min or 1
	local max=max or g:GetCount()
	local ext_params={...}
	local sg=Group.CreateGroup()
	if cg then sg:Merge(cg) end
	local ct=sg:GetCount()
	while ct<max and not (ct>=min and f(sg,...) and not (g:IsExists(Chikichikibanban.CheckGroupRecursive,1,sg,sg,g,f,min,max,ext_params) and Duel.SelectYesNo(tp,210))) do
		Duel.Hint(HINT_SELECTMSG,tp,desc)
		local tg=g:FilterSelect(tp,Chikichikibanban.CheckGroupRecursive,1,1,sg,sg,g,f,min,max,ext_params)
		if tg:GetCount()==0 then error("Incorrect Group Filter",2) end
		sg:Merge(tg)
		ct=sg:GetCount()
	end
	return sg
end
function Chikichikibanban.matfilter1(c,syncard,tp)
	if c:IsFacedown() then return false end
	if c:IsSetCard(0x37f6) and c:IsSynchroType(TYPE_PENDULUM) and c:IsControler(tp) and c:IsLocation(LOCATION_PZONE) and c:IsType(TYPE_TUNER) then return true end 
	return c:IsSynchroType(TYPE_TUNER) and c:IsCanBeSynchroMaterial(syncard) and (c:IsFaceup() or not c:IsLocation(LOCATION_MZONE))
		and (c:IsSetCard(0x37f6) or not c:IsLocation(LOCATION_PZONE))
end
function Chikichikibanban.matfilter2(c,syncard)
	if c:IsSetCard(0x37f6) and c:IsSynchroType(TYPE_PENDULUM) and c:IsControler(tp) and c:IsLocation(LOCATION_PZONE) and not c:IsType(TYPE_TUNER) then return true end 
	return c:IsSynchroType(TYPE_PENDULUM) and (c:IsLocation(LOCATION_HAND) or c:IsFaceup()) and c:IsNotTuner(syncard) and c:IsCanBeSynchroMaterial(syncard)
		and (c:IsFaceup() or not c:IsLocation(LOCATION_MZONE)) and (c:IsSetCard(0x37f6) or not c:IsLocation(LOCATION_PZONE))
end
function Chikichikibanban.synfilter(c,syncard,lv,g2,g3,minc,maxc,tp)
	local tsg=c:IsHasEffect(EFFECT_HAND_SYNCHRO) and g3 or g2
	local f=c.tuner_filter
	if c.tuner_filter then tsg=tsg:Filter(f,nil) end
	return Chikichikibanban.CheckGroup(tsg,Chikichikibanban.goal,Group.FromCards(c),minc,maxc,tp,lv,syncard,c)
end
function Chikichikibanban.goal(g,tp,lv,syncard,tuc)
	if Duel.GetLocationCountFromEx(tp,tp,g,syncard)<=0 then return false end
	if tuc:IsHasEffect(EFFECT_HAND_SYNCHRO) and g:IsExists(Card.IsLocation,2,tuc,LOCATION_HAND) then return false end
	local ct=g:GetCount()
	return g:CheckWithSumEqual(Chikichikibanban.val,lv,ct,ct,syncard)
end
function Chikichikibanban.syncon(e,c,tuner,mg)
	if c==nil then return true end
	if c:IsType(TYPE_PENDULUM) and c:IsFaceup() then return false end
	local tp=c:GetControler()
	local minc=2
	local maxc=c:GetLevel()
	local g1=nil
	local g2=nil
	local g3=nil
	if mg then
		g1=mg:Filter(Chikichikibanban.matfilter1,nil,c,tp)
		g2=mg:Filter(Chikichikibanban.matfilter2,nil,c)
		g3=g2:Clone()
	else
		g1=Duel.GetMatchingGroup(Chikichikibanban.matfilter1,tp,LOCATION_MZONE+LOCATION_PZONE,LOCATION_MZONE,nil,c,tp)
		g2=Duel.GetMatchingGroup(Chikichikibanban.matfilter2,tp,LOCATION_MZONE+LOCATION_PZONE,LOCATION_MZONE,nil,c)
		g3=Duel.GetMatchingGroup(Chikichikibanban.matfilter2,tp,LOCATION_MZONE+LOCATION_HAND,LOCATION_MZONE,nil,c)
	end
	local lv=c:GetLevel()
	local sg=nil
	if tuner then
		return Chikichikibanban.matfilter1(c,tp) and Chikichikibanban.synfilter(tuner,c,lv,g2,g3,minc,maxc,tp)
	else
		return g1:IsExists(Chikichikibanban.synfilter,1,nil,c,lv,g2,g3,minc,maxc,tp)
	end
end
function Chikichikibanban.syntg(e,tp,eg,ep,ev,re,r,rp,chk,c,tuner,mg)
	local minc=2
	local maxc=c:GetLevel()
	local g1=nil
	local g2=nil
	local g3=nil
	if mg then
		g1=mg:Filter(Chikichikibanban.matfilter1,nil,c,tp)
		g2=mg:Filter(Chikichikibanban.matfilter2,nil,c)
		g3=g2:Clone()
	else
		g1=Duel.GetMatchingGroup(Chikichikibanban.matfilter1,tp,LOCATION_MZONE+LOCATION_PZONE,LOCATION_MZONE,nil,c,tp)
		g2=Duel.GetMatchingGroup(Chikichikibanban.matfilter2,tp,LOCATION_MZONE+LOCATION_PZONE,LOCATION_MZONE,nil,c)
		g3=Duel.GetMatchingGroup(Chikichikibanban.matfilter2,tp,LOCATION_MZONE+LOCATION_HAND,LOCATION_MZONE,nil,c)
	end
	local pe=Duel.IsPlayerAffectedByEffect(tp,EFFECT_MUST_BE_SMATERIAL)
	local lv=c:GetLevel()
	local tuc=nil
	if tuner then
		tuner=tuc
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
		if not pe then
			local t1=g1:FilterSelect(tp,Chikichikibanban.synfilter,1,1,nil,c,lv,g2,g3,minc,maxc,tp)
			tuc=t1:GetFirst()
		else
			tuc=pe:GetOwner()
			Group.FromCards(tuc):Select(tp,1,1,nil)
		end
	end
	tuc:RegisterFlagEffect(m,RESET_EVENT+0x1fe0000,0,1)
	local tsg=tuc:IsHasEffect(EFFECT_HAND_SYNCHRO) and g3 or g2
	local f=tuc.tuner_filter
	if tuc.tuner_filter then tsg=tsg:Filter(f,nil) end
	local g=Chikichikibanban.SelectGroup(tp,HINTMSG_SMATERIAL,tsg,Chikichikibanban.goal,Group.FromCards(tuc),minc,maxc,tp,lv,c,tuc)
	if g then
		g:KeepAlive()
		e:SetLabelObject(g)
		return true
	else return false end
end
function Chikichikibanban.synop(e,tp,eg,ep,ev,re,r,rp,c,tuner,mg)
	local g=e:GetLabelObject()
	c:SetMaterial(g)
	Duel.SendtoGrave(g,REASON_MATERIAL+REASON_SYNCHRO)
	g:DeleteGroup()
end

--铳影自肃(代写)
function Chikichikibanban.c4a71Limit(c)
	--spsummon cost
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SPSUMMON_COST)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetCost(Chikichikibanban.c4a71Limitspcost)
	e1:SetOperation(Chikichikibanban.c4a71Limitspcop)
	c:RegisterEffect(e1)
	--spsummon condition
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetCode(EFFECT_SPSUMMON_CONDITION)
	e2:SetValue(Chikichikibanban.c4a71Limitsplimit2)
	c:RegisterEffect(e2)
	Duel.AddCustomActivityCounter(12825602,ACTIVITY_SPSUMMON,Chikichikibanban.counterfilter)
end
function Chikichikibanban.counterfilter(c)
	return not c:IsSummonLocation(LOCATION_EXTRA) or c:IsType(TYPE_XYZ)
end
function Chikichikibanban.c4a71Limitspcost(e,c,tp)
	return Duel.GetCustomActivityCount(12825602,tp,ACTIVITY_SPSUMMON)==0
end
function Chikichikibanban.c4a71Limitspcop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	e1:SetTarget(Chikichikibanban.c4a71Limitsplimit)
	Duel.RegisterEffect(e1,tp)
end
function Chikichikibanban.c4a71Limitsplimit(e,c)
	return c:IsLocation(LOCATION_EXTRA) and not c:IsType(TYPE_XYZ)
end
function Chikichikibanban.c4a71Limitsplimit2(e,se,sp,st)
	return se:GetHandler():IsSetCard(0x4a76)
end
--铳影通用回收(代写)
function Chikichikibanban.c4a71tohand(c,tg,op,category)
	local tg=tg 
	if not tg then tg=Chikichikibanban.c4a71tohandthtg end
	local op=op 
	if not op then op=Chikichikibanban.c4a71tohandthop end
	local category=category 
	if not category then category=CATEGORY_TOHAND+CATEGORY_SEARCH end
	--to hand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(1110)
	e1:SetCategory(category)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetCost(aux.bfgcost)
	e1:SetTarget(tg)
	e1:SetOperation(op)
	c:RegisterEffect(e1)
end
function Chikichikibanban.c4a71tohandthfilter(c)
	return c:IsSetCard(0x4a76) and c:IsAbleToHand()
end
function Chikichikibanban.c4a71tohandthtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Chikichikibanban.c4a71tohandthfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
end
function Chikichikibanban.c4a71tohandthop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,Chikichikibanban.c4a71tohandthfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	local tc=g:GetFirst()
	if tc:IsCode(12825601) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 
		and tc:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.SelectYesNo(tp,2) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	else
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	end
end

--铳影通用康型效果(代写)
function Chikichikibanban.c4a71kang(c,con,tg,op,category,cardcode,message,excode)
	local con=con 
	if not con then con=Chikichikibanban.c4a71kangdiscon end
	local tg=tg 
	if not tg then tg=Chikichikibanban.c4a71tohandthtg end
	local op=op 
	if not op then op=Chikichikibanban.c4a71tohandthop end
	local cardcode=cardcode 
	local excode=excode
	local category=category 
	if not category then category=CATEGORY_TOHAND+CATEGORY_SEARCH end
	--negate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(message)
	e1:SetCategory(CATEGORY_NEGATE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,cardcode)
	e1:SetCondition(con)
	e1:SetTarget(tg)
	e1:SetOperation(op)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCountLimit(1)
	e2:SetCost(Chikichikibanban.c4a71kangcost)
	e2:SetCondition(Chikichikibanban.c4a71kangdiscon2(con,excode))
	c:RegisterEffect(e2)
	--summon success
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetOperation(Chikichikibanban.sumsuc)
	c:RegisterEffect(e3)
end

function Chikichikibanban.c4a71kang2(c,con,tg,op,category,cardcode,message,excode)
	local con=con 
	if not con then con=Chikichikibanban.c4a71kangdiscon end
	local tg=tg 
	if not tg then tg=Chikichikibanban.c4a71tohandthtg end
	local op=op 
	if not op then op=Chikichikibanban.c4a71tohandthop end
	local cardcode=cardcode 
	local excode=excode
	local category=category 
	if not category then category=CATEGORY_TOHAND+CATEGORY_SEARCH end
	--negate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(message)
	e1:SetCategory(CATEGORY_NEGATE)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,cardcode)
	e1:SetCondition(con)
	e1:SetTarget(tg)
	e1:SetOperation(op)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCountLimit(1)
	e2:SetCost(Chikichikibanban.c4a71kangcost)
	e2:SetCondition(Chikichikibanban.c4a71kangdiscon2(con,excode))
	c:RegisterEffect(e2)
	--summon success
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetOperation(Chikichikibanban.sumsuc)
	c:RegisterEffect(e3)
end
function Chikichikibanban.c4a71kangcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) 
		and Duel.GetFlagEffect(tp,12825602)==0 end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
	Duel.RegisterFlagEffect(tp,12825602,RESET_PHASE+PHASE_END,EFFECT_FLAG_OATH,1)
end
function Chikichikibanban.sumsuc(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if e:GetHandler():GetFlagEffect(12825612)~=0 then return end
	c:RegisterFlagEffect(12825612,RESET_PHASE+PHASE_END,0,1)
end

function Chikichikibanban.c4a71kangdiscon(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp and e:GetHandler():GetFlagEffect(12825612)>0 
end
function Chikichikibanban.c4a71kangdiscon2(con,excode)
	return  function(e,tp,eg,ep,ev,re,r,rp)
				return (not con or con(e,tp,eg,ep,ev,re,r,rp)) and e:GetHandler():GetOverlayGroup():IsExists(Card.IsCode,1,nil,excode)
			end
end

--铳影通用升阶效果(代写)
function Chikichikibanban.c4a71rankup(c,f1,f2,cardcode)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(2)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,cardcode)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(Chikichikibanban.c4a71rankuptarget(f1,f2))
	e1:SetOperation(Chikichikibanban.c4a71rankupactivate(f1,f2))
	c:RegisterEffect(e1)
end
function Chikichikibanban.c4a71rankupfilter1(c,e,tp,f1,f2)
	return (not f1 or f1(c)) and Duel.IsExistingMatchingCard(Chikichikibanban.c4a71rankupfilter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,c,f2)
		and aux.MustMaterialCheck(c,tp,EFFECT_MUST_BE_XMATERIAL)
end
function Chikichikibanban.c4a71rankupfilter2(c,e,tp,mc,f2)
	return (not f2 or f2(c)) and mc:IsCanBeXyzMaterial(c)
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false) and Duel.GetLocationCountFromEx(tp,tp,mc,c)>0
end
function Chikichikibanban.c4a71rankuptarget(f1,f2)
	return  function(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
				if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and Chikichikibanban.c4a71rankupfilter1(chkc,e,tp,f1,f2) end
				if chk==0 then return Duel.IsExistingTarget(Chikichikibanban.c4a71rankupfilter1,tp,LOCATION_MZONE,0,1,nil,e,tp,f1,f2) end
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
				Duel.SelectTarget(tp,Chikichikibanban.c4a71rankupfilter1,tp,LOCATION_MZONE,0,1,1,nil,e,tp,f1,f2)
				Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
			end
end
function Chikichikibanban.c4a71rankupactivate(f1,f2)
	return  function(e,tp,eg,ep,ev,re,r,rp)
				local c=e:GetHandler()
				local tc=Duel.GetFirstTarget()
				if not aux.MustMaterialCheck(tc,tp,EFFECT_MUST_BE_XMATERIAL) then return end
				if tc:IsFacedown() or not tc:IsRelateToEffect(e) or tc:IsControler(1-tp) or tc:IsImmuneToEffect(e) then return end
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
				local g=Duel.SelectMatchingCard(tp,Chikichikibanban.c4a71rankupfilter2,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,tc,f2)
				local sc=g:GetFirst()
				if sc then
					local mg=tc:GetOverlayGroup()
					if mg:GetCount()~=0 then
						Duel.Overlay(sc,mg)
					end
					sc:SetMaterial(Group.FromCards(tc))
					Duel.Overlay(sc,Group.FromCards(tc))
					Duel.SpecialSummon(sc,SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP)
					sc:CompleteProcedure()
					if c:IsRelateToEffect(e) then
						c:CancelToGrave()
						Duel.Overlay(sc,Group.FromCards(c))
					end
				end
			end
end


--通用墓地启动效果
function Chikichikibanban.chikione(c,location,cost,con,tg,op,category,cardcode,message)
	local location=location
	if not location then location=LOCATION_MZONE end
	local cost=cost 
	local con=con
	local tg=tg 
	if not tg then tg=Chikichikibanban.c4a71tohandthtg end
	local op=op 
	if not op then op=Chikichikibanban.c4a71tohandthop end
	local message=message
	local cardcode=cardcode 
	local category=category
	--material
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(message)
	if category then
		e1:SetCategory(category)
	end
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCountLimit(1,cardcode)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(location)
	if con then
		e1:SetCondition(con)
	end
	if cost then 
		e1:SetCost(cost)
	end
	e1:SetTarget(tg)
	e1:SetOperation(op)
	c:RegisterEffect(e1)
end


function Chikichikibanban.chikiav(c,propery,cost,con,tg,op,category,cardcode,message)
	local propery=propery
	local cost=cost 
	local con=con
	local tg=tg 
	if not tg then tg=Chikichikibanban.c4a71tohandthtg end
	local op=op 
	if not op then op=Chikichikibanban.c4a71tohandthop end
	local category=category
	local cardcode=cardcode 
	local message=message
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(message)
	e1:SetCategory(category)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,cardcode)
	if propery then
		e1:SetProperty(propery)
	end
	if con then
		e1:SetCondition(con)
	end
	if cost then 
		e1:SetCost(cost)
	end
	e1:SetTarget(tg)
	e1:SetOperation(op)
	c:RegisterEffect(e1)
end



function Chikichikibanban.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
end