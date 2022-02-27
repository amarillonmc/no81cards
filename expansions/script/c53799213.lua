local m=53799213
local cm=_G["c"..m]
cm.name="核武发射 YYS"
function cm.initial_effect(c)
	c:EnableReviveLimit()
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_SPSUMMON_COST)
	e0:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e0:SetCost(cm.spcost)
	c:RegisterEffect(e0)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(1164)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCondition(cm.SynCondition(f1,f2,minc,99,0))
	e1:SetTarget(cm.SynTarget(f1,f2,minc,99,0))
	e1:SetOperation(aux.SynOperation(f1,f2,minc,99))
	e1:SetValue(SUMMON_TYPE_SYNCHRO)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetDescription(aux.Stringid(m,0))
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_SPSUM_PARAM)
	e2:SetTargetRange(POS_FACEUP,1)
	e2:SetCondition(cm.SynCondition(f1,f2,minc,99,1))
	e2:SetTarget(cm.SynTarget(f1,f2,minc,99,1))
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,1))
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)return e:GetHandler():IsSummonType(SUMMON_TYPE_SYNCHRO)end)
	e3:SetTarget(cm.destg)
	e3:SetOperation(cm.desop)
	c:RegisterEffect(e3)
end
function cm.spcost(e,c,tp,st)
	if bit.band(st,SUMMON_TYPE_SYNCHRO)~=SUMMON_TYPE_SYNCHRO then return true end
	return Duel.GetTurnPlayer()==tp
end
function cm.SynCondition(f1,f2,minc,maxc,lab)
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
				if smat and smat:IsType(TYPE_TUNER) and (not f1 or f1(smat)) then
					return Duel.CheckTunerMaterial(c,smat,f1,f2,minc,maxc,mg) end
				return Duel.CheckSynchroMaterial(c,f1,f2,minc,maxc,smat,mg) and (Duel.GetMZoneCount(1-c:GetControler())>0 or lab==0)
			end
end
function cm.SynTarget(f1,f2,minc,maxc,lab)
	return  function(e,tp,eg,ep,ev,re,r,rp,chk,c,smat,mg,min,max)
				local minc=minc
				local maxc=maxc
				if min then
					if min>minc then minc=min end
					if max<maxc then maxc=max end
					if minc>maxc then return false end
				end
				Duel.Hint(HINT_MUSIC,0,aux.Stringid(m,2))
				if lab==1 then
					local e8=Effect.CreateEffect(c)
					e8:SetType(EFFECT_TYPE_SINGLE)
					e8:SetCode(EFFECT_MUST_USE_MZONE)
					e8:SetValue(function(e,c,fp,rp,r)return 0x1f001f end)
					e8:SetReset(RESET_EVENT+RESETS_STANDARD)
					c:RegisterEffect(e8)
				end
				local g=nil
				if smat and smat:IsType(TYPE_TUNER) and (not f1 or f1(smat)) then
					g=Duel.SelectTunerMaterial(c:GetControler(),c,smat,f1,f2,minc,maxc,mg)
				else
					g=Duel.SelectSynchroMaterial(c:GetControler(),c,f1,f2,minc,maxc,smat,mg)
				end
				if g then
					g:KeepAlive()
					e:SetLabelObject(g)
					return true
				else return false end
			end
end
function cm.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function cm.desop(e,tp,eg,ep,ev,re,r,rp)
	local count=8
	while count>0 and Duel.GetFieldGroupCount(0,LOCATION_ONFIELD,LOCATION_ONFIELD)>0 do
		if count<8 then Duel.BreakEffect() end
		local g=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
		Duel.Destroy(g,REASON_EFFECT)
		count=count-1
	end
end
