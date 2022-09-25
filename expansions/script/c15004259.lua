local m=15004259
local cm=_G["c"..m]
cm.name="古代的机械混沌奇忆巨人"
function cm.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,10,3)
	c:EnableReviveLimit()
	--spsummon limit
	local e0=Effect.CreateEffect(c)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	e0:SetValue(aux.xyzlimit)
	c:RegisterEffect(e0)
	--lv change
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_XYZ_LEVEL)
	e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetTarget(cm.lvtg)
	e1:SetValue(cm.lvval)
	c:RegisterEffect(e1)
	--negate
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL+EFFECT_FLAG_CARD_TARGET)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,15004259)
	e2:SetCondition(cm.discon)
	e2:SetTarget(cm.distg)
	e2:SetOperation(cm.disop)
	c:RegisterEffect(e2)
	--search
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetCountLimit(1,15004260)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCost(cm.cost)
	e3:SetTarget(cm.target)
	e3:SetOperation(cm.operation)
	c:RegisterEffect(e3)
	--send replace
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EFFECT_SEND_REPLACE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTarget(cm.rtg)
	e4:SetValue(cm.rval)
	c:RegisterEffect(e4)
end
cm.name_beyond_Non_Vemoisit={51788412}
function cm.lvtg(e,c)
	return c:IsLevelAbove(1) and c:IsSetCard(0x5f31)
end
function cm.lvval(e,c,rc)
	local lv=c:GetLevel()
	if rc==e:GetHandler() then return 10
	else return lv end
end
function cm.discon(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and Duel.IsChainNegatable(ev)
		and re:IsHasType(EFFECT_TYPE_ACTIVATE)
end
function cm.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chkc then return chkc:IsOnField() and chkc:IsControler(tp) end
	if chk==0 then return Duel.IsExistingTarget(aux.TRUE,tp,LOCATION_ONFIELD,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,aux.TRUE,tp,LOCATION_ONFIELD,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function cm.disop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		if Duel.Destroy(eg,REASON_EFFECT)~=0 then
			Duel.BreakEffect()
			if tc:IsRelateToEffect(e) then
				Duel.Destroy(tc,REASON_EFFECT)
			end
		end
	end
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(100)
	return true
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if e:GetLabel()~=100 then return false end
		e:SetLabel(0)
		local ct=e:GetHandler():GetOverlayCount()
		local g=Duel.GetMatchingGroup(cm.th2filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,nil)
		return ct>1 and g:GetCount()>0
	end
	local ct=e:GetHandler():GetOverlayCount()
	local ct2=e:GetHandler():RemoveOverlayCard(tp,ct,ct,REASON_COST)
	Duel.SetTargetParam(ct2)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function cm.th2filter(c)
	return (c:IsSetCard(0x5f31) or c:IsSetCard(0x7)) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.GetChainInfo(0,CHAININFO_TARGET_PARAM)-1
	local g=Duel.GetMatchingGroup(cm.th2filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,nil)
	if ct>0 and g:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=g:SelectSubGroup(tp,aux.dncheck,false,1,ct)
		if sg:GetCount()>0 then
			Duel.SendtoHand(sg,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,sg)
		end
	end
end
function cm.rtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local tp=c:GetControler()
	if chk==0 then return bit.band(r,REASON_EFFECT)~=0 and c:IsLocation(LOCATION_MZONE) and c:IsFaceup() and re and re:GetHandler()~=e:GetHandler() and c:IsAbleToHand() and eg:IsContains(c) and re:GetHandler():IsSetCard(0x5f31) end
	if aux.TRUE then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetValue(LOCATION_HAND)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e1)
		c:RegisterFlagEffect(15004259,RESET_EVENT+0x1de0000+RESET_PHASE+PHASE_END,0,1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
		e2:SetCode(EVENT_TO_HAND)
		e2:SetCountLimit(1)
		e2:SetCondition(cm.thcon)
		e2:SetOperation(cm.thop)
		e2:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e2,tp)
		return true
	else return false end
end
function cm.rval(e,c)
	return false
end
function cm.thfilter(c)
	return c:GetFlagEffect(15004259)~=0
end
function cm.thcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(cm.thfilter,1,nil)
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(cm.thfilter,nil)
	Duel.ConfirmCards(1-tp,g)
	Duel.ShuffleHand(tp)
end