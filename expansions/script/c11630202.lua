--重装运输机
local m=11630202
local cm=_G["c"..m]
function c11630202.initial_effect(c)
	--link summon
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,cm.lkcheck,2,2)  
	--equip
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,0))
	e2:SetCategory(CATEGORY_EQUIP)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,m)
	e2:SetTarget(cm.eqtg)
	e2:SetOperation(cm.eqop)
	c:RegisterEffect(e2)  
end
--
function cm.lkcheck(c)
	return c:IsType(TYPE_MONSTER) and c:IsType(TYPE_EFFECT) and c:IsRace(RACE_MACHINE) 
end
--
function cm.tgfilter(c,tp)
	return c:IsFaceup() and c:IsType(TYPE_MONSTER) and c:IsAttackAbove(2500) and c:IsRace(RACE_MACHINE) and c:GetEquipCount()<1 and Duel.IsExistingMatchingCard(cm.eqfilter,tp,LOCATION_DECK,0,1,nil,tp,c)
end
function cm.eqfilter(c,tp,ec)
	return c:IsType(TYPE_EQUIP) and c:CheckUniqueOnField(tp) and not c:IsForbidden() --and c:CheckEquipTarget(ec)
end
function cm.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and cm.tgfilter(chkc,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingTarget(cm.tgfilter,tp,LOCATION_MZONE,0,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	Duel.SelectTarget(tp,cm.tgfilter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,nil,1,tp,LOCATION_DECK)
end
function cm.eqop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
		local g=Duel.SelectMatchingCard(tp,cm.eqfilter,tp,LOCATION_DECK,0,1,1,nil,tp,tc)
		local ec=g:GetFirst()
		if ec then
			if not Duel.Equip(tp,ec,tc) then return end
			--equip limit
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_EQUIP_LIMIT)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetLabelObject(tc)
			e1:SetValue(cm.eqlimit)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			ec:RegisterEffect(e1)
		end
	end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetValue(cm.actlimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function cm.eqlimit(e,c)
	return c==e:GetLabelObject()
end
function cm.actlimit(e,re,rp)
	local ex=re:IsHasCategory(CATEGORY_EQUIP)
	return ex
end