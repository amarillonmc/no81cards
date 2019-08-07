--真光子幻爆
function c10150055.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c41097056.target)
	e1:SetOperation(c41097056.activate)
	c:RegisterEffect(e1) 
end
function c10150055.filter(c,e,tp)
	return c:IsFaceup() and c:IsType(TYPE_XYZ) and (c:IsSetCard(0x55) or c:IsSetCard(0x107b)) and Duel.IsExistingMatchingCard(c10150055.mfilter,tp,0,LOCATION_MZONE,1,nil,c:GetAttack())
end
function c10150055.mfilter(c,atk)
	return c:IsFaceup() and c:IsAttackBelow(atk) and not c:IsType(TYPE_TOKEN) and c:IsAbleToChangeControler()
end
function c10150055.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c10150055.filter(chkc,e,tp) end
	if chk==0 then return Duel.IsExistingTarget(c10150055.filter,tp,LOCATION_MZONE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c10150055.filter,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
end
function c10150055.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsFacedown() or not tc:IsRelateToEffect(e) or tc:IsControler(1-tp) or tc:IsImmuneToEffect(e) or not tc:IsType(TYPE_XYZ) then return end
	local g=Duel.GetMatchingGroup(c10150055.mfilter,tp,0,LOCATION_MZONE,nil,tc:GetAttack())
	if g:GetCount()>0 then
	   Duel.Overlay(tc,g)
	end
end