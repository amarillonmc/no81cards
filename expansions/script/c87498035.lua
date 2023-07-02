--肃清之器 梅西亚
function c87498035.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFun2(c,aux.FilterBoolFunction(Card.IsFusionType,TYPE_FUSION),aux.FilterBoolFunction(Card.IsRace,RACE_WARRIOR),true) 
	--to hand 
	local e1=Effect.CreateEffect(c)  
	e1:SetCategory(CATEGORY_TOHAND) 
	e1:SetType(EFFECT_TYPE_QUICK_O) 
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER) 
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET) 
	e1:SetRange(LOCATION_MZONE) 
	e1:SetCountLimit(1,87498035) 
	e1:SetTarget(c87498035.thtg) 
	e1:SetOperation(c87498035.thop) 
	c:RegisterEffect(e1) 
	if not c87498035.global_check then
		c87498035.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_DESTROYED) 
		ge1:SetOperation(c87498035.checkop)
		Duel.RegisterEffect(ge1,0) 
	end 
end 
function c87498035.checkop(e,tp,eg,ep,ev,re,r,rp) 
	local g=eg:Filter(Card.IsType,nil,TYPE_MONSTER) 
	if g:GetCount()<=0 then return end 
	local tc=g:GetFirst()
	while tc do 
		local flag=Duel.GetFlagEffectLabel(0,87498035) 
		if flag==nil then 
			Duel.RegisterFlagEffect(0,87498035,0,0,1,1) 
		else 
			Duel.SetFlagEffectLabel(0,87498035,flag+1) 
		end 
		tc=g:GetNext()
	end
end
function c87498035.thtg(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return Duel.IsExistingTarget(Card.IsAbleToHand,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end 
	local g=Duel.SelectTarget(tp,Card.IsAbleToHand,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil) 
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,g:GetCount(),0,0) 
end  
function c87498035.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	local tc=Duel.GetFirstTarget() 
	if tc:IsRelateToEffect(e) then 
		Duel.SendtoHand(tc,nil,REASON_EFFECT) 
		if Duel.GetTurnPlayer()==1-tp and c:IsRelateToEffect(e) then  
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_FIELD)
			e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE) 
			e1:SetRange(LOCATION_MZONE) 
			e1:SetTargetRange(0,LOCATION_MZONE)
			e1:SetValue(function(e,c) 
			return c==e:GetHandler() end) 
			e1:SetCondition(function(e) 
			return Duel.GetTurnPlayer()==tp end)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,2) 
			c:RegisterEffect(e1) 
			local e2=Effect.CreateEffect(c) 
			e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
			e2:SetCode(EVENT_BATTLED)  
			e2:SetCondition(c87498035.calcon)
			e2:SetOperation(c87498035.calop) 
			e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,2) 
			c:RegisterEffect(e2)  
		end   
	end 
end 
function c87498035.calcon(e,tp,eg,ep,ev,re,r,rp)
	local flag=Duel.GetFlagEffectLabel(0,87498035) 
	local bc=e:GetHandler():GetBattleTarget()
	return Duel.GetTurnPlayer()==tp and bc and bc:IsLocation(LOCATION_MZONE) and flag and flag>0 and e:GetHandler():GetFlagEffect(87498035)==0 
end 
function c87498035.calop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	local flag=Duel.GetFlagEffectLabel(0,87498035) 
	local bc=e:GetHandler():GetBattleTarget() 
	if bc and bc:IsLocation(LOCATION_MZONE) and flag and flag>0 then 
		Duel.Hint(hint_c,0,87498035)   
		local dam1=Duel.GetBattleDamage(tp) 
		local dam2=Duel.GetBattleDamage(1-tp) 
		for i=1,flag do 
			Duel.Damage(tp,dam1,REASON_BATTLE) 
			Duel.Damage(1-tp,dam2,REASON_BATTLE) 
		end 
	end  
end 







