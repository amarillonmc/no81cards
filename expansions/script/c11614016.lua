--雪域生灵 虎崽
--Snowland Creature
local s,id,o=GetID()
function s.initial_effect(c)
	--Special Summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetCountLimit(1,id)
	e1:SetTarget(s.sptg)
	e1:SetOperation(s.spop)
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
function s.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x5226)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false)
		and Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToChain() then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
	local e1=Effect.CreateEffect(c)
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
		e1:SetDescription(aux.Stringid(id,3))
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
		e1:SetCode(EFFECT_CANNOT_ATTACK)
		e1:SetCondition(s.rcon)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		tc:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD,0,1)
		tc:RegisterFlagEffect(11614056,RESET_EVENT+RESETS_STANDARD,0,1)
	end
end
function s.rcon(e)
	local c=e:GetOwner()
	return c:IsFaceup() and c:IsLocation(LOCATION_MZONE)
end
