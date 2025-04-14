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
	e3:SetCondition(c11561006.condition)
	e3:SetOperation(c11561006.xdesop2) 
	c:RegisterEffect(e3) 
end
function c11561006.condition(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return ph>=PHASE_BATTLE_START and ph<=PHASE_BATTLE
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
	if chk==0 then return Duel.GetFlagEffect(tp,11561006)<e:GetHandler():GetLinkedGroupCount() end
	Duel.RegisterFlagEffect(tp,11561006,RESET_PHASE+PHASE_END,0,1)
end 
function c11561006.xdesop2(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler()
	if c:IsFacedown() or not c:IsRelateToEffect(e) then return end
	local e0=Effect.CreateEffect(c) 
	e0:SetType(EFFECT_TYPE_SINGLE) 
	e0:SetCode(EFFECT_IMMUNE_EFFECT) 
	e0:SetRange(LOCATION_MZONE) 
	e0:SetValue(function(e,te) 
	return e:GetOwner()~=te:GetOwner() end) 
	e0:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_CHAIN) 
	c:RegisterEffect(e0)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE) 
		e1:SetCode(EFFECT_UPDATE_ATTACK) 
		e1:SetRange(LOCATION_MZONE) 
		e1:SetValue(2000) 
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END) 
		c:RegisterEffect(e1)
	if Duel.IsExistingMatchingCard(function(c,atk) return c:GetAttack()<atk and c:IsFaceup() end,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,c:GetAttack()) and Duel.SelectYesNo(tp,aux.Stringid(11561006,0)) then 
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local dg=Duel.SelectMatchingCard(tp,function(c,atk) return c:GetAttack()<atk and c:IsFaceup() end,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,c:GetAttack())
		Duel.Destroy(dg,REASON_EFFECT)
	end 
end

function c11561006.xdesop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler()
	if c:IsFacedown() or not c:IsRelateToEffect(e) then return end
	local e0=Effect.CreateEffect(c) 
	e0:SetType(EFFECT_TYPE_SINGLE) 
	e0:SetCode(EFFECT_IMMUNE_EFFECT) 
	e0:SetRange(LOCATION_MZONE) 
	e0:SetValue(function(e,te) 
	return e:GetOwner()~=te:GetOwner() end) 
	e0:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_CHAIN) 
	c:RegisterEffect(e0)
	local b1=Duel.IsExistingMatchingCard(function(c,atk) return c:GetAttack()<atk and c:IsFaceup() end,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,c:GetAttack()) and not c:GetFlagEffectLabel(11561006)==1
	local b2=c:IsFaceup() and c:IsRelateToEffect(e) and not c:GetFlagEffectLabel(11561006)==2
	local b3=true
	local op=aux.SelectFromOptions(tp,
		{b1,aux.Stringid(11561006,2)},
		{b2,aux.Stringid(11561006,3)},
		{b3,aux.Stringid(11561006,4)})
	if op==1 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE) 
		e1:SetCode(EFFECT_UPDATE_ATTACK) 
		e1:SetRange(LOCATION_MZONE) 
		e1:SetValue(2000) 
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END) 
		c:RegisterEffect(e1)
		c:ResetFlagEffect(11561006)
		c:RegisterFlagEffect(11561006,RESET_EVENT+RESETS_STANDARD,0,1,1)
	elseif op==2 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local dg=Duel.SelectMatchingCard(tp,function(c,atk) return c:GetAttack()<atk and c:IsFaceup() end,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,c:GetAttack())
		Duel.Destroy(dg,REASON_EFFECT)
		c:ResetFlagEffect(11561006)
		c:RegisterFlagEffect(11561006,RESET_EVENT+RESETS_STANDARD,0,1,2)
	end 
end
