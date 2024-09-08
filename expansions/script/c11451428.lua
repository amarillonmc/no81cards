--闪刀信条-守护
local cm,m=GetID()
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_BATTLE_START+TIMING_ATTACK)
	e1:SetCondition(cm.condition)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
end
function cm.cfilter(c)
	return c:GetSequence()<5
end
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	return aux.bpcon() and not Duel.IsExistingMatchingCard(cm.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function cm.filter2(c)
	return c:IsFaceup() and c:IsSetCard(0x1115) and c:IsType(TYPE_MONSTER)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and cm.filter2(chkc) end
	if chk==0 then return Duel.IsExistingTarget(cm.filter2,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,cm.filter2,tp,LOCATION_MZONE,0,1,1,nil)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local c=e:GetHandler()
	if tc:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_ONLY_ATTACK_MONSTER)
		e1:SetTargetRange(0,LOCATION_MZONE)
		e1:SetValue(cm.atklimit)
		e1:SetLabel(tc:GetRealFieldID())
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
		if Duel.GetMatchingGroupCount(Card.IsType,tp,LOCATION_GRAVE,0,nil,TYPE_SPELL)<3 then return end
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_FIELD)
		e2:SetCode(EFFECT_IMMUNE_EFFECT)
		e2:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
		e2:SetTargetRange(LOCATION_ONFIELD,0)
		e2:SetValue(cm.efilter)
		e2:SetLabel(tc:GetRealFieldID())
		e2:SetLabelObject(tc)
		e2:SetOwnerPlayer(tp)
		e2:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e2,tp)
	end
end
function cm.atklimit(e,c)
	return c:GetRealFieldID()==e:GetLabel()
end
function cm.efilter(e,re)
	local c=e:GetLabelObject()
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	return e:GetOwnerPlayer()~=re:GetOwnerPlayer() and (c:GetRealFieldID()~=e:GetLabel() or not (re:IsHasType(EFFECT_TYPE_ACTIONS) and re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) and g and g:IsContains(c)))
end