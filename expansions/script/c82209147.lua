--曙
local m=82209147
local cm=c82209147 
function cm.initial_effect(c)  
	--Activate  
	local e1=Effect.CreateEffect(c)  
	e1:SetCategory(CATEGORY_DRAW)  
	e1:SetType(EFFECT_TYPE_ACTIVATE)  
	e1:SetCode(EVENT_FREE_CHAIN)  
	e1:SetCondition(cm.condition)  
	e1:SetCost(cm.cost)  
	e1:SetTarget(cm.target)  
	e1:SetOperation(cm.activate)  
	c:RegisterEffect(e1)  
end  
function cm.cfilter(c)  
	return c:GetSummonLocation()==LOCATION_EXTRA  
end  
function cm.condition(e,tp,eg,ep,ev,re,r,rp)  
	return Duel.IsExistingMatchingCard(cm.cfilter,tp,0,LOCATION_MZONE,1,nil) and not Duel.IsExistingMatchingCard(nil,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,e:GetHandler()) 
end  
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return true end  
	Duel.PayLPCost(tp,math.floor(Duel.GetLP(tp)/2))  
end  
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=Duel.GetFieldGroupCount(tp,0,LOCATION_HAND+LOCATION_ONFIELD)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,ct) and Duel.IsPlayerCanDraw(1-tp,ct) end
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,ct)  
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,1-tp,ct)  
	if e:IsHasType(EFFECT_TYPE_ACTIVATE) then  
		Duel.SetChainLimit(aux.FALSE)  
	end  
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ct=Duel.GetFieldGroupCount(tp,0,LOCATION_HAND+LOCATION_ONFIELD)
	if Duel.IsPlayerCanDraw(tp,ct) then
		local ct2=Duel.Draw(tp,ct,REASON_EFFECT)
		if Duel.IsPlayerCanDraw(1-tp,ct2) then
			Duel.Draw(1-tp,ct2,REASON_EFFECT)
		end
	end
	if not e:IsHasType(EFFECT_TYPE_ACTIVATE) then return end  
	local e1=Effect.CreateEffect(c)  
	e1:SetType(EFFECT_TYPE_FIELD)  
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)  
	e1:SetCode(EFFECT_CANNOT_DRAW)  
	e1:SetTargetRange(1,0)  
	e1:SetReset(RESET_PHASE+PHASE_END)  
	Duel.RegisterEffect(e1,tp)  
	local e2=Effect.CreateEffect(c)  
	e2:SetType(EFFECT_TYPE_FIELD)  
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)  
	e2:SetCode(EFFECT_CANNOT_ACTIVATE)  
	e2:SetTargetRange(0,1)  
	e2:SetValue(cm.actlimit)  
	e2:SetReset(RESET_PHASE+PHASE_END)  
	Duel.RegisterEffect(e2,tp) 
end
function cm.aclimit(e,re,tp)  
	return re:GetHandler():IsOnField() or re:IsHasType(EFFECT_TYPE_ACTIVATE)  
end  
	