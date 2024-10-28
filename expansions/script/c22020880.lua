--人理之基 卡米拉
function c22020880.initial_effect(c)
	aux.AddCodeList(c,22020850)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0xff1),7,2)
	c:EnableReviveLimit()
	--negate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(22020880,0))
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,22020880)
	e1:SetCondition(c22020880.cona)
	e1:SetCost(c22020880.atkcost)
	e1:SetTarget(c22020880.target)
	e1:SetOperation(c22020880.operation)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP)
	e2:SetHintTiming(TIMING_DAMAGE_STEP,0x21e0)
	e2:SetCondition(c22020880.condition2)
	c:RegisterEffect(e2)
	--pierce
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_PIERCE)
	c:RegisterEffect(e3)
end
function c22020880.atkcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c22020880.cona(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsAttackPos()
end
function c22020880.filter(c)
	return c:IsPosition(POS_FACEUP_ATTACK)
end
function c22020880.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(1-tp) and chkc:IsLocation(LOCATION_MZONE) and c22020880.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c22020880.filter,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,c22020880.filter,tp,0,LOCATION_MZONE,1,1,nil)
end
function c22020880.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsPosition(POS_FACEUP_ATTACK) and tc:IsRelateToEffect(e) and c:IsPosition(POS_FACEUP_ATTACK) then
		Duel.CalculateDamage(c,tc,true)
	end
end
function c22020880.condition2(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return e:GetHandler():GetOverlayGroup():IsExists(Card.IsCode,1,nil,22020850)
		and e:GetHandler():IsAttackPos() and Duel.GetTurnPlayer()==tp and ph>=PHASE_BATTLE_START and ph<=PHASE_BATTLE 
end