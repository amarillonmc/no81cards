--传承之苍炎 神将艾克
function c75030029.initial_effect(c)
	--xyz summon
	c:EnableReviveLimit() 
	aux.AddXyzProcedure(c,nil,12,99,c75030029.ovfilter,nil,99,c75030029.xyzop)  
	--splimit
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e0) 
	local e0=Effect.CreateEffect(c) 
	e0:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS) 
	e0:SetCode(EVENT_SPSUMMON_SUCCESS) 
	e0:SetOperation(function(e,tp,eg,ep,ev,re,r,rp) 
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetTargetRange(1,0)
	e1:SetTarget(function(e,c)
	return c:IsCode(75030029) end)  
	Duel.RegisterEffect(e1,tp)
	end) 
	c:RegisterEffect(e0)
	--cannot target
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE) 
	e1:SetValue(aux.tgoval) 
	e1:SetCondition(function(e) 
	return e:GetHandler():GetOverlayCount()>0 end)
	c:RegisterEffect(e1) 
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_IMMUNE_EFFECT) 
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(function(e,te) 
	return e:GetOwnerPlayer()~=te:GetOwnerPlayer() and te:IsActiveType(TYPE_SPELL) end) 
	e1:SetCondition(function(e) 
	return e:GetHandler():GetOverlayCount()>0 end)
	c:RegisterEffect(e1) 
	--sb  
	local e2=Effect.CreateEffect(c) 
	e2:SetCategory(CATEGORY_DISABLE)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_PHASE+PHASE_BATTLE_START) 
	e2:SetRange(LOCATION_MZONE) 
	e2:SetCountLimit(1)
	e2:SetTarget(c75030029.negtg)
	e2:SetOperation(c75030029.negop)
	c:RegisterEffect(e2)
	--
	local e3=Effect.CreateEffect(c)  
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_BATTLE_START) 
	e3:SetCost(function(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST) end)   
	e3:SetTarget(c75030029.bttg)
	e3:SetOperation(c75030029.btop)
	c:RegisterEffect(e3)
	if not c75030029.global_check then
		c75030029.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_DAMAGE_STEP_END)
		ge1:SetOperation(c75030029.checkop)
		Duel.RegisterEffect(ge1,0) 
	end
end
function c75030029.ovfilter(c)
	return c:IsFaceup() and c:IsCode(75030004) 
end 
function c75030029.xyzop(e,tp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,75030029)~=0 end 
end
function c75030029.checkop(e,tp,eg,ep,ev,re,r,rp)
	local a,b=Duel.GetBattleMonster(0) 
	local g=Group.FromCards(a,b) 
	if a and b and g:IsExists(Card.IsCode,1,nil,75030004) and g:IsExists(Card.IsCode,1,nil,75030023) and a:IsOnField() and a:IsRelateToBattle() and b:IsOnField() and b:IsRelateToBattle() then 
		Duel.RegisterFlagEffect(0,75030029,0,0,0)  
		Duel.RegisterFlagEffect(1,75030029,0,0,0)  
	end   
end  
function c75030029.negtg(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return Duel.IsExistingMatchingCard(aux.NegateAnyFilter,tp,0,LOCATION_ONFIELD,1,nil) end  
	local g=Duel.GetMatchingGroup(aux.NegateAnyFilter,tp,0,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,g,g:GetCount(),0,0)
end
function c75030029.negop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(aux.NegateAnyFilter,tp,0,LOCATION_ONFIELD,nil)
	if g:GetCount()>0 then 
		local tc=g:GetFirst() 
		while tc do 
		Duel.NegateRelatedChain(tc,RESET_TURN_SET)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_DISABLE) 
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_BATTLE)  
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
		tc=g:GetNext() 
		end 
	end
end
function c75030029.bttg(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return true end 
end   
function c75030029.btop(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler() 
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_PRE_BATTLE_DAMAGE)
	e2:SetCondition(c75030029.damcon)
	e2:SetOperation(c75030029.damop) 
	e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_DAMAGE_CAL) 
	c:RegisterEffect(e2) 
end 
function c75030029.damcon(e,tp,eg,ep,ev,re,r,rp) 
	return ep~=tp  
end
function c75030029.damop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ChangeBattleDamage(ep,ev*2) 
	Duel.Recover(tp,ev*2,REASON_EFFECT)  
end 
