--龟蟹流拳-幻象波动拳
function c49811435.initial_effect(c)
	--equip limit
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_EQUIP_LIMIT)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e0:SetValue(c49811435.eqlimit)
	c:RegisterEffect(e0)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_SEARCH+CATEGORY_TOHAND+CATEGORY_LEAVE_GRAVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,49811435)
	e1:SetTarget(c49811435.target)
	e1:SetOperation(c49811435.operation)
	c:RegisterEffect(e1)
	--change
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(49811435,3))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_DESTROYED)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,49811436)
	e2:SetCondition(c49811435.chcon)
	e2:SetTarget(c49811435.chtg)
	e2:SetOperation(c49811435.chop)
	c:RegisterEffect(e2)
end
function c49811435.eqlimit(e,c)
	return c:IsAttribute(ATTRIBUTE_WATER)
end
function c49811435.spfilter(c,e,tp)
	return c:IsAttribute(ATTRIBUTE_WATER) and c:IsRace(RACE_AQUA) and c:IsType(TYPE_NORMAL) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c49811435.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetMZoneCount(tp)>0
		and Duel.IsExistingMatchingCard(c49811435.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)
end
function c49811435.thfilter(c)
	return c:IsCode(76806714) and c:IsAbleToHand()
end
function c49811435.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetMZoneCount(tp)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tc=Duel.SelectMatchingCard(tp,c49811435.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp):GetFirst()
	if tc==nil or Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)==0 then return end
	local c=e:GetHandler()
	if not Duel.Equip(tp,c,tc) then return end
	--Add Equip limit
	local e1=Effect.CreateEffect(tc)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_EQUIP_LIMIT)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetValue(c49811435.eqlimit2)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	c:RegisterEffect(e1)
	local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(c49811435.thfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,nil)
	if #g>0 and Duel.SelectYesNo(tp,aux.Stringid(49811435,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local tg=g:Select(tp,1,1,nil)
		Duel.BreakEffect()
		Duel.SendtoHand(tg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tg)
	end
end
function c49811435.eqlimit2(e,c)
	return e:GetOwner()==c
end
function c49811435.chcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(Card.IsPreviousLocation,1,nil,LOCATION_ONFIELD) and not eg:IsContains(e:GetHandler())
end
function c49811435.cfilter1(c)
	return c:IsAttribute(ATTRIBUTE_WATER) and c:IsRace(RACE_AQUA) and c:IsLevelAbove(1) and c:IsFaceup()
end
function c49811435.cfilter2(c)
	return c:IsType(TYPE_RITUAL) and c:IsFaceup()
end
function c49811435.chtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c49811435.cfilter1,tp,LOCATION_MZONE,0,1,nil)
		or Duel.IsExistingMatchingCard(c49811435.cfilter2,tp,LOCATION_MZONE,0,1,nil) end
end
function c49811435.chop(e,tp,eg,ep,ev,re,r,rp)
	local b1=Duel.IsExistingMatchingCard(c49811435.cfilter1,tp,LOCATION_MZONE,0,1,nil)
	local b2=Duel.IsExistingMatchingCard(c49811435.cfilter2,tp,LOCATION_MZONE,0,1,nil)
	if not (b1 or b2) then return end
	local op=aux.SelectFromOptions(tp,
		{b1,aux.Stringid(49811435,1)},
		{b2,aux.Stringid(49811435,2)})
	if op==1 then
		local g=Duel.GetMatchingGroup(c49811435.cfilter1,tp,LOCATION_MZONE,0,nil)
		local ct=0
		if g:GetClassCount(Card.GetLevel)==1 then
			ct=g:GetFirst():GetLevel()
		end
		local lv=Duel.AnnounceLevel(tp,1,8,ct)
		local lg=g:Filter(Card.IsLevel,nil,lv)
		local tc=g:Select(tp,1,1,lg):GetFirst()
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_LEVEL)
		e1:SetValue(lv)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
	else
		local g=Duel.GetMatchingGroup(c49811435.cfilter2,tp,LOCATION_MZONE,0,nil)
		local ct=0
		if g:GetClassCount(Card.GetCode)==1 then
			ct=g:GetFirst():GetCode()
		end
		getmetatable(e:GetHandler()).announce_filter={ATTRIBUTE_WATER,OPCODE_ISATTRIBUTE,ct,OPCODE_ISCODE,OPCODE_NOT,OPCODE_AND,RACE_AQUA,OPCODE_ISRACE,OPCODE_AND}
		local code=Duel.AnnounceCard(tp,table.unpack(getmetatable(e:GetHandler()).announce_filter))
		local cg=g:Filter(Card.IsCode,nil,code)
		local tc=g:Select(tp,1,1,cg):GetFirst()
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_CODE)
		e1:SetValue(code)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
	end
end
