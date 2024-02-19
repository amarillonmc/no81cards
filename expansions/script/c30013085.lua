--于深土之中复苏 
local m=30013085
local cm=_G["c"..m]
function cm.initial_effect(c)
	--Effect 1
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,m)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
	--Effect 2  
	local e12=Effect.CreateEffect(c)
	e12:SetCategory(CATEGORY_DRAW+CATEGORY_HANDES)
	e12:SetType(EFFECT_TYPE_IGNITION)
	e12:SetRange(LOCATION_GRAVE)
	e12:SetCountLimit(1,m+m)
	e12:SetCondition(cm.con)
	e12:SetCost(cm.cost)
	e12:SetTarget(cm.drtg)
	e12:SetOperation(cm.drop)
	c:RegisterEffect(e12)
	local e32=e12:Clone()
	e32:SetType(EFFECT_TYPE_QUICK_O)
	e32:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e32:SetCode(EVENT_FREE_CHAIN)
	e32:SetCondition(cm.ccon)
	c:RegisterEffect(e32)
end
--Effect 1
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsExistingMatchingCard(Card.IsFaceup,tp,LOCATION_MZONE,0,1,nil)
end
function cm.mset(c)
	return c:IsMSetable(true,nil)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(cm.mset,tp,LOCATION_HAND,0,nil)
	if chk==0 then return #g>0 end
	Duel.SetOperationInfo(0,CATEGORY_SUMMON,nil,1,0,0)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local sg=Duel.GetMatchingGroup(cm.mset,tp,LOCATION_HAND,0,nil)
	if #sg==0 then return end 
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
	local tc=sg:Select(tp,1,1,nil):GetFirst()
	if tc==nil or not tc:IsMSetable(true,nil) then return false end 
	if tc:IsLocation(LOCATION_HAND) and cm.mset(tc) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_MSET)
		e1:SetReset(RESET_PHASE+PHASE_END)
		e1:SetCondition(cm.limcon)
		e1:SetOperation(cm.limop)
		e1:SetLabelObject(tc)
		Duel.RegisterEffect(e1,tp)
		Duel.MSet(tp,tc,true,nil)
	end
end
function cm.hf(c)
	local b1=c:IsType(TYPE_FLIP)
	local b2=c:IsSetCard(0x92c)
	return (b1 or b2) and c:IsDiscardable(REASON_EFFECT)
end
function cm.limcon(e,tp,eg,ep,ev,re,r,rp)
	return #eg==1 and eg:GetFirst()==e:GetLabelObject()
end
function cm.limop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=eg:GetFirst()
	local hg=Duel.GetMatchingGroup(cm.hf,tp,LOCATION_HAND,0,nil)
	if #hg>0 and tc:IsPosition(POS_FACEDOWN_DEFENSE) and Duel.SelectYesNo(tp,aux.Stringid(m,1)) then
		Duel.BreakEffect()
		if Duel.DiscardHand(tp,cm.hf,1,1,REASON_EFFECT+REASON_DISCARD)==0 then return false end
		Duel.Hint(HINT_CARD,0,m)
		local pos=Duel.SelectPosition(tp,tc,POS_FACEUP_ATTACK+POS_FACEUP_DEFENSE)
		Duel.ChangePosition(tc,pos)
	end
	e:Reset()
end
--Effect 2
function cm.con(e)
	local tsp=e:GetHandler():GetControler()
	return not Duel.IsPlayerAffectedByEffect(tsp,30013020) and aux.exccon(e) 
end
function cm.ccon(e)
	local tsp=e:GetHandler():GetControler()
	return Duel.IsPlayerAffectedByEffect(tsp,30013020) and aux.exccon(e) 
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToDeckAsCost() end
	Duel.SendtoDeck(c,nil,SEQ_DECKSHUFFLE,REASON_COST)
end
function cm.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1)
		and Duel.IsExistingMatchingCard(cm.hf,tp,LOCATION_HAND,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function cm.drop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.DiscardHand(tp,cm.hf,1,1,REASON_EFFECT+REASON_DISCARD,nil)~=0 then
		Duel.Draw(tp,1,REASON_EFFECT)
	end
end

