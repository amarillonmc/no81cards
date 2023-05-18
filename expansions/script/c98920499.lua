--魔女术组合·召唤小组
function c98920499.initial_effect(c)
	c:SetSPSummonOnce(98920499)
	--link summon
	aux.AddLinkProcedure(c,c98920499.mfilter,2,2,c98920499.lcheck)
	c:EnableReviveLimit()
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(98920499,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,98930499)
	e1:SetCost(c98920499.cost)
	e1:SetTarget(c98920499.target)
	e1:SetOperation(c98920499.operation)
	c:RegisterEffect(e1)
	--tograve replace
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EFFECT_SEND_REPLACE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,98920499)
	e3:SetTarget(c98920499.reptg2)
	e3:SetValue(c98920499.repval2)
	c:RegisterEffect(e3) 
end
function c98920499.mfilter(c) 
	return c:IsLinkRace(RACE_SPELLCASTER)   
end 
function c98920499.lcheck(g,lc)
	return g:GetClassCount(Card.GetLinkAttribute)==g:GetCount()
end
function c98920499.tgfilter(c)
	return c:IsSetCard(0x128) and c:IsType(TYPE_SPELL) and c:IsAbleToGrave()
end
function c98920499.repfilter2(c,tp)
	return c:IsLocation(LOCATION_HAND) and c:IsType(TYPE_SPELL)
		and c:GetDestination()==LOCATION_GRAVE 
end
function c98920499.reptg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return  bit.band(r,REASON_COST)~=0 and re and re:IsActiveType(TYPE_MONSTER)
		and re:GetHandler():IsSetCard(0x128) and not re:GetHandler():IsCode(98920499) and Duel.IsExistingMatchingCard(c98920499.tgfilter,tp,LOCATION_DECK,0,1,nil) and eg:IsExists(c98920499.repfilter2,1,nil,tp) end
	if Duel.SelectYesNo(tp,aux.Stringid(98920499,1)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local g=Duel.SelectMatchingCard(tp,c98920499.tgfilter,tp,LOCATION_DECK,0,1,1,nil)
		Duel.SendtoGrave(g,REASON_COST)
		return true
	else return false end
end
function c98920499.repval2(e,c)
	return c:IsLocation(LOCATION_HAND) and c:IsType(TYPE_SPELL)
end
function c98920499.costfilter(c,tp)
	if c:IsLocation(LOCATION_HAND) then return c:IsType(TYPE_SPELL) and c:IsDiscardable() end
	return c:IsFaceup() and c:IsAbleToGraveAsCost() and c:IsHasEffect(83289866,tp)
end
function c98920499.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c98920499.costfilter,tp,LOCATION_HAND+LOCATION_SZONE,0,1,nil,tp) end
	local g=Duel.GetMatchingGroup(c98920499.costfilter,tp,LOCATION_HAND+LOCATION_SZONE,0,nil,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
	local tc=g:Select(tp,1,1,nil):GetFirst()
	local te=tc:IsHasEffect(83289866,tp)
	if te then
		te:UseCountLimit(tp)
		Duel.SendtoGrave(tc,REASON_COST)
	else
		Duel.SendtoGrave(tc,REASON_COST+REASON_DISCARD)
	end
end
function c98920499.filter(c,e,tp)
	return c:IsSetCard(0x128) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c98920499.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c98920499.filter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c98920499.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c98920499.filter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
		e1:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetValue(1)
		g:GetFirst():RegisterEffect(e1)
	end
end