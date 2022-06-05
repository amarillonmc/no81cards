--虚妄之心罪·纯神之奏者
function c29010405.initial_effect(c)
	c:EnableReviveLimit() 
	--atk
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(29010405,0))
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e1:SetRange(LOCATION_HAND)
	e1:SetHintTiming(TIMING_DAMAGE_STEP)
	e1:SetCountLimit(1,29010405)
	e1:SetCondition(c29010405.atkcon)
	e1:SetCost(c29010405.atkcost)
	e1:SetTarget(c29010405.atktg)
	e1:SetOperation(c29010405.atkop)
	c:RegisterEffect(e1)	
	--negate
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(29010405,1))
	e2:SetCategory(CATEGORY_NEGATE+CATEGORY_TODECK)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,19010405)
	e2:SetCondition(c29010405.discon)
	e2:SetTarget(c29010405.distg)
	e2:SetOperation(c29010405.disop)
	c:RegisterEffect(e2)
end 
function c29010405.atkcon(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return ph>=PHASE_BATTLE_START and ph<=PHASE_BATTLE and aux.dscon(e,tp,eg,ep,ev,re,r,rp)
end 
function c29010405.atkcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsDiscardable() end
	Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)
end
function c29010405.atkfil(c) 
	return c:IsSetCard(0x7a1) and c:IsFaceup() 
end 
function c29010405.atktg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(c29010405.atkfil,tp,LOCATION_MZONE,0,1,nil) end
end
function c29010405.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	local g=Duel.GetMatchingGroup(c29010405.atkfil,tp,LOCATION_MZONE,0,nil) 
	if g:GetCount()<=0 then return end 
	local tc=g:Select(tp,1,1,nil):GetFirst() 
	local e1=Effect.CreateEffect(c) 
	e1:SetType(EFFECT_TYPE_SINGLE) 
	e1:SetCode(EFFECT_UPDATE_ATTACK) 
	e1:SetRange(LOCATION_MZONE) 
	e1:SetValue(1000) 
	e1:SetReset(RESET_EVENT+RESETS_STANDARD) 
	tc:RegisterEffect(e1) 
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_BATTLED)
	e1:SetCondition(c29010405.catkcon)
	e1:SetOperation(c29010405.catkop)
	e1:SetCountLimit(1)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	tc:RegisterEffect(e1)
end 
function c29010405.catkcon(e,tp,eg,ep,ev,re,r,rp) 
	return aux.bdocon(e,tp,eg,ep,ev,re,r,rp) and e:GetHandler():IsChainAttackable()
end
function c29010405.catkop(e,tp,eg,ep,ev,re,r,rp) 
	Duel.Hint(HINT_CARD,0,29010405)
	Duel.ChainAttack()
end
function c29010405.discon(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp and Duel.IsChainNegatable(ev)
end
function c29010405.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return aux.ndcon(tp,re) end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_TODECK,eg,1,0,0)
	end
end
function c29010405.disop(e,tp,eg,ep,ev,re,r,rp)
	local ec=re:GetHandler()
	if Duel.NegateActivation(ev) and ec:IsRelateToEffect(re) then
		ec:CancelToGrave()
		Duel.SendtoDeck(ec,nil,SEQ_DECKSHUFFLE,REASON_EFFECT) 
	end
end










