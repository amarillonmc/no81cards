--焦热龙翼·德莱克
function c11560317.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,c11560317.mfilter,8,2)
	aux.AddXyzProcedureLevelFree(c,c11560317.mfilter,nil,3,3)
	c:EnableReviveLimit() 
	--redirect 
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_TO_GRAVE_REDIRECT)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetValue(LOCATION_REMOVED)
	c:RegisterEffect(e0) 
	--atk and des
	local e1=Effect.CreateEffect(c)  
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O) 
	e1:SetCode(EVENT_SPSUMMON_SUCCESS) 
	e1:SetProperty(EFFECT_FLAG_DELAY)  
	e1:SetCountLimit(1,11560317)
	e1:SetTarget(c11560317.adestg) 
	e1:SetOperation(c11560317.adesop) 
	c:RegisterEffect(e1)  
	--defense attack
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_DEFENSE_ATTACK)
	e2:SetValue(1)
	c:RegisterEffect(e2) 
	--des 
	local e3=Effect.CreateEffect(c) 
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_DAMAGE_STEP_END) 
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP) 
	e3:SetCountLimit(1,21560317) 
	e3:SetCost(function(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end 
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST) end)
	e3:SetTarget(c11560317.destg)
	e3:SetOperation(c11560317.desop)
	c:RegisterEffect(e3)
	if not c11560317.global_check then
		c11560317.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_REMOVE)
		ge1:SetOperation(c11560317.rmckop)
		Duel.RegisterEffect(ge1,0) 
	end 
end
c11560317.SetCard_XdMcy=true 
function c11560317.rmckop(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst() 
	while tc do   
	local flag=Duel.GetFlagEffectLabel(tc:GetControler(),11560317)
	if flag==nil then 
	Duel.RegisterFlagEffect(tc:GetControler(),11560317,0,0,0,1) 
	else 
	Duel.SetFlagEffectLabel(tc:GetControler(),11560317,flag+1)   
	end 
	tc=eg:GetNext() 
	end 
end  
function c11560317.mfilter(c)
	return c.SetCard_XdMcy
end 
function c11560317.adestg(e,tp,eg,ep,ev,re,r,rp,chk) 
	local flag=Duel.GetFlagEffectLabel(tp,11560317) 
	if chk==0 then return flag and flag>=10 end 
end  
function c11560317.desfil(c) 
	return c:IsFaceup() and c:IsDefenseBelow(2400)  
end 
function c11560317.adesop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	if c:IsRelateToEffect(e) and c:IsFaceup() then 
	local e1=Effect.CreateEffect(c) 
	e1:SetType(EFFECT_TYPE_SINGLE) 
	e1:SetCode(EFFECT_UPDATE_ATTACK) 
	e1:SetRange(LOCATION_MZONE) 
	e1:SetValue(1600)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD) 
	c:RegisterEffect(e1) 
	local e2=e1:Clone() 
	e2:SetCode(EFFECT_UPDATE_DEFENSE) 
	e2:SetValue(2400) 
	c:RegisterEffect(e2) 
		if Duel.IsExistingMatchingCard(c11560317.desfil,tp,0,LOCATION_MZONE,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(11560317,0)) then 
		local dc=Duel.SelectMatchingCard(tp,c11560317.desfil,tp,0,LOCATION_MZONE,1,1,nil):GetFirst() 
		if Duel.Destroy(dc,REASON_EFFECT)~=0 and c:IsRelateToEffect(e) then 
		local e1=Effect.CreateEffect(c) 
		e1:SetType(EFFECT_TYPE_SINGLE) 
		e1:SetCode(EFFECT_UPDATE_DEFENSE) 
		e1:SetRange(LOCATION_MZONE) 
		e1:SetValue(dc:GetDefense())
		e1:SetReset(RESET_EVENT+RESETS_STANDARD) 
		c:RegisterEffect(e1) 
		end  
		end
	end 
end  
function c11560317.xdesfil(c,def) 
	return c:IsFaceup() and c:IsDefenseBelow(def)  
end 
function c11560317.destg(e,tp,eg,ep,ev,re,r,rp,chk) 
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c11560317.xdesfil,tp,0,LOCATION_MZONE,nil,c:GetDefense())
	if chk==0 then return c:IsPosition(POS_DEFENSE) and Duel.IsExistingMatchingCard(c11560317.xdesfil,tp,0,LOCATION_MZONE,1,nil,c:GetDefense()) end 
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c11560317.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	local def=e:GetHandler():GetDefense()
	local g=Duel.GetMatchingGroup(c11560317.xdesfil,tp,0,LOCATION_MZONE,nil,def)
	if g:GetCount()>0 then  
	Duel.Destroy(g,REASON_EFFECT) 
		local flag=Duel.GetFlagEffectLabel(tp,11560317) 
		if flag and flag>=10 then 
		Duel.Damage(1-tp,2000,REASON_EFFECT) 
		end  
	end  
end 





