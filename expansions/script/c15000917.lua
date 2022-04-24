local m=15000917
local cm=_G["c"..m]
cm.name="传说未来圣罚 圣修暗凯·无限命运"
function cm.initial_effect(c)
	c:EnableReviveLimit()
	--pendulum summon
	aux.EnablePendulumAttribute(c,false)
	--SynchroSummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(1164)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCondition(aux.SynMixCondition(cm.matfilter1,nil,nil,aux.NonTuner(cm.matfilter2),1,1,gc))
	e1:SetTarget(aux.SynMixTarget(cm.matfilter1,nil,nil,aux.NonTuner(cm.matfilter2),1,1,gc))
	e1:SetOperation(cm.SynMixOperation(cm.matfilter1,nil,nil,aux.NonTuner(cm.matfilter2),1,1,gc))
	e1:SetValue(SUMMON_TYPE_SYNCHRO)
	c:RegisterEffect(e1)
	--splimit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
	e2:SetTargetRange(1,0)
	e2:SetTarget(cm.psplimit)
	c:RegisterEffect(e2)
	--add indes
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetCondition(cm.tncon)
	e3:SetOperation(cm.tnop)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_MATERIAL_CHECK)
	e4:SetValue(cm.valcheck)
	e4:SetLabelObject(e3)
	c:RegisterEffect(e4)
	--atk/def
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCode(EFFECT_UPDATE_ATTACK)
	e5:SetValue(cm.atkval)
	c:RegisterEffect(e5)
	local e6=e5:Clone()
	e6:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e6)
	--lose LP
	local e7=Effect.CreateEffect(c)
	e7:SetCategory(CATEGORY_REMOVE+CATEGORY_ATKCHANGE)
	e7:SetType(EFFECT_TYPE_IGNITION)
	e7:SetRange(LOCATION_MZONE)
	e7:SetCondition(cm.atcon)
	e7:SetCost(cm.atcost)
	e7:SetOperation(cm.atop)
	c:RegisterEffect(e7)
end
function cm.matfilter1(c,syncard)
	return c:IsSynchroType(TYPE_TUNER) or (c:IsSynchroType(TYPE_PENDULUM) and c:IsSetCard(0x5f3e))
end
function cm.matfilter2(c,syncard)
	return c:IsCode(15000907)
end
function cm.SynMixOperation(f1,f2,f3,f4,minct,maxc,gc)
	return  function(e,tp,eg,ep,ev,re,r,rp,c,smat,mg,min,max)
				local g=e:GetLabelObject()
				c:SetMaterial(g)
				Duel.Remove(g,POS_FACEUP,REASON_MATERIAL+REASON_SYNCHRO)
				g:DeleteGroup()
			end
end
function cm.psplimit(e,c,tp,sumtp,sumpos)
	return not c:IsRace(RACE_FIEND)
end
function cm.valcheck(e,c)
	local flag=0
	local g=c:GetMaterial()
	local ag=g:Filter(cm.mfilter,nil)
	if ag:GetCount()~=0 then
		flag=flag|1
	end
	e:GetLabelObject():SetLabel(flag)
end
function cm.mfilter(c)
	return c:IsAttribute(ATTRIBUTE_DARK) and c:IsSetCard(0x5f3e)
end
function cm.tncon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_SYNCHRO) and e:GetLabel()>0
end
function cm.tnop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if e:GetLabel()&1==1 then
		--immune
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_IMMUNE_EFFECT)
		e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e2:SetRange(LOCATION_MZONE)
		e2:SetValue(cm.efilter)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e2)
		c:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(m,0))
	end
end
function cm.atkfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x6f3e) and c:IsType(TYPE_CONTINUOUS) and c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function cm.atkval(e,c)
	return Duel.GetMatchingGroupCount(cm.atkfilter,c:GetControler(),LOCATION_SZONE,0,nil)*1500
end
function cm.atcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()<=PHASE_BATTLE and Duel.IsAbleToEnterBP()
end
function cm.cfilter(c)
	return c:IsAbleToRemoveAsCost()
end
function cm.atcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(cm.cfilter,tp,LOCATION_MZONE+LOCATION_PZONE,0,e:GetHandler())
	if chk==0 then return g:GetCount()>0 end
	local x=Duel.Remove(g,POS_FACEUP,REASON_COST)
	e:SetLabel(x)
end
function cm.atop(e,tp,eg,ep,ev,re,r,rp)
	local ct=e:GetLabel()
	local e5=Effect.CreateEffect(e:GetHandler())
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCode(EFFECT_UPDATE_ATTACK)
	e5:SetValue(ct*2000)
	e5:SetReset(RESET_EVENT+RESETS_STANDARD)
	e:GetHandler():RegisterEffect(e5)
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_PHASE+PHASE_BATTLE)
	e2:SetCountLimit(1)
	e2:SetReset(RESET_PHASE+PHASE_BATTLE+RESET_PHASE+PHASE_END)
	e2:SetOperation(cm.ctop)
	e2:SetLabel(tp)
	Duel.RegisterEffect(e2,tp)
end
function cm.ctop(e,tp,eg,ep,ev,re,r,rp)
	local p=e:GetLabel()
	Duel.SetLP(p,0)
end