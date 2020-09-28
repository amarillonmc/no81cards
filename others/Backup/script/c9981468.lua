--医疗SPA
function c9981468.initial_effect(c)
	 --Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetLabel(0)
	e1:SetCountLimit(1,9981469+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c9981468.cost)
	e1:SetTarget(c9981468.target)
	e1:SetOperation(c9981468.activate)
	c:RegisterEffect(e1)
end
function c9981468.filter(c,e,tp)
	local rg=Duel.GetMatchingGroup(c9981468.cfilter,tp,LOCATION_GRAVE,0,c)
	local lv=c:GetLevel()
	return lv>0 and c:IsSetCard(0xba5) and c:IsCanBeSpecialSummoned(e,0,tp,true,false)
		and rg:CheckWithSumEqual(Card.GetLevel,lv,2,99)
end
function c9981468.cfilter(c)
	local lv=c:GetLevel()
	return lv>0 and c:IsType(TYPE_MONSTER) and c:IsSetCard(0xba5) and c:IsAbleToRemoveAsCost()
end
function c9981468.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(100)
	if chk==0 then return true end
end
function c9981468.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if e:GetLabel()~=100 then return false end
		e:SetLabel(0)
		return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
			and Duel.IsExistingMatchingCard(c9981468.filter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil,e,tp) end
	local g=Duel.GetMatchingGroup(c9981468.filter,tp,LOCATION_HAND+LOCATION_DECK,0,nil,e,tp)
	local lvt={}
	local pc=1
	for i=2,12 do
		if g:IsExists(c9981468.spfilter,1,nil,e,tp,i) then lvt[pc]=i pc=pc+1 end
	end
	lvt[pc]=nil
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(9981468,0))
	local lv=Duel.AnnounceNumber(tp,table.unpack(lvt))
	local rg=Duel.GetMatchingGroup(c9981468.cfilter,tp,LOCATION_GRAVE,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local sg=rg:SelectWithSumEqual(tp,Card.GetLevel,lv,2,99)
	Duel.Remove(sg,POS_FACEUP,REASON_COST)
	e:SetLabel(lv)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_HAND)
end
function c9981468.spfilter(c,e,tp,lv)
	return c:IsLevel(lv) and c:IsType(TYPE_MONSTER) and c:IsSetCard(0xba5) and c:IsCanBeSpecialSummoned(e,0,tp,true,false)
end
function c9981468.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c9981468.spfilter),tp,LOCATION_DECK+LOCATION_HAND,0,1,1,nil,e,tp,e:GetLabel())
	local tc=g:GetFirst()
	if tc then
		Duel.SpecialSummon(tc,0,tp,tp,true,false,POS_FACEUP)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CANNOT_ATTACK)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
	end
end

