--真竜皇バハルストスF
function c83321037.initial_effect(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,83321037)
	e1:SetTarget(c83321037.sptg)
	e1:SetOperation(c83321037.spop)
	c:RegisterEffect(e1)
	--spsummon2
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_DESTROYED)
	e2:SetCountLimit(1,83321038)
	e2:SetCondition(c83321037.spcon2)
	e2:SetTarget(c83321037.sptg2)
	e2:SetOperation(c83321037.spop2)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_DISABLE)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCountLimit(1,83321039+EFFECT_COUNT_CODE_DUEL)
	e3:SetCost(aux.bfgcost)
	e3:SetTarget(c83321037.sptg3)
	e3:SetOperation(c83321037.spop3)
	c:RegisterEffect(e3)
end
function c83321037.desfilter(c)
	return c:IsType(TYPE_MONSTER) and ((c:IsLocation(LOCATION_MZONE) and c:IsFaceup()) or c:IsLocation(LOCATION_HAND))
end
function c83321037.locfilter(c,tp)
	return c:IsLocation(LOCATION_MZONE) and c:IsControler(tp)
end
function c83321037.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local loc=LOCATION_MZONE+LOCATION_HAND
	if ft<0 then loc=LOCATION_MZONE end
	local loc2=0
	if Duel.IsPlayerAffectedByEffect(tp,88581108) then loc2=LOCATION_MZONE end
	local g=Duel.GetMatchingGroup(c83321037.desfilter,tp,loc,loc2,c)
	if chk==0 then return c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and g:GetCount()>=1 and (ft>0 or g:IsExists(c83321037.locfilter,-ft+1,nil,tp)) end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,tp,loc)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c83321037.rmfilter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToRemove()
end
function c83321037.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local loc=LOCATION_MZONE+LOCATION_HAND
	if ft<0 then loc=LOCATION_MZONE end
	local loc2=0
	if Duel.IsPlayerAffectedByEffect(tp,88581108) then loc2=LOCATION_MZONE end
	local g=Duel.GetMatchingGroup(c83321037.desfilter,tp,loc,loc2,c)
	if g:GetCount()<1  then return end
	local g1=nil local g2=nil
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	if ft<1 then
		g1=g:FilterSelect(tp,c83321037.locfilter,1,1,nil,tp)
	else
		g1=g:Select(tp,1,1,nil)
	end
	g:RemoveCard(g1:GetFirst())
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local rm=g1:IsExists(Card.IsAttribute,1,nil,ATTRIBUTE_WATER)
	if Duel.Destroy(g1,REASON_EFFECT)==1 then
		if not c:IsRelateToEffect(e) then return end
		if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)==0 then
			return
		end
		local rg=Duel.GetMatchingGroup(c83321037.rmfilter,tp,0,LOCATION_ONFIELD+LOCATION_GRAVE,nil)
		if rm and rg:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(83321037,1)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
			local tg=rg:Select(tp,1,2,nil)
			Duel.HintSelection(tg)
			Duel.Remove(tg,POS_FACEUP,REASON_EFFECT)
		end
	end
end
function c83321037.spcon2(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsReason(REASON_EFFECT)
end
function c83321037.thfilter(c,e,tp)
	return c:IsNonAttribute(ATTRIBUTE_WATER) and c:IsRace(RACE_WYRM) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE)
end
function c83321037.sptg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c83321037.thfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,LOCATION_DECK)
end
function c83321037.spop2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c83321037.thfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
	end
end
function c83321037.sptg3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.NegateAnyFilter,tp,0,LOCATION_ONFIELD,2,nil) end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,nil,2,0,LOCATION_ONFIELD)
end
function c83321037.spop3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.SelectMatchingCard(tp,aux.NegateAnyFilter,tp,0,LOCATION_ONFIELD,2,2,nil)
		local tc=g:GetFirst()
		Duel.HintSelection(g)
	while tc do
		Duel.NegateRelatedChain(tc,RESET_TURN_SET)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e2:SetValue(RESET_TURN_SET)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e2)
		if tc:IsType(TYPE_TRAPMONSTER) then
			local e3=Effect.CreateEffect(c)
			e3:SetType(EFFECT_TYPE_SINGLE)
			e3:SetCode(EFFECT_DISABLE_TRAPMONSTER)
			e3:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e3)
		end
	tc=g:GetNext()
	end
end