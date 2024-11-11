--勇者 伊丽莎白·巴托里
function c77032549.initial_effect(c)
	--Synchro summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(nil),1)
	c:EnableReviveLimit()
	--coin 
	local e1=Effect.CreateEffect(c) 
	e1:SetCategory(CATEGORY_COIN) 
	e1:SetType(EFFECT_TYPE_IGNITION) 
	e1:SetRange(LOCATION_MZONE) 
	e1:SetCountLimit(1,77032549) 
	e1:SetCost(c77032549.cncost)  
	e1:SetTarget(c77032549.cntg) 
	e1:SetOperation(c77032549.cnop)  
	c:RegisterEffect(e1) 
	--damage 
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DAMAGE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_BATTLE_DAMAGE) 
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp end)  
	e2:SetTarget(c77032549.damtg)
	e2:SetOperation(c77032549.damop)
	c:RegisterEffect(e2)
end
c77032549.toss_coin=true 
function c77032549.cncost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,1000) end 
	Duel.PayLPCost(tp,1000) 
end 
function c77032549.cntg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end 
	Duel.SetOperationInfo(0,CATEGORY_COIN,nil,0,tp,1)   
end 
function c77032549.cnop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	local x=4 
	if not c:IsHasEffect(77096010) then  
	local x1,x2,x3=Duel.TossCoin(tp,3) 
	x=x1+x2+x3 
	end 
	if x==3 or c:IsHasEffect(77096010) then 
		local g=Duel.GetMatchingGroup(nil,tp,LOCATION_MZONE,0,nil) 
		local tc=g:GetFirst() 
		while tc do 
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e1:SetRange(LOCATION_MZONE)
		e1:SetCode(EFFECT_INDESTRUCTABLE_COUNT)
		e1:SetCountLimit(1)
		e1:SetValue(function(e,re,r,rp)
		return bit.band(r,REASON_BATTLE+REASON_EFFECT)~=0 end)  
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,2) 
		tc:RegisterEffect(e1)  
		tc=g:GetNext() 
		end 
	end  
	if x==2 or c:IsHasEffect(77096010) then 
		if c:IsRelateToEffect(e) then 
			local e1=Effect.CreateEffect(c) 
			e1:SetType(EFFECT_TYPE_SINGLE)  
			e1:SetCode(EFFECT_UPDATE_ATTACK) 
			e1:SetRange(LOCATION_MZONE) 
			e1:SetValue(1000) 
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,2) 
			c:RegisterEffect(e1)		
		end 
	end 
	if x==1 or c:IsHasEffect(77096010) then 
		Duel.Draw(tp,1,REASON_EFFECT)   
	end 
	if x==0 or c:IsHasEffect(77096010) then 
		local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,0,nil) 
		local tc=g:GetFirst() 
		while tc do 
			local e1=Effect.CreateEffect(c) 
			e1:SetType(EFFECT_TYPE_SINGLE)  
			e1:SetCode(EFFECT_UPDATE_ATTACK) 
			e1:SetRange(LOCATION_MZONE) 
			e1:SetValue(500) 
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,2) 
			tc:RegisterEffect(e1)  
		tc=g:GetNext() 
		end 
	end 
end 
function c77032549.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end 
	Duel.SetTargetPlayer(1-tp) 
	Duel.SetTargetParam(1000) 
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,tp,1000)  
end 
function c77032549.damop(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler() 
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM) 
	Duel.Damage(p,d,REASON_EFFECT) 
end 
