--雷灭卿 阿尔贝尔
function c87490445.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,9,3)
	c:EnableReviveLimit()
	--xx
	local e1=Effect.CreateEffect(c)  
	e1:SetDescription(aux.Stringid(87490445,1))
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O) 
	e1:SetCode(EVENT_SPSUMMON_SUCCESS) 
	e1:SetProperty(EFFECT_FLAG_DELAY)  
	e1:SetCost(c87490445.sxxcost)
	e1:SetTarget(c87490445.sxxtg1) 
	e1:SetOperation(c87490445.sxxop1) 
	c:RegisterEffect(e1) 
	local e1=Effect.CreateEffect(c)  
	e1:SetDescription(aux.Stringid(87490445,2))
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O) 
	e1:SetCode(EVENT_SPSUMMON_SUCCESS) 
	e1:SetProperty(EFFECT_FLAG_DELAY)  
	e1:SetCost(c87490445.sxxcost)
	e1:SetTarget(c87490445.sxxtg2) 
	e1:SetOperation(c87490445.sxxop2) 
	c:RegisterEffect(e1) 
	--dis
	local e2=Effect.CreateEffect(c) 
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS) 
	e2:SetCode(EVENT_CHAIN_SOLVING) 
	e2:SetRange(LOCATION_MZONE) 
	e2:SetCondition(c87490445.discon) 
	e2:SetOperation(c87490445.disop) 
	c:RegisterEffect(e2) 
end
function c87490445.sxxcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:GetFlagEffect(87491445)==0 end
	c:RegisterFlagEffect(87491445,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_DAMAGE_CAL,0,1)
end 
function c87490445.sxxtg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end 
end 
function c87490445.sxxop1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler() 
	--indes
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e1:SetValue(1) 
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,2)  
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	c:RegisterEffect(e2)
end 
function c87490445.sxxtg2(e,tp,eg,ep,ev,re,r,rp,chk) 
	local g=Duel.GetFieldGroup(tp,0,LOCATION_ONFIELD)
	if chk==0 then return g:GetCount()>0 end 
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)  
	Duel.SetChainLimit(c87490445.chlimit)
end
function c87490445.chlimit(e,ep,tp)
	return tp==ep
end
function c87490445.sxxop2(e,tp,eg,ep,ev,re,r,rp,chk) 
	local c=e:GetHandler()   
	local g=Duel.GetFieldGroup(tp,0,LOCATION_ONFIELD)
	if g:GetCount()>0 then 
		Duel.Destroy(g,REASON_EFFECT) 
	end 
end 
function c87490445.discon(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler()
	return c:GetFlagEffect(87490445)<2 and re:GetHandlerPlayer()~=tp and Duel.IsChainDisablable(ev) and c:CheckRemoveOverlayCard(tp,1,REASON_EFFECT) and re:IsActiveType(TYPE_MONSTER)   
end 
function c87490445.disop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	if c:GetFlagEffect(87490445)<2 and Duel.IsChainDisablable(ev) and c:CheckRemoveOverlayCard(tp,1,REASON_EFFECT) and Duel.SelectYesNo(tp,aux.Stringid(87490445,0)) then 
		Duel.Hint(HINT_CARD,0,87490445) 
		c:RegisterFlagEffect(87490445,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1) 
		c:RemoveOverlayCard(tp,1,1,REASON_EFFECT)
		Duel.NegateEffect(ev) 
		if c:IsRelateToEffect(e) then 
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetCode(EFFECT_EXTRA_ATTACK)
			e1:SetValue(1)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			c:RegisterEffect(e1)
		end 
	end 
end 



