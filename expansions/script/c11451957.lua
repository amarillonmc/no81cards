--水灵佑佐 艾莉娅
local cm,m=GetID()
function cm.initial_effect(c)
	--immune
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_CHAINING)
	e3:SetRange(LOCATION_MZONE)
	e3:SetOperation(cm.chainop)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e2:SetRange(LOCATION_MZONE)
	e2:SetLabelObject(e3)
	e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e2:SetTarget(aux.TargetBoolFunction(Card.IsType,TYPE_EFFECT))
	c:RegisterEffect(e2)
	--tohand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_TOGRAVE+CATEGORY_DECKDES)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetHintTiming(0,TIMING_END_PHASE+TIMINGS_CHECK_MONSTER)
	e1:SetCountLimit(1)
	e1:SetTarget(cm.tdtg)
	e1:SetOperation(cm.tdop)
	local e4=e2:Clone()
	e4:SetLabelObject(e1)
	c:RegisterEffect(e4)
end
function cm.chainop(e,tp,eg,ep,ev,re,r,rp)
	if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return end
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	if g and g:IsContains(e:GetHandler()) then
		Duel.SetChainLimit(function(e,lp,tp) return e:GetHandler()==c end)
	end
end
function cm.tgfilter(c,tp)
	return c:IsFaceup() and Duel.IsExistingMatchingCard(cm.cfilter2,tp,LOCATION_DECK+LOCATION_ONFIELD,LOCATION_ONFIELD,1,c,c)
end
function cm.cfilter2(c,tc)
	return c:IsAbleToGrave() and ((tc:IsType(c:GetType()&0x6) and (c:IsFaceupEx() or c:GetEquipTarget() or c:IsLocation(LOCATION_FZONE))) or (tc:IsType(c:GetType()&0x1) and c:IsFaceupEx() and tc:IsAttribute(c:GetAttribute())))
end
function cm.tdtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and cm.tgfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(cm.tgfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local tg=Duel.SelectTarget(tp,cm.tgfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil,tp)
	Duel.Hint(HINT_OPSELECTED,tp,e:GetDescription())
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,2,PLAYER_ALL,LOCATION_DECK+LOCATION_ONFIELD)
end
function cm.tdop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) or not (tc:IsFaceupEx() or tc:GetEquipTarget() or tc:IsLocation(LOCATION_FZONE)) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,cm.cfilter2,tp,LOCATION_DECK+LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,tc,tc)
	if #g>0 then
		g:AddCard(tc)
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
end