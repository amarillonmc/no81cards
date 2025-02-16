--海岛的炼金术士 莱莎琳·斯托特
function c75011024.initial_effect(c)
	aux.AddCodeList(c,46130346,5318639,12580477)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x75e),4,2,c75011024.ovfilter,aux.Stringid(75011024,0),2,c75011024.xyzop)
	c:EnableReviveLimit()
	--to grave
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOGRAVE+CATEGORY_DECKDES)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCondition(c75011024.tgcon)
	e1:SetCost(c75011024.tgcost)
	e1:SetTarget(c75011024.tgtg)
	e1:SetOperation(c75011024.tgop)
	c:RegisterEffect(e1)
	--to deck
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TODECK)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c75011024.tdcon)
	e2:SetTarget(c75011024.tdtg)
	e2:SetOperation(c75011024.tdop)
	c:RegisterEffect(e2)
end
function c75011024.ovfilter(c)
	return c:IsAttribute(ATTRIBUTE_LIGHT) and c:IsSetCard(0x75e) and c:IsFaceup()
end
function c75011024.xyzop(e,tp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,75011024)==0 and Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE)>Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0) end
	Duel.RegisterFlagEffect(tp,75011024,RESET_PHASE+PHASE_END,EFFECT_FLAG_OATH,1)
end
function c75011024.tgcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ)
end
function c75011024.tgcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	local g=e:GetHandler():GetOverlayGroup()
	e:SetLabel(#g)
	Duel.SendtoGrave(g,REASON_COST)
end
function c75011024.tgfilter(c)
	return c:IsCode(46130346,5318639,12580477) and c:IsAbleToGrave()
end
function c75011024.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c75011024.tgfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function c75011024.thfilter(c)
	return (c:IsType(TYPE_QUICKPLAY) or c:GetType()==TYPE_SPELL) and c:IsAbleToHand()
end
function c75011024.tgop(e,tp,eg,ep,ev,re,r,rp)
	local ct=e:GetLabel()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c75011024.tgfilter,tp,LOCATION_DECK,0,1,ct,nil)
	if #g>0 and Duel.SendtoGrave(g,REASON_EFFECT)~=0 and g:IsExists(Card.IsLocation,1,nil,0x10)
		and Duel.IsExistingMatchingCard(c75011024.thfilter,tp,LOCATION_GRAVE,0,1,nil)
		and Duel.SelectYesNo(tp,aux.Stringid(75011024,2)) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local tc=Duel.SelectMatchingCard(tp,c75011024.thfilter,tp,LOCATION_GRAVE,0,1,1,nil):GetFirst()
		if tc then
			Duel.SendtoHand(tc,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,tc)
		end
	end
end
function c75011024.tdcon(e,tp,eg,ep,ev,re,r,rp)
	return ep==tp and re:IsHasType(EFFECT_TYPE_ACTIVATE)
		and (re:IsActiveType(TYPE_QUICKPLAY) or re:GetActiveType()==TYPE_SPELL)
end
function c75011024.tdfilter(c,e)
	return c:IsCode(46130346,5318639,12580477) and c:IsCanBeEffectTarget(e) and c:IsAbleToDeck() and c:IsFaceupEx()
end
function c75011024.tdtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(0x30) and chkc:IsControler(tp) and c75011024.tdfilter(chkc,e) end
	local g=Duel.GetMatchingGroup(c75011024.tdfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,nil,e)
	if chk==0 then return #g>0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local sg=g:SelectSubGroup(tp,aux.dncheck,false,1,3)
	Duel.SetTargetCard(sg)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,#g,0,0)
end
function c75011024.tdop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetTargetsRelateToChain()
	if #g>0 and Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)~=0 then
		local og=Duel.GetOperatedGroup()
		local tg=og:Filter(Card.IsLocation,nil,LOCATION_DECK)
		for tc in aux.Next(tg) do
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e1:SetCode(EVENT_CHAIN_SOLVED)
			e1:SetLabelObject(tc)
			--e1:SetCondition(c75011024.arcon)
			e1:SetOperation(c75011024.arop)
			Duel.RegisterEffect(e1,tp)
		end
	end
end
function c75011024.arop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	Duel.Hint(HINT_CARD,0,tc:GetOriginalCode())
	local te,ceg,cep,cev,cre,cr,crp=tc:CheckActivateEffect(false,true,true)
	if not te then return end
	Duel.ClearTargetCard()
	local tg=te:GetTarget()
	if tg then tg(te,tp,eg,ep,ev,re,r,rp,1) end
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	if g then
		for oc in aux.Next(g) do
			oc:CreateEffectRelation(te)
		end
	end
	local op=te:GetOperation()
	if op then op(te,tp,eg,ep,ev,re,r,rp) end
	--tc:ReleaseEffectRelation(te)
	if g then
		for oc in aux.Next(g) do
			oc:ReleaseEffectRelation(te)
		end
	end
	e:Reset()
end
