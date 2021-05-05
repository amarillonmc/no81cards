--深层之愿-大杯
function c40008597.initial_effect(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(40008597,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,40008597+EFFECT_COUNT_CODE_DUEL)
	e1:SetCost(c40008597.atkcost)
	e1:SetTarget(c40008597.sptg)
	e1:SetOperation(c40008597.spop)
	c:RegisterEffect(e1)	
end
function c40008597.atkcfilter(c)
	return c:IsRace(RACE_ZOMBIE) and c:IsAbleToGraveAsCost()
end
function c40008597.atkcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c40008597.atkcfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local tc=Duel.SelectMatchingCard(tp,c40008597.atkcfilter,tp,LOCATION_DECK,0,1,1,nil):GetFirst()
	Duel.SendtoGrave(tc,REASON_COST)
	e:SetLabel(tc:GetLevel())
end
function c40008597.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c40008597.dfilter(c)
	return c:IsFaceup() and c:IsCode(4064256)
end
function c40008597.filter(c,e,tp)
	return c:IsRace(RACE_ZOMBIE) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c40008597.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP) then 
		local dg=Duel.GetMatchingGroup(c40008597.dfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil) 
		local g=Duel.GetMatchingGroup(c40008597.cfilter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,1,nil)
		if dg:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(40008597,1)) then 
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local g=Duel.SelectMatchingCard(tp,c40008597.filter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,1,nil,e,tp)
			if g:GetCount()>0 then
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
			end
		end
	 end
end
