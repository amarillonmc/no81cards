--雪域生灵 豹崽
--Snowland Creature
local s,id,o=GetID()
function s.initial_effect(c)
	--Search
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetCountLimit(1,id)
	e1:SetCost(s.thcost)
	e1:SetTarget(s.thtg)
	e1:SetOperation(s.thop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	--Apply effect
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,1))
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_CHAINING)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(s.con3)
	e3:SetOperation(s.op3)
	c:RegisterEffect(e3)
end
function s.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end
function s.thfilter(c)
	return c:IsSetCard(0x5226) and c:IsAbleToHand()
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local g=Duel.GetMatchingGroup(s.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,nil)
		return g:GetCount()>=2
	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,2,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(s.thfilter,tp,LOCATION_DECK,0,nil)
	local g2=Duel.GetMatchingGroup(aux.NecroValleyFilter(s.thfilter),tp,LOCATION_GRAVE,0,nil)
	g:Merge(g2)
	if g:GetCount()>=2 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=g:Select(tp,2,2,nil)
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
	end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetTargetRange(1,0)
	e1:SetTarget(s.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function s.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return not c:IsRace(RACE_BEAST+RACE_WINDBEAST)
end
function s.cfilter(c)
	return c:GetFlagEffect(id)>0 and c:IsFaceup()
end
function s.con3(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsExistingMatchingCard(s.cfilter,tp,0,LOCATION_MZONE,1,nil) then return false end
	if not (re:GetHandler():IsSetCard(0x5226) and re:IsActiveType(TYPE_MONSTER) and rp==tp) then return false end
	if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return false end
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	return g and g:IsExists(Card.IsControler,1,nil,1-tp)
end
function s.op3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS):Filter(Card.IsControler,nil,1-tp)
	if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(id,2)) then 
		local tc=g:GetFirst()
		if g:GetCount()>1 then tc=g:Select(tp,1,1,nil):GetFirst() end
		local e1=Effect.CreateEffect(c)
		e1:SetDescription(aux.Stringid(id,3))
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
		e1:SetCode(EFFECT_UNRELEASABLE_SUM)
		e1:SetValue(1)
		e1:SetCondition(s.rcon)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_UNRELEASABLE_NONSUM)
		tc:RegisterEffect(e2)
		local e3=e1:Clone()
		e3:SetCode(EFFECT_CANNOT_BE_FUSION_MATERIAL)
		e3:SetValue(s.matval)
		tc:RegisterEffect(e3)
		local e4=e3:Clone()
		e4:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
		tc:RegisterEffect(e4)
		local e5=e3:Clone()
		e5:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
		tc:RegisterEffect(e5)
		local e6=e3:Clone()
		e6:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
		tc:RegisterEffect(e6)
		tc:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(id,3))
		tc:RegisterFlagEffect(11614056,RESET_EVENT+RESETS_STANDARD,0,1)
	end
end
function s.matval(e,c,sumtype)
	return true
end
function s.rcon(e)
	local c=e:GetOwner()
	return c:IsFaceup() and c:IsLocation(LOCATION_MZONE)
end
