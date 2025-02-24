--坠落的城市
local s,id,o=GetID()
function s.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(1191)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,id+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
	--Cannot be effect
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e3:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetTarget(s.efftg)
	e3:SetValue(aux.tgoval)
	c:RegisterEffect(e3)
end
function s.efftg(e,c)
	return c:IsRace(RACE_FIEND) and c:IsSummonLocation(LOCATION_GRAVE)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDiscardDeck(1-tp,1) end
	Duel.SetOperationInfo(0,CATEGORY_DECKDES,nil,0,1-tp,1)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsAbleToGrave,tp,0,LOCATION_DECK,nil)
	local exsp=false
	if #g<0 then return end
	local max=13
	if #g<max then max=#g end
	local kazu={}
	local i=1
	for i=1,max do kazu[i]=i end
	local count=Duel.AnnounceNumber(1-tp,table.unpack(kazu))
	if Duel.DiscardDeck(1-tp,count,REASON_EFFECT)~=0 then
		local og1=Duel.GetOperatedGroup()
		local ct1=og1:FilterCount(Card.IsLocation,nil,LOCATION_GRAVE)
		if ct1>=1 then
			local g2=Duel.GetMatchingGroup(Card.IsAbleToGrave,tp,LOCATION_DECK,0,nil)
			if #g2<count then count=#g2 end
			Duel.DiscardDeck(tp,count,REASON_EFFECT)
			local og2=Duel.GetOperatedGroup()
			local ct2=og2:FilterCount(Card.IsLocation,nil,LOCATION_GRAVE)
			if ct1+ct2>=13 then exsp=true end
		end
	end
	if exsp and Duel.IsExistingMatchingCard(aux.NecroValleyFilter(s.spfilter),tp,LOCATION_GRAVE,0,1,nil,e,tp) and
	Duel.SelectYesNo(tp,aux.Stringid(id,1)) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.spfilter),tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
		local tc=sg:GetFirst()
		local b1=Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		local b2=Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0
		local toplayer=aux.SelectFromOptions(tp,
		{b1,aux.Stringid(id,2),tp},
		{b2,aux.Stringid(id,3),1-tp})
		if toplayer~=nil then
			Duel.SpecialSummon(tc,0,tp,toplayer,false,false,POS_FACEUP)
		end
	end
end
function s.spfilter(c,e,tp)
	return c:IsRace(RACE_FIEND) and ((Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)) or (c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,1-tp) and Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0))
end