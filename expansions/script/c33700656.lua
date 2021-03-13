if not pcall(function() require("expansions/script/c33700650") end) then require("script/c33700650") end
--破天神狐 ～异世界少女的日常被理不尽的祈愿撕裂之卷
local m=33700656
local cm=_G["c"..m]
cm.named_with_ptsh=true
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,m)
	e1:SetCost(cm.cost)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.operation)
	c:RegisterEffect(e1)
	--to deck
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TODECK)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,m)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(cm.target1)
	e2:SetOperation(cm.operation1)
	c:RegisterEffect(e2)
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,1000) end
	Duel.PayLPCost(tp,1000)
end
function cm.filter(c)
	return sr_ptsh.check_set_ptsh(c) and c:IsType(TYPE_MONSTER)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_DECK,0,1,nil) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 end
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<1 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local g=Duel.SelectMatchingCard(tp,cm.filter,tp,LOCATION_DECK,0,1,1,nil)
	local tc=g:GetFirst()
	while tc do
		Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEDOWN,true)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetCode(EFFECT_CHANGE_TYPE)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
		e1:SetValue(TYPE_TRAP+TYPE_CONTINUOUS)
		tc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_REMOVE_TYPE)
		e2:SetValue(TYPE_MONSTER+TYPE_EFFECT)
		tc:RegisterEffect(e2)
		local e11=Effect.CreateEffect(e:GetHandler())
		e11:SetType(EFFECT_TYPE_FIELD)
		e11:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e11:SetCode(EFFECT_CANNOT_ACTIVATE)
		e11:SetTargetRange(1,0)
		e11:SetValue(cm.aclimit)
		e11:SetLabel(tc:GetCode())
		e11:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e11,tp)
		tc=g:GetNext()
	end
end
function cm.aclimit(e,re,tp)
	return re:GetHandler():IsCode(e:GetLabel())
end
function cm.tdfilter(c,tp)
	return sr_ptsh.check_set_ptsh(c) and c:IsFaceup() and (c:IsLocation(LOCATION_SZONE) or Duel.GetLocationCount(tp,LOCATION_SZONE)>0 )
end
function cm.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.tdfilter,tp,LOCATION_ONFIELD,0,1,e:GetHandler(),tp) and Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_ONFIELD)
end
function cm.operation1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(cm.tdfilter,tp,LOCATION_ONFIELD,0,nil)
	local tg=Duel.GetMatchingGroup(cm.filter,tp,LOCATION_DECK,0,nil)
	local tt=0
	local st=tg:Filter(aux.dncheck,nil)
	local ct=g:Filter(Card.IsLocation,nil,LOCATION_SZONE)
	local gt=Duel.GetLocationCount(tp,LOCATION_SZONE)
	tt=math.min(st,ct+gt)
	if tt==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local mg=g:Select(tp,1,tt,c)
	if mg:GetCount()==0 then return end
	Duel.SendtoDeck(mg,nil,2,REASON_EFFECT)
	local pg=Duel.GetOperatedGroup():IsLocation(LOCATION_DECK)
	if pg:GetCount()==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local g=Duel.SelectMatchingCard(tp,cm.filter,tp,LOCATION_DECK,0,pg:GetCount(),pg:GetCount(),nil)
	local tc=g:GetFirst()
	while tc do
		Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEDOWN,true)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetCode(EFFECT_CHANGE_TYPE)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
		e1:SetValue(TYPE_TRAP+TYPE_CONTINUOUS)
		tc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_REMOVE_TYPE)
		e2:SetValue(TYPE_MONSTER+TYPE_EFFECT)
		tc:RegisterEffect(e2)
		tc=g:GetNext()
	end
end
