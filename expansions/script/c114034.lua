--朝暮的小鹿·阿丽娜
local m=114034
local cm=_G["c"..m]
function cm.initial_effect(c)
	aux.AddCodeList(c,114032,114035,114034)
	--Special Summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_DESTROYED)
	e1:SetCountLimit(1,m+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(cm.spcon)
	e1:SetTarget(cm.sptg)
	e1:SetOperation(cm.spop)
	c:RegisterEffect(e1)
end
function cm.spcon(e,tp,eg,ep,ev,re,r,rp)
	return re and (re:GetHandler():IsRace(RACE_WARRIOR) or re:GetHandler():GetCode()==114035)
end
function cm.spfilter(c,e,tp)
	return c:IsCode(114032) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=Duel.GetLocationCountFromEx(1-tp,tp,nil,nil)
	if chk==0 then return ct>0 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCountFromEx(1-tp,tp,nil,nil)<=0 then return end
	local zg=Duel.GetFieldGroup(tp,LOCATION_EXTRA,0)
	if zg:IsExists(cm.spfilter,1,nil,e,tp) then
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,cm.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,1-tp,false,false,POS_FACEUP_ATTACK)
	end
	end
end