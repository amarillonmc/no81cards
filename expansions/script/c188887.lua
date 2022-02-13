local m=188887
local cm=_G["c"..m]
cm.name="星魅真龙剑士-德里斯·弧梦"
function cm.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddFusionProcCodeFun(c,188874,aux.FilterBoolFunction(Card.IsFusionSetCard,0xca2),2,true,true)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetTarget(function(e,c)return c:IsSetCard(0xca2) and c:IsRace(RACE_WYRM)end)
	e1:SetValue(700)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetOperation(cm.eqop)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(m,1))
	e4:SetCategory(CATEGORY_REMOVE)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetRange(LOCATION_MZONE)
	e4:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e4:SetCountLimit(1,m)
	e4:SetTarget(cm.rmtg)
	e4:SetOperation(cm.rmop)
	c:RegisterEffect(e4)
end
function cm.eqfilter(c,tp)
	return (c:IsFaceup() or c:IsLocation(LOCATION_GRAVE)) and c:IsSetCard(0xca2) and c:CheckUniqueOnField(tp) and not c:IsForbidden()
end
function cm.fselect(g,ft)
	return g:FilterCount(Card.IsCode,nil,188874)>=#g-1 and #g<=ft
end
function cm.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(cm.eqfilter),tp,LOCATION_GRAVE+LOCATION_REMOVED,0,nil,tp)
	local ft=Duel.GetLocationCount(tp,LOCATION_SZONE)
	if c:IsFacedown() or not g:CheckSubGroup(cm.fselect,2,#g,ft) then return end
	if not Duel.SelectYesNo(tp,aux.Stringid(m,0)) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local sg=g:SelectSubGroup(tp,cm.fselect,false,2,#g,ft)
	for tc in aux.Next(sg) do
		if Duel.Equip(tp,tc,c) then
			local e1=Effect.CreateEffect(c)
			e1:SetProperty(EFFECT_FLAG_COPY_INHERIT+EFFECT_FLAG_OWNER_RELATE)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_EQUIP_LIMIT)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			e1:SetValue(function(e,c)return e:GetOwner()==c end)
			tc:RegisterEffect(e1)
		end
	end
end
function cm.rmtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_ONFIELD+LOCATION_GRAVE) and chkc:IsAbleToRemove() end
	local ct=e:GetHandler():GetEquipGroup():GetCount()
	if chk==0 then return Duel.IsExistingTarget(Card.IsAbleToRemove,tp,LOCATION_ONFIELD+LOCATION_GRAVE,LOCATION_ONFIELD+LOCATION_GRAVE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,Card.IsAbleToRemove,tp,LOCATION_ONFIELD+LOCATION_GRAVE,LOCATION_ONFIELD+LOCATION_GRAVE,1,ct,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,g:GetCount(),0,LOCATION_ONFIELD+LOCATION_GRAVE)
end
function cm.rmop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if g:GetCount()~=0 and Duel.Remove(g,POS_FACEUP,REASON_EFFECT)~=0 then
		local c=e:GetHandler()
		local sg=g:Filter(Card.IsLocation,nil,LOCATION_REMOVED)
		for tc in aux.Next(sg) do
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_FIELD)
			e1:SetCode(EFFECT_DISABLE)
			e1:SetTargetRange(LOCATION_ONFIELD,LOCATION_ONFIELD)
			e1:SetTarget(cm.distg1)
			e1:SetLabelObject(tc)
			e1:SetReset(RESET_PHASE+PHASE_END)
			Duel.RegisterEffect(e1,tp)
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e2:SetCode(EVENT_CHAIN_SOLVING)
			e2:SetCondition(cm.discon)
			e2:SetOperation(cm.disop)
			e2:SetLabelObject(tc)
			e2:SetReset(RESET_PHASE+PHASE_END)
			Duel.RegisterEffect(e2,tp)
			local e3=Effect.CreateEffect(c)
			e3:SetType(EFFECT_TYPE_FIELD)
			e3:SetCode(EFFECT_DISABLE_TRAPMONSTER)
			e3:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
			e3:SetTarget(cm.distg2)
			e3:SetLabelObject(tc)
			e3:SetReset(RESET_PHASE+PHASE_END)
			Duel.RegisterEffect(e3,tp)
		end
	end
end
function cm.distg1(e,c)
	local tc=e:GetLabelObject()
	if c:IsType(TYPE_SPELL+TYPE_TRAP) then
		return c:IsCode(tc:GetCode())
	else
		return c:IsCode(tc:GetCode()) and (c:IsType(TYPE_EFFECT) or c:GetOriginalType()&TYPE_EFFECT~=0)
	end
end
function cm.distg2(e,c)
	local tc=e:GetLabelObject()
	return c:IsCode(tc:GetCode())
end
function cm.discon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	return re:GetHandler():IsCode(tc:GetCode())
end
function cm.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateEffect(ev)
end
