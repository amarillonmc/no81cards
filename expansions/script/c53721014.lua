local m=53721014
local cm=_G["c"..m]
cm.name="囚于悚牢的咏唱"
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCountLimit(1,m+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(cm.condition)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,1))
	e2:SetCategory(CATEGORY_TODECK)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(cm.tdtg)
	e2:SetOperation(cm.tdop)
	c:RegisterEffect(e2)
	if not cm.global_check then
		cm.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_TO_GRAVE)
		ge1:SetOperation(cm.checkop)
		Duel.RegisterEffect(ge1,0)
		local ge2=ge1:Clone()
		ge2:SetCode(EVENT_CHAINING)
		ge2:SetLabelObject(ge1)
		ge2:SetOperation(cm.reset)
		Duel.RegisterEffect(ge2,0)
	end
end
function cm.checkop(e,tp,eg,ep,ev,re,r,rp)
	for tc in aux.Next(eg) do
		if tc:IsAttribute(ATTRIBUTE_WATER) and tc:IsReason(REASON_COST) and re:IsActivated() and re:IsActiveType(TYPE_MONSTER) and re:GetHandler():IsAttribute(ATTRIBUTE_WATER) then
			Duel.RegisterFlagEffect(0,m,0,0,0)
			e:SetLabelObject(re)
		end
	end
end
function cm.reset(e,tp,eg,ep,ev,re,r,rp)
	local ace=e:GetLabelObject():GetLabelObject()
	if ace and re~=ace then Duel.ResetFlagEffect(0,m) end
end
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	local res=false
	for i=1,ev-1 do
		local tgp=Duel.GetChainInfo(i,CHAININFO_TRIGGERING_PLAYER)
		if tgp~=tp and Duel.IsChainDisablable(i) then res=true end
	end
	local attr=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_ATTRIBUTE)
	return res and re:IsActiveType(TYPE_MONSTER) and attr&ATTRIBUTE_WATER>0 and Duel.GetFlagEffect(0,m)>0
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_CHAIN_SOLVING)
	e1:SetCondition(cm.negcon)
	e1:SetOperation(cm.negop)
	e1:SetReset(RESET_CHAIN)
	Duel.RegisterEffect(e1,tp)
end
function cm.negcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsChainDisablable(ev) and ep~=tp
end
function cm.negop(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.SelectYesNo(tp,aux.Stringid(m,0)) then return end
	Duel.Hint(HINT_CARD,0,m)
	local rc=re:GetHandler()
	if Duel.NegateEffect(ev) then Duel.Remove(rc,POS_FACEUP,REASON_EFFECT) end
	e:Reset()
end
function cm.tdfilter(c)
	return c:IsRace(RACE_FISH) and c:IsAbleToDeck()
end
function cm.tdtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and cm.tdfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(cm.tdfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,cm.tdfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
end
function cm.tdop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then Duel.SendtoDeck(tc,nil,0,REASON_EFFECT) end
end
