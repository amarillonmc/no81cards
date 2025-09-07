--昆虫学家托鲁
function c7449159.initial_effect(c)
	aux.AddCodeList(c,7449105)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(7449159,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e1:SetCountLimit(1,7449159)
	e1:SetCondition(c7449159.spscon)
	e1:SetTarget(c7449159.spstg)
	e1:SetOperation(c7449159.spsop)
	c:RegisterEffect(e1)
	--token
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOKEN+CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,7449159+1)
	e2:SetCost(c7449159.tkcost)
	e2:SetTarget(c7449159.tktg)
	e2:SetOperation(c7449159.tkop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
end
function c7449159.cfilter(c)
	return c:IsCode(7449105) or aux.IsCodeListed(c,7449105)
end
function c7449159.spscon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c7449159.cfilter,tp,LOCATION_GRAVE,0,5,nil)
end
function c7449159.spstg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetMZoneCount(tp)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c7449159.spsop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c7449159.tkcost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(1)
	if chk==0 then return true end
end
function c7449159.chkfilter(c)
	return c:IsRace(RACE_INSECT) and not c:IsPublic()
end
function c7449159.tktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if e:GetLabel()==0 then return false end
		e:SetLabel(0)
		return Duel.IsExistingMatchingCard(c7449159.chkfilter,tp,LOCATION_HAND,0,1,nil) and Duel.GetMZoneCount(tp)>0 and Duel.IsPlayerCanSpecialSummonMonster(tp,7449161,0,TYPES_TOKEN_MONSTER,1500,1500,1,RACE_INSECT,ATTRIBUTE_WATER) end
	if e:GetLabel()~=0 then
		e:SetLabel(0)
		local ft=Duel.GetMZoneCount(tp)
		if ft>1 and Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
		local g=Duel.GetMatchingGroup(c7449159.chkfilter,tp,LOCATION_HAND,0,nil,tp)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
		local cg=g:SelectSubGroup(tp,aux.TRUE,false,1,ft)
		Duel.ConfirmCards(1-tp,cg)
		Duel.ShuffleHand(tp)
		e:SetLabel(#cg)
		Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,#cg,0,0)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,#cg,0,0)
	end
end
function c7449159.tkop(e,tp,eg,ep,ev,re,r,rp)
	local ct=e:GetLabel()
	if Duel.GetMZoneCount(tp)<ct or ct>=2 and Duel.IsPlayerAffectedByEffect(tp,59822133) then return end
	for i=1,ct do
		local token=Duel.CreateToken(tp,7449161)
		Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_LEAVE_FIELD)
		e1:SetLabel(tp)
		e1:SetOperation(c7449159.spop)
		token:RegisterEffect(e1,true)
	end
	Duel.SpecialSummonComplete()
end
function c7449159.spfilter(c,e,tp)
	return c:IsRace(RACE_INSECT) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c7449159.spop(e,tp,eg,ep,ev,re,r,rp)
	local p=e:GetLabel()
	if Duel.IsExistingMatchingCard(c7449159.spfilter,p,LOCATION_HAND,0,1,nil,e,p) and Duel.GetMZoneCount(p)>0 and Duel.SelectYesNo(p,aux.Stringid(7449159,2)) then
		Duel.Hint(HINT_SELECTMSG,p,HINTMSG_SPSUMMON)
		local sc=Duel.SelectMatchingCard(p,c7449159.spfilter,p,LOCATION_HAND,0,1,1,nil,e,p):GetFirst()
		Duel.SpecialSummon(sc,0,p,p,false,false,POS_FACEUP)
	end
	e:Reset()
end
