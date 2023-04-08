--绘舞华·绯梦之樱术使 RK7
--21.06.23
local cm,m=GetID()
function cm.initial_effect(c)
	aux.AddCodeList(c,11451583)
	--xyz summon
	aux.AddXyzProcedure(c,nil,7,2)
	c:EnableReviveLimit()
	--effect1
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_QUICK_F)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_CAL+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_EVENT_PLAYER)
	e1:SetCode(EVENT_CHAINING)
	e1:SetValue(11451480)
	e1:SetCondition(cm.condition)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.operation)
	c:RegisterEffect(e1)
	--effect2
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,1))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetCondition(cm.con)
	e2:SetTarget(cm.tg)
	e2:SetOperation(cm.op)
	c:RegisterEffect(e2)
end
cm.rkdn={11451579}
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	return not re:GetHandler():IsSetCard(0x97f) and re:GetValue()~=11451480
end
function cm.filter(c,re)
	return c:IsCanOverlay() and c:IsRelateToEffect(re)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetFlagEffect(m)==0 end
	e:GetHandler():RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD+RESET_CHAIN,0,1)
	local op=0
	local rc=re:GetHandler()
	local b1=e:GetHandler():IsType(TYPE_XYZ) and rc:IsCanOverlay() and rc:IsRelateToEffect(re)
	local b2=e:GetHandler():GetOverlayGroup():IsExists(Card.IsAbleToDeck,1,nil)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(m,4))
	if b1 and b2 then
		op=Duel.SelectOption(tp,aux.Stringid(m,2),aux.Stringid(m,3))+1
	elseif b1 then
		op=Duel.SelectOption(tp,aux.Stringid(m,2))+1
	elseif b2 then
		op=Duel.SelectOption(tp,aux.Stringid(m,3))+2
	end
	e:SetLabel(op)
end
function cm.matfilter(c,re,e)
	return c:IsRelateToEffect(re) and not c:IsImmuneToEffect(e)
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if e:GetLabel()==1 then
		local rc=re:GetHandler()
		if rc:IsImmuneToEffect(e) or not rc:IsRelateToEffect(re) or not c:IsRelateToEffect(e) then return end
		rc:CancelToGrave()
		local og=rc:GetOverlayGroup()
		if #og>0 then Duel.SendtoGrave(og,REASON_RULE) end
		Duel.Overlay(c,rc)
	elseif e:GetLabel()==2 then
		local g=c:GetOverlayGroup():Filter(Card.IsAbleToDeck,nil)
		if not c:IsRelateToEffect(e) or #g==0 then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local tc=g:Select(tp,1,1,nil):GetFirst()
		if Duel.SendtoDeck(tc,nil,0,REASON_EFFECT)>0 then
			local g=Group.CreateGroup()
			Duel.ChangeTargetCard(ev,g)
			Duel.ChangeChainOperation(ev,cm.repop)
		end
	end
end
function cm.repop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetDescription(aux.Stringid(m,5))
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_CHAIN_SOLVING)
	--e1:SetProperty(EFFECT_FLAG_CLIENT_HINT+EFFECT_FLAG_PLAYER_TARGET)
	--e1:SetTargetRange(0,1)
	e1:SetCountLimit(1)
	e1:SetCondition(cm.discon)
	e1:SetOperation(cm.disop)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function cm.discon(e,tp,eg,ep,ev,re,r,rp)
	local loc,p=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION,CHAININFO_TRIGGERING_CONTROLER)
	return loc&LOCATION_ONFIELD>0 and p~=tp
end
function cm.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateEffect(ev)
	e:SetProperty(0)
	e:Reset()
end
function cm.filter3(c,tp)
	return c:IsCode(11451583) and c:IsAbleToHand()
end
function cm.con(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetOverlayCount()>=3
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.filter3,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,tp) end
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(cm.filter3),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end