local m=53796066
local cm=_G["c"..m]
cm.name="迷航之触"
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e1:SetCountLimit(1,m)
	e1:SetTarget(cm.sptg)
	e1:SetOperation(cm.spop)
	c:RegisterEffect(e1)
end
function cm.cfilter(c)
	return (c:IsFaceup() or c:IsLocation(LOCATION_GRAVE)) and c:GetRace()~=0 and c:IsAttribute(ATTRIBUTE_WATER)
end
function cm.filter(c,e,tp)
	return c:IsLevelBelow(5) and c:IsAttribute(ATTRIBUTE_WATER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and not Duel.IsExistingMatchingCard(cm.filter1,tp,LOCATION_MZONE+LOCATION_GRAVE,0,1,c,c:GetRace())
end
function cm.filter1(c,race)
	return (c:IsFaceup() or c:IsLocation(LOCATION_GRAVE)) and c:IsRace(race)
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(cm.cfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,c)
	local ct=g:GetClassCount(Card.GetRace)
	if ct==0 then return false end
	local b1=(c:IsLocation(LOCATION_HAND) or ct>2) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
	local b2=ct>4 and Duel.GetLocationCount(tp,LOCATION_MZONE)>1 and Duel.IsPlayerCanSpecialSummonCount(tp,2) and Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,nil,e,tp)
	if chk==0 then return b1 or b2 end
	if b2 then Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE) elseif b1 then Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0) end
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(cm.cfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,c)
	local ct=g:GetClassCount(Card.GetRace)
	local rflag=false
	local c=e:GetHandler()
	if ct>0 then
		if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 then rflag=true end
	end
	if ct>4 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,cm.filter,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,e,tp)
		if g:GetCount()>0 then
			if rflag then Duel.BreakEffect() end
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end
