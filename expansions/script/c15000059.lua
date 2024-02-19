local m=15000059
local cm=_G["c"..m]
cm.name="色带神·犹格索托斯"
function cm.initial_effect(c)
	--synchro summon  
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(Card.IsSetCard,0x3f33),1)  
	c:EnableReviveLimit()
	--Destroy 
	local e1=Effect.CreateEffect(c)  
	e1:SetCategory(CATEGORY_DESTROY)  
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)  
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(cm.srcon)
	e1:SetTarget(cm.srtg)
	e1:SetOperation(cm.srop)
	c:RegisterEffect(e1)
end
function cm.srcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tp=c:GetControler()
	return c:IsSummonType(SUMMON_TYPE_SYNCHRO)
end
function cm.srtg(e,tp,eg,ep,ev,re,r,rp,chk)  
	local c=e:GetHandler()
	local tp=c:GetControler()
	if chk==0 then return c:IsDestructable(e) end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,c,1,0,0)  
end
function cm.srop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tp=c:GetControler()
	if Duel.Destroy(c,REASON_EFFECT)~=0 then
		local g=Duel.GetFieldGroup(tp,LOCATION_MZONE,0)
		if #g>0 and #g==Duel.GetMatchingGroupCount(cm.filter,tp,LOCATION_MZONE,0,1,nil) then
			Duel.BreakEffect()
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_FIELD)
			e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
			e1:SetCode(EFFECT_CANNOT_ACTIVATE)
			e1:SetTargetRange(0,1)
			e1:SetValue(cm.aclimit)
			e1:SetReset(RESET_PHASE+PHASE_END)
			Duel.RegisterEffect(e1,tp)
		end
	end
end
function cm.filter(c)
	return c:IsFaceup() and c:IsSetCard(0xf33)
end
function cm.aclimit(e,re,tp)
	return re:GetActivateLocation()==LOCATION_HAND
end