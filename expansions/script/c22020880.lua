--人理之基 卡米拉
function c22020880.initial_effect(c)
	aux.AddCodeList(c,22020850)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0xff1),7,2)
	c:EnableReviveLimit()
	--negate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(22020880,0))
	e1:SetCategory(CATEGORY_DISABLE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,22020880)
	e1:SetCondition(c22020880.cona)
	e1:SetCost(c22020880.atkcost)
	e1:SetTarget(c22020880.target)
	e1:SetOperation(c22020880.operation)
	c:RegisterEffect(e1)
	--double battle damage
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_CHANGE_BATTLE_DAMAGE)
	e2:SetCondition(c22020880.damcon)
	e2:SetValue(aux.ChangeBattleDamage(1,DOUBLE_DAMAGE))
	c:RegisterEffect(e2)
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
function c22020880.damcon(e)
	return e:GetHandler():GetBattleTarget()~=nil and e:GetHandler():GetOverlayGroup():FilterCount(Card.IsCode,nil,22020850)~=0
end