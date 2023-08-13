local cm,m,o=GetID()
cm.name = "永世国度"
cm.num={
	["M"]={},
	["S"]={},
	["T"]={}
}
cm.group={}
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_FIELD)
	e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,EFFECT_COUNT_CODE_CHAIN)
	e1:SetCost(cm.cost)
	e1:SetCondition(cm.con)
	e1:SetTarget(cm.tg)
	e1:SetOperation(cm.op)
	c:RegisterEffect(e1)
	if not cm.check then
		cm.check=true
		local ge1=Effect.GlobalEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINOUS)
		ge1:SetCode(EVENT_CHAINING)
		ge1:SetOperation(cm.opp)
		Duel.RegisterEffect(ge1,0)
	end
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not e:GetHandler():IsPublic() end
end
function cm.con(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer==1-tp
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,LOCATION_HAND,0,1,nil) end
	local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,LOCATION_HAND,0,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,tp,LOCATION_HAND)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,LOCATION_HAND,0,nil)
	if #g==0 then return false end
	if Duel.Remove(g,POS_FACEUP,REASON_EFFECT)>0 then
		table.insert(cm.group,g)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINOUS)
		e1:SetCode(EVENT_CHAINING)
		e1:SetCondition(cm.con1)
		e1:SetOperation(cm.op1)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
	end
end
function cm.con1(e,tp,eg,ep,ev,re,r,rp)
	local turn=Duel.GetTurnCount()
	if (not cm.num["M"][turn] or cm.num["M"][turn]~=turn) or (not cm.num["S"][turn] or cm.num["S"][turn]~=turn) or (not cm.num["T"][turn] or cm.num["T"][turn]~=turn) then return false end
	return rp==1-tp and e:GetHandler():IsLocation(LOCATION_REMOVED)
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsLocation(LOCATION_REMOVED) or Duel.GetLocationCount(tp,LOCATION_MZONE)==0 then return false end
	if Duel.SpecialSummon(c,e,0,tp,false,false,POS_FACEUP)>0 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetCode(EFFECT_SKIP_TURN)
		e1:SetTargetRange(0,1)
		e1:SetReset(RESET_PHASE+PHASE_END+RESET_OPPO_TURN)
		Duel.RegisterEffect(e1,tp)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e2:SetCode(EVENT_PHASE+PHASE_END)
		e2:SetOperation(cm.op2)
		e2:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e2,tp)	
	end
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tab=cm.group[#cm.group]
	if not cm.group[#cm.group] then return false end
	if c:GetLocation()==LOCATION_MZONE and c:IsFaceup() then
		Duel.SendtoHand(tab,tp,REASON_EFFECT)
	elseif c:IsLocation(LOCATION_REMOVED) then
		if Duel.SendtoDeck(tab,tp,2,REASON_EFFECT)>0 then
			Duel.Draw(tp,#tab,REASON_EFFECT)
		end
	else
		Duel.Hint(3,tp,HINTMSG_TODECK)
		local g=Duel.SelectMatchingCard(tp,Card.IsAbleToDeck,tp,0,LOCATION_DECK,1,#tab,nil)
		if #g>0 then
			Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
		end
	end
	table.remove(cm.group)
end
function cm.opp(e,tp,eg,ep,ev,re,r,rp)
	local turn,py,typ,ct=Duel.GetTurnCount(),re:GetHandlerPlayer(),re:GetActivateType(),nil
	if typ==0x1 then ct="M"
	elseif typ==0x2 then ct="S"
	elseif typ==0x3 then ct="T" end
	if not cm.num[ct][turn] then cm.num[ct][turn]=0 end
	cm.num[ct][turn]=cm.num[ct][turn]+1
end