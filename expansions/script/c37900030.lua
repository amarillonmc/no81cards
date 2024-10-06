--护界神·提露密努斯·艾斯特
function c37900030.initial_effect(c)
	aux.AddXyzProcedure(c,nil,8,3,c37900030.ovfilter,aux.Stringid(37900030,0))
	c:EnableReviveLimit()
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e3:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
	e3:SetValue(1)
	c:RegisterEffect(e3)
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e0:SetRange(LOCATION_MZONE)
	e0:SetCode(EFFECT_INDESTRUCTABLE_COUNT)
	e0:SetCountLimit(2)
	e0:SetValue(c37900030.valcon)
	c:RegisterEffect(e0)	
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
	e1:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c37900030.atkcon)
	e1:SetCost(c37900030.atkcost)
	e1:SetOperation(c37900030.atkop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_POSITION)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCountLimit(1)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCost(c37900030.cost)
	e2:SetTarget(c37900030.tg)
	e2:SetOperation(c37900030.op)
	c:RegisterEffect(e2)
end
function c37900030.ovfilter(c)
	return c:IsFaceup() and c:IsRank(7) and c:IsSetCard(0x389,0x381)
end
function c37900030.valcon(e,re,r,rp)
	return r & (REASON_BATTLE + REASON_EFFECT) ~=0
end
function c37900030.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ)
end
function c37900030.atkcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLP(tp)>1000 end
	local lp=Duel.GetLP(tp)
	e:SetLabel(lp-1000)
	Duel.PayLPCost(tp,lp-1000)
end
function c37900030.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFaceup() and c:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e1:SetRange(LOCATION_MZONE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(e:GetLabel())
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
		c:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_UPDATE_DEFENSE)
		c:RegisterEffect(e2)
	end
end
function c37900030.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c37900030.pfilter(c)
	return c:IsPosition(POS_FACEUP_ATTACK) and c:IsType(TYPE_EFFECT) and c:IsCanChangePosition()
end
function c37900030.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c37900030.pfilter,tp,LOCATION_MZONE,LOCATION_MZONE,c)
	if chk==0 then return g:GetCount()>0 end
end
function c37900030.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c37900030.pfilter,tp,LOCATION_MZONE,LOCATION_MZONE,c)
	if g:GetCount()>0 then
		if Duel.ChangePosition(g,POS_FACEUP_DEFENSE)>0 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_BATTLE_START)
		e1:SetRange(LOCATION_MZONE)
		e1:SetDescription(aux.Stringid(37900030,1))
		e1:SetCondition(c37900030.con22)
		e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
		e1:SetOperation(c37900030.op22)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e1)
		end
	end
end
function c37900030.con22(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	return c:GetAttack()>bc:GetAttack() or (not bc:IsType(TYPE_LINK) and c:GetAttack()>bc:GetDefense())
end
function c37900030.op22(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	if bc:IsRelateToBattle(e) and bc:IsAbleToGrave() then
	Duel.SendtoGrave(bc,REASON_RULE,1-tp)
	end
end