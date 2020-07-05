--端午节的觉醒虫师
function c8709011.initial_effect(c)
		  --xyz summon
	aux.AddXyzProcedure(c,nil,4,2,c8709011.ovfilter,aux.Stringid(8709011,0),2,c8709011.xyzop)
	c:EnableReviveLimit()
	--atk
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(c8709011.atkval)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_UPDATE_DEFENSE)
	e2:SetValue(c8709011.defval)
	c:RegisterEffect(e2) 
	--
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(8709011,1))
	e3:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e3:SetCode(EVENT_CHAINING)
	e3:SetCondition(c8709011.discon)
	e3:SetCost(c8709011.discost)
	e3:SetTarget(c8709011.distg)
	e3:SetOperation(c8709011.disop)
	c:RegisterEffect(e3)
   

end
function c8709011.ovfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xafa) and not c:IsCode(8709011)
end
function c8709011.xyzop(e,tp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,8709011)==0 end
	Duel.RegisterFlagEffect(tp,8709011,RESET_PHASE+PHASE_END,EFFECT_FLAG_OATH,1)
end
function c8709011.atkfilter(c)
	return c:IsSetCard(0xafa) and c:GetAttack()>=0
end
function c8709011.atkval(e,c)
	local g=e:GetHandler():GetOverlayGroup():Filter(c8709011.atkfilter,nil)
	return g:GetSum(Card.GetAttack)
end
function c8709011.deffilter(c)
	return c:IsSetCard(0xafa) and c:GetDefense()>=0
end
function c8709011.defval(e,c)
	local g=e:GetHandler():GetOverlayGroup():Filter(c8709011.deffilter,nil)
	return g:GetSum(Card.GetDefense)
end

function c8709011.discon(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) then return false end
	return rp==1-tp and re:IsHasType(EFFECT_TYPE_ACTIVATE) and Duel.IsChainNegatable(ev)
end
function c8709011.discost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c8709011.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c8709011.disop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end









