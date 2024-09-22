--39光年的盛情
function c98921047.initial_effect(c)
	aux.AddCodeList(c,64382839)	
	c:SetUniqueOnField(1,0,98921047)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--boost
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetValue(c98921047.atkval)
	e2:SetCondition(c98921047.effcon)
	e2:SetTarget(aux.TargetBoolFunction(Card.IsCode,64382840))
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e3)
	--act limit
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_CHAINING)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCondition(c98921047.effcon2)
	e4:SetOperation(c98921047.chainop)
	c:RegisterEffect(e4)
	--remove
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e5:SetCode(EFFECT_TO_GRAVE_REDIRECT)
	e5:SetRange(LOCATION_SZONE)
	e5:SetTarget(c98921047.rmtarget)
	e5:SetCondition(c98921047.effcon3)
	e5:SetTargetRange(0,LOCATION_ONFIELD)
	e5:SetValue(LOCATION_REMOVED)
	c:RegisterEffect(e5)
	--to deck
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(98921047,1))
	e6:SetCategory(CATEGORY_TODECK)
	e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e6:SetRange(LOCATION_SZONE)
	e6:SetCode(EVENT_PHASE+PHASE_END)
	e6:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e6:SetCountLimit(1)
	e6:SetCondition(c98921047.condition2)
	e6:SetTarget(c98921047.target2)
	e6:SetOperation(c98921047.operation2)
	c:RegisterEffect(e6)
end
function c98921047.confilter(c)
	return c:IsCode(64382839)
end
function c98921047.effcon(e)
	local g=Duel.GetMatchingGroup(c98921047.confilter,e:GetHandlerPlayer(),LOCATION_GRAVE,0,nil)
	return g:GetCount()>=1
end
function c98921047.effcon2(e)
	local g=Duel.GetMatchingGroup(c98921047.confilter,e:GetHandlerPlayer(),LOCATION_GRAVE,0,nil)
	return g:GetCount()>=2
end
function c98921047.effcon3(e)
	local g=Duel.GetMatchingGroup(c98921047.confilter,e:GetHandlerPlayer(),LOCATION_GRAVE,0,nil)
	return g:GetCount()>=3
end
function c98921047.atkval(e,c)
	return Duel.GetMatchingGroup(Card.IsCode,e:GetHandlerPlayer(),LOCATION_GRAVE,0,nil,64382839):GetCount()*500
end
function c98921047.chainop(e,tp,eg,ep,ev,re,r,rp)
	if aux.IsCodeListed(re:GetHandler(),64382839) or re:GetHandler():IsCode(64382839) and ep==tp then
		Duel.SetChainLimit(c98921047.chainlm)
	end
end
function c98921047.chainlm(e,rp,tp)
	return tp==rp
end
function c98921047.rmtarget(e,c)
	return c:IsType(TYPE_MONSTER)
end
function c98921047.condition2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_END and Duel.GetTurnPlayer()~=tp
end
function c98921047.tgfilter2(c)
	return c:IsCode(64382839) and c:IsAbleToDeck()
end
function c98921047.target2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local check=Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==0
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c98921047.tgfilter2(chkc) end
	if chk==0 then return true end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,c98921047.tgfilter2,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
end
function c98921047.operation2(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) then return end
	Duel.SendtoDeck(tc,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
end