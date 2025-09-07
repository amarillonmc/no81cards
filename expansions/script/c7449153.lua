--烟雾熏蒸
function c7449153.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetHintTiming(TIMING_BATTLE_END+TIMING_END_PHASE,TIMINGS_CHECK_MONSTER+TIMING_BATTLE_END+TIMING_END_PHASE)
	e1:SetCategory(CATEGORY_DEFCHANGE+CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP)
	e1:SetTarget(c7449153.target)
	e1:SetOperation(c7449153.activate)
	c:RegisterEffect(e1)
	--set
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(7449153,1))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_BATTLE_DESTROYED)
	e2:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e2:SetCountLimit(1,7449153)
	e2:SetCondition(c7449153.setcon)
	e2:SetTarget(c7449153.settg)
	e2:SetOperation(c7449153.setop)
	c:RegisterEffect(e2)
end
function c7449153.gcheck(g)
	return g:GetClassCount(Card.GetRace)==1
end
function c7449153.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsFaceup() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,nil):Filter(Card.IsCanBeEffectTarget,nil,e)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local sg=g:SelectSubGroup(tp,c7449153.gcheck,false,1,#g)
	Duel.SetTargetCard(sg)
end
function c7449153.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetTargetsRelateToChain()
	if #g==0 then return end
	local val=0
	for tc in aux.Next(g) do
		local def=tc:GetDefense()
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_DEFENSE)
		e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetValue(-1500)
		e1:SetRange(LOCATION_MZONE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		if tc:GetDefense()<def then val=val+def-tc:GetDefense() end
		if not tc:IsDefenseAbove(1) then Duel.SendtoGrave(tc,REASON_EFFECT) end
	end
	if val<200 then return end
	local ct=math.floor(val/1000)
	for i=1,ct do
		Duel.BreakEffect()
		Duel.Damage(1-tp,200,REASON_EFFECT)
	end
end
function c7449153.cfilter(c)
	return bit.band(c:GetPreviousRaceOnField(),RACE_INSECT)~=0
end
function c7449153.setcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c7449153.cfilter,1,nil)
end
function c7449153.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsSSetable() end
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,e:GetHandler(),1,0,0)
end
function c7449153.setop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SSet(tp,c)
	end
end
