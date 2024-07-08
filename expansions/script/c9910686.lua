--神械监牢 鞭挞者
function c9910686.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,9910686)
	e1:SetTarget(c9910686.sptg)
	e1:SetOperation(c9910686.spop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetCondition(c9910686.spcon)
	e2:SetCost(c9910686.spcost)
	c:RegisterEffect(e2)
	--special summon
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TOGRAVE+CATEGORY_REMOVE)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_DESTROYED)
	e3:SetCountLimit(1,9910687)
	e3:SetTarget(c9910686.tgtg)
	e3:SetOperation(c9910686.tgop)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EVENT_REMOVE)
	c:RegisterEffect(e4)
end
function c9910686.rmfilter(c)
	return c:IsFacedown() and c:IsAbleToRemove()
end
function c9910686.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsOnField() and chkc:IsControler(1-tp) and c9910686.rmfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c9910686.rmfilter,tp,0,LOCATION_ONFIELD,1,nil)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,c9910686.rmfilter,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c9910686.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)>0 and c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c9910686.spcon(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp
end
function c9910686.cfilter(c)
	return c:IsSetCard(0xc954) and c:IsType(TYPE_MONSTER) and c:IsAbleToRemoveAsCost()
end
function c9910686.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local b1=Duel.IsExistingMatchingCard(c9910686.cfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,c)
	local b2=Duel.IsPlayerAffectedByEffect(tp,9910682) and Duel.CheckLPCost(tp,2000)
	if chk==0 then return b1 or b2 end
	if b2 and (not b1 or Duel.SelectYesNo(tp,aux.Stringid(9910682,0))) then
		Duel.PayLPCost(tp,2000)
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local g=Duel.SelectMatchingCard(tp,c9910686.cfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,c)
		Duel.Remove(g,POS_FACEUP,REASON_COST)
	end
end
function c9910686.tgfilter(c)
	return c:IsSetCard(0xc954) and c:IsAbleToGrave()
end
function c9910686.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9910686.tgfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function c9910686.filter(c)
	return c:IsFaceup() and c:IsSetCard(0xc954)
end
function c9910686.tgop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c9910686.tgfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 and Duel.SendtoGrave(g,REASON_EFFECT)~=0 and g:GetFirst():IsLocation(LOCATION_GRAVE) then
		local ct=Duel.GetMatchingGroupCount(c9910686.filter,tp,LOCATION_MZONE,0,nil)
		local sg=Duel.GetMatchingGroup(c9910686.rmfilter,tp,0,LOCATION_EXTRA,nil)
		if ct>0 and sg:GetCount()>=ct and Duel.SelectYesNo(tp,aux.Stringid(9910686,0)) then
			Duel.BreakEffect()
			local rg=sg:RandomSelect(tp,ct)
			Duel.Remove(rg,POS_FACEUP,REASON_EFFECT)
		end
	end
end
