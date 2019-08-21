--大魔神 恐惧之王迪亚波罗
if not pcall(function() require("expansions/script/c10121001") end) then require("script/c10121001") end
local m=10121007
local cm=_G["c"..m]
function cm.initial_effect(c)
	c:EnableReviveLimit()
	rsdio.XyzEffect(c,4)
	--material
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(cm.macon)
	e1:SetTarget(cm.matg)
	e1:SetOperation(cm.maop)
	c:RegisterEffect(e1)
	--disable 
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e2:SetCode(EVENT_CHAIN_SOLVING)
	e2:SetOperation(cm.disop)
	local e3=e2:Clone()
	e3:SetType(EFFECT_TYPE_XMATERIAL+EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	c:RegisterEffect(e3)
	e2:SetRange(LOCATION_MZONE)
	c:RegisterEffect(e2)
end
function cm.mafilter(c,tp)
	return (c:IsControler(tp) or c:IsType(TYPE_SPELL+TYPE_TRAP) or c:IsAbleToChangeControler()) and not c:IsType(TYPE_TOKEN)
end
function cm.matg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsOnField() and chkc~=c and cm.mafilter(chkc,tp) end
	if chk==0 then return c:IsType(TYPE_XYZ) and Duel.IsExistingTarget(cm.mafilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,c) and Duel.GetFieldGroupCount(tp,LOCATION_GRAVE,LOCATION_GRAVE)>0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,cm.mafilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,c)
end
function cm.maop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	local g=Duel.GetFieldGroup(tp,LOCATION_GRAVE,LOCATION_GRAVE)
	if tc:IsRelateToEffect(e) then
	   g:AddCard(tc)
	end
	if c:IsRelateToEffect(e) and g:GetCount()>0 then
	   local sg,sg2=Group.CreateGroup(),Group.CreateGroup()
	   for tc in aux.Next(g) do
		   if not tc:IsImmuneToEffect(e) then
			  local og=tc:GetOverlayGroup()
			  sg2:Merge(og)
			  sg:AddCard(tc)
		   end
	   end
	   if sg2:GetCount()>0 then Duel.SendtoGrave(sg2,REASON_RULE) end
	   if sg:GetCount()>0 then Duel.Overlay(c,sg) end
	end
end
function cm.macon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ)
end
function cm.disop(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetHandler():GetOverlayGroup()
	if ep~=tp and g:GetCount()>0 and g:IsExists(Card.IsCode,1,nil,re:GetHandler():GetCode()) then
	   Duel.NegateEffect(ev)
	end
end
