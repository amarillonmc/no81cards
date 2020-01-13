--月下花园恋人
function c9910071.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(Card.IsRace,RACE_FAIRY),1)
	c:EnableReviveLimit()
	--change attribute
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCondition(c9910071.attcon)
	e1:SetTarget(c9910071.atttg)
	e1:SetOperation(c9910071.attop)
	c:RegisterEffect(e1)
	--recover
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_RECOVER)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,9910071)
	e2:SetCost(c9910071.reccost)
	e2:SetTarget(c9910071.rectg)
	e2:SetOperation(c9910071.recop)
	c:RegisterEffect(e2)
end
function c9910071.attcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_SYNCHRO)
end
function c9910071.atttg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsFaceup() and not c:IsAttribute(ATTRIBUTE_DARK) end
end
function c9910071.attop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFaceup() and c:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_ATTRIBUTE)
		e1:SetValue(ATTRIBUTE_DARK)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		c:RegisterEffect(e1)
	end
end
function c9910071.reccost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroupEx(tp,Card.IsRace,1,nil,RACE_FAIRY) end
	local g=Duel.SelectReleaseGroupEx(tp,Card.IsRace,1,2,nil,RACE_FAIRY)
	local label=g:GetCount()*10
	if g:IsExists(Card.IsAttribute,1,nil,ATTRIBUTE_LIGHT) then label=label+1 end
	if g:IsExists(Card.IsAttribute,1,nil,ATTRIBUTE_DARK) then label=label+2 end
	e:SetLabel(label)
	Duel.Release(g,REASON_COST)
end
function c9910071.rectg(e,tp,eg,ep,ev,re,r,rp,chk)
	local label=e:GetLabel()
	local ct1=label//10
	local ct2=label-ct1*10
	if chk==0 then return true end
	if ct2==1 then
		e:SetCategory(CATEGORY_RECOVER+CATEGORY_TOHAND+CATEGORY_SEARCH)
	elseif ct2==2 then
		e:SetCategory(CATEGORY_RECOVER+CATEGORY_TODECK)
	elseif ct2==3 then
		e:SetCategory(CATEGORY_RECOVER+CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_TODECK)
	end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(ct1*1000)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,ct1*1000)
end
function c9910071.thfilter(c)
	return c:IsType(TYPE_TRAP) and c:IsType(TYPE_COUNTER) and c:IsAbleToHand()
end
function c9910071.recop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Recover(p,d,REASON_EFFECT)
	local label=e:GetLabel()
	local ct1=label//10
	local ct2=label-ct1*10
	if (ct2==1 or ct2==3) and Duel.IsExistingMatchingCard(c9910071.thfilter,tp,LOCATION_DECK,0,1,nil)
		and Duel.SelectYesNo(tp,aux.Stringid(9910071,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,c9910071.thfilter,tp,LOCATION_DECK,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	end
	if (ct2==2 or ct2==3) and Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)>0
		and Duel.SelectYesNo(tp,aux.Stringid(9910071,1)) then
		local g=Duel.GetFieldGroup(tp,0,LOCATION_HAND):RandomSelect(tp,1)
		Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
	end
end
