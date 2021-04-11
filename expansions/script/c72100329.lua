--“可靠的大姐姐” 吹雪
local m=72100329
local cm=_G["c"..m]
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_DECK+LOCATION_HAND)
	e1:SetCost(cm.cost)
	e1:SetTarget(cm.sptg)
	e1:SetOperation(cm.spop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_DECK+LOCATION_HAND)
	e2:SetCost(cm.cost2)
	e2:SetTarget(cm.sptg)
	e2:SetOperation(cm.spop)
	c:RegisterEffect(e2)
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.spscostfil,tp,LOCATION_HAND,0,2,e:GetHandler()) end
	local g=Duel.SelectMatchingCard(tp,cm.spscostfil,tp,LOCATION_HAND,0,2,2,e:GetHandler())
	Duel.SendtoGrave(g,REASON_COST)
end
function cm.spscostfil(c)
	return c:IsRace(RACE_MACHINE) and c:IsType(TYPE_MONSTER) and not c:IsCode(m)
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
end
-----------
function cm.spscostfil2(c)
	return c:IsRace(RACE_MACHINE) and c:IsType(TYPE_MONSTER) and Card.IsAbleToDeckAsCost and not c:IsCode(m)
end
function cm.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.spscostfil,tp,LOCATION_HAND,0,2,nil) end
	local g=Duel.SelectMatchingCard(tp,cm.spscostfil,tp,LOCATION_HAND,0,2,2,nil)
	Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
end