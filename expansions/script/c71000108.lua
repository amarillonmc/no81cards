--一曲镇魂
function c71000108.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCategory(CATEGORY_NEGATE)
	e1:SetCountLimit(1,71000108)
	e1:SetCondition(c71000108.con)
	e1:SetTarget(c71000108.tg)
	e1:SetOperation(c71000108.op)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	c:RegisterEffect(e2)
end
function c71000108.f(c)
	return c:IsFaceup() and c:IsCode(71000100) and c:IsType(TYPE_XYZ)
end
function c71000108.f2(c)
	return c:IsFaceup() and c:IsCode(71000100) and c:IsType(TYPE_XYZ) and not c:IsStatus(STATUS_BATTLE_DESTROYED)
end
function c71000108.con(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c71000108.f,tp,LOCATION_MZONE,0,1,nil)
		and re:IsActiveType(TYPE_MONSTER+TYPE_TRAP)
		and Duel.IsChainNegatable(ev)
end
function c71000108.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
end
function c71000108.op(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	if Duel.NegateActivation(ev) and rc:IsRelateToEffect(re) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
		local g=Duel.SelectMatchingCard(tp,c71000108.f2,tp,LOCATION_MZONE,0,1,1,nil)
		if g:GetCount()>0 and not g:GetFirst():IsImmuneToEffect(e) and rc:IsCanOverlay() then
			rc:CancelToGrave()
			Duel.Overlay(g:GetFirst(),Group.FromCards(rc))
		end
	end
end