local m=25000119
local cm=_G["c"..m]
cm.name="百万巨神 大法乌"
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_HAND)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCondition(cm.spcon)
	e1:SetTarget(cm.sptg)
	e1:SetOperation(cm.spop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,1))
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetTarget(cm.target)
	e2:SetOperation(cm.operation)
	c:RegisterEffect(e2)
end
function cm.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(Card.IsFaceup,tp,LOCATION_FZONE,LOCATION_FZONE,1,nil) and re:IsHasType(EFFECT_TYPE_ACTIVATE) and (re:GetActiveType()==TYPE_SPELL or re:GetActiveType()==TYPE_TRAP)
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
function cm.thfilter(c)
	return c:IsCode(25000113,25000116) and c:IsAbleToHand()
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and aux.NegateEffectMonsterFilter(chkc) and chkc~=e:GetHandler() end
	local b1=Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_DECK,0,1,nil)
	local b2=Duel.IsExistingTarget(aux.NegateEffectMonsterFilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,e:GetHandler())
	if chk==0 then return b1 or b2 end
	local op=0
	if b1 and b2 then op=Duel.SelectOption(tp,aux.Stringid(m,2),aux.Stringid(m,3))
	elseif b1 then op=Duel.SelectOption(tp,aux.Stringid(m,2))
	else op=Duel.SelectOption(tp,aux.Stringid(m,3))+1 end
	e:SetLabel(op)
	if op==0 then
		e:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND+CATEGORY_TODECK)
		e:SetProperty(EFFECT_FLAG_DELAY)
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
		Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_HAND)
	else
		e:SetCategory(CATEGORY_DISABLE)
		e:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISABLE)
		local g=Duel.SelectTarget(tp,aux.NegateEffectMonsterFilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,e:GetHandler())
		Duel.SetOperationInfo(0,CATEGORY_DISABLE,g,1,0,0)
	end
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	if e:GetLabel()==0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,cm.thfilter,tp,LOCATION_DECK,0,1,1,nil)
		if g:GetCount()>0 and Duel.SendtoHand(g,nil,REASON_EFFECT)>0 then
			Duel.ConfirmCards(1-tp,g)
			Duel.ShuffleDeck(tp)
			Duel.ShuffleHand(tp)
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
			local sg=Duel.SelectMatchingCard(tp,Card.IsAbleToDeck,tp,LOCATION_HAND,0,1,1,nil)
			if sg:GetCount()>0 then
				Duel.BreakEffect()
				Duel.SendtoDeck(sg,nil,1,REASON_EFFECT)
			end
		end
	else
		local c=e:GetHandler()
		local tc=Duel.GetFirstTarget()
		if tc:IsFaceup() and tc:IsRelateToEffect(e) and not tc:IsDisabled() and not tc:IsImmuneToEffect(e) then
			Duel.NegateRelatedChain(tc,RESET_TURN_SET)
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_DISABLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e1)
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_DISABLE_EFFECT)
			e2:SetValue(RESET_TURN_SET)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e2)
		end
	end
end
