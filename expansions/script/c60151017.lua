--叛逆的物语 晓美焰
function c60151017.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsRace,RACE_SPELLCASTER),6,2)
	c:EnableReviveLimit()
	--atk & def
	local e11=Effect.CreateEffect(c)
	e11:SetType(EFFECT_TYPE_SINGLE)
	e11:SetCode(EFFECT_UPDATE_ATTACK)
	e11:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e11:SetRange(LOCATION_MZONE)
	e11:SetValue(c60151017.atkval2)
	c:RegisterEffect(e11)
	--destroy
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCategory(CATEGORY_CONTROL)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,60151017)
	e2:SetCost(c60151017.atkcost)
	e2:SetTarget(c60151017.destg)
	e2:SetOperation(c60151017.desop)
	c:RegisterEffect(e2)
	--search
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(60151017,1))
	e3:SetCategory(CATEGORY_POSITION)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e3:SetTarget(c60151017.destg2)
	e3:SetOperation(c60151017.desop2)
	c:RegisterEffect(e3)
end
function c60151017.atkval2(e,c)
	return c:GetOverlayCount()*1000
end
function c60151017.atkcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c60151017.dfilter(c,atk)
	return c:IsFaceup() and c:IsAttackAbove(atk) and c:IsAbleToChangeControler()
end
function c60151017.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(c60151017.dfilter,tp,0,LOCATION_MZONE,1,c,c:GetAttack()) end
	local sg=Duel.GetMatchingGroup(c60151017.dfilter,tp,0,LOCATION_MZONE,c,c:GetAttack())
	Duel.SetOperationInfo(0,CATEGORY_CONTROL,sg,sg:GetCount(),0,0)
end
function c60151017.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local sg=Duel.GetMatchingGroup(c60151017.dfilter,tp,0,LOCATION_MZONE,c,c:GetAttack())
	local tc=sg:GetFirst()
	while tc do
		if not tc:IsImmuneToEffect(e) and not tc:IsType(TYPE_TOKEN) then
		local og=tc:GetOverlayGroup()
		if og:GetCount()>0 then
			Duel.SendtoGrave(og,REASON_RULE)
		end
		Duel.Overlay(c,Group.FromCards(tc))
		end
		tc=sg:GetNext()
	end
end
function c60151017.dfilter2(c,atk)
	return c:IsFaceup() and c:IsAttackAbove(atk)
end
function c60151017.chlimit(e,ep,tp)
	return tp==ep
end
function c60151017.destg2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(c60151017.dfilter2,tp,0,LOCATION_MZONE,1,c,c:GetAttack()) end
	local sg=Duel.GetMatchingGroup(c60151017.dfilter2,tp,0,LOCATION_MZONE,c,c:GetAttack())
	Duel.SetOperationInfo(0,CATEGORY_ATKCHANGE,sg,sg:GetCount(),0,0)
	Duel.SetChainLimit(c60151017.chlimit)
end
function c60151017.desop2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local sg=Duel.GetMatchingGroup(c60151017.dfilter2,tp,0,LOCATION_MZONE,c,c:GetAttack())
	local tc=sg:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e2)
		tc=sg:GetNext()
	end
end