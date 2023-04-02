--不可思议的探求者 爱丽丝
function c11513059.initial_effect(c)
	--atk 
	local e1=Effect.CreateEffect(c) 
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O) 
	e1:SetCode(EVENT_SUMMON_SUCCESS) 
	e1:SetProperty(EFFECT_FLAG_DELAY)  
	e1:SetOperation(c11513059.atkop) 
	c:RegisterEffect(e1) 
	local e2=e1:Clone() 
	e2:SetCode(EVENT_SPSUMMON_SUCCESS) 
	c:RegisterEffect(e2) 
	--def 
	local e3=Effect.CreateEffect(c) 
	e3:SetType(EFFECT_TYPE_QUICK_F)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EVENT_BECOME_TARGET) 
	e3:SetProperty(EFFECT_FLAG_NO_TURN_RESET)
	e3:SetCountLimit(1)
	e3:SetCondition(c11513059.defcon) 
	e3:SetOperation(c11513059.defop)
	c:RegisterEffect(e3)
end
function c11513059.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	Duel.Hint(HINT_MESSAGE,0,aux.Stringid(11513059,1))
	Duel.Hint(HINT_MESSAGE,1,aux.Stringid(11513059,1))
	local e1=Effect.CreateEffect(c) 
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_UPDATE_ATTACK) 
	e1:SetTargetRange(LOCATION_MZONE,0) 
	e1:SetValue(600) 
	Duel.RegisterEffect(e1,tp) 
end  
function c11513059.defcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsContains(e:GetHandler())
end 
function c11513059.defop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	if c:IsRelateToEffect(e) then 
	Duel.Hint(HINT_MESSAGE,0,aux.Stringid(11513059,1))
	Duel.Hint(HINT_MESSAGE,1,aux.Stringid(11513059,1))
		local e1=Effect.CreateEffect(c) 
		e1:SetType(EFFECT_TYPE_SINGLE) 
		e1:SetCode(EFFECT_UPDATE_ATTACK) 
		e1:SetRange(LOCATION_MZONE) 
		e1:SetValue(800) 
		e1:SetReset(RESET_EVENT+RESETS_STANDARD) 
		c:RegisterEffect(e1) 
		local e1=Effect.CreateEffect(c) 
		e1:SetType(EFFECT_TYPE_SINGLE) 
		e1:SetCode(EFFECT_UPDATE_DEFENSE)  
		e1:SetRange(LOCATION_MZONE) 
		e1:SetValue(800) 
		e1:SetReset(RESET_EVENT+RESETS_STANDARD) 
		c:RegisterEffect(e1) 
	local e1=Effect.CreateEffect(c) 
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_UPDATE_DEFENSE) 
	e1:SetTargetRange(LOCATION_MZONE,0) 
	e1:SetValue(600) 
	Duel.RegisterEffect(e1,tp) 
	end 
end 







