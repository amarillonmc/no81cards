--导引巫女·可可萝
function c11561044.initial_effect(c)
	c:SetSPSummonOnce(11561044) 
	c:EnableCounterPermit(0x1)
	--link summon
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,c11561044.mfilter,1)
	--counter 
	local e1=Effect.CreateEffect(c) 
	e1:SetCategory(CATEGORY_COUNTER)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCondition(c11561044.ctcon)
	e1:SetTarget(c11561044.cttg)
	e1:SetOperation(c11561044.ctop)
	c:RegisterEffect(e1)	
end
function c11561044.mfilter(c)
	return c:IsLinkType(TYPE_LINK) and c:GetLink()>=2
end
function c11561044.ctcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function c11561044.ctfilter(c,e)
	return c:IsType(TYPE_LINK) 
end
function c11561044.cttg(e,tp,eg,ep,ev,re,r,rp,chk) 
	local mg=e:GetHandler():GetMaterial()
	if mg:GetCount()<1 then return false end   
	local g=mg:Filter(c11561044.ctfilter,1,nil,e) 
	local lk=g:GetSum(Card.GetLink)
	if chk==0 then return g:GetCount()>0 and e:GetHandler():IsCanAddCounter(0x1,lk) end 
	e:SetCategory(CATEGORY_COUNTER) 
	Duel.SetOperationInfo(0,CATEGORY_COUNTER,nil,1,0,0x1) 
	if lk>=2 then 
		e:SetCategory(e:GetCategory()+CATEGORY_RECOVER)
		Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,1200)
	end 
	if lk>=3 then 
		e:SetCategory(e:GetCategory()+CATEGORY_DRAW)
		Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1) 
	end 
end
function c11561044.ctop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local mg=e:GetHandler():GetMaterial()
	if mg:GetCount()<1 then return false end   
	local g=mg:Filter(c11561044.ctfilter,1,nil,e) 
	local lk=g:GetSum(Card.GetLink)
	if c:IsRelateToEffect(e) then 
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
		e1:SetValue(400) 
		e1:SetReset(RESET_EVENT+RESETS_STANDARD) 
		tc:RegisterEffect(e1)
		local e1=Effect.CreateEffect(c) 
		e1:SetType(EFFECT_TYPE_SINGLE) 
		e1:SetCode(EFFECT_UPDATE_DEFENSE) 
		e1:SetRange(LOCATION_MZONE) 
		e1:SetValue(400) 
		e1:SetReset(RESET_EVENT+RESETS_STANDARD) 
		tc:RegisterEffect(e1)
		tc=g:GetNext() 
		end 
	end 
	if lk>=2 then 
		Duel.Recover(tp,1200,REASON_EFFECT)
	end
	if lk>=3 and Duel.IsPlayerCanDraw(tp,1) then 
		Duel.Draw(tp,1,REASON_EFFECT)
	end  
	if lk>=4 then  
		local e1=Effect.CreateEffect(c) 
		e1:SetType(EFFECT_TYPE_FIELD) 
		e1:SetCode(EFFECT_UPDATE_ATTACK) 
		e1:SetRange(LOCATION_MZONE) 
		e1:SetTargetRange(LOCATION_MZONE,0)
		e1:SetValue(400) 
		e1:SetReset(RESET_EVENT+RESETS_STANDARD) 
		c:RegisterEffect(e1)
		local e1=Effect.CreateEffect(c) 
		e1:SetType(EFFECT_TYPE_FIELD) 
		e1:SetCode(EFFECT_EXTRA_ATTACK) 
		e1:SetRange(LOCATION_MZONE) 
		e1:SetTargetRange(LOCATION_MZONE,0)
		e1:SetValue(1)  
		e1:SetReset(RESET_EVENT+RESETS_STANDARD) 
		c:RegisterEffect(e1)  
		local e2=Effect.CreateEffect(c) 
		e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS) 
		e2:SetCode(EVENT_LEAVE_FIELD) 
		e2:SetOperation(c11561044.efop1)
		c:RegisterEffect(e2)
	end 
	if lk>=5 and Duel.IsPlayerCanDraw(tp,1) then 
		Duel.Draw(tp,1,REASON_EFFECT)
	end
	if lk>=6 and Duel.IsPlayerCanDraw(tp,1) then  
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

