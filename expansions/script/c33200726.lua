--音速的水将 尼克塔里奥
function c33200726.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkType,TYPE_EFFECT),2,2,c33200726.lcheck)
	c:EnableReviveLimit()
	--tohand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(33200726,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,33200726)
	e1:SetCondition(c33200726.thcon)
	e1:SetTarget(c33200726.thtg)
	e1:SetOperation(c33200726.thop)
	c:RegisterEffect(e1)
	--remove
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(33200726,1))
	e2:SetCategory(CATEGORY_COUNTER)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_REMOVE)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,33200727)
	e2:SetTarget(c33200726.rmtg)
	e2:SetOperation(c33200726.rmop)
	c:RegisterEffect(e2)
end
function c33200726.lcheck(g,lc)
	return g:IsExists(Card.IsLinkSetCard,1,nil,0xc32a)
end

--e1
function c33200726.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function c33200726.thfilter(c)
	return c:IsCode(33200721) and c:IsAbleToHand()
end
function c33200726.rmfilter(c)
	return c:IsSetCard(0xc32a) and c:IsAbleToRemove()
end
function c33200726.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c33200726.thfilter,tp,LOCATION_DECK,0,1,nil) and Duel.IsExistingMatchingCard(c33200726.rmfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_GRAVE)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c33200726.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c33200726.rmfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 and Duel.Remove(g,POS_FACEUP,REASON_EFFECT) then
		local tg=Duel.GetFirstMatchingCard(c33200726.thfilter,tp,LOCATION_DECK,0,nil)
		if tg then
			Duel.SendtoHand(tg,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,tg)
		end
	end
end

--e2
function c33200726.filter(c)
	return c:IsFaceup() and c:IsCanAddCounter(0x32a,2)
end
function c33200726.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chkc then return chkc:IsOnField() and c33200726.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c33200726.filter,tp,LOCATION_ONFIELD,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_COUNTER)
	Duel.SelectTarget(tp,c33200726.filter,tp,LOCATION_ONFIELD,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_COUNTER,nil,1,0,0x32a)
end
function c33200726.rmop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsFaceup() and tc:IsRelateToEffect(e) then
		tc:AddCounter(0x32a,2)
	end
end