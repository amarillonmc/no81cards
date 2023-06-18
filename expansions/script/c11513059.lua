--不可思议的探求者 爱丽丝
function c11513059.initial_effect(c)
	--atk 
	local e1=Effect.CreateEffect(c) 
	e1:SetDescription(aux.Stringid(11513059,1))
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O) 
	e1:SetCode(EVENT_SUMMON_SUCCESS) 
	e1:SetProperty(EFFECT_FLAG_DELAY) 
	e1:SetCost(c11513059.atkcost) 
	e1:SetTarget(function(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return e:GetHandler():GetFlagEffect(11513059)==0 end 
	e:GetHandler():RegisterFlagEffect(11513059,RESET_CHAIN,0,1) end)
	e1:SetOperation(c11513059.atkop1) 
	c:RegisterEffect(e1) 
	local e2=e1:Clone() 
	e2:SetCode(EVENT_SPSUMMON_SUCCESS) 
	c:RegisterEffect(e2) 
	local e1=Effect.CreateEffect(c) 
	e1:SetDescription(aux.Stringid(11513059,2))
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O) 
	e1:SetCode(EVENT_SUMMON_SUCCESS) 
	e1:SetProperty(EFFECT_FLAG_DELAY)  
	e1:SetTarget(function(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return e:GetHandler():GetFlagEffect(11513059)==0 end 
	e:GetHandler():RegisterFlagEffect(11513059,RESET_CHAIN,0,1) end)
	e1:SetOperation(c11513059.atkop2) 
	c:RegisterEffect(e1) 
	local e2=e1:Clone() 
	e2:SetCode(EVENT_SPSUMMON_SUCCESS) 
	c:RegisterEffect(e2) 
	--def 
	local e3=Effect.CreateEffect(c) 
	e3:SetDescription(aux.Stringid(11513059,1))
	e3:SetType(EFFECT_TYPE_QUICK_F)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EVENT_BECOME_TARGET)
	e3:SetProperty(EFFECT_FLAG_NO_TURN_RESET)
	e3:SetCountLimit(1) 
	e3:SetCondition(c11513059.defcon) 
	e3:SetCost(c11513059.atkcost) 
	e3:SetTarget(function(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return e:GetHandler():GetFlagEffect(11513059)==0 end 
	e:GetHandler():RegisterFlagEffect(21513059,RESET_CHAIN,0,1) end)
	e3:SetOperation(c11513059.defop1)
	c:RegisterEffect(e3)
	local e3=Effect.CreateEffect(c) 
	e3:SetDescription(aux.Stringid(11513059,2))
	e3:SetType(EFFECT_TYPE_QUICK_F)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EVENT_BECOME_TARGET)
	e3:SetProperty(EFFECT_FLAG_NO_TURN_RESET)
	e3:SetCountLimit(1) 
	e3:SetCondition(c11513059.defcon)  
	e3:SetTarget(function(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return e:GetHandler():GetFlagEffect(11513059)==0 end 
	e:GetHandler():RegisterFlagEffect(21513059,RESET_CHAIN,0,1) end)
	e3:SetOperation(c11513059.defop2)
	c:RegisterEffect(e3)
end
function c11513059.atkcost(e,tp,eg,ep,ev,re,r,rp,chk) 
	local g=Duel.GetMatchingGroup(function(c) return c:IsType(TYPE_MONSTER) and not c:IsPublic() end,tp,LOCATION_HAND,0,nil) 
	if chk==0 then return g:CheckSubGroup(aux.dabcheck,1,7) end 
	local sg=g:SelectSubGroup(tp,aux.dabcheck,false,1,7)
	local tc=sg:GetFirst() 
	while tc do 
	Duel.ConfirmCards(1-tp,tc)
	tc=sg:GetNext() 
	sg:KeepAlive() 
	e:SetLabelObject(sg) 
	end 
end 
function c11513059.atkop1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	Duel.Hint(HINT_MESSAGE,0,aux.Stringid(11513059,0))
	Duel.Hint(HINT_MESSAGE,1,aux.Stringid(11513059,0))
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,0,nil) 
	if g:GetCount()>0 then  
		local tc=g:GetFirst() 
		while tc do 
			local e1=Effect.CreateEffect(c) 
			e1:SetType(EFFECT_TYPE_SINGLE) 
			e1:SetCode(EFFECT_UPDATE_ATTACK)  
			e1:SetRange(LOCATION_MZONE) 
			e1:SetValue(800) 
			e1:SetReset(RESET_EVENT+RESETS_STANDARD) 
			tc:RegisterEffect(e1) 
			local e1=Effect.CreateEffect(c) 
			e1:SetType(EFFECT_TYPE_SINGLE) 
			e1:SetCode(EFFECT_UPDATE_DEFENSE)  
			e1:SetRange(LOCATION_MZONE) 
			e1:SetValue(800) 
			e1:SetReset(RESET_EVENT+RESETS_STANDARD) 
			tc:RegisterEffect(e1)  
			tc=g:GetNext() 
		end 
		local sg=e:GetLabelObject() 
		if sg and sg:GetCount()>0 then  
			local tc=sg:GetFirst() 
			while tc do 
			local e1=Effect.CreateEffect(c) 
			e1:SetType(EFFECT_TYPE_SINGLE) 
			e1:SetCode(EFFECT_UPDATE_ATTACK)  
			e1:SetRange(LOCATION_MZONE) 
			e1:SetValue(800) 
			e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD) 
			tc:RegisterEffect(e1) 
			local e1=Effect.CreateEffect(c) 
			e1:SetType(EFFECT_TYPE_SINGLE) 
			e1:SetCode(EFFECT_UPDATE_DEFENSE)  
			e1:SetRange(LOCATION_MZONE) 
			e1:SetValue(800) 
			e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD) 
			tc:RegisterEffect(e1)  
			tc=sg:GetNext() 
			end 
		end 
	end 
end  
function c11513059.atkop2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	Duel.Hint(HINT_MESSAGE,0,aux.Stringid(11513059,0))
	Duel.Hint(HINT_MESSAGE,1,aux.Stringid(11513059,0))
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,0,nil) 
	if g:GetCount()>0 then  
		 local tc=g:GetFirst() 
		 while tc do 
			local e1=Effect.CreateEffect(c) 
			e1:SetType(EFFECT_TYPE_SINGLE) 
			e1:SetCode(EFFECT_UPDATE_ATTACK)  
			e1:SetRange(LOCATION_MZONE) 
			e1:SetValue(800) 
			e1:SetReset(RESET_EVENT+RESETS_STANDARD) 
			tc:RegisterEffect(e1) 
			local e1=Effect.CreateEffect(c) 
			e1:SetType(EFFECT_TYPE_SINGLE) 
			e1:SetCode(EFFECT_UPDATE_DEFENSE)  
			e1:SetRange(LOCATION_MZONE) 
			e1:SetValue(800) 
			e1:SetReset(RESET_EVENT+RESETS_STANDARD) 
			tc:RegisterEffect(e1) 
			tc=g:GetNext() 
		end 
	end 
end  
function c11513059.defcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsContains(e:GetHandler())
end 
function c11513059.defop1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,0,nil) 
	if g:GetCount()>0 then  
		Duel.Hint(HINT_MESSAGE,0,aux.Stringid(11513059,0))
		Duel.Hint(HINT_MESSAGE,1,aux.Stringid(11513059,0))  
			local tc=g:GetFirst() 
			while tc do 
			local e1=Effect.CreateEffect(c) 
			e1:SetType(EFFECT_TYPE_SINGLE) 
			e1:SetCode(EFFECT_UPDATE_DEFENSE)  
			e1:SetRange(LOCATION_MZONE) 
			e1:SetValue(800) 
			e1:SetReset(RESET_EVENT+RESETS_STANDARD) 
			tc:RegisterEffect(e1)  
			tc=g:GetNext() 
			end  
		if c:IsRelateToEffect(e) then  
		Duel.BreakEffect() 
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
		local sg=e:GetLabelObject() 
		if sg and sg:GetCount()>0 then  
			local tc=sg:GetFirst() 
			while tc do  
			local e1=Effect.CreateEffect(c) 
			e1:SetType(EFFECT_TYPE_SINGLE) 
			e1:SetCode(EFFECT_UPDATE_DEFENSE)  
			e1:SetRange(LOCATION_MZONE) 
			e1:SetValue(800) 
			e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD) 
			tc:RegisterEffect(e1)  
			tc=sg:GetNext() 
			end 
		end 
		end 
	end 
end 
function c11513059.defop2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,0,nil) 
	if g:GetCount()>0 then  
		Duel.Hint(HINT_MESSAGE,0,aux.Stringid(11513059,0))
		Duel.Hint(HINT_MESSAGE,1,aux.Stringid(11513059,0))  
			local tc=g:GetFirst() 
			while tc do 
			local e1=Effect.CreateEffect(c) 
			e1:SetType(EFFECT_TYPE_SINGLE) 
			e1:SetCode(EFFECT_UPDATE_DEFENSE)  
			e1:SetRange(LOCATION_MZONE) 
			e1:SetValue(800) 
			e1:SetReset(RESET_EVENT+RESETS_STANDARD) 
			tc:RegisterEffect(e1) 
			tc=g:GetNext() 
			end  
		if c:IsRelateToEffect(e) then  
		Duel.BreakEffect() 
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
		end 
	end 
end 







