--人理之基 阿塔兰忒·异灵
function c22026350.initial_effect(c)
	aux.AddCodeList(c,22025820,22021020)
	--xyz summon
	aux.AddXyzProcedure(c,nil,6,3,c22026350.ovfilter,aux.Stringid(22026350,0),3,c22026350.xyzop)
	c:EnableReviveLimit()
	--Damage
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(22026350,1))
	e1:SetCategory(CATEGORY_DAMAGE)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_DESTROYED)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,22026350)
	e1:SetCondition(c22026350.damcon)
	e1:SetCost(c22026350.damcost)
	e1:SetTarget(c22026350.damtg)
	e1:SetOperation(c22026350.damop)
	c:RegisterEffect(e1)
	--Destroy
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_DESTROY+CATEGORY_ATKCHANGE)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_CHAIN_SOLVING)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(c22026350.discon)
	e3:SetOperation(c22026350.disop)
	c:RegisterEffect(e3)
end
function c22026350.cfilter0(c)
	return c:IsSetCard(0xff1) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsDiscardable()
end
function c22026350.ovfilter(c)
	return c:IsFaceup() and c:IsCode(22021020)
end
function c22026350.xyzop(e,tp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c22026350.cfilter0,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,c22026350.cfilter0,1,1,REASON_COST+REASON_DISCARD)
end
function c22026350.cfilter(c,tp)
	return c:IsReason(REASON_BATTLE+REASON_EFFECT) and c:IsPreviousLocation(LOCATION_MZONE) and c:IsPreviousControler(1-tp)
end
function c22026350.damcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c22026350.cfilter,1,nil,tp)
end
function c22026350.damcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c22026350.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local dam=e:GetHandler():GetAttack()
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(dam)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,dam)
end
function c22026350.damop(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	Duel.Damage(p,e:GetHandler():GetAttack(),REASON_EFFECT)
end
function c22026350.discon(e,tp,eg,ep,ev,re,r,rp)
	return rp==tp and re:GetHandler():IsCode(22025820) and Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_MZONE,1,nil)
end
function c22026350.disop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.SelectEffectYesNo(tp,e:GetHandler(),aux.Stringid(22026350,2)) then
		Duel.Hint(HINT_CARD,0,22026350)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local g=Duel.SelectMatchingCard(tp,aux.TRUE,tp,0,LOCATION_MZONE,1,1,nil)
		if g:GetCount()>0 then
			Duel.HintSelection(g)
				Duel.Destroy(g,REASON_EFFECT)
				local e1=Effect.CreateEffect(c)
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_UPDATE_ATTACK)
				e1:SetValue(700)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
				c:RegisterEffect(e1)
		end
	end
end
