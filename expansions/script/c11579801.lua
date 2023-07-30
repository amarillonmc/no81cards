--终极猎手
function c11579801.initial_effect(c)
	--link summon
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,c11579801.matfilter,2) 
	--xx
	local e1=Effect.CreateEffect(c) 
	e1:SetDescription(aux.Stringid(11579801,1)) 
	e1:SetCategory(CATEGORY_REMOVE+CATEGORY_DISABLE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O) 
	e1:SetCode(EVENT_SPSUMMON_SUCCESS) 
	e1:SetProperty(EFFECT_FLAG_DELAY) 
	e1:SetCountLimit(1,11579801)
	e1:SetCondition(function(e) 
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK) end) 
	e1:SetTarget(c11579801.xxtg1) 
	e1:SetOperation(c11579801.xxop1) 
	c:RegisterEffect(e1) 
	local e1=Effect.CreateEffect(c) 
	e1:SetDescription(aux.Stringid(11579801,2)) 
	e1:SetCategory(CATEGORY_REMOVE+CATEGORY_DISABLE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O) 
	e1:SetCode(EVENT_SPSUMMON_SUCCESS) 
	e1:SetProperty(EFFECT_FLAG_DELAY) 
	e1:SetCountLimit(1,11579801)
	e1:SetCondition(function(e) 
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK) end) 
	e1:SetTarget(c11579801.xxtg2) 
	e1:SetOperation(c11579801.xxop2) 
	c:RegisterEffect(e1) 
	--multi attack
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_EXTRA_ATTACK_MONSTER)
	e2:SetValue(3)
	c:RegisterEffect(e2) 
	--actlimit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(EFFECT_CANNOT_ACTIVATE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(0,1)
	e2:SetValue(1)
	e2:SetCondition(function(e)
	return Duel.GetAttacker()==e:GetHandler() or Duel.GetAttackTarget()==e:GetHandler() end)
	c:RegisterEffect(e2) 
	--battle remove
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetCode(EFFECT_BATTLE_DESTROY_REDIRECT)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(LOCATION_REMOVED)
	c:RegisterEffect(e2)
end
function c11579801.matfilter(c)
	return c:IsSummonLocation(LOCATION_EXTRA)
end
function c11579801.xxtg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(function(c) return c:IsFaceup() and c:GetAttack()>0 end,tp,0,LOCATION_MZONE,1,nil) end  
end 
function c11579801.xxop1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	for i=1,4 do 
		local g=Duel.GetMatchingGroup(function(c) return c:IsFaceup() and c:GetAttack()>0 end,tp,0,LOCATION_MZONE,nil) 
		if g:GetCount()>0 then  
			local tc=g:RandomSelect(tp,1):GetFirst() 
			local pratk=tc:GetAttack()
			local e1=Effect.CreateEffect(c) 
			e1:SetType(EFFECT_TYPE_SINGLE) 
			e1:SetCode(EFFECT_UPDATE_ATTACK) 
			e1:SetRange(LOCATION_MZONE) 
			e1:SetValue(-1300) 
			e1:SetReset(RESET_EVENT+RESETS_STANDARD) 
			tc:RegisterEffect(e1)  
			if pratk~=0 and tc:GetAttack()==0 then 
				local e1=Effect.CreateEffect(e:GetHandler())
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
				e1:SetCode(EFFECT_DISABLE)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
				tc:RegisterEffect(e1)
				local e2=Effect.CreateEffect(e:GetHandler())
				e2:SetType(EFFECT_TYPE_SINGLE)
				e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
				e2:SetCode(EFFECT_DISABLE_EFFECT)
				e2:SetValue(RESET_TURN_SET)
				e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
				tc:RegisterEffect(e2)
				Duel.AdjustInstantly()
				Duel.NegateRelatedChain(tc,RESET_TURN_SET)
				Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)   
			end  
		end 
	end 
end  
function c11579801.xxtg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(function(c) return c:IsFaceup() and c:GetAttack()>0 end,tp,0,LOCATION_MZONE,1,nil) end  
end 
function c11579801.xxop2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	for i=1,2 do 
		local g=Duel.GetMatchingGroup(function(c) return c:IsFaceup() and c:GetAttack()>0 end,tp,0,LOCATION_MZONE,nil) 
		if g:GetCount()>0 then  
			local tc=g:RandomSelect(tp,1):GetFirst() 
			local pratk=tc:GetAttack()
			local e1=Effect.CreateEffect(c) 
			e1:SetType(EFFECT_TYPE_SINGLE) 
			e1:SetCode(EFFECT_UPDATE_ATTACK) 
			e1:SetRange(LOCATION_MZONE) 
			e1:SetValue(-5000) 
			e1:SetReset(RESET_EVENT+RESETS_STANDARD) 
			tc:RegisterEffect(e1)  
			if pratk~=0 and tc:GetAttack()==0 then 
				local e1=Effect.CreateEffect(e:GetHandler())
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
				e1:SetCode(EFFECT_DISABLE)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
				tc:RegisterEffect(e1)
				local e2=Effect.CreateEffect(e:GetHandler())
				e2:SetType(EFFECT_TYPE_SINGLE)
				e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
				e2:SetCode(EFFECT_DISABLE_EFFECT)
				e2:SetValue(RESET_TURN_SET)
				e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
				tc:RegisterEffect(e2)
				Duel.AdjustInstantly()
				Duel.NegateRelatedChain(tc,RESET_TURN_SET)
				Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)   
			end  
		end 
	end 
	if c:IsRelateToEffect(e) then 
		local e1=Effect.CreateEffect(c)  
		e1:SetType(EFFECT_TYPE_SINGLE) 
		e1:SetCode(EFFECT_CANNOT_ATTACK) 
		e1:SetRange(LOCATION_MZONE) 
		if Duel.GetTurnPlayer()==tp and (Duel.GetCurrentPhase()>=PHASE_BATTLE_START and Duel.GetCurrentPhase()<=PHASE_BATTLE) then 
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_BATTLE+RESET_SELF_TURN,2)
		else 
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_BATTLE+RESET_SELF_TURN)
		end 
		c:RegisterEffect(e1) 
	end 
end  






