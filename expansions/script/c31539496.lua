--真竜皇リトスアジムD
function c31539496.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(31539496,0))
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,31539496)
	e1:SetTarget(c31539496.sptg)
	e1:SetOperation(c31539496.spop)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(31539496,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_DESTROYED)
	e2:SetCountLimit(1,31539497)
	e2:SetCondition(c31539496.spcon2)
	e2:SetTarget(c31539496.sptg2)
	e2:SetOperation(c31539496.spop2)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCountLimit(1,31539498+EFFECT_COUNT_CODE_DUEL)
	e3:SetCost(aux.bfgcost)
	e3:SetTarget(c31539496.sptg3)
	e3:SetOperation(c31539496.spop3)
	c:RegisterEffect(e3)
end
function c31539496.desfilter(c)
	return c:IsType(TYPE_MONSTER) and ((c:IsLocation(LOCATION_MZONE) and c:IsFaceup()) or c:IsLocation(LOCATION_HAND))
end
function c31539496.locfilter(c,tp)
	return c:IsLocation(LOCATION_MZONE) and c:IsControler(tp)
end 
function c31539496.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local loc=LOCATION_MZONE+LOCATION_HAND
	if ft<0 then loc=LOCATION_MZONE end
	local loc2=0
	if Duel.IsPlayerAffectedByEffect(tp,88581108) then loc2=LOCATION_MZONE end
	local g=Duel.GetMatchingGroup(c31539496.desfilter,tp,loc,loc2,c)
	if chk==0 then return c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and g:GetCount()>=1   and (ft>0 or g:IsExists(c31539496.locfilter,-ft+1,nil,tp)) end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,tp,loc)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c31539496.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local loc=LOCATION_MZONE+LOCATION_HAND
	if ft<0 then loc=LOCATION_MZONE end
	local loc2=0
	if Duel.IsPlayerAffectedByEffect(tp,88581108) then loc2=LOCATION_MZONE end
	local g=Duel.GetMatchingGroup(c31539496.desfilter,tp,loc,loc2,c)
	if g:GetCount()<1  then return end
	local g1=nil local g2=nil
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	if ft<1 then
		g1=g:FilterSelect(tp,c31539496.locfilter,1,1,nil,tp)
	else
		g1=g:Select(tp,1,1,nil)
	end
	g:RemoveCard(g1:GetFirst())
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local rm=g1:IsExists(Card.IsAttribute,1,nil,ATTRIBUTE_EARTH)
	if Duel.Destroy(g1,REASON_EFFECT)==1 then
		if not c:IsRelateToEffect(e) then return end
		if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)==0 then
			return
		end
		local rg=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_EXTRA,nil)
		if rm and rg:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(31539496,2)) then
			Duel.ConfirmCards(tp,rg)
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
			local tg=rg:SelectSubGroup(tp,aux.dncheck,false,1,3)
			Duel.Remove(tg,POS_FACEUP,REASON_EFFECT)
			Duel.ShuffleExtra(1-tp)
		end
	end
end
function c31539496.spcon2(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsReason(REASON_EFFECT)
end
function c31539496.thfilter(c,e,tp)
	return c:IsNonAttribute(ATTRIBUTE_EARTH) and c:IsRace(RACE_WYRM) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c31539496.thfilter2(c,e,tp)
	return  c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c31539496.sptg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c31539496.thfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function c31539496.spop2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c31539496.thfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c31539496.sptg3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>1
		and Duel.IsExistingMatchingCard(c31539496.thfilter2,tp,LOCATION_GRAVE,0,2,e:GetHandler(),e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function c31539496.spop3(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=1 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c31539496.thfilter2,tp,LOCATION_GRAVE,0,2,2,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
