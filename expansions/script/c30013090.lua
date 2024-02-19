--深土巨卵 残缺灵核
local m=30013090
local cm=_G["c"..m]
function cm.initial_effect(c)
	--Effect 1
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_FLIP+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,m)
	e1:SetTarget(cm.ttg)
	c:RegisterEffect(e1)
	--Effect 2  
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,0))
	e2:SetCategory(CATEGORY_HANDES+CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_DISCARD)
	e2:SetRange(LOCATION_HAND)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,m+m)
	e2:SetCondition(cm.con)
	e2:SetTarget(cm.tg)
	e2:SetOperation(cm.op)
	c:RegisterEffect(e2)
	--all
	if cm.tcounter==nil then
		cm.tcounter=true
		cm[0]=0
		cm[1]=0
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
		e2:SetCode(EVENT_PHASE_START+PHASE_DRAW)
		e2:SetOperation(cm.resetcount)
		Duel.RegisterEffect(e2,0)
		local e4=Effect.CreateEffect(c)
		e4:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
		e4:SetCode(EVENT_DISCARD)
		e4:SetOperation(cm.addcount)
		Duel.RegisterEffect(e4,0)
	end
end
--all
function cm.resetcount(e,tp,eg,ep,ev,re,r,rp)
	cm[0]=0
	cm[1]=0
end
function cm.addcount(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	while tc do
		if tc:IsPreviousLocation(LOCATION_HAND) and (tc:IsType(TYPE_FLIP) or tc:IsSetCard(0x92c)) then
			local p=tc:GetPreviousControler()
			cm[p]=cm[p]+1
			if tc:IsLocation(LOCATION_GRAVE+LOCATION_REMOVED) then 
				tc:RegisterFlagEffect(m+110,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
			end
		end
		tc=eg:GetNext()
	end
end
--e1--
function cm.ttg(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=not Duel.IsPlayerAffectedByEffect(tp,30013020)
	local b2=cm[tp]>0
	if chk==0 then return b1 or b2 end
	if Duel.IsPlayerAffectedByEffect(tp,30013020) then
		e:SetOperation(cm.ops)
		local ct=cm[tp]
		if cm[tp]>3 then ct=3 end
		Debug.Message(ct) 
		Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,ct)
	else
		e:SetOperation(cm.opx)
	end
end
function cm.ops(e,tp,eg,ep,ev,re,r,rp)
	local ct=cm[tp]
	if ct==0 then return end
	if cm[tp]>3 then ct=3 end
	Duel.Draw(tp,ct,REASON_EFFECT)
end
function cm.opx(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetCountLimit(1)
	e1:SetOperation(cm.ddrop)
	Duel.RegisterEffect(e1,tp)
end
function cm.ddrop(e,tp,eg,ep,ev,re,r,rp)
	local ct=cm[tp]
	if ct==0 then return end
	if cm[tp]>3 then ct=3 end
	Duel.Hint(HINT_CARD,0,m)
	Duel.Draw(tp,ct,REASON_EFFECT)
end
--e2--
function cm.cfilter(c,tp)
	return  c:IsReason(REASON_DISCARD)
		and c:IsPreviousControler(tp)
		and (c:IsType(TYPE_FLIP) or c:IsSetCard(0x92c))
end
function cm.tf(c)
	local b1=c:GetFlagEffect(m+110)>0
	local b2=c:IsType(TYPE_FLIP) 
	local b3=c:IsSetCard(0x92c)
	return c:IsFaceupEx() and b1 and (b2 or b3) and c:IsAbleToHand()
end
function cm.con(e,tp,eg,ep,ev,re,r,rp)
	return  eg:IsExists(cm.cfilter,1,nil,tp)
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local cchk=c:IsDiscardable(REASON_EFFECT) and c:IsLocation(LOCATION_HAND)
	local g=Duel.GetMatchingGroup(cm.tf,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,nil)
	if chk==0 then return cchk and #g>0 end
	Duel.SetOperationInfo(0,CATEGORY_HANDES,e:GetHandler(),1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE+LOCATION_REMOVED)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local cchk=c:IsDiscardable(REASON_EFFECT) and c:IsLocation(LOCATION_HAND)
	local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(cm.tf),tp,LOCATION_GRAVE+LOCATION_REMOVED,0,nil)
	if #g==0 or not cchk then return end
	if Duel.SendtoGrave(c,REASON_EFFECT+REASON_DISCARD)==0 or c:IsLocation(LOCATION_HAND) then return false end
	g=Duel.GetMatchingGroup(aux.NecroValleyFilter(cm.tf),tp,LOCATION_GRAVE+LOCATION_REMOVED,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local tag=g:Select(tp,1,2,nil)
	if #tag==0 then return false end
	Duel.HintSelection(tag)
	--local tc=tag:GetFirst()
	Duel.SendtoHand(tag,nil,REASON_EFFECT)
	Duel.ConfirmCards(1-tp,tag)
end