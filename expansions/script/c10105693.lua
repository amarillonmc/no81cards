function c10105693.initial_effect(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,10105693)
	e1:SetCondition(c10105693.spcon)
	e1:SetTarget(c10105693.sptg)
	e1:SetOperation(c10105693.spop)
	c:RegisterEffect(e1)
    	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(10105693,0))
	e2:SetCategory(CATEGORY_DESTROY+CATEGORY_SEARCH+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,101056930)
	e2:SetTarget(c10105693.thtg)
	e2:SetOperation(c10105693.thop)
	c:RegisterEffect(e2)
end
function c10105693.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x1a1) and c:IsType(TYPE_MONSTER)
end
function c10105693.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c10105693.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c10105693.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c10105693.cgfilter(c)
	return c:IsFaceup() and c:IsAttackAbove(2000)
end
function c10105693.spfilter(c,e,tp)
	return c:IsSetCard(0x1a1) and c:IsAttackBelow(2000) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c10105693.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 then
		local cg=Duel.GetMatchingGroup(c10105693.cgfilter,tp,0,LOCATION_MZONE,nil)
		local ct=math.min(#cg,(Duel.GetLocationCount(tp,LOCATION_MZONE)))
		if ct>1 and Duel.IsPlayerAffectedByEffect(tp,59822133) then ct=1 end
		local g=Duel.GetMatchingGroup(c10105693.spfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,nil,e,tp)
		if g:GetCount()>0 and ct>0 and Duel.SelectYesNo(tp,aux.Stringid(10105693,1)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local sg=g:Select(tp,1,ct,nil)
			Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end
function c10105693.dfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x1a1) and c:IsType(TYPE_MONSTER)
end
function c10105693.filter(c)
	return c:IsSetCard(0x1a1) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToHand()
end
function c10105693.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(c10105693.dfilter,tp,LOCATION_MZONE,0,nil)
	if chk==0 then return #g>0 and Duel.IsExistingMatchingCard(c10105693.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c10105693.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,c10105693.dfilter,tp,LOCATION_MZONE,0,1,1,nil)
	if Duel.Destroy(g,REASON_EFFECT)<1 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local sg=Duel.SelectMatchingCard(tp,c10105693.filter,tp,LOCATION_DECK,0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
	end
end