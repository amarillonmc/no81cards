--魔 骸 囚 牢
local m=22348303
local cm=_G["c"..m]
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--dd
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(22348303,0))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1)
	e2:SetTarget(c22348303.ddtg)
	e2:SetOperation(c22348303.ddop)
	c:RegisterEffect(e2)
	--play fieldspell
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(22348303,1))
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1,22349303)
	e3:SetCost(c22348303.afcost)
	e3:SetTarget(c22348303.target)
	e3:SetOperation(c22348303.activate)
	c:RegisterEffect(e3)
	--set
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_IGNITION)
	e0:SetRange(LOCATION_GRAVE)
	e0:SetCountLimit(1,22348303)
	e0:SetCost(c22348303.setcost)
	e0:SetTarget(c22348303.settg)
	e0:SetOperation(c22348303.setop)
	c:RegisterEffect(e0)
	--Destroy
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e4:SetRange(LOCATION_ONFIELD)
	e4:SetCode(EVENT_LEAVE_FIELD)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetCondition(c22348303.descon2)
	e4:SetOperation(c22348303.desop2)
	c:RegisterEffect(e4)
	--Destroy
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	e5:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e5:SetCode(EVENT_LEAVE_FIELD_P)
	e5:SetOperation(c22348303.checkop)
	c:RegisterEffect(e5)
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	e6:SetCode(EVENT_LEAVE_FIELD)
	e6:SetOperation(c22348303.desop)
	e6:SetLabelObject(e5)
	c:RegisterEffect(e6)
	
end
function c22348303.checkop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsDisabled() then
		e:SetLabel(1)
	else e:SetLabel(0) end
end
function c22348303.desop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetLabelObject():GetLabel()~=0 then return end
	local g=e:GetHandler():GetCardTarget()
	local tg=g:Filter(Card.IsLocation,nil,LOCATION_ONFIELD)
	if tg:GetCount()>0 then
		Duel.Destroy(tg,REASON_EFFECT)
	end
end
function c22348303.descon2(e,tp,eg,ep,ev,re,r,rp)
	local tg=e:GetHandler():GetCardTarget()
	local gc=Group.__band(eg,tg)
	return gc:GetCount()>0
end
function c22348303.desop2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Destroy(e:GetHandler(),REASON_EFFECT)
end

function c22348303.ddtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_ONFIELD,0,1,c) end
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_ONFIELD,0,c)
end
function c22348303.ddop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SELECT)
	local g=Duel.SelectMatchingCard(tp,aux.TRUE,tp,LOCATION_ONFIELD,0,1,1,c)
	local tc=g:GetFirst()
	if c:IsRelateToEffect(e) and tc then
		c:SetCardTarget(tc)
	end
end
function c22348303.afcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST)
end
function c22348303.filter(c)
	return c:IsSetCard(0x70a6) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c22348303.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c22348303.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c22348303.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c22348303.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c22348303.costfilter(c)
	return c:IsType(TYPE_MONSTER)
end
function c22348303.setcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,c22348303.costfilter,1,nil,tp) end
	local g=Duel.SelectReleaseGroup(tp,c22348303.costfilter,1,1,nil,tp)
	Duel.Release(g,REASON_COST)
end
function c22348303.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsSSetable() end
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,e:GetHandler(),1,0,0)
end
function c22348303.setop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SSet(tp,c)
	end
end

