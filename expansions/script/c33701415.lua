--残存的思念
local m=33701415
local cm=_G["c"..m]
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_END_PHASE+TIMING_DESTROY)
	e1:SetCondition(cm.condition)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
	if not cm.global_check then
		cm.global_check=true
		cm[0]=0
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_DESTROY)
		ge1:SetOperation(cm.checkop)
		Duel.RegisterEffect(ge1,0)
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge2:SetCode(EVENT_PHASE_START+PHASE_DRAW)
		ge2:SetOperation(cm.clear)
		Duel.RegisterEffect(ge2,0)
	end
	
end
function cm.checkop(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	while tc do
		if bit.band(r,REASON_BATTLE+REASON_EFFECT)~=0 then
			local destroyed=cm[0]
			local destroyed=destroyed+1
			cm[0]=destroyed
			if cm[destroyed]==nil then table.insert(cm,tc:GetOriginalCode())
			else cm[destroyed]=tc:GetOriginalCode() end
		end
		tc=eg:GetNext()
	end
end
function cm.clear(e,tp,eg,ep,ev,re,r,rp)
	local i=0
	local destroyed=cm[0]
	while i<=destroyed do
		cm[i]=0
		i=i+1
	end
end
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	return cm[0]>0
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CODE)
	local ac=Duel.AnnounceCard(tp)
	Duel.SetTargetParam(ac)
	Duel.SetOperationInfo(0,CATEGORY_ANNOUNCE,nil,0,tp,0)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ac=Duel.GetChainInfo(0,CHAININFO_TARGET_PARAM)
	local i=1
	local destroyed=cm[0]
	while i<=destroyed do
		if cm[i]==ac then
			e:SetLabel(ac)
			c:SetHint(CHINT_CARD,ac)
			--tohand
			local e2=Effect.CreateEffect(c)
			e2:SetDescription(aux.Stringid(m,0))
			e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
			e2:SetType(EFFECT_TYPE_QUICK_O)
			e2:SetCode(EVENT_FREE_CHAIN)
			e2:SetRange(LOCATION_SZONE)
			e2:SetCountLimit(1)
			e2:SetLabelObject(e1)
			e2:SetTarget(cm.thtg)
			e2:SetOperation(cm.thop)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD)
			c:RegisterEffect(e2)
			local e3=Effect.CreateEffect(c)
			e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
			e3:SetCode(EVENT_TO_HAND)
			e3:SetRange(LOCATION_SZONE)
			e3:SetCondition(cm.drcon1)
			e3:SetOperation(cm.drop1)
			e3:SetReset(RESET_EVENT+RESETS_STANDARD)
			c:RegisterEffect(e3)
			break
		end
		i=i+1
	end
end
function cm.thfilter(c,code)
	return c:IsCode(code) and c:IsAbleToHand()
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetLabelObject() and e:GetLabelObject():GetLabel() and Duel.IsExistingMatchingCard(aux.NecroValleyFilter(cm.thfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,e:GetLabelObject():GetLabel()) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(cm.thfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,e:GetLabelObject():GetLabel())
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function cm.cfilter(c,tp,code)
	return c:IsControler(tp) and not c:IsCode(code) and 
end
function cm.drcon1(e,tp,eg,ep,ev,re,r,rp)
	local code=0
	local ct=0
	if e:GetLabelObject() and e:GetLabelObject():GetLabel() then
		code=e:GetLabelObject():GetLabel()
	end
	if code~=0 then ct=eg:FilterCount(cm.cfilter,nil,tp,code)
	else return false end
	e:SetLabel(ct)
	return ct>0
		and (not re:IsHasType(EFFECT_TYPE_ACTIONS) or re:IsHasType(EFFECT_TYPE_CONTINUOUS))
end
function cm.drop1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,m)
	Duel.SetLP(tp,Duel.GetLP(tp)-2000*e:GetLabel())
end
