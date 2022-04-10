local m=53799258
local cm=_G["c"..m]
cm.name="过度锻炼"
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_CUSTOM+m)
	e1:SetCost(cm.cost)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
	if not cm.global_check then
		cm.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_CHAIN_SOLVING)
		ge1:SetOperation(cm.record)
		Duel.RegisterEffect(ge1,0)
		local ge2=ge1:Clone()
		ge2:SetCode(EVENT_CHAIN_SOLVED)
		ge2:SetOperation(cm.count)
		Duel.RegisterEffect(ge2,0)
		local ge3=ge1:Clone()
		ge3:SetCode(EVENT_CHAIN_END)
		ge3:SetOperation(cm.reset)
		Duel.RegisterEffect(ge3,0)
	end
end
function cm.record(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsFaceup,0,LOCATION_MZONE,LOCATION_MZONE,nil)
	for tc in aux.Next(g) do
		tc:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD,0,1,tc:GetAttack())
	end
end
function cm.count(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(function(c)return c:GetFlagEffect(m)>0 end,0,LOCATION_MZONE,LOCATION_MZONE,nil)
	local ag=Group.CreateGroup()
	for tc in aux.Next(g) do
		if tc:GetFlagEffect(m+50)==0 then tc:RegisterFlagEffect(m+50,RESET_EVENT+RESETS_STANDARD+RESET_OVERLAY,0,1,tc:GetAttack()-tc:GetFlagEffectLabel(m)) else tc:SetFlagEffectLabel(m+50,tc:GetFlagEffectLabel(m+50)+tc:GetAttack()-tc:GetFlagEffectLabel(m)) end
		ag:AddCard(tc)
		tc:ResetFlagEffect(m)
	end
	ag:KeepAlive()
	cm[0]=ag
end
function cm.reset(e,tp,eg,ep,ev,re,r,rp)
	local g=cm[0]:Filter(function(c)return c:GetFlagEffect(m+50)>0 end,0,LOCATION_MZONE,LOCATION_MZONE,nil)
	local atk,tg=0,Group.CreateGroup()
	for tc in aux.Next(g) do
		if tc:GetFlagEffectLabel(m+50)>0 then
			atk=atk+tc:GetFlagEffectLabel(m+50)
			tc:ResetFlagEffect(m+50)
			tg:AddCard(tc)
		end
	end
	local ct=math.floor(atk/800)
	if ct>0 then Duel.RaiseEvent(tg,EVENT_CUSTOM+m,re,r,rp,ep,ct) end
	cm[0]=0
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		e:SetLabel(100)
		return true
	end
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() end
	if chk==0 then
		if e:GetLabel()~=100 then return false end
		e:SetLabel(0)
		return Duel.IsExistingTarget(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,e:GetHandler()) and eg:IsExists(function(c)return c:IsFaceup() and c:IsLocation(LOCATION_MZONE)end,1,nil)
	end
	local exc=nil
	if not e:GetHandler():IsStatus(STATUS_EFFECT_ENABLED) then exc=e:GetHandler() end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g1=Duel.SelectTarget(tp,aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,ev,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g1,g1:GetCount(),0,0)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if g:GetCount()>0 then
		Duel.Destroy(g,REASON_EFFECT)
	end
end
