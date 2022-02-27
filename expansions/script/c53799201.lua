local m=53799201
local cm=_G["c"..m]
cm.name="蜜柑之女 AZS"
function cm.initial_effect(c)
	cm.AddSynchroProcedure(c,nil,aux.NonTuner(nil),1,2)
	c:EnableReviveLimit()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(1,0)
	e1:SetTarget(function(e,c,sump,sumtype,sumpos,targetp)return c:IsLocation(LOCATION_EXTRA) and not c:IsType(TYPE_SYNCHRO)end)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_NONTUNER)
	e2:SetValue(function(e,c)return e:GetHandler():IsControler(c:GetControler())end)
	c:RegisterEffect(e2)
end
function cm.AddSynchroProcedure(c,f1,f2,minc,maxc)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(1164)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCondition(cm.SynCondition(f1,f2,minc,maxc))
	e1:SetTarget(cm.SynTarget(f1,f2,minc,maxc))
	e1:SetOperation(aux.SynOperation(f1,f2,minc,maxc))
	e1:SetValue(SUMMON_TYPE_SYNCHRO)
	c:RegisterEffect(e1)
end
function cm.fselect1(g,c,smat,f1,f2,minc,maxc,tp)
	return Duel.CheckTunerMaterial(c,smat,f1,f2,minc,maxc,g) and g:FilterCount(Card.IsLocation,nil,LOCATION_HAND)<3-Duel.GetFlagEffect(tp,m)
end
function cm.fselect2(g,c,f1,f2,minc,maxc,smat,tp)
	return Duel.CheckSynchroMaterial(c,f1,f2,minc,maxc,smat,g) and g:FilterCount(Card.IsLocation,nil,LOCATION_HAND)<3-Duel.GetFlagEffect(tp,m)
end
function cm.SynCondition(f1,f2,minc,maxc)
	return
	function(e,c,smat,mg,min,max)
		if c==nil then return true end
		if c:IsType(TYPE_PENDULUM) and c:IsFaceup() then return false end
		local minc=minc
		local maxc=maxc
		if min then
			if min>minc then minc=min end
			if max<maxc then maxc=max end
			if minc>maxc then return false end
		end
		local exg=Duel.GetMatchingGroup(Card.IsLevelAbove,c:GetControler(),LOCATION_HAND+LOCATION_ONFIELD,0,nil,0)
		if mg then mg:Merge(exg) else mg=exg end
		if smat and smat:IsType(TYPE_TUNER) and (not f1 or f1(smat)) then
			return mg:CheckSubGroup(cm.fselect1,minc,maxc,c,smat,f1,f2,minc,maxc,c:GetControler()) end
		return mg:CheckSubGroup(cm.fselect2,minc,maxc,c,f1,f2,minc,maxc,smat,c:GetControler())
	end
end
function cm.SynTarget(f1,f2,minc,maxc)
	return
	function(e,tp,eg,ep,ev,re,r,rp,chk,c,smat,mg,min,max)
		local minc=minc
		local maxc=maxc
		if min then
			if min>minc then minc=min end
			if max<maxc then maxc=max end
			if minc>maxc then return false end
		end
		local g=nil
		local exg=Duel.GetMatchingGroup(Card.IsLevelAbove,c:GetControler(),LOCATION_HAND+LOCATION_ONFIELD,0,nil,0)
		if mg then mg:Merge(exg) else mg=exg end
		if smat and smat:IsType(TYPE_TUNER) and (not f1 or f1(smat)) then
			g=mg:SelectSubGroup(c:GetControler(),cm.fselect1,false,minc,maxc,c,smat,f1,f2,minc,maxc,c:GetControler())
		else
			g=mg:SelectSubGroup(c:GetControler(),cm.fselect2,false,minc,maxc,c,f1,f2,minc,maxc,smat,c:GetControler())
		end
		if g then
			local ct=g:FilterCount(Card.IsLocation,nil,LOCATION_HAND)
			if ct>0 then for i=1,ct do Duel.RegisterFlagEffect(c:GetControler(),m,RESET_PHASE+PHASE_END,0,1) end end
			g:KeepAlive()
			e:SetLabelObject(g)
			return true
		else return false end
	end
end
