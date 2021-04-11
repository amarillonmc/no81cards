local m=70700007
local cm=_G["c"..m]
cm.name="苏生能力者 然火"
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_TO_GRAVE)
	e1:SetCondition(cm.con)
	e1:SetTarget(cm.tg)
	e1:SetOperation(cm.op)
	c:RegisterEffect(e1)
end
function cm.con(e,tp,eg,ep,ev,re,r,rp)
	return re and re:GetHandler():IsSetCard(0x93a)
end
function cm.filter(c,e,tp)
	if c:IsCode(m) and Duel.GetFlagEffect(tp,m)~=0 then return false end
	return c:IsSetCard(0x93a) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) 
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_GRAVE,0,2,nil,e,tp) and Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE)==0 and not Duel.IsPlayerAffectedByEffect(tp,59822133) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE)~=0 or Duel.IsPlayerAffectedByEffect(tp,59822133) or Duel.GetLocationCount(tp,LOCATION_MZONE)<2 then return end
	local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(cm.filter),tp,LOCATION_GRAVE,0,nil,e,tp)
	if #g<2 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tg=g:Select(tp,2,2,nil)
	Duel.SpecialSummon(tg,0,tp,tp,false,false,POS_FACEUP)
	if tg:Filter(Card.IsLocation,nil,LOCATION_MZONE):FilterCount(Card.IsCode,nil,m)>0 then
		Duel.RegisterFlagEffect(tp,m,RESET_PHASE+PHASE_END,nil)
	end
end