--坏兽的营销计划
function c11567831.initial_effect(c)
	c:EnableCounterPermit(0x37)
	c:SetCounterLimit(0x37,5)
	--Activate 
	local e1=Effect.CreateEffect(c) 
	e1:SetType(EFFECT_TYPE_ACTIVATE) 
	e1:SetCode(EVENT_FREE_CHAIN) 
	c:RegisterEffect(e1)  
	--add 
	local e2=Effect.CreateEffect(c) 
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS) 
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)  
	e2:SetRange(LOCATION_SZONE) 
	e2:SetOperation(c11567831.adop) 
	c:RegisterEffect(e2)	 
	--dis and draw 
	local e3=Effect.CreateEffect(c) 
	e3:SetCategory(CATEGORY_DRAW)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O) 
	e3:SetCode(EVENT_CONTROL_CHANGED) 
	e3:SetProperty(EFFECT_FLAG_DELAY) 
	e3:SetRange(LOCATION_SZONE)  
	e3:SetCost(c11567831.ddrcost) 
	e3:SetTarget(c11567831.ddrtg) 
	e3:SetOperation(c11567831.ddrop) 
	c:RegisterEffect(e3) 
end
function c11567831.adop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler()  
	local xg=eg:Filter(Card.IsSetCard,nil,0xd3) 
	local x=xg:GetCount() 
	if x>0 then
	c:AddCounter(0x37,x,true) 
	end 
	if xg:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(11567831,0)) then 
		local tc=xg:GetFirst() 
		while tc do  
		Duel.NegateRelatedChain(tc,RESET_TURN_SET)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD) 
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetValue(RESET_TURN_SET)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e2)
		tc=xg:GetNext() 
		end 
	end 
end 
function c11567831.ddrcost(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return e:GetHandler():IsCanRemoveCounter(tp,0x37,1,REASON_COST) end 
	e:GetHandler():RemoveCounter(tp,0x37,1,1,REASON_COST) 
end 
function c11567831.ddrtg(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end  
	Duel.SetTargetPlayer(tp)  
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,1,tp,1)  
end 
function c11567831.ckfil(c) 
	return c:IsFaceup() and c:IsSetCard(0xd3) and aux.NegateEffectMonsterFilter(c) 
end 
function c11567831.ddrop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler()   
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)  
end 











