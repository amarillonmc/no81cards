--水桶腰
function c11561018.initial_effect(c)
	--control
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_CANNOT_CHANGE_CONTROL)
	c:RegisterEffect(e1)
	--limit 
	local e2=Effect.CreateEffect(c) 
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_CHANGE_POSITION) 
	e2:SetRange(LOCATION_MZONE) 
	e2:SetTargetRange(0,LOCATION_MZONE)  
	e2:SetTarget(function(e,c)
	return c:IsDefensePos() end)  
	c:RegisterEffect(e2) 
	--remove 
	local e3=Effect.CreateEffect(c) 
	e3:SetCategory(CATEGORY_REMOVE) 
	e3:SetType(EFFECT_TYPE_QUICK_O) 
	e3:SetCode(EVENT_CHAINING) 
	e3:SetRange(LOCATION_MZONE) 
	e3:SetCountLimit(1,11561018)   
	e3:SetCondition(c11561018.rmcon) 
	e3:SetTarget(c11561018.rmtg) 
	e3:SetOperation(c11561018.rmop) 
	c:RegisterEffect(e3)  
	--atk 
	local e4=Effect.CreateEffect(c) 
	e4:SetCategory(CATEGORY_TOGRAVE)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e4:SetCode(EVENT_ATTACK_ANNOUNCE)
	e4:SetCountLimit(1,21561018) 
	e4:SetTarget(c11561018.atktg)
	e4:SetOperation(c11561018.atkop)
	c:RegisterEffect(e4) 
	--rec 
	local e5=Effect.CreateEffect(c) 
	e5:SetCategory(CATEGORY_RECOVER) 
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e5:SetCode(EVENT_LEAVE_FIELD) 
	e5:SetProperty(EFFECT_FLAG_PLAYER_TARGET) 
	e5:SetCountLimit(1,31561018) 
	e5:SetTarget(c11561018.rectg) 
	e5:SetOperation(c11561018.recop) 
	c:RegisterEffect(e5) 
end
function c11561018.rmcon(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp and re and re:IsActiveType(TYPE_MONSTER) and re:GetHandler():IsLocation(LOCATION_GRAVE)   
end 
function c11561018.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return re and re:GetHandler():IsAbleToRemove() end 
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,eg,eg:GetCount(),0,0)
end 
function c11561018.rmop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	if re:GetHandler():IsRelateToEffect(re) then
		Duel.Remove(eg,POS_FACEUP,REASON_EFFECT)
	end 
end 
function c11561018.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end 
end 
function c11561018.atkop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	if c:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c) 
		e1:SetType(EFFECT_TYPE_SINGLE) 
		e1:SetCode(EFFECT_UPDATE_ATTACK) 
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE) 
		e1:SetRange(LOCATION_MZONE) 
		e1:SetValue(600) 
		e1:SetReset(RESET_EVENT+RESETS_STANDARD) 
		c:RegisterEffect(e1)	   
	end 
end 
function c11561018.rectg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end 
	Duel.SetTargetPlayer(tp) 
	Duel.SetTargetParam(600) 
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,600)
end 
function c11561018.recop(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler() 
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Recover(p,d,REASON_EFFECT) 
end 





