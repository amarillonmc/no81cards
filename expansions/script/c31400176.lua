local m=31400176
local cm=_G["c"..m]
cm.name="星尘龙星群"
function cm.initial_effect(c)
	aux.AddCodeList(c,44508094)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,0))
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_QP_ACT_IN_NTPHAND)
	e2:SetCondition(cm.handcon)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCountLimit(1,m)
	e3:SetCost(cm.thcost)
	e3:SetTarget(cm.thtg)
	e3:SetOperation(cm.thop)
	c:RegisterEffect(e3)
	if not cm.global_check then
		cm.global_check=true
		local ge1=Effect.GlobalEffect()
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_RELEASE)
		ge1:SetOperation(cm.rel_checkop)
		Duel.RegisterEffect(ge1,0)
		cm[0]=0
		cm[1]=0
		cm[2]=0
		cm[3]=0
		cm[4]=0
		local ge2=Effect.GlobalEffect()
		ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge2:SetCode(EVENT_ADJUST)
		ge2:SetOperation(cm.col_checkop)
		Duel.RegisterEffect(ge2,0)
		local ge3=Effect.GlobalEffect()
		ge3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge3:SetCode(EVENT_PHASE+PHASE_END)
		ge3:SetOperation(cm.col_resetop)
		ge3:SetCountLimit(1)
		Duel.RegisterEffect(ge3,1)
	end
end
function cm.rel_checkop(e,tp,eg,ep,ev,re,r,rp)
	if not re then return end
	if Duel.GetFlagEffect(0,m)==0 and r&REASON_COST>0 and eg:IsContains(re:GetHandler()) then
		Duel.RegisterFlagEffect(0,m,RESET_PHASE+PHASE_END,0,1)
	end
end
function cm.handcon(e)
	return Duel.GetFlagEffect(0,m)~=0
end
function cm.col_checkop(e,tp,eg,ep,ev,re,r,rp)
	local sdg=Duel.GetFieldGroup(0,LOCATION_ONFIELD,LOCATION_ONFIELD):Filter(Card.IsSetCard,nil,0xa3)
	if #sdg==0 then return end
	local tc=sdg:GetFirst()
	while tc do
		if not tc:IsLocation(LOCATION_FZONE) then
			cm[aux.GetColumn(tc)]=1
		end
		tc=sdg:GetNext()
	end
end
function cm.col_resetop(e,tp,eg,ep,ev,re,r,rp)
	cm[0]=0
	cm[1]=0
	cm[2]=0
	cm[3]=0
	cm[4]=0
end
function cm.filter(c)
	return not c:IsLocation(LOCATION_FZONE) and cm[aux.GetColumn(c)]==1
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=Duel.GetMatchingGroup(cm.filter,tp,0,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function cm.zone_check(c,i,zone)
	return c:IsLocation(zone) and aux.GetColumn(c)==i
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(cm.filter,tp,0,LOCATION_ONFIELD,nil)
	local val=0
	for i=0,4 do
		if cm[i]==1 then
			if not g:IsExists(cm.zone_check,1,nil,i,LOCATION_MZONE) then
				val=val|aux.SequenceToGlobal(1-tp,LOCATION_MZONE,math.abs(i+4*tp-4))
			end
			if not g:IsExists(cm.zone_check,1,nil,i,LOCATION_SZONE) then
				val=val|aux.SequenceToGlobal(1-tp,LOCATION_SZONE,math.abs(i+4*tp-4))
			end
		end
	end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_DISABLE_FIELD)
	e1:SetValue(val)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	Duel.Destroy(g,REASON_EFFECT)
end
function cm.thcfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToGraveAsCost() and aux.IsCodeListed(c,44508094)
end
function cm.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.thcfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,cm.thcfilter,tp,LOCATION_DECK,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToHand() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,c,1,0,0)
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SendtoHand(c,nil,REASON_EFFECT)
	end
end