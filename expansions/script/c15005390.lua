local m=15005390
local cm=_G["c"..m]
cm.name="龙衣指引者·瓦拉克之翼"
function cm.initial_effect(c)
	aux.AddCodeList(c,15005403,15005397)
	--token
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_REMOVE+CATEGORY_TOKEN+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,m)
	e1:SetCost(cm.cost)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.operation)
	c:RegisterEffect(e1)
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,1))
	e2:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_REMOVED)
	e2:SetHintTiming(0,TIMING_MAIN_END)
	e2:SetCountLimit(1,m+1)
	e2:SetCondition(cm.srcon)
	e2:SetCost(cm.srcost)
	e2:SetTarget(cm.srtg)
	e2:SetOperation(cm.srop)
	c:RegisterEffect(e2)
	if not cm.global_check then
		cm.global_check=true
		local ge1=Effect.GlobalEffect()
		ge1:SetType(EFFECT_TYPE_FIELD)
		ge1:SetCode(EFFECT_TO_GRAVE_REDIRECT)
		ge1:SetTargetRange(0xff,0xff)
		ge1:SetTarget(aux.TargetBoolFunction(Card.IsOriginalCodeRule,m))
		ge1:SetValue(LOCATION_REMOVED)
		Duel.RegisterEffect(ge1,0)
	end
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not e:GetHandler():IsPublic() end
end
function cm.rmfilter(c,tp)
	return c:IsSetCard(0xaf3c) and c:IsAbleToRemove() and c:IsLevelAbove(1) and Duel.IsPlayerCanSpecialSummonMonster(tp,15005397,nil,TYPES_TOKEN_MONSTER,c:GetTextAttack(),c:GetTextDefense(),c:GetOriginalLevel(),RACE_DRAGON,c:GetOriginalAttribute()) and Duel.GetMZoneCount(tp,c)>0
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(cm.rmfilter,tp,LOCATION_HAND,0,1,nil,tp) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_HAND)
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local tc=Duel.SelectMatchingCard(tp,cm.rmfilter,tp,LOCATION_HAND,0,1,1,nil,tp):GetFirst()
	if tc and Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)~=0 then
		local tcid=tc:GetFieldID()
		tc:RegisterFlagEffect(15005390,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,tcid,aux.Stringid(15005390,7))
		if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
		if not Duel.IsPlayerCanSpecialSummonMonster(tp,15005397,nil,TYPES_TOKEN_MONSTER,tc:GetTextAttack(),tc:GetTextDefense(),tc:GetOriginalLevel(),RACE_DRAGON,tc:GetOriginalAttribute()) then return end
		local atk=tc:GetTextAttack()
		local def=tc:GetTextDefense()
		local lv=tc:GetOriginalLevel()
		local attr=tc:GetOriginalAttribute()
		local tkm=0
		if attr&ATTRIBUTE_LIGHT==ATTRIBUTE_LIGHT then tkm=15005401 end
		if attr&ATTRIBUTE_DARK==ATTRIBUTE_DARK then tkm=15005391 end
		if attr&ATTRIBUTE_EARTH==ATTRIBUTE_EARTH then tkm=15005397 end
		if attr&ATTRIBUTE_WATER==ATTRIBUTE_WATER then tkm=15005395 end
		if attr&ATTRIBUTE_FIRE==ATTRIBUTE_FIRE then tkm=15005393 end
		if attr&ATTRIBUTE_WIND==ATTRIBUTE_WIND then tkm=15005399 end
		if attr&ATTRIBUTE_DIVINE==ATTRIBUTE_DIVINE then tkm=15005402 end
		local token=Duel.CreateToken(tp,tkm)
		if Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP) then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_SET_ATTACK)
			e1:SetValue(atk)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD)
			token:RegisterEffect(e1)
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_SET_DEFENSE)
			e2:SetValue(def)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD)
			token:RegisterEffect(e2)
			local e3=Effect.CreateEffect(c)
			e3:SetType(EFFECT_TYPE_SINGLE)
			e3:SetCode(EFFECT_CHANGE_ATTRIBUTE)
			e3:SetValue(attr)
			token:RegisterEffect(e3)
			local e4=Effect.CreateEffect(c)
			e4:SetType(EFFECT_TYPE_SINGLE)
			e4:SetCode(EFFECT_CHANGE_LEVEL)
			e4:SetValue(lv)
			token:RegisterEffect(e4)
			local e5=Effect.CreateEffect(e:GetHandler())
			e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
			e5:SetCode(EVENT_LEAVE_FIELD)
			e5:SetOperation(cm.bedesop)
			e5:SetLabelObject(tc)
			e5:SetLabel(tcid)
			token:RegisterEffect(e5,true)
		end
		Duel.SpecialSummonComplete()
		tc:SetCardTarget(token)
	end
end
function cm.bedesop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsReason(REASON_DESTROY) then
		local tc=e:GetLabelObject()
		if tc and tc:GetFlagEffect(15005390)~=0 then
			local tcid=tc:GetFlagEffectLabel(15005390)
			if tcid==tc:GetFieldID() then
				Duel.Hint(HINT_CARD,1-tp,15005390)
				Duel.SendtoHand(tc,nil,REASON_EFFECT)
				Duel.ConfirmCards(1-tp,tc)
			end
		end
	end
	e:Reset()
end
function cm.nonfilter(c,attr)
	return c:IsAttribute(attr) and c:IsFaceup()
end
function cm.srfilter(c,attr)
	return (not c:IsAttribute(attr)) and c:IsSetCard(0xaf3c) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function cm.srcon(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return (ph==PHASE_MAIN1 or ph==PHASE_MAIN2) and not Duel.IsExistingMatchingCard(cm.nonfilter,tp,LOCATION_MZONE,0,1,nil,ATTRIBUTE_DARK)
end
function cm.srcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToDeckAsCost() end
	Duel.SendtoDeck(e:GetHandler(),nil,2,REASON_COST)
end
function cm.srtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.srfilter,tp,LOCATION_DECK,0,1,nil,ATTRIBUTE_DARK) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function cm.srop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,cm.srfilter,tp,LOCATION_DECK,0,1,1,nil,ATTRIBUTE_DARK)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end