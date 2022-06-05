local m=53796011
local cm=_G["c"..m]
cm.name="实在太舒服了吧！"
if not pcall(function() require("expansions/script/c10199990") end) then require("script/c10199990") end
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_LIMIT_ZONE)
	e1:SetValue(cm.zones)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
end
function cm.zones(e,tp,eg,ep,ev,re,r,rp)
	local zone=0xff
	local g=Duel.GetMatchingGroup(cm.filter,tp,LOCATION_MZONE,LOCATION_MZONE,nil,tp):Filter(Card.IsCanBeEffectTarget,nil,e)
	local tc=g:GetFirst()
	if #g==1 and tc:IsControler(tp) then zone=zone-(1<<tc:GetSequence()) end
	return zone
end
function cm.filter(c,tp)
	local s,p=c:GetSequence(),c:GetControler()
	return c:IsFaceup() and s<5 and Duel.CheckLocation(p,LOCATION_SZONE,s) and (p==tp or Duel.IsExistingMatchingCard(cm.eqfilter,1-p,LOCATION_DECK+LOCATION_HAND,0,1,nil))
end
function cm.eqfilter(c)
	return c:IsType(TYPE_MONSTER) and not c:IsForbidden()
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and cm.filter(chkc,tp) end
	if chk==0 then return Duel.IsExistingTarget(cm.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,cm.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,tp)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local c,tc=e:GetHandler(),Duel.GetFirstTarget()
	local s,p=tc:GetSequence(),tc:GetControler()
	if not tc:IsRelateToEffect(e) or not Duel.CheckLocation(p,LOCATION_SZONE,s) then return end
	Duel.Hint(HINT_SELECTMSG,1-p,HINTMSG_EQUIP)
	local ec=Duel.SelectMatchingCard(1-p,cm.eqfilter,1-p,LOCATION_DECK+LOCATION_HAND,0,1,1,nil):GetFirst()
	if not ec then return end
	rsop.MoveToField(ec,p,p,LOCATION_SZONE,POS_FACEUP,true,1<<s)
	if not ec:IsLocation(LOCATION_SZONE) or not Duel.Equip(p,ec,tc) then return end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_EQUIP_LIMIT)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	e1:SetValue(function(e,c)return c==e:GetLabelObject()end)
	e1:SetLabelObject(tc)
	ec:RegisterEffect(e1)
	local e2=Effect.CreateEffect(ec)
	e2:SetType(EFFECT_TYPE_EQUIP)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetValue(1000)
	e2:SetReset(RESET_EVENT+RESETS_STANDARD)
	ec:RegisterEffect(e2)
	local e3=Effect.CreateEffect(ec)
	e3:SetType(EFFECT_TYPE_EQUIP)
	e3:SetCode(EFFECT_DISABLE)
	e3:SetReset(RESET_EVENT+RESETS_STANDARD)
	ec:RegisterEffect(e3)
end
