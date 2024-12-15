local m=15005812
local cm=_G["c"..m]
cm.name="天翎渊之造主·撒拉斐永"
function cm.initial_effect(c)
	--synchro summon
	aux.AddSynchroMixProcedure(c,aux.Tuner(nil),nil,nil,aux.Tuner(aux.FilterBoolFunction(Card.IsAttribute,ATTRIBUTE_LIGHT)),1,99)
	c:EnableReviveLimit()
	--search
	local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e5:SetProperty(EFFECT_FLAG_DELAY)
	e5:SetCode(EVENT_SPSUMMON_SUCCESS)
	e5:SetCountLimit(1,m)
	e5:SetCondition(cm.thcon)
	e5:SetTarget(cm.thtg)
	e5:SetOperation(cm.thop)
	c:RegisterEffect(e5)
	--return
	local e6=Effect.CreateEffect(c)
	e6:SetCategory(CATEGORY_TOEXTRA+CATEGORY_TOHAND)
	e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_QUICK_O)
	e6:SetCode(EVENT_CHAINING)
	e6:SetRange(LOCATION_MZONE+LOCATION_GRAVE)
	e6:SetCountLimit(1,m+1)
	e6:SetCondition(cm.tecon)
	e6:SetTarget(cm.tetg)
	e6:SetOperation(cm.teop)
	c:RegisterEffect(e6)
end
function cm.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_SYNCHRO)
end
function cm.thfilter(c)
	return c:IsSetCard(0x5f43) and c:IsAbleToHand()
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function cm.pubfilter(c)
	return c:IsSetCard(0x5f43) and not c:IsPublic()
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,cm.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 and Duel.SendtoHand(g,nil,REASON_EFFECT)>0 then
		Duel.ConfirmCards(1-tp,g)
		if Duel.IsExistingMatchingCard(cm.pubfilter,tp,LOCATION_HAND,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(m,1)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(m,2))
			local tc=Duel.SelectMatchingCard(tp,cm.pubfilter,tp,LOCATION_HAND,0,1,1,nil):GetFirst()
			if not tc then return end
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetDescription(66)
			e1:SetCode(EFFECT_PUBLIC)
			e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END+RESET_OPPO_TURN)
			tc:RegisterEffect(e1)
		end
	end
end
function cm.tecon(e,tp,eg,ep,ev,re,r,rp)
	return re:IsHasType(EFFECT_TYPE_ACTIVATE)
		and re:GetHandler():IsSetCard(0x5f43) and re:GetHandler():IsType(TYPE_CONTINUOUS)
end
function cm.tethfilter(c)
	return c:IsSetCard(0x5f43) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function cm.tetg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToExtra() and Duel.IsExistingMatchingCard(cm.tethfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOEXTRA,e:GetHandler(),1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
end
function cm.teop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.SendtoDeck(c,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)>0 and c:IsLocation(LOCATION_EXTRA) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(cm.tethfilter),tp,LOCATION_GRAVE,0,1,2,nil)
		if g:GetCount()>0 then
			Duel.BreakEffect()
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	end
end