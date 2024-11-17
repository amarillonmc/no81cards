--炸弹恶魔
local s,id,o=GetID()
function s.initial_effect(c)
	aux.AddCodeList(c,12866665,12866670)
	c:EnableReviveLimit()
	--splimit
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(s.splimit)
	c:RegisterEffect(e1)
	--toss
	local e2=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_DAMAGE+CATEGORY_DICE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCountLimit(1,id)
	e2:SetTarget(s.totg)
	e2:SetOperation(s.toop)
	c:RegisterEffect(e2)
	--SpecialSummon
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetCountLimit(1,id+1)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetTarget(s.sptg)
	e3:SetOperation(s.spop)
	c:RegisterEffect(e3)
end
s.toss_dice=true
function s.splimit(e,se,sp,st)
	return aux.IsCodeListed(se:GetHandler(),id) or not e:GetHandler():IsLocation(LOCATION_EXTRA)
end
function s.totg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DICE,nil,0,tp,1)
end
function s.toop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local dc1,dc2=Duel.TossDice(tp,2)
	if not c:IsRelateToEffect(e) or not c:IsLocation(LOCATION_MZONE) then
		local op=Duel.SelectOption(tp,aux.Stringid(id,1),aux.Stringid(id,2),aux.Stringid(id,3))
		if op==0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DICE)
			dc1=Duel.AnnounceNumber(tp,1,2,3,4,5,6)
		elseif op==1 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DICE)
			dc2=Duel.AnnounceNumber(tp,1,2,3,4,5,6)
		end
	end
	s.revere_op(dc1,tp,dc2)
	Duel.BreakEffect()
	s.revere_op(dc2,tp,dc1)
end
function s.revere_op(dc1,tp,dc2)
	local dc1=dc2
	if dc1==1 then
		Duel.Damage(tp,2000,REASON_EFFECT)
	elseif dc1==2 then
		Duel.Damage(tp,2000,REASON_EFFECT)
	elseif dc1==3 then
		Duel.Damage(1-tp,2000,REASON_EFFECT)
	elseif dc1==4 then
		Duel.Damage(1-tp,2000,REASON_EFFECT)
	elseif dc1==5 then
		local g=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_MZONE,0,nil)
		if #g<=0 then return end
		Duel.Destroy(g,REASON_EFFECT)
	elseif dc1==6 then
		local g=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_MZONE,nil)
		if #g<=0 then return end
		Duel.Destroy(g,REASON_EFFECT)
	end
end
function s.spfilter(c,e,tp)
	return c:IsFaceupEx() and c:IsCode(12866665) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.spfilter),tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end