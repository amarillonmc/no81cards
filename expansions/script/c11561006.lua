--誓约女君 克莉丝提娜
function c11561006.initial_effect(c)
	c:EnableCounterPermit(0x1) 
	--link summon
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkType,TYPE_EFFECT),2)
	--counter 
	local e1=Effect.CreateEffect(c) 
	e1:SetCategory(CATEGORY_COUNTER)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS) 
	e1:SetCondition(function(e) 
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK) end)
	e1:SetTarget(c11561006.addtg)
	e1:SetOperation(c11561006.addop)
	c:RegisterEffect(e1) 
	--des 
	local e2=Effect.CreateEffect(c)   
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)  
	e2:SetRange(LOCATION_MZONE) 
	e2:SetCountLimit(1,11561006)
	e2:SetCondition(c11561006.descon) 
	e2:SetTarget(c11561006.destg) 
	e2:SetOperation(c11561006.desop) 
	c:RegisterEffect(e2) 
	--des 
	local e3=Effect.CreateEffect(c) 
	e3:SetCategory(CATEGORY_DESTROY) 
	e3:SetType(EFFECT_TYPE_QUICK_O) 
	e3:SetCode(EVENT_FREE_CHAIN) 
	e3:SetHintTiming(0,TIMINGS_CHECK_MONSTER)   
	e3:SetRange(LOCATION_MZONE) 
	e3:SetCost(c11561006.xdescost) 
	e3:SetTarget(c11561006.xdestg) 
	e3:SetOperation(c11561006.xdesop) 
	c:RegisterEffect(e3) 
end
function c11561006.addtg(e,tp,eg,ep,ev,re,r,rp,chk) 
	local x=e:GetHandler():GetMaterialCount() 
	if chk==0 then return x>0 and e:GetHandler():IsCanAddCounter(0x1,x) end
	Duel.SetOperationInfo(0,CATEGORY_COUNTER,nil,x,0,0x1)
end
function c11561006.addop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	local x=c:GetMaterialCount()  
	if c:IsRelateToEffect(e) then
		c:AddCounter(0x1,x)
	end
end
function c11561006.desfil(c,e,tp) 
	return e:GetHandler():GetLinkedGroup():IsContains(c) 
end 
function c11561006.descon(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler()
	return eg:IsExists(c11561006.desfil,1,nil,e,tp)   
end 
function c11561006.destg(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return true end  
end   
function c11561006.desop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	local x=c:GetLinkedGroupCount() 
	if x>0 then   
		if c:IsRelateToEffect(e) and c:IsCanAddCounter(0x1,x) then 
			c:AddCounter(0x1,x)  
		end 
	end 
end 
function c11561006.xdescost(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return Duel.IsCanRemoveCounter(tp,1,0,0x1,2,REASON_COST) end
	Duel.RemoveCounter(tp,1,0,0x1,2,REASON_COST)
end  
function c11561006.xdestg(e,tp,eg,ep,ev,re,r,rp,chk)  
	local c=e:GetHandler() 
	local x=c:GetLinkedGroupCount() 
	local b1=c:GetFlagEffect(21561006)==0 
	local b2=c:GetFlagEffect(31561006)==0 and Duel.IsExistingMatchingCard(function(c,atk) return c:GetAttack()<atk and c:IsFaceup() end,tp,0,LOCATION_MZONE,1,nil,c:GetAttack()) 
	local b3=c:GetFlagEffect(41561006)==0
	if chk==0 then return c:GetFlagEffect(11561006)<x and (b1 or b2 or b3) end
	c:RegisterFlagEffect(11561006,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1) 
end 
function c11561006.xdesop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler()  
		local b1=c:GetFlagEffect(21561006)==0 
		local b2=c:GetFlagEffect(31561006)==0 and Duel.IsExistingMatchingCard(function(c,atk) return c:GetAttack()<atk and c:IsFaceup() end,tp,0,LOCATION_MZONE,1,nil,c:GetAttack()) 
		local b3=c:GetFlagEffect(41561006)==0
		if (b1 or b2 or b3) then 
			local op=0 
			if b1 and b2 and b3 then 
				op=Duel.SelectOption(tp,aux.Stringid(11561006,1),aux.Stringid(11561006,2),aux.Stringid(11561006,3))
			elseif b1 and b2 then 
				op=Duel.SelectOption(tp,aux.Stringid(11561006,1),aux.Stringid(11561006,2))
			elseif b2 and b3 then 
				op=Duel.SelectOption(tp,aux.Stringid(11561006,2),aux.Stringid(11561006,3))+1 
			elseif b1 and b3 then 
				op=Duel.SelectOption(tp,aux.Stringid(11561006,1),aux.Stringid(11561006,3)) 
				if op==1 then op=op+1 end 
			elseif b1 then 
				op=Duel.SelectOption(tp,aux.Stringid(11561006,1)) 
			elseif b2 then 
				op=Duel.SelectOption(tp,aux.Stringid(11561006,2))+1 
			elseif b3 then 
				op=Duel.SelectOption(tp,aux.Stringid(11561006,3))+2 
			end  
			if op==0 then   
				local e1=Effect.CreateEffect(c) 
				e1:SetType(EFFECT_TYPE_SINGLE) 
				e1:SetCode(EFFECT_UPDATE_ATTACK) 
				e1:SetRange(LOCATION_MZONE) 
				e1:SetValue(2000) 
				e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END) 
				c:RegisterEffect(e1) 
				c:RegisterFlagEffect(21561006,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
			elseif op==1 then   
				local dg=Duel.SelectMatchingCard(tp,function(c,atk) return c:GetAttack()<atk and c:IsFaceup() end,tp,0,LOCATION_MZONE,1,1,nil,c:GetAttack())
				Duel.Destroy(dg,REASON_EFFECT)   
				c:RegisterFlagEffect(31561006,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
			elseif op==2 then   
				local e1=Effect.CreateEffect(c) 
				e1:SetType(EFFECT_TYPE_SINGLE) 
				e1:SetCode(EFFECT_IMMUNE_EFFECT) 
				e1:SetRange(LOCATION_MZONE) 
				e1:SetValue(function(e,te) 
				return e:GetOwner()~=te:GetOwner() end) 
				e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_CHAIN) 
				c:RegisterEffect(e1) 
				c:RegisterFlagEffect(41561006,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
			end 
		end  
end 
