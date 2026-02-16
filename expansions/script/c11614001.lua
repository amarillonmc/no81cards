--雪域生灵 狼崽
local s,id,o=GetID()
function s.initial_effect(c)
	--Special Summon self
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,id)
	e1:SetCost(s.cost1)
	e1:SetTarget(s.target1)
	e1:SetOperation(s.op1)
	c:RegisterEffect(e1)
	--Apply effect
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(s.con2)
	e2:SetOperation(s.op2)
	c:RegisterEffect(e2)
end
function s.tgfilter(c)
	return c:IsSetCard(0x5226) and c:IsType(TYPE_MONSTER) and c:IsAbleToGraveAsCost()
end
function s.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetCustomActivityCount(id,ACTIVITY_SPSUMMON,tp)==0
		and Duel.IsExistingMatchingCard(s.tgfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,s.tgfilter,tp,LOCATION_DECK,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
end
function s.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return not (c:IsRace(RACE_BEAST) or c:IsRace(RACE_WINDBEAST))
end
function s.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function s.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToChain() then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	e1:SetTarget(s.splimit)
	Duel.RegisterEffect(e1,tp)
end
function s.cfilter(c)
	return c:GetFlagEffect(id)>0 and c:IsFaceup()
end
function s.con2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsExistingMatchingCard(s.cfilter,tp,0,LOCATION_MZONE,1,nil) then return false end
	if not (re:GetHandler():IsSetCard(0x5226) and re:IsActiveType(TYPE_MONSTER) and rp==tp) then return false end
	if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return false end
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	return g and g:IsExists(Card.IsControler,1,nil,1-tp)
end
function s.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS):Filter(Card.IsControler,nil,1-tp)
	if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(id,2)) then 
		local tc=g:GetFirst()
		if g:GetCount()>1 then tc=g:Select(tp,1,1,nil):GetFirst() end
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CANNOT_ACTIVATE)
		e1:SetValue(s.aclimit)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		tc:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(id,3))
		tc:RegisterFlagEffect(11614056,RESET_EVENT+RESETS_STANDARD,0,1)
	end
end
function s.aclimit(e,re,tp)
	return Duel.GetCurrentChain()>0
end