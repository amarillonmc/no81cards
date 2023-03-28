--肋骨之路
local m=111013
local cm=_G["c"..m]
function cm.initial_effect(c)
   --destroy
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e1:SetCountLimit(1,m)
	e1:SetTarget(cm.destg)
	e1:SetOperation(cm.desop)
	c:RegisterEffect(e1)
end
function cm.desfilter(c,tp)
	return (c:IsLocation(LOCATION_MZONE) or Duel.GetLocationCount(tp,LOCATION_MZONE)>0) and c:IsType(TYPE_MONSTER) and c:IsRace(RACE_BEASTWARRIOR)
end
function cm.tgfilter(c)
	return c:IsAbleToGrave() and c:IsType(TYPE_MONSTER) and c:IsRace(RACE_BEASTWARRIOR) and c:IsAttack(1950)
end
function cm.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false)and Duel.IsExistingMatchingCard(cm.desfilter,tp,LOCATION_MZONE+LOCATION_HAND,0,1,nil,tp) and Duel.IsExistingMatchingCard(cm.tgfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function cm.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,cm.desfilter,tp,LOCATION_MZONE+LOCATION_HAND,0,1,1,nil,tp)
	if #g>0 and Duel.Destroy(g,REASON_EFFECT)~=0 then
		if (c:IsRelateToEffect(e) or c==Duel.GetOperatedGroup():GetFirst()) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) then
			if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 then
				Duel.BreakEffect()
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
				local tg=Duel.SelectMatchingCard(tp,cm.tgfilter,tp,LOCATION_DECK,0,1,1,nil)
				if tg:GetCount()>0 then
					Duel.SendtoGrave(tg,REASON_EFFECT)
				end
			end
		end
	end
end