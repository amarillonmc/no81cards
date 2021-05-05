--恶路程式 蜘蛛
function c40008586.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(40008586,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCost(c40008586.spcost)
	e1:SetTarget(c40008586.sptg)
	e1:SetOperation(c40008586.spop)
	c:RegisterEffect(e1)
	--salvage
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(40008586,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOGRAVE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCost(c40008586.thcost)
	e2:SetTarget(c40008586.thtg)
	e2:SetOperation(c40008586.thop)
	c:RegisterEffect(e2)	 
end
function c40008586.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_COST)
end
function c40008586.filter(c,e,tp)
	return c:IsSetCard(0xc016) and c:IsRace(RACE_INSECT) and c:IsLevelAbove(5) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c40008586.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1
		and Duel.IsExistingMatchingCard(c40008586.filter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c40008586.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c40008586.filter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c40008586.cfilter(c)
	return c:IsSetCard(0xc016) and c:IsAbleToRemoveAsCost() and not c:IsCode(40008586)
end
function c40008586.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost()
		and Duel.IsExistingMatchingCard(c40008586.cfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c40008586.cfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	g:AddCard(e:GetHandler())
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c40008586.thfilter1(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,1-tp,false,false)
end
function c40008586.tgfilter(c)
	return c:IsSetCard(0xc016) and c:IsAbleToGrave()
end
function c40008586.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c40008586.thfilter1,tp,0,LOCATION_HAND,1,nil,e,1-tp) and Duel.IsExistingMatchingCard(c40008586.tgfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,1-tp,LOCATION_HAND)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function c40008586.thop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(1-tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(1-tp,c40008586.thfilter1,tp,0,LOCATION_HAND,1,1,nil,e,1-tp)
	local sg=g:Select(1-tp,1,1,nil)
	if sg:GetCount()>0 then
		if Duel.SpecialSummon(sg,0,1-tp,1-tp,false,false,POS_FACEUP)>0 then
		 Duel.BreakEffect()
		 local g=Duel.SelectMatchingCard(tp,c40008586.tgfilter,tp,LOCATION_DECK,0,1,1,nil)
		 Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		 Duel.SendtoGrave(g,REASON_EFFECT)
		end
	end
end