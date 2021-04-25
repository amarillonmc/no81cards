--幻旅传说·遭遇
--21.04.09
local m=11451400
local cm=_G["c"..m]
function cm.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetCondition(cm.condition)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
end
cm.traveler_saga=true
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	return #eg==1 and eg:GetFirst():IsControler(1-tp)
end
function cm.filter(c,e,tp,zone)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCountFromEx(tp,tp,nil,c,zone)>0
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local rc=eg:GetFirst()
	if chk==0 then return Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_EXTRA,0,1,nil,e,tp,rc:GetColumnZone(LOCATION_MZONE,tp)) end
	rc:CreateEffectRelation(e)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local rc=eg:GetFirst()
	if not rc:IsRelateToEffect(e) then return end
	local g=Duel.GetFieldGroup(tp,LOCATION_EXTRA,0)
	if #g>0 then
		local tc=g:RandomSelect(1-tp,1):GetFirst()
		Duel.ConfirmCards(1-tp,tc)
		Duel.ConfirmCards(tp,tc)
		if cm.filter(tc,e,tp,rc:GetColumnZone(LOCATION_MZONE,tp)) then
			local rfid=rc:GetRealFieldID()
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_IGNORE_IMMUNE)
			e1:SetCode(EVENT_LEAVE_FIELD)
			e1:SetOperation(cm.reop)
			e1:SetLabel(rfid)
			rc:RegisterEffect(e1,true)
			if Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP,rc:GetColumnZone(LOCATION_MZONE,tp)) then
				tc:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD,0,0,rfid)
				rc:CreateRelation(tc,RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
				Duel.SpecialSummonComplete()
				Debug.Message("或许是由于过于疲惫，落单的怪兽不幸遭遇了来自额外卡组的黑色高级怪兽")
				Debug.Message("面对为了保护决斗者而揽下所有责任的落单怪兽，对方怪兽提出的和解条件是……")
			end
		end
	end
end
function cm.refilter(c,rfid)
	return c:GetFlagEffectLabel(m)==rfid
end
function cm.reop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(cm.refilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil,e:GetLabel())
	Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
	e:Reset()
end