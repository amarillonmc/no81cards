--深土之物 斜纹刃刺龙
local m=30013045
local cm=_G["c"..m]
function cm.initial_effect(c)
	c:EnableReviveLimit()
	--Effect 1
	--Effect 2  
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_POSITION)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_FLIP+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,m)
	e1:SetTarget(cm.sptg)
	c:RegisterEffect(e1)
	--Effect 3 
	local e12=Effect.CreateEffect(c)
	e12:SetCategory(CATEGORY_TOHAND+CATEGORY_GRAVE_ACTION)
	e12:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_FIELD)
	e12:SetRange(LOCATION_MZONE)
	e12:SetCode(EVENT_PHASE+PHASE_END)
	e12:SetCountLimit(1,m+100)
	e12:SetCondition(cm.thcon1)
	e12:SetCost(cm.thcost)
	e12:SetTarget(cm.thtg)
	e12:SetOperation(cm.thop)
	c:RegisterEffect(e12)
	local e32=Effect.CreateEffect(c)
	e32:SetCategory(CATEGORY_TOHAND+CATEGORY_GRAVE_ACTION)
	e32:SetType(EFFECT_TYPE_QUICK_O)
	e32:SetCode(EVENT_FREE_CHAIN)
	e32:SetRange(LOCATION_MZONE)
	e32:SetCountLimit(1,m+100)
	e32:SetCondition(cm.thcon2)
	e32:SetCost(cm.thcost)
	e32:SetTarget(cm.thtg)
	e32:SetOperation(cm.thop)
	c:RegisterEffect(e32)
end
--Effect 2
function cm.set(c,tp)
	return c:IsType(TYPE_FIELD) 
			or (Duel.GetLocationCount(tp,LOCATION_SZONE)>0
			and c:IsSSetable())
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not Duel.IsPlayerAffectedByEffect(tp,30013020)
		or Duel.IsExistingMatchingCard(cm.set,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil,tp) end
	if Duel.IsPlayerAffectedByEffect(tp,30013020) then
		e:SetOperation(cm.spop3)
		Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,g,1,0,0)
	else
		e:SetOperation(cm.spop)
		Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,g,1,0,0)
	end
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetCountLimit(1)
	e1:SetCondition(cm.spcon5)
	e1:SetOperation(cm.spop5)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function cm.spcon5(e,tp,eg,ep,ev,re,r,rp) 
	return  Duel.IsExistingMatchingCard(cm.set,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil,tp)
end
function cm.spop5(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,m)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local c=e:GetHandler()
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(cm.set),tp,LOCATION_GRAVE,LOCATION_GRAVE,1,1,nil,tp)
	if g:GetCount()>0 then
		local tc=g:GetFirst()
		if Duel.SSet(tp,tc)>0 and tc:IsSetCard(0x92c) then
			local b1=tc:IsType(TYPE_QUICKPLAY) or tc:IsType(TYPE_TRAP)
			if b1 then
				if tc:IsType(TYPE_QUICKPLAY) then
					local e1=Effect.CreateEffect(c)
					e1:SetType(EFFECT_TYPE_SINGLE)
					e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
					e1:SetCode(EFFECT_QP_ACT_IN_SET_TURN)
					e1:SetReset(RESET_EVENT+RESETS_STANDARD)
					tc:RegisterEffect(e1)
				else
					local e1=Effect.CreateEffect(c)
					e1:SetType(EFFECT_TYPE_SINGLE)
					e1:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
					e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
					e1:SetReset(RESET_EVENT+RESETS_STANDARD)
					tc:RegisterEffect(e1)
				end
			else
				local te=tc:GetActivateEffect()
				local se=te:Clone()
				local con_c=te:GetCondition()
				se:SetProperty(te:GetProperty(),EFFECT_FLAG2_COF)
				se:SetCode(EVENT_CHAIN_END)
				se:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)
					if Duel.GetCurrentChain()~=0 or not e:GetHandler():IsLocation(LOCATION_SZONE) then return false end
					return not con_c or con_c(e,tp,eg,ep,ev,re,r,rp)
				end)
				se:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
				tc:RegisterEffect(se)
			end
		end
	end
	if e:GetHandler():IsCanTurnSet() and Duel.SelectYesNo(tp,aux.Stringid(m,2)) then	
		Duel.ChangePosition(e:GetHandler(),POS_FACEDOWN_DEFENSE)
	end 
end
function cm.spop3(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(cm.set),tp,LOCATION_GRAVE,LOCATION_GRAVE,1,1,nil,tp)
	local c=e:GetHandler()
	if g:GetCount()>0 then
		local c=e:GetHandler()
		local tc=g:GetFirst()
		if Duel.SSet(tp,tc)>0 and tc:IsSetCard(0x92c) then
			local b1=tc:IsType(TYPE_QUICKPLAY) or tc:IsType(TYPE_TRAP)
			if b1 then
				if tc:IsType(TYPE_QUICKPLAY) then
					local e1=Effect.CreateEffect(c)
					e1:SetType(EFFECT_TYPE_SINGLE)
					e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
					e1:SetCode(EFFECT_QP_ACT_IN_SET_TURN)
					e1:SetReset(RESET_EVENT+RESETS_STANDARD)
					tc:RegisterEffect(e1)
				else
					local e1=Effect.CreateEffect(c)
					e1:SetType(EFFECT_TYPE_SINGLE)
					e1:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
					e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
					e1:SetReset(RESET_EVENT+RESETS_STANDARD)
					tc:RegisterEffect(e1)
				end
			else
				local te=tc:GetActivateEffect()
				local se=te:Clone()
				local con_c=te:GetCondition()
				se:SetProperty(te:GetProperty(),EFFECT_FLAG2_COF)
				se:SetCode(EVENT_CHAIN_END)
				se:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)
					if Duel.GetCurrentChain()~=0 or not e:GetHandler():IsLocation(LOCATION_SZONE) then return false end
					return not con_c or con_c(e,tp,eg,ep,ev,re,r,rp)
				end)
				se:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
				tc:RegisterEffect(se)
			end
		end
	end
	if c:IsCanTurnSet() and Duel.SelectYesNo(tp,aux.Stringid(m,2)) then 
		Duel.ChangePosition(c,POS_FACEDOWN_DEFENSE)
	end 
end
--Effect 3 
function cm.thcon1(e)
	local tsp=e:GetHandler():GetControler()
	return not Duel.IsPlayerAffectedByEffect(tsp,30013020)
end
function cm.thcon2(e)
	local tsp=e:GetHandler():GetControler()
	return Duel.IsPlayerAffectedByEffect(tsp,30013020)
end
function cm.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,e:GetHandler()) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end
function cm.th(c)
	return c:IsAbleToHand() and  c:IsSetCard(0x92c)
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.th,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(cm.th),tp,LOCATION_GRAVE,0,1,2,nil)
	if #g>0 then		
		Duel.HintSelection(g) 
		Duel.SendtoHand(g,nil,REASON_EFFECT)
	end
end
 

