--诶？四人的除夕？
function c10200067.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c10200067.cost)
	e1:SetTarget(c10200067.target)
	e1:SetOperation(c10200067.operation)
	c:RegisterEffect(e1)
end
function c10200067.cfilter(c,tp)
	return c:IsRace(RACE_BEASTWARRIOR+RACE_WINGEDBEAST+RACE_FAIRY) and c:IsReleasable()
		and Duel.IsExistingMatchingCard(c10200067.spfilter,tp,LOCATION_DECK,0,1,nil,c)
end
function c10200067.spfilter(c,mc)
	return c:GetCode()~=mc:GetCode()
		and c:GetAttribute()==mc:GetAttribute()
		and c:GetRace()==mc:GetRace()
		and c:GetTextAttack()==mc:GetTextAttack()
		and c:GetTextDefense()==mc:GetTextDefense()
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c10200067.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,c10200067.cfilter,1,nil,tp) end
	local g=Duel.SelectReleaseGroup(tp,c10200067.cfilter,1,1,nil,tp)
	local tc=g:GetFirst()
	e:SetLabelObject(tc)
	Duel.Release(g,REASON_COST)
end
function c10200067.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c10200067.spfilter2(c,e,tp,mc)
	return c:GetCode()~=mc:GetCode()
		and c:GetAttribute()==mc:GetAttribute()
		and c:GetRace()==mc:GetRace()
		and c:GetTextAttack()==mc:GetTextAttack()
		and c:GetTextDefense()==mc:GetTextDefense()
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c10200067.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local mc=e:GetLabelObject()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c10200067.spfilter2,tp,LOCATION_DECK,0,1,1,nil,e,tp,mc)
	if #g>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
