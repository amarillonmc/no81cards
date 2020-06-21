--罗德岛·术士干员-格雷伊
function c79029143.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,3,2)
	c:EnableReviveLimit()
	--atk
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(c79029143.val)
	c:RegisterEffect(e1)
	--atk
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_ATKCHANGE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c79029143.atkcon2)
	e2:SetCost(c79029143.atkcost2)
	e2:SetOperation(c79029143.atkop2)
	c:RegisterEffect(e2)   
	--atk down
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_ATKCHANGE)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCost(c79029143.atkcost)
	e3:SetTarget(c79029143.atktg)
	e3:SetOperation(c79029143.atkop)
	c:RegisterEffect(e3)
end
function c79029143.cfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_LINK)
end
function c79029143.val(e,c)
	local g=Duel.GetMatchingGroup(c79029143.cfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	return g:GetSum(Card.GetLink)*200
end
function c79029143.val1(e,c)
	local g=Duel.GetMatchingGroup(c79029143.cfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	return g:GetSum(Card.GetLink)*-200
end
function c79029143.atkcon2(e,tp,eg,ep,ev,re,r,rp)
	local bc=e:GetHandler():GetBattleTarget()
	return bc~=nil and bc:GetAttack()~=bc:GetBaseAttack()
end
function c79029143.atkcost2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:GetFlagEffect(79029143)==0 end
	c:RegisterFlagEffect(79029143,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_DAMAGE_CAL,0,1)
end
function c79029143.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.TURE,tp,0,LOCATION_MZONE,1,nil) and Duel.IsExistingMatchingCard(c79029143.cfilter,tp,0,LOCATION_MZONE,1,nil) end
end
function c79029143.atkop2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFaceup() and c:IsRelateToEffect(e) then
		local atk=c:GetAttack()*2
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_ATTACK_FINAL)
		e1:SetValue(atk)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+RESET_DISABLE+PHASE_DAMAGE_CAL)
		c:RegisterEffect(e1)
	end
end
function c79029143.atkcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end

function c79029143.atkop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(tp,0,LOCATION_MZONE)
	local tc=g:GetFirst()
		while tc do
		local e4=Effect.CreateEffect(e:GetHandler())
		e4:SetType(EFFECT_TYPE_SINGLE)
		e4:SetCode(EFFECT_UPDATE_ATTACK)
		e4:SetValue(c79029143.val1)
		e4:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e4)
		tc=g:GetNext()
end
end






