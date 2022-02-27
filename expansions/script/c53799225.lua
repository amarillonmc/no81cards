local m=53799225
local cm=_G["c"..m]
cm.name="鼻炎姐妹"
function cm.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,function(c,fc,sub,mg,sg)return not sg or sg:FilterCount(aux.TRUE,c)==0 or (sg:IsExists(Card.IsRace,1,c,c:GetRace()) and not sg:IsExists(Card.IsFusionAttribute,1,c,c:GetFusionAttribute()))end,2,true)
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_MATERIAL_LIMIT)
	e0:SetValue(cm.matlimit)
	c:RegisterEffect(e0)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(function(e,se,sp,st)return not e:GetHandler():IsLocation(LOCATION_EXTRA) or st&SUMMON_TYPE_FUSION==SUMMON_TYPE_FUSION end)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,m)
	e2:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)return e:GetHandler():IsSummonType(SUMMON_TYPE_FUSION)end)
	e2:SetCost(cm.spcost)
	e2:SetTarget(cm.sptg)
	e2:SetOperation(cm.spop)
	c:RegisterEffect(e2)
end
function cm.matlimit(e,c,fc,st)
	if st~=SUMMON_TYPE_FUSION then return true end
	return c:IsControler(fc:GetControler()) and c:IsLocation(LOCATION_ONFIELD+LOCATION_HAND)
end
function cm.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsReleasable() and Duel.GetMZoneCount(tp,c)>1 end
	Duel.Release(c,REASON_COST)
end
function cm.filter(c,e,tp)
	return c:IsLevelBelow(5) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.fselect(g)
	return g:GetClassCount(Card.GetRace)==1 and g:GetClassCount(Card.GetAttribute)==#g
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(cm.filter,tp,LOCATION_HAND+LOCATION_GRAVE,0,nil,e,tp)
	if chk==0 then return not Duel.IsPlayerAffectedByEffect(tp,59822133) and g:CheckSubGroup(cm.fselect,2,2) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,tp,LOCATION_HAND+LOCATION_GRAVE)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsPlayerAffectedByEffect(tp,59822133) or Duel.GetLocationCount(tp,LOCATION_MZONE)<2 then return end
	local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(cm.filter),tp,LOCATION_HAND+LOCATION_GRAVE,0,nil,e,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg=g:SelectSubGroup(tp,cm.fselect,false,2,2)
	if sg:GetCount()>0 then
		for tc in aux.Next(sg) do
			Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP)
			if tc:IsPreviousLocation(LOCATION_GRAVE) then
				local e1=Effect.CreateEffect(e:GetHandler())
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_DISABLE)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD)
				tc:RegisterEffect(e1,true)
				local e2=Effect.CreateEffect(e:GetHandler())
				e2:SetType(EFFECT_TYPE_SINGLE)
				e2:SetCode(EFFECT_DISABLE_EFFECT)
				e2:SetReset(RESET_EVENT+RESETS_STANDARD)
				tc:RegisterEffect(e2,true)
			end
		end
		Duel.SpecialSummonComplete()
	end
end
