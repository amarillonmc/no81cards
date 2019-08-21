--天使长 智慧之马赛尔
if not pcall(function() require("expansions/script/c10121001") end) then require("script/c10121001") end
local m=10121014
local cm=_G["c"..m]
function cm.initial_effect(c)
	rsdio.XyzEffect(c,2)
	c:EnableReviveLimit()
	--material
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCountLimit(1)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(cm.macon)
	e1:SetCost(cm.macost)
	e1:SetOperation(cm.maop)
	c:RegisterEffect(e1)
	--activate cost
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_XYZ_LEVEL)
	e2:SetProperty(EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(cm.lvtg)
	e2:SetValue(cm.lvval)
	local e3=e2:Clone()
	e3:SetType(EFFECT_TYPE_XMATERIAL+EFFECT_TYPE_FIELD)
	c:RegisterEffect(e3)
	e2:SetRange(LOCATION_MZONE)
	c:RegisterEffect(e2)
end
function cm.lvtg(e,c)
	return c:IsType(TYPE_XYZ) and c:GetRank()==10
end
function cm.lvval(e,c,rc)
	return 10
end
function cm.macost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function cm.macon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)>=6 and e:GetHandler():IsType(TYPE_XYZ)
end
function cm.maop(e,tp,eg,ep,ev,re,r,rp)
	local hg=Duel.GetFieldGroup(tp,0,LOCATION_HAND)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or not c:IsType(TYPE_XYZ) or hg:GetCount()<=5 then return end 
	Duel.Hint(HINT_SELECTMSG,tp,rshint.xyz)
	local g=hg:Select(1-tp,hg:GetCount()-5,hg:GetCount()-5,nil)
	if g:GetCount()>0 then
	   Duel.Overlay(c,g)
	end
end
