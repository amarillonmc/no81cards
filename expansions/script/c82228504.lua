function c82228504.initial_effect(c)  
	--xyz summon  
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x291),8,2)  
	c:EnableReviveLimit()
	--pierce  
	local e1=Effect.CreateEffect(c)  
	e1:SetType(EFFECT_TYPE_SINGLE)  
	e1:SetCode(EFFECT_PIERCE)  
	c:RegisterEffect(e1)  
	local e2=Effect.CreateEffect(c)  
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)  
	e2:SetCode(EVENT_PRE_BATTLE_DAMAGE)  
	e2:SetCondition(c82228504.damcon)  
	e2:SetOperation(c82228504.damop)  
	c:RegisterEffect(e2)  
	--atk  
	local e3=Effect.CreateEffect(c)  
	e3:SetDescription(aux.Stringid(82228504,0))  
	e3:SetCategory(CATEGORY_ATKCHANGE)  
	e3:SetType(EFFECT_TYPE_IGNITION)  
	e3:SetRange(LOCATION_MZONE)  
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)  
	e3:SetCountLimit(1)  
	e3:SetCost(c82228504.cost)  
	e3:SetTarget(c82228504.atktg)  
	e3:SetOperation(c82228504.atkop)  
	c:RegisterEffect(e3) 
end  
function c82228504.damcon(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler()  
	return ep~=tp and c==Duel.GetAttacker() and Duel.GetAttackTarget() and Duel.GetAttackTarget():IsDefensePos()  
end  
function c82228504.damop(e,tp,eg,ep,ev,re,r,rp)  
	Duel.ChangeBattleDamage(ep,ev*2)  
end  
function c82228504.cost(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end  
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)  
end  
function c82228504.atktg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)  
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and aux.nzatk(chkc) end  
	if chk==0 then return Duel.IsExistingTarget(aux.nzatk,tp,0,LOCATION_MZONE,1,nil) end  
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)  
	Duel.SelectTarget(tp,aux.nzatk,tp,0,LOCATION_MZONE,1,1,nil)  
end  
function c82228504.atkop(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler()  
	local tc=Duel.GetFirstTarget()  
	if tc:IsFaceup() and tc:IsRelateToEffect(e) and not tc:IsImmuneToEffect(e) and c:IsRelateToEffect(e) and c:IsFaceup() then  
		local atk=tc:GetAttack()	
		local e2=Effect.CreateEffect(c)  
		e2:SetType(EFFECT_TYPE_SINGLE)  
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)  
		e2:SetCode(EFFECT_UPDATE_ATTACK)  
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)  
		e2:SetValue(atk)  
		c:RegisterEffect(e2)   
	end  
end  