--奇幻之梦 爱丽丝
function c11561007.initial_effect(c)
	--draw 
	local e1=Effect.CreateEffect(c) 
	e1:SetCategory(CATEGORY_DRAW) 
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O) 
	e1:SetCode(EVENT_SUMMON_SUCCESS) 
	e1:SetProperty(EFFECT_FLAG_DELAY) 
	e1:SetCountLimit(1,11561007)
	e1:SetCondition(function(e) 
	local tp=e:GetHandlerPlayer() 
	return Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)>=3 end)  
	e1:SetTarget(c11561007.drtg) 
	e1:SetOperation(c11561007.drop) 
	c:RegisterEffect(e1)  
	local e2=e1:Clone() 
	e2:SetCode(EVENT_SPSUMMON_SUCCESS) 
	c:RegisterEffect(e2) 
	--direct attack
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_DIRECT_ATTACK)
	c:RegisterEffect(e3) 
	--atk 
	local e4=Effect.CreateEffect(c)  
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_ATTACK_ANNOUNCE) 
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)  
	e4:SetCondition(c11561007.atkcon1) 
	e4:SetCost(c11561007.cost) 
	e4:SetTarget(c11561007.atktg)
	e4:SetOperation(c11561007.atkop)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c) 
	e5:SetType(EFFECT_TYPE_QUICK_O) 
	e5:SetCode(EVENT_CHAINING) 
	e5:SetProperty(EFFECT_FLAG_CARD_TARGET)  
	e5:SetRange(LOCATION_MZONE) 
	e5:SetCondition(c11561007.atkcon2) 
	e5:SetCost(c11561007.cost) 
	e5:SetTarget(c11561007.atktg) 
	e5:SetOperation(c11561007.atkop) 
	c:RegisterEffect(e5) 
	Duel.AddCustomActivityCounter(11561007,ACTIVITY_CHAIN,c11561007.chainfilter)
end
function c11561007.chainfilter(re,tp,cid)
	local rc=re:GetHandler()
	return not re:IsHasType(EFFECT_TYPE_ACTIVATE)  
end
function c11561007.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetCustomActivityCount(11561007,tp,ACTIVITY_CHAIN)==0 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetTargetRange(1,0)
	e1:SetValue(function(e,re,tp) 
	return re:IsHasType(EFFECT_TYPE_ACTIVATE) end)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c11561007.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,2) end 
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2) 
end 
function c11561007.drop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	if Duel.Draw(tp,2,REASON_EFFECT)~=0 and c:IsRelateToEffect(e) then 
		Duel.BreakEffect()  
		local e1=Effect.CreateEffect(c) 
		e1:SetType(EFFECT_TYPE_SINGLE) 
		e1:SetCode(EFFECT_UPDATE_ATTACK)   
		e1:SetRange(LOCATION_MZONE)  
		e1:SetValue(800) 
		e1:SetReset(RESET_EVENT+RESETS_STANDARD) 
		c:RegisterEffect(e1) 
		local e2=e1:Clone() 
		e2:SetCode(EFFECT_UPDATE_DEFENSE) 
		c:RegisterEffect(e2)			 
	end 
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetTargetRange(1,0)
	e1:SetValue(function(e,re,tp) 
	return re:IsHasType(EFFECT_TYPE_ACTIVATE) end) 
	Duel.RegisterEffect(e1,tp)
end 
function c11561007.atkcon1(e,tp,eg,ep,ev,re,r,rp) 
	return e:GetHandler():GetFlagEffect(11561007)<2 
end 
function c11561007.atkcon2(e,tp,eg,ep,ev,re,r,rp) 
	return e:GetHandler():GetFlagEffect(11561007)<2 and re:GetHandler()~=e:GetHandler() and re:IsActiveType(TYPE_MONSTER) and re:GetHandler():IsLocation(LOCATION_MZONE) and re:GetHandler():IsControler(tp) 
end 
function c11561007.atktg(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return Duel.IsExistingTarget(Card.IsFaceup,tp,LOCATION_MZONE,0,1,nil) end  
	local g=Duel.SelectTarget(tp,Card.IsFaceup,tp,LOCATION_MZONE,0,1,1,nil)
	e:GetHandler():RegisterFlagEffect(11561007,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1) 
end 
function c11561007.atkop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	local tc=Duel.GetFirstTarget() 
	if tc:IsRelateToEffect(e) then 
		local e1=Effect.CreateEffect(c) 
		e1:SetType(EFFECT_TYPE_SINGLE) 
		e1:SetCode(EFFECT_UPDATE_ATTACK)   
		e1:SetRange(LOCATION_MZONE)  
		e1:SetValue(800) 
		e1:SetReset(RESET_EVENT+RESETS_STANDARD) 
		tc:RegisterEffect(e1) 
		local e2=e1:Clone() 
		e2:SetCode(EFFECT_UPDATE_DEFENSE) 
		tc:RegisterEffect(e2)	 
	end 
end 




