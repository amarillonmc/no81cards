--CiNo.106 熔燚掌 神之手
function c79029531.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,6,4)
	c:EnableReviveLimit()
	--Negate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(55888045,0))
	e1:SetCategory(CATEGORY_NEGATE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCost(c79029531.cost)
	e1:SetOperation(c79029531.negop)
	c:RegisterEffect(e1)
	--atk up
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_ATKCHANGE)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_CHANGE_POS)
	e2:SetRange(LOCATION_MZONE)
	e2:SetOperation(c79029531.atkop) 
	c:RegisterEffect(e2)
	--destroy replace
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EFFECT_DESTROY_REPLACE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTarget(c79029531.reptg)
	e3:SetOperation(c79029531.repop)
	c:RegisterEffect(e3)
	--cannot special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(c79029531.splimit)
	c:RegisterEffect(e1)
end
aux.xyz_number[79029531]=106
function c79029531.splimit(e,se,sp,st)
	return se:GetHandler():IsSetCard(0x95) and se:GetHandler():IsType(TYPE_SPELL)
end
function c79029531.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c79029531.negop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,c)
	local tc=g:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e2)
		tc=g:GetNext()
	end
end
function c79029531.atkop(e,tp,eg,ep,ev,re,r,rp)
	 Duel.Hint(HINT_CARD,0,79029531)
	 local c=e:GetHandler()
	 local e1=Effect.CreateEffect(c)
	 e1:SetType(EFFECT_TYPE_SINGLE)
	 e1:SetCode(EFFECT_UPDATE_ATTACK)
	 e1:SetRange(LOCATION_MZONE)
	 e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	 e1:SetValue(200)
	 c:RegisterEffect(e1)
	 local e2=e1:Clone()
	 e2:SetCode(EFFECT_UPDATE_DEFENSE)
	 c:RegisterEffect(e2)
end
function c79029531.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDisabled,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,c) end
	return Duel.SelectEffectYesNo(tp,e:GetHandler(),79029096)
end
function c79029531.repop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.GetMatchingGroup(Card.IsDisabled,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,c,e,tp)
	local tc=g:Select(tp,1,1,nil)
	Duel.SendtoGrave(tc,REASON_EFFECT+REASON_REPLACE)
end









