--五月的蝇
local m=33701368
local cm=_G["c"..m]
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(cm.condition)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
	if not cm.global_check then
		cm.global_check=true
		cm[0]=0
		cm[1]=0
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_SPSUMMON_SUCCESS)
		ge1:SetOperation(cm.checkop)
		Duel.RegisterEffect(ge1,0)
		local ge3=Effect.CreateEffect(c)
		ge3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge3:SetCode(EVENT_PHASE_START+PHASE_DRAW)
		ge3:SetOperation(cm.clear)
		Duel.RegisterEffect(ge3,0)
	end
	
end
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	return cm[1-tp]>(math.floor(Duel.GetFieldGroupCount(tp,LOCATION_EXTRA,0)/2)) and Duel.GetFieldGroupCount(tp,LOCATION_EXTRA,0)>=5
end
function cm.filter(c,tp)
	return c:IsLocation(LOCATION_MZONE) and c:IsPreviousLocation(LOCATION_EXTRA) and c:IsSummonPlayer(1-tp)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetFieldGroup(tp,0,LOCATION_EXTRA)
	local ct=g:GetCount()-Duel.GetFieldGroupCount(tp,LOCATION_EXTRA,0)
	if chk==0 then return eg:IsExists(cm.filter,1,nil,tp) and Duel.IsPlayerCanSendtoGrave(1-tp) and ct>0 and g:IsExists(Card.IsAbleToGrave,1,nil,1-tp,REASON_RULE) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,ct,0,0)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.SetLP(1-tp,math.floor(Duel.GetLP(1-tp)/2))
	if not Duel.IsPlayerCanSendtoGrave(1-tp) then return end
	local g=Duel.GetFieldGroup(tp,0,LOCATION_EXTRA)
	local ct=g:GetCount()-Duel.GetFieldGroupCount(tp,LOCATION_EXTRA,0)
	if ct>0 then
		Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_TOGRAVE)
		local sg=g:FilterSelect(1-tp,Card.IsAbleToGrave,ct,ct,nil,1-tp,REASON_RULE)
		Duel.SendtoGrave(sg,REASON_RULE)
	end
end
function cm.checkop(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	while tc do
		if tc:IsLocation(LOCATION_MZONE) and tc:IsPreviousLocation(LOCATION_EXTRA) then
			cm[tc:GetSummonPlayer()]=cm[tc:GetSummonPlayer()]+1
		end
		tc=eg:GetNext()
	end
end
function cm.clear(e,tp,eg,ep,ev,re,r,rp)
	cm[0]=0
	cm[1]=0
end
