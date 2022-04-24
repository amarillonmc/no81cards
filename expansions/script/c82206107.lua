--时钟诛机
local m=82206107
local cm=_G["c"..m]
function cm.initial_effect(c)
	--synchro summon
	c:EnableReviveLimit()
	aux.AddSynchroMixProcedure(c,cm.matfilter1,nil,nil,aux.NonTuner(cm.syncheck),1,99)
	--effect gain
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(cm.regcon)
	e1:SetOperation(cm.regop)
	c:RegisterEffect(e1)
	--
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_CHAIN_SOLVING)
	e2:SetCondition(cm.condition)
	e2:SetOperation(cm.operation)
	c:RegisterEffect(e2)
end
function cm.matfilter1(c) 
	return (c:IsSynchroType(TYPE_TUNER) or c:IsSetCard(0x3294)) and c:IsAttribute(ATTRIBUTE_LIGHT)
end
function cm.syncheck(c)
	return c:IsAttribute(ATTRIBUTE_DARK)
end
function cm.lcheck(g,lc)
	return g:GetClassCount(Card.GetLinkCode)==g:GetCount()
end
function cm.regcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_SYNCHRO)
end
function cm.regop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rg=c:GetMaterial()
	for tc in aux.Next(rg) do
		if tc:IsSetCard(0x3294) then
			local code=tc:GetOriginalCode()
			c:CopyEffect(code,RESET_EVENT+0x7e0000)
		end
	end
end
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp and rp~=tp
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local code1,code2=re:GetHandler():GetCode()
	local ct=Duel.GetTurnCount()
	if code1 then
		Duel.Hint(HINT_CARD,1,m)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetCode(EFFECT_CANNOT_ACTIVATE)
		e1:SetTargetRange(0,1)
		e1:SetLabel(code1,ct)
		e1:SetValue(cm.aclimit1)
		e1:SetReset(RESET_PHASE+PHASE_END+RESET_OPPO_TURN,2)
		Duel.RegisterEffect(e1,tp)
	end
	if code2 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetCode(EFFECT_CANNOT_ACTIVATE)
		e1:SetTargetRange(0,1)
		e1:SetLabel(code2,ct)
		e1:SetValue(cm.aclimit1)
		e1:SetReset(RESET_PHASE+PHASE_END+RESET_OPPO_TURN,2)
		Duel.RegisterEffect(e1,tp)
	end
end
function cm.aclimit1(e,re,tp)
	local code,ct=e:GetLabel()
	return re:GetHandler():GetOriginalCode()==code and Duel.GetTurnCount()>ct+1
end