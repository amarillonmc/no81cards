--正义之大天使 泰瑞尔
if not pcall(function() require("expansions/script/c10121001") end) then require("script/c10121001") end
local m=10121015
local cm=_G["c"..m]
function cm.initial_effect(c)
	c:EnableReviveLimit()
	rsdio.XyzEffect(c,3)
	--material
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCost(cm.macost)
	e1:SetTarget(cm.matg)
	e1:SetOperation(cm.maop)
	c:RegisterEffect(e1)
	--activate cost
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_ACTIVATE_COST)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetTargetRange(0,1)
	e2:SetCost(cm.costchk)
	e2:SetOperation(cm.costop)
	local e3=e2:Clone()
	e3:SetType(EFFECT_TYPE_XMATERIAL+EFFECT_TYPE_FIELD)
	c:RegisterEffect(e3)
	e2:SetRange(LOCATION_MZONE)
	c:RegisterEffect(e2)
	--accumulate
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(0x10000000+m)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetTargetRange(0,1)
	local e5=e4:Clone()
	e5:SetType(EFFECT_TYPE_XMATERIAL+EFFECT_TYPE_FIELD)
	c:RegisterEffect(e5)
	e4:SetRange(LOCATION_MZONE)
	c:RegisterEffect(e4)
end
function cm.costchk(e,te_or_c,tp)
	local ct=Duel.GetFlagEffect(tp,m)
	local mct=Duel.GetOverlayCount(e:GetHandlerPlayer(),1,0)
	return Duel.CheckLPCost(tp,mct*100*ct)
end
function cm.costop(e,tp,eg,ep,ev,re,r,rp)
	local mct=Duel.GetOverlayCount(e:GetHandlerPlayer(),1,0)
	Duel.PayLPCost(tp,mct*100)
end
function cm.macost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function cm.matg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,0,LOCATION_EXTRA)>0 and e:GetHandler():IsType(TYPE_XYZ) end
end
function cm.maop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetFieldGroup(tp,0,LOCATION_EXTRA)
	if g:GetCount()<=0 or not c:IsType(TYPE_XYZ) or not c:IsRelateToEffect(e) then return end
	Duel.ConfirmCards(tp,g)
	Duel.Hint(HINT_SELECTMSG,tp,rshint.xyz)
	local mg=g:Select(tp,1,1,nil)
	g:Remove(Card.IsCode,nil,mg:GetFirst():GetCode())
	if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(m,1)) then
	   local mg2=g:Select(tp,1,1,nil)
	   mg:Merge(mg2)
	end
	Duel.Overlay(c,mg)
end


