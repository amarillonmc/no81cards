--闪耀的迷光 和泉爱依
function c28316251.initial_effect(c)
	--Straylight spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(28316251,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_COUNTER+CATEGORY_POSITION)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,28316251)
	e1:SetCondition(c28316251.spcon)
	e1:SetTarget(c28316251.sptg)
	e1:SetOperation(c28316251.spop)
	c:RegisterEffect(e1)
	--Straylight search
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(28316251,2))
	e2:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,38316251)
	e2:SetCost(c28316251.thcost)
	e2:SetTarget(c28316251.thtg)
	e2:SetOperation(c28316251.thop)
	c:RegisterEffect(e2)
	--atk/def up
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_FLIP)
	e3:SetTarget(c28316251.atktg)
	e3:SetOperation(c28316251.atkop)
	c:RegisterEffect(e3)
c28316251.shinycounter=true
end
function c28316251.slfilter(c)
	return c:IsFaceup() and (c:GetCounter(0x1283)>0 or (c:IsSetCard(0x288) and c:IsLocation(LOCATION_MZONE)))
end
function c28316251.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c28316251.slfilter,tp,LOCATION_ONFIELD,0,1,nil)
end
function c28316251.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c28316251.ctfilter(c)
	return c:IsSetCard(0x288) and c:IsFaceup() and c:IsCanAddCounter(0x1283,1)
end
function c28316251.mefilter(c)
	return c:IsSetCard(0x288) and c:IsFaceup()
end
function c28316251.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 or not c:IsRelateToEffect(e) then return end
	if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 and Duel.IsExistingMatchingCard(c28316251.ctfilter,tp,LOCATION_MZONE,0,1,nil) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_COUNTER)
		local g=Duel.SelectMatchingCard(tp,c28316251.ctfilter,tp,LOCATION_MZONE,0,1,1,nil)
		if g:GetFirst():AddCounter(0x1283,1)~=0 and Duel.IsExistingMatchingCard(Card.IsFaceup,tp,LOCATION_MZONE,0,1,c) and c:IsCanTurnSet() and Duel.SelectYesNo(tp,aux.Stringid(28316251,1)) then
			Duel.BreakEffect()
			Duel.ChangePosition(c,POS_FACEDOWN_DEFENSE)
			Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(28316251,4))
			local tc=Duel.SelectMatchingCard(tp,Card.IsFaceup,tp,LOCATION_MZONE,0,1,1,nil):GetFirst()
			tc:AddCounter(0x1283,1)
		end
	end
end
function c28316251.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsCanRemoveCounter(tp,1,0,0x1283,3,REASON_COST) end
	Duel.RemoveCounter(tp,1,0,0x1283,3,REASON_COST)
end
function c28316251.thfilter(c)
	return c:IsSetCard(0x283) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c28316251.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c28316251.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c28316251.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c28316251.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c28316251.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
end
function c28316251.atkop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local tc=Duel.SelectMatchingCard(tp,Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil):GetFirst()
	if tc then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetValue(1000)
		tc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_UPDATE_DEFENSE)
		tc:RegisterEffect(e2)
		local e3=e1:Clone()
		e3:SetCode(EFFECT_UPDATE_LEVEL)
		e3:SetValue(1)
		tc:RegisterEffect(e3)
		tc:RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(28316251,5))
	end
end
