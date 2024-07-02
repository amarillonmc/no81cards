--蒸汽淑女守护
function c40011467.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN) 
	e1:SetCountLimit(1,40011467) 
	e1:SetTarget(c40011467.xxtg)
	e1:SetOperation(c40011467.xxop)
	c:RegisterEffect(e1)
	--Remove 
	local e2=Effect.CreateEffect(c) 
	e2:SetCategory(CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET) 
	e2:SetRange(LOCATION_REMOVED)
	e2:SetCountLimit(1,40011467+1) 
	e2:SetCondition(c40011467.rmcon)
	e2:SetTarget(c40011467.rmtg)
	e2:SetOperation(c40011467.rmop)
	c:RegisterEffect(e2) 
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_REMOVE)   
	e2:SetCondition(c40011467.xrmcon)
	e2:SetOperation(c40011467.xrmop)
	c:RegisterEffect(e2)
end
function c40011467.xxtg(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return true end 
end
function c40011467.xxop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_CHAINING)
	e1:SetOperation(c40011467.actop)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)  
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT) 
	e2:SetTargetRange(LOCATION_ONFIELD,0)
	e2:SetTarget(function(e,c) 
	return c:IsSetCard(0xaf1a) end)
	e2:SetValue(aux.indoval)
	e2:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e2,tp)
end
function c40011467.actop(e,tp,eg,ep,ev,re,r,rp)
	if ep==tp and re:GetHandler():IsSetCard(0xaf1a) then
		Duel.SetChainLimit(c40011467.chainlm)
	end
end
function c40011467.chainlm(e,rp,tp)
	return tp==rp
end
function c40011467.xrmcon(e,tp,eg,ep,ev,re,r,rp)
	if re==nil then return false end  
	local rc=re:GetHandler()
	return e:GetHandler():IsReason(REASON_COST) and re:IsActivated() and rc and rc:IsSetCard(0xaf1a) 
end 
function c40011467.xrmop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler()
	c:RegisterFlagEffect(40011467,RESET_EVENT+RESETS_STANDARD+RESET_CHAIN,0,1) 
end 
function c40011467.rmcon(e,tp,eg,ep,ev,re,r,rp) 
	return e:GetHandler():GetFlagEffect(40011467)~=0  
end 
function c40011467.rmtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and Card.IsAbleToRemove(chkc) end
	if chk==0 then return Duel.IsExistingTarget(Card.IsAbleToRemove,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,Card.IsAbleToRemove,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
end
function c40011467.rmop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE) 
		e1:SetRange(LOCATION_REMOVED)
		e1:SetCountLimit(1)
		e1:SetOperation(function(e) 
		Duel.SendtoHand(e:GetHandler(),nil,REASON_EFFECT) end) 
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
	end
end



