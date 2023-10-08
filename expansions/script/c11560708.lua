--星海航线 天启帝君
function c11560708.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,8,2) 
	c:EnableReviveLimit()   
	--Disable 
	local e1=Effect.CreateEffect(c)  
	e1:SetCategory(CATEGORY_DISABLE+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O) 
	e1:SetCode(EVENT_SPSUMMON_SUCCESS) 
	e1:SetProperty(EFFECT_FLAG_DELAY) 
	e1:SetCountLimit(1,11560708)
	e1:SetTarget(c11560708.distg) 
	e1:SetOperation(c11560708.disop) 
	c:RegisterEffect(e1)   
	--
	--local e2=Effect.CreateEffect(c) 
	--e2:SetType(EFFECT_TYPE_FIELD) 
	--e2:SetCode(EFFECT_CANNOT_TRIGGER) 
	--e2:SetRange(LOCATION_MZONE)  
	--e2:SetTargetRange(0,LOCATION_MZONE) 
	--e2:SetTarget(function(e,c)
	--return c:GetAttack()~=c:GetBaseAttack() end) 
	--c:RegisterEffect(e2) 
	local e2=Effect.CreateEffect(c)   
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS) 
	e2:SetCode(EVENT_CHAIN_SOLVED)  
	e2:SetRange(LOCATION_MZONE)
	e2:SetTarget(c11560708.atkcon) 
	e2:SetOperation(c11560708.atkop) 
	c:RegisterEffect(e2) 
	--Disable 
	local e3=Effect.CreateEffect(c)  
	e3:SetCategory(CATEGORY_DISABLE+CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,21560708)
	e3:SetCost(c11560708.bdiscost)
	e3:SetTarget(c11560708.bdistg) 
	e3:SetOperation(c11560708.bdisop) 
	c:RegisterEffect(e3)  
	--remove
	local e4=Effect.CreateEffect(c)  
	e4:SetCategory(CATEGORY_TOGRAVE)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e4:SetCode(EVENT_LEAVE_FIELD) 
	e4:SetCountLimit(1,31560708) 
	e4:SetLabel(0)
	e4:SetCondition(function(e) 
	return e:GetLabel()~=0 end)
	e4:SetTarget(c11560708.rmtg) 
	e4:SetOperation(c11560708.rmop) 
	c:RegisterEffect(e4) 
	local e5=Effect.CreateEffect(c) 
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS) 
	e5:SetCode(EVENT_LEAVE_FIELD_P)  
	e5:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e5:SetLabelObject(e4) 
	e5:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler() 
	local te=e:GetLabelObject() 
	if te==nil then return end 
	if c:GetOverlayCount()>0 then 
	te:SetLabel(1)
	else
	te:SetLabel(0) 
	end end)  
	c:RegisterEffect(e5) 
end  
c11560708.SetCard_SR_Saier=true 
function c11560708.distg(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return Duel.IsExistingMatchingCard(aux.NegateEffectMonsterFilter,tp,0,LOCATION_MZONE,1,nil) end 
	local g=Duel.GetMatchingGroup(aux.NegateEffectMonsterFilter,tp,0,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,g,g:GetCount(),0,0) 
end 
function c11560708.disop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	local g=Duel.GetMatchingGroup(aux.NegateEffectMonsterFilter,tp,0,LOCATION_MZONE,nil)
	if g:GetCount()>0 then 
	local tc=g:GetFirst() 
	while tc do 
		Duel.NegateRelatedChain(tc,RESET_TURN_SET)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetValue(RESET_TURN_SET)
		tc:RegisterEffect(e2)
		if tc:IsType(TYPE_TRAPMONSTER) then
			local e3=e1:Clone()
			e3:SetCode(EFFECT_DISABLE_TRAPMONSTER)
			tc:RegisterEffect(e3)
		end
	local pratk=tc:GetAttack() 
	local e1=Effect.CreateEffect(c) 
	e1:SetType(EFFECT_TYPE_SINGLE) 
	e1:SetCode(EFFECT_UPDATE_ATTACK) 
	e1:SetRange(LOCATION_MZONE) 
	e1:SetValue(-1500) 
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)   
	tc:RegisterEffect(e1) 
	local atk=tc:GetAttack() 
	if pratk~=0 and atk==0 then Duel.Destroy(tc,REASON_EFFECT) end 
	tc=g:GetNext() 
	end 
	end 
end 
function c11560708.atkcon(e,tp,eg,ep,ev,re,r,rp) 
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
	return rp==1-tp and g:GetCount()>0  
end 
function c11560708.atkop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
	if g:GetCount()>0 then 
		Duel.Hint(HINT_CARD,0,11560708)
		local tc=g:GetFirst() 
		while tc do  
		local pratk=tc:GetAttack() 
		local e1=Effect.CreateEffect(c) 
		e1:SetType(EFFECT_TYPE_SINGLE) 
		e1:SetCode(EFFECT_UPDATE_ATTACK) 
		e1:SetRange(LOCATION_MZONE) 
		e1:SetValue(-300) 
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)   
		tc:RegisterEffect(e1) 
		local atk=tc:GetAttack() 
		if pratk~=0 and atk==0 then Duel.Destroy(tc,REASON_EFFECT) end 
		tc=g:GetNext() 
		end 
	end 
end 
function c11560708.bdiscost(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end 
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST) 
end 
function c11560708.bdistg(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return Duel.IsExistingMatchingCard(aux.NegateEffectMonsterFilter,tp,0,LOCATION_MZONE,1,nil) end 
	local g=Duel.GetMatchingGroup(aux.NegateEffectMonsterFilter,tp,0,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,g,g:GetCount(),0,0) 
end 
function c11560708.bdisop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	local g=Duel.GetMatchingGroup(aux.NegateEffectMonsterFilter,tp,0,LOCATION_MZONE,nil)
	if g:GetCount()>0 then 
	local tc=g:GetFirst() 
	while tc do 
		Duel.NegateRelatedChain(tc,RESET_TURN_SET)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetValue(RESET_TURN_SET)
		tc:RegisterEffect(e2)
		if tc:IsType(TYPE_TRAPMONSTER) then
			local e3=e1:Clone()
			e3:SetCode(EFFECT_DISABLE_TRAPMONSTER)
			tc:RegisterEffect(e3)
		end
	local pratk=tc:GetAttack() 
	local e1=Effect.CreateEffect(c) 
	e1:SetType(EFFECT_TYPE_SINGLE) 
	e1:SetCode(EFFECT_UPDATE_ATTACK) 
	e1:SetRange(LOCATION_MZONE) 
	e1:SetValue(-1500) 
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)   
	tc:RegisterEffect(e1) 
	local atk=tc:GetAttack() 
	if pratk~=0 and atk==0 then Duel.Destroy(tc,REASON_EFFECT) end 
	tc=g:GetNext() 
	end 
	end 
end 
function c11560708.rmtg(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return true end 
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,1-tp,LOCATION_ONFIELD) 
end 
function c11560708.rmop(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler() 
	local g=Duel.GetMatchingGroup(Card.IsAbleToGrave,tp,0,LOCATION_ONFIELD,nil) 
	if g:GetCount()>0 then 
		local dg=g:Select(tp,1,1,nil) 
		Duel.SendtoGrave(dg,REASON_EFFECT) 
	end 
end 















