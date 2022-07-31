--轮回世界的战车
function c6162301.initial_effect(c)
	 --xyz summon  
	aux.AddXyzProcedure(c,c6162301.mfilter,6,3,c6162301.ovfilter,aux.Stringid(6162301,0),99,c6162301.xyzop)  
	c:EnableReviveLimit()
	--indes 
	local e1=Effect.CreateEffect(c)  
	e1:SetDescription(aux.Stringid(6162301,1))  
	e1:SetType(EFFECT_TYPE_QUICK_O)  
	e1:SetCode(EVENT_FREE_CHAIN) 
	e1:SetRange(LOCATION_MZONE) 
	e1:SetHintTiming(0,TIMING_END_PHASE)  
	e1:SetCost(c6162301.incost)
	e1:SetTarget(c6162301.intg)   
	e1:SetOperation(c6162301.inop)  
	c:RegisterEffect(e1)  
	--atkup  
	local e2=Effect.CreateEffect(c)  
	e2:SetDescription(aux.Stringid(6162301,2))  
	e2:SetType(EFFECT_TYPE_QUICK_O)  
	e2:SetCode(EVENT_FREE_CHAIN)  
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP)  
	e2:SetRange(LOCATION_MZONE)  
	e2:SetHintTiming(TIMING_DAMAGE_STEP)  
	e2:SetCountLimit(1)  
	e2:SetCondition(aux.dscon)  
	e2:SetCost(c6162301.cost)  
	e2:SetTarget(c6162301.target)  
	e2:SetOperation(c6162301.operation)  
	c:RegisterEffect(e2)  
end
function c6162301.mfilter(c)  
	return c:IsRace(RACE_SPELLCASTER) 
end  
function c6162301.ovfilter(c)  
	return c:IsFaceup() and c:IsType(TYPE_XYZ) and c:IsRace(RACE_SPELLCASTER)  
end  
function c6162301.incost(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end  
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)  
end  
function c6162301.infilter(c)
	return c:IsFaceup() and c:IsRace(RACE_SPELLCASTER)
end
function c6162301.intg(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return Duel.IsExistingMatchingCard(c6162301.infilter,tp,LOCATION_MZONE,0,1,nil) end  
end  
function c6162301.inop(e,tp,eg,ep,ev,re,r,rp)  
	local g=Duel.GetMatchingGroup(c6162301.infilter,tp,LOCATION_MZONE,0,nil)  
	local tc=g:GetFirst()  
	while tc do  
		local e1=Effect.CreateEffect(e:GetHandler())  
		e1:SetType(EFFECT_TYPE_SINGLE)  
		e1:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)  
		e1:SetValue(1)  
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)  
		tc:RegisterEffect(e1)  
		local e2=e1:Clone()  
		e2:SetDescription(aux.Stringid(6162301,3))   
		e2:SetProperty(EFFECT_FLAG_CLIENT_HINT)  
		tc:RegisterEffect(e2)  
		tc=g:GetNext()  
	end  
end  
function c6162301.cfilter(c)  
	return c:IsSetCard(0x616) and c:IsType(TYPE_MONSTER) and c:IsAbleToRemoveAsCost()  
end  
function c6162301.cost(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return Duel.IsExistingMatchingCard(c6162301.cfilter,tp,LOCATION_GRAVE,0,1,nil) end  
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)  
	local g=Duel.SelectMatchingCard(tp,c6162301.cfilter,tp,LOCATION_GRAVE,0,1,1,nil)  
	e:SetLabel(g:GetFirst():GetAttack())  
	Duel.Remove(g,POS_FACEUP,REASON_COST)  
end  
function c6162301.atkfilter(c)
	return c:IsFaceup() and c:IsRace(RACE_SPELLCASTER)
end
function c6162301.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)  
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsFaceup() and c:IsRace(RACE_SPELLCASTER) end  
	if chk==0 then return Duel.IsExistingTarget(c6162301.atkfilter,tp,LOCATION_MZONE,0,1,nil) end  
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)  
	Duel.SelectTarget(tp,c6162301.atkfilter,tp,LOCATION_MZONE,0,1,1,nil)  
end  
function c6162301.operation(e,tp,eg,ep,ev,re,r,rp)  
	local tc=Duel.GetFirstTarget()  
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then  
		local e1=Effect.CreateEffect(e:GetHandler())  
		e1:SetType(EFFECT_TYPE_SINGLE)  
		e1:SetCode(EFFECT_UPDATE_ATTACK)  
		e1:SetValue(e:GetLabel())  
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)  
		tc:RegisterEffect(e1)  
	end  
end