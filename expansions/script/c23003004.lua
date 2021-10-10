--龙启之地的北地祭司
local m=23003004
local cm=_G["c"..m]
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetTarget(cm.atktg1)
	e1:SetOperation(cm.atkop1)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
end
--e1
function cm.spfilter1(c,e,tp)
	return  c:IsLevel(3) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.atktg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(cm.spfilter1,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE)
end
function cm.atkop1(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	if Duel.SelectYesNo(tp,aux.Stringid(m,3)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,cm.spfilter1,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,e,tp)
		if g:GetCount()>0 then
			if Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)~=0 and g:GetFirst():IsType(TYPE_NORMAL) and g:GetFirst():IsSetCard(0x352) then
				local sg=Duel.GetMatchingGroup(nil,tp,0,LOCATION_SZONE,nil)
				if #sg>0 then
					local zg=sg:Select(tp,1,1,nil)
					Duel.Destroy(zg,REASON_EFFECT)
				end
			end
		end
	end
end