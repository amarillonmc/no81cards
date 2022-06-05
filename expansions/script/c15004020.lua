local m=15004020
local cm=_G["c"..m]
cm.name="创造环境 厄尔庇斯"
function cm.initial_effect(c)
	aux.AddCodeList(c,15004030)
	aux.AddCodeList(c,15004032)
	aux.AddCodeList(c,15004034)
	aux.AddCodeList(c,15004036)
	aux.AddCodeList(c,15004028)
	c:EnableCounterPermit(0xf30)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,m+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
	--remove(记 录 )
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_CUSTOM+15004020)
	e2:SetRange(LOCATION_FZONE)
	e2:SetOperation(cm.ad1op)
	c:RegisterEffect(e2)
	--remove(实 行 )
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_ADJUST)
	e3:SetRange(LOCATION_FZONE)
	e3:SetOperation(cm.ad2op)
	e3:SetLabelObject(e2)
	c:RegisterEffect(e3)
	--act limit
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_CHAINING)
	e4:SetRange(LOCATION_FZONE)
	e4:SetOperation(cm.chainop)
	c:RegisterEffect(e4)
end
function cm.chainop(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	if re:IsHasType(EFFECT_TYPE_ACTIVATE) and rc:IsCode(15004030,15004032,15004034,15004036) then
		if e:GetHandler():IsCanRemoveCounter(tp,0xf30,2,REASON_EFFECT) and Duel.SelectYesNo(tp,aux.Stringid(m,3)) then
			if e:GetHandler():RemoveCounter(tp,0xf30,2,REASON_EFFECT) then
				Duel.SetChainLimit(cm.chainlm)
			end
		end
	end
end
function cm.chainlm(e,rp,tp)
	return tp==rp
end
function cm.filter(c)
	return c:IsSetCard(0x6f30) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,cm.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function cm.nodarkfilter(c)
	return c:IsType(TYPE_MONSTER) and (c:IsSetCard(0x6f30) or c:IsCode(15004028)) and not c:IsAttribute(ATTRIBUTE_DARK)
end
function cm.ad1op(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(cm.nodarkfilter,tp,LOCATION_MZONE,0,nil)
	if g:GetCount()==0 then
		local ag=Group.CreateGroup()
		ag:KeepAlive()
		e:SetLabelObject(ag)
		return
	end
	g:KeepAlive()
	e:SetLabelObject(g)
end
function cm.ad2op(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetLabelObject():GetLabelObject() then
		Duel.RaiseEvent(Group.FromCards(e:GetHandler()),EVENT_CUSTOM+15004020,e,0,0,0,0)
		return
	end
	local g=e:GetLabelObject():GetLabelObject()
	local ag=g:Filter(Card.IsAttribute,nil,ATTRIBUTE_DARK)
	if ag:GetCount()~=0 and Duel.Remove(ag,POS_FACEUP,REASON_EFFECT)~=0 then
		e:GetHandler():AddCounter(0xf30,1)
	end
	Duel.RaiseEvent(Group.FromCards(e:GetHandler()),EVENT_CUSTOM+15004020,e,0,0,0,0)
end