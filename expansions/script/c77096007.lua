--伊丽莎白·巴托里 万圣节
function c77096007.initial_effect(c)
	aux.AddCodeList(c,77096005) 
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcCodeFun(c,77096005,aux.FilterBoolFunction(Card.IsLevel,7),1,true,true)
	--activate cost
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_ACTIVATE_COST)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(0,1)
	e1:SetCost(c77096007.costchk)
	e1:SetOperation(c77096007.costop)
	c:RegisterEffect(e1)
	--accumulate
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(0x10000000+77096007)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetTargetRange(0,1)
	c:RegisterEffect(e2)	 
	--atk 
	local e2=Effect.CreateEffect(c) 
	e2:SetCategory(CATEGORY_DICE+CATEGORY_ATKCHANGE+CATEGORY_DAMAGE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O) 
	e2:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
	e2:SetCountLimit(1,77096007)
	e2:SetCondition(c77096007.atkcon)
	e2:SetOperation(c77096007.atkop)
	c:RegisterEffect(e2)
end 
c77096007.toss_dice=true 
function c77096007.costchk(e,te_or_c,tp)
	local ct=Duel.GetFlagEffect(tp,77096007)
	return Duel.CheckLPCost(tp,ct*500)
end
function c77096007.costop(e,tp,eg,ep,ev,re,r,rp)
	Duel.PayLPCost(tp,500)
end
function c77096007.atkcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	return c:IsRelateToBattle() and bc and bc:IsFaceup() and bc:IsRelateToBattle() 
end
function c77096007.filter(c)
	return c:IsFaceup() and c:IsType(TYPE_PENDULUM)
end
function c77096007.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_COIN)
	local coin=Duel.AnnounceCoin(tp)
	local res=Duel.TossCoin(tp,1)
	if coin~=res then
		if c:IsRelateToEffect(e) then 
			local e1=Effect.CreateEffect(c) 
			e1:SetType(EFFECT_TYPE_SINGLE) 
			e1:SetCode(EFFECT_SET_ATTACK_FINAL) 
			e1:SetRange(LOCATION_MZONE) 
			e1:SetValue(c:GetAttack()*2) 
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END) 
			c:RegisterEffect(e1)  
			local e1=Effect.CreateEffect(c) 
			e1:SetType(EFFECT_TYPE_SINGLE) 
			e1:SetCode(EFFECT_SET_DEFENSE_FINAL) 
			e1:SetRange(LOCATION_MZONE) 
			e1:SetValue(c:GetDefense()*2) 
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END) 
			c:RegisterEffect(e1)   
			Duel.BreakEffect() 
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS) 
			e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
			e1:SetCountLimit(1) 
			e1:SetLabel(0) 
			e1:SetCondition(c77096007.xxcon)
			e1:SetOperation(c77096007.xxop) 
			Duel.RegisterEffect(e1,tp)
		end   
	end 
end
function c77096007.xxcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==1-tp
end
function c77096007.xxop(e,tp,eg,ep,ev,re,r,rp)   
	local ct=e:GetLabel()
	e:GetHandler():SetTurnCounter(ct+1) 
	Duel.Damage(1-tp,300,REASON_EFFECT) 
	if ct==10 then 
		e:Reset() 
	else 
		e:SetLabel(ct+1)  
	end 
end







