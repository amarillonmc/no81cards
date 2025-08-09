--导引巫女·可可萝
function c11561044.initial_effect(c)
	c:SetSPSummonOnce(11561044) 
	c:EnableCounterPermit(0x1)
	--link summon
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,c11561044.mfilter,1)
	--ld
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e0:SetCode(EVENT_ATTACK_ANNOUNCE)
	e0:SetCondition(c11561044.ldcon)
	e0:SetOperation(c11561044.ldop)
	c:RegisterEffect(e0)
	--counter 
	local e1=Effect.CreateEffect(c)  
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS) 
	e1:SetCondition(c11561044.ctcon) 
	e1:SetOperation(c11561044.ctop)
	c:RegisterEffect(e1)  
end
function c11561044.ldcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(11561044)>0
end
function c11561044.filter(c)
	return c:GetAttackedCount()>0
end
function c11561044.ldop(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetMatchingGroup(c11561044.filter,tp,LOCATION_MZONE,0,nil)
	local c=e:GetHandler()
	local tc=sg:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_EXTRA_ATTACK)
		e1:SetValue(1)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_BATTLE)
		tc:RegisterEffect(e1)
		tc=sg:GetNext()
	end
end
function c11561044.mfilter(c)
	return c:IsLinkType(TYPE_LINK) and c:GetLink()>=2
end
function c11561044.ctfilter(c,e)
	return c:IsType(TYPE_LINK) 
end
function c11561044.ctcon(e,tp,eg,ep,ev,re,r,rp)
	local mg=e:GetHandler():GetMaterial()
	if mg:GetCount()<1 then return false end   
	local g=mg:Filter(c11561044.ctfilter,1,nil,e) 
	local lk=g:GetSum(Card.GetLink)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK) and g:GetCount()>0 and e:GetHandler():IsCanAddCounter(0x1,lk)
end 
function c11561044.ctop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local mg=e:GetHandler():GetMaterial()
	if mg:GetCount()<1 then return false end  
	Duel.Hint(HINT_CARD,0,11561044) 
	local g=mg:Filter(c11561044.ctfilter,1,nil,e) 
	local lk=g:GetSum(Card.GetLink)
	if c:IsFaceup() and c:IsLocation(LOCATION_ONFIELD) then 
		c:AddCounter(0x1,lk)
	end
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,0,nil) 
	if lk>=1 and g:GetCount()>0 then 
		local tc=g:GetFirst() 
		while tc do 
		local e1=Effect.CreateEffect(c) 
		e1:SetType(EFFECT_TYPE_SINGLE) 
		e1:SetCode(EFFECT_UPDATE_ATTACK) 
		e1:SetRange(LOCATION_MZONE) 
		e1:SetValue(lk*200) 
		e1:SetReset(RESET_EVENT+RESETS_STANDARD) 
		tc:RegisterEffect(e1)
		local e1=Effect.CreateEffect(c) 
		e1:SetType(EFFECT_TYPE_SINGLE) 
		e1:SetCode(EFFECT_UPDATE_DEFENSE) 
		e1:SetRange(LOCATION_MZONE) 
		e1:SetValue(lk*200) 
		e1:SetReset(RESET_EVENT+RESETS_STANDARD) 
		tc:RegisterEffect(e1)
		tc=g:GetNext() 
		end 
	end 
	if lk>=2 then 
		Duel.Recover(tp,lk*400,REASON_EFFECT)
	end
	if lk>=3 and Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>=math.floor(lk/2) and Duel.IsPlayerCanDiscardDeck(tp,math.floor(lk/2))  then 
		Duel.DiscardDeck(tp,math.floor(lk/2),REASON_EFFECT)
	end  
	if lk>=4 then
		c:RegisterFlagEffect(11561044,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1,0)
	end 
	if lk>=5 and Duel.IsPlayerCanDraw(tp,math.floor(lk/3)) then 
		Duel.Draw(tp,math.floor(lk/3),REASON_EFFECT)
	end
	if lk>=6 then  
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
		e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		e1:SetRange(LOCATION_MZONE)
		e1:SetTargetRange(0x3c,0x3c)
		e1:SetTarget(function(e,c)
		return c~=e:GetHandler() end)
		e1:SetValue(aux.tgoval)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD) 
		c:RegisterEffect(e1) 
		local e2=Effect.CreateEffect(c) 
		e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS) 
		e2:SetCode(EVENT_LEAVE_FIELD) 
		e2:SetOperation(c11561044.efop2)
		c:RegisterEffect(e2)
	end  
end  
function c11561044.efop1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=e:GetHandler():GetReasonCard()
	e:Reset()
	if e:GetHandler():IsLocation(LOCATION_GRAVE) and r==REASON_LINK and rc then 
		local e1=Effect.CreateEffect(c) 
		e1:SetType(EFFECT_TYPE_FIELD) 
		e1:SetCode(EFFECT_UPDATE_ATTACK) 
		e1:SetRange(LOCATION_MZONE) 
		e1:SetTargetRange(LOCATION_MZONE,0)
		e1:SetValue(400) 
		e1:SetReset(RESET_EVENT+RESETS_STANDARD) 
		rc:RegisterEffect(e1)
		local e1=Effect.CreateEffect(c) 
		e1:SetType(EFFECT_TYPE_FIELD) 
		e1:SetCode(EFFECT_EXTRA_ATTACK) 
		e1:SetRange(LOCATION_MZONE) 
		e1:SetTargetRange(LOCATION_MZONE,0)
		e1:SetValue(1)  
		e1:SetReset(RESET_EVENT+RESETS_STANDARD) 
		rc:RegisterEffect(e1)  
	end 
end  
function c11561044.efop2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=e:GetHandler():GetReasonCard()
	e:Reset()
	if e:GetHandler():IsLocation(LOCATION_GRAVE) and r==REASON_LINK and rc then 
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
		e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		e1:SetRange(LOCATION_MZONE)
		e1:SetTargetRange(LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_REMOVED,LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_REMOVED)
		e1:SetTarget(function(e,c)
		return c~=e:GetHandler() end)
		e1:SetValue(aux.tgoval)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD) 
		rc:RegisterEffect(e1) 
	end 
end  

