--深渊异龙的觉醒
local cm,m,o=GetID()
function cm.initial_effect(c)
	local e1=aux.AddRitualProcGreater2(c,cm.rf1,LOCATION_GRAVE,nil,nil,nil,cm.op1)
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,m)
	e2:SetCost(cm.cos2)
	e2:SetTarget(cm.tg2)
	e2:SetOperation(cm.op2)
	c:RegisterEffect(e2)
end
--e1
function cm.rf1(c)
	return c:IsType(TYPE_RITUAL) and c:IsRace(RACE_DRAGON)
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(24,0,aux.Stringid(m,0))
end
--e2
function cm.cos2(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetFieldGroup(tp,LOCATION_HAND,0):Filter(Card.IsPublic,nil):Filter(Card.IsSetCard,nil,0x9fd5):Filter(Card.IsAbleToGraveAsCost,nil)
	if chk==0 then return #g>0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	g=g:Select(tp,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
end
function cm.tgf2(c,e,tp)
	return c:GetType()&0x81==0x81 and c:IsCanBeSpecialSummoned(e,0,tp,false,true) and c:IsRace(RACE_DRAGON) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
end
function cm.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToHand() and Duel.IsExistingMatchingCard(cm.tgf2,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tc=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(cm.tgf2),tp,LOCATION_GRAVE,0,1,1,nil,e,tp):GetFirst()
	if tc and Duel.SpecialSummon(tc,0,tp,tp,false,true,POS_FACEUP)>0 then
		if not e:GetHandler():IsRelateToEffect(e) then return end
		Duel.BreakEffect()
		Duel.SendtoHand(e:GetHandler(),nil,REASON_EFFECT)
	end
end
