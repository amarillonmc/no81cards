--灵械姬的疾驰
local m=77003500
local cm=_G["c"..m]
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_END_PHASE)
	e1:SetCountLimit(1,m+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(cm.sptg)
	e1:SetOperation(cm.spop)
	c:RegisterEffect(e1)
end
--Effect 1
function cm.spfilter(c,e,tp)
	return c:IsSetCard(0x3eec) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.xf(c)
	return c:IsSetCard(0x3eec) and c:IsXyzSummonable(nil)
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local g=Duel.GetMatchingGroup(cm.spfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,nil,e,tp)
	if chk==0 then return ft>0 and #g>0 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(cm.spfilter),tp,LOCATION_HAND+LOCATION_GRAVE,0,nil,e,tp)
	if ft==0 or #g==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg=g:Select(tp,1,1,nil)
	if #sg==0 then return false end  
	if Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)==0 then return false end
	Duel.BreakEffect()
	local xg=Duel.GetMatchingGroup(cm.xf,tp,LOCATION_EXTRA,0,nil)
	if #xg>0 and Duel.IsPlayerCanSpecialSummonCount(tp,1) and Duel.SelectYesNo(tp,aux.Stringid(m,0)) then
		local xc=xg:Select(tp,1,1,nil):GetFirst()
		if xc and xc:IsLocation(LOCATION_EXTRA) then
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
			e2:SetCode(EVENT_SPSUMMON_SUCCESS)
			e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_OATH)
			e2:SetOperation(cm.sumsuc)
			e2:SetReset(RESET_PHASE+PHASE_END)
			xc:RegisterEffect(e2,true)
			local e12=Effect.CreateEffect(c)
			e12:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
			e12:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e12:SetCode(EVENT_TO_DECK)
			e12:SetOperation(cm.regop)
			e12:SetLabelObject(e2)
			e12:SetReset(RESET_PHASE+PHASE_END)
			xc:RegisterEffect(e12,true)
			Duel.XyzSummon(tp,xc,nil)
		end
	end
end
function cm.sumsuc(e,tp,eg,ep,ev,re,r,rp)
	e:Reset()
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	e1:SetValue(1000)
	c:RegisterEffect(e1)
end
function cm.regop(e,tp,eg,ep,ev,re,r,rp)
	local rse=e:GetLabelObject()
	rse:Reset()
end