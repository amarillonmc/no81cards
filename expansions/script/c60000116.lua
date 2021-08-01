--伊米露·爱因
function c60000116.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkType,TYPE_EFFECT),2,99,c60000116.lcheck)
	c:EnableReviveLimit() 
	--
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(60000116,0))
	e1:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,60000116)
	e1:SetTarget(c60000116.actg)
	e1:SetOperation(c60000116.acop)
	c:RegisterEffect(e1)
	--
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(60000116,1))
	e2:SetCategory(CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,10000116)
	e2:SetTarget(c60000116.rmtg)
	e2:SetOperation(c60000116.rmop)
	c:RegisterEffect(e2)
end
function c60000116.lcheck(g)
	return g:IsExists(Card.IsLinkSetCard,1,nil,0x56a9)
end
function c60000116,ckfil(c)
	return c:IsType(TYPE_MONSTER) and IsSetCard(0x56a9)
end
function c60000116.actg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingTarget(c60000116.ckfil,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.SelectTarget(tp,c60000116.ckfil,tp,LOCATION_GRAVE,0,1,1,nil)
end
function c60000116.acop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	Duel.SendtoDeck(tc,tp,2,REASON_EFFECT)
	Duel.ShuffleDeck(tp)
	if Duel.GetDecktopGroup(tp,1):GetFirst():IsCode(tc:GetCode()) then
	Duel.Draw(tp,1,REASON_EFFECT)
	--negate
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_CHAIN_SOLVING)
	e2:SetCondition(c60000116.negcon)
	e2:SetOperation(c60000116.negop)
	Duel.RegisterEffect(e2,tp)
	else
	Duel.Draw(tp,1,REASON_EFFECT)
	tc1=Duel.SelectMatchingCard(tp,Card.IsCode,tp,LOCATION_DECK,0,1,1,nil,tc:GetCode())
	Duel.Remove(tc1,POS_FACEUP,REASON_EFFECT)
	end
end
function c60000116.negcon(e,tp,eg,ep,ev,re,r,rp)
	return re:IsActiveType(TYPE_MONSTER)
end
function c60000116.negop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,60000116)
	local rc=re:GetHandler()
	if Duel.SelectEffectYesNo(tp,e:GetHandler()) then
	Duel.NegateEffect(ev)
	e:Reset()
	end
end
function c60000116.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>0 end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,Duel.GetFieldGroup(tp,LOCATION_DECK,0),Duel.GetFieldGroupCount(tp,LOCATION_DECK,0),tp,LOCATION_DECK)
end
function c60000116(c)
	return not c:IsSetCard(0x36a0) 
end
function c60000116.rmop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetFieldGroup(tp,LOCATION_DECK,0)
	Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
	g:KeepAlive()
	--
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetCountLimit(1)
	e1:SetLabelObject(g)
	e1:SetOperation(c60000116.tdop)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	local g1=g:Filter(c60000116.ckfil,nil)
	local tc1=g1:GetFirst()
	while tc1 do
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_DISABLE)
	e1:SetTargetRange(LOCATION_ONFIELD,LOCATION_ONFIELD)
	e1:SetTarget(c60000116.distg)
	e1:SetLabelObject(tc1)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_CHAIN_SOLVING)
	e2:SetCondition(c60000116.discon)
	e2:SetOperation(c60000116.disop)
	e2:SetLabelObject(tc1)
	e2:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e2,tp)
	tc1=g1:GetNext()
	end
end
function c60000116.tdop(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
end
function c60000116.distg(e,c)
	local tc=e:GetLabelObject()
	return c:IsOriginalCodeRule(tc:GetOriginalCodeRule())
end
function c60000116.discon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	return re:GetHandler():IsOriginalCodeRule(tc:GetOriginalCodeRule())
end
function c60000116.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateEffect(ev)
end



















