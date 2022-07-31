--破碎世界的倒吊者
function c6160008.initial_effect(c)
	--atk down  
	 local e1=Effect.CreateEffect(c)  
	e1:SetDescription(aux.Stringid(6160008,0))  
	e1:SetCategory(CATEGORY_ATKCHANGE)  
	e1:SetType(EFFECT_TYPE_QUICK_O)  
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP)  
	e1:SetCode(EVENT_FREE_CHAIN)  
	e1:SetRange(LOCATION_HAND)  
	e1:SetCountLimit(1,6160008)  
	e1:SetHintTiming(TIMING_DAMAGE_STEP)  
	e1:SetCondition(aux.dscon)  
	e1:SetCost(c6160008.atkcost)  
	e1:SetTarget(c6160008.atktg)  
	e1:SetOperation(c6160008.atkop)  
	c:RegisterEffect(e1)  
	--negate  
	local e2=Effect.CreateEffect(c)  
	e2:SetDescription(aux.Stringid(6160008,0))  
	e2:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)  
	e2:SetType(EFFECT_TYPE_QUICK_O)  
	e2:SetCode(EVENT_CHAINING)  
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)  
	e2:SetRange(LOCATION_MZONE+LOCATION_GRAVE)  
	e2:SetCountLimit(1,6161008)
	e2:SetCost(aux.bfgcost) 
	e2:SetCondition(c6160008.condition)  
	e2:SetTarget(c6160008.distg) 
	e2:SetOperation(c6160008.disop)  
	c:RegisterEffect(e2) 
end 
function c6160008.atkcost(e,tp,eg,ep,ev,re,r,rp,chk)  
	local c=e:GetHandler()  
	if chk==0 then return c:IsDiscardable() end  
	Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)  
end   
function c6160008.atkfilter(c)  
	return c:IsFaceup()  
end  
function c6160008.atktg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)  
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and c6160008.atkfilter(chkc) end  
	if chk==0 then return Duel.IsExistingTarget(c6160008.atkfilter,tp,0,LOCATION_MZONE,1,nil) end  
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)  
	Duel.SelectTarget(tp,c6160008.atkfilter,tp,0,LOCATION_MZONE,1,1,nil)  
end  
function c6160008.atkop(e,tp,eg,ep,ev,re,r,rp)  
	local tc=Duel.GetFirstTarget()  
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then  
		local e1=Effect.CreateEffect(e:GetHandler())  
		e1:SetType(EFFECT_TYPE_SINGLE)  
		e1:SetCode(EFFECT_UPDATE_ATTACK)  
		e1:SetValue(-1000)  
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)  
		tc:RegisterEffect(e1)  
	end  
end
function c6160008.cfilter(c)  
	return c:IsFaceup() and c:IsRace(RACE_SPELLCASTER)  
end 
function c6160008.condition(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler()  
	local rc=re:GetHandler()  
	local loc=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION) 
	return Duel.IsExistingMatchingCard(c6160008.cfilter,tp,LOCATION_MZONE,0,1,nil) and rp==1-tp and re:IsActiveType(TYPE_MONSTER) and not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and Duel.IsChainNegatable(ev)  
end  
function c6160008.distg(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return not re:GetHandler():IsStatus(STATUS_DISABLED) end  
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,eg,1,0,0)  
end  
function c6160008.disop(e,tp,eg,ep,ev,re,r,rp)  
	Duel.NegateEffect(ev)  
end  