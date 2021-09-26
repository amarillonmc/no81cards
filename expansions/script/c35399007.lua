--大海怪 火山漩涡龙
function c35399007.initial_effect(c)
--
	c:EnableReviveLimit()
	aux.AddSynchroProcedure(c,c35399007.MatFilter,aux.NonTuner(c35399007.matfilter),1)
--
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	e0:SetValue(c35399007.val0)
	c:RegisterEffect(e0)
--
	local e1_1=Effect.CreateEffect(c)
	e1_1:SetType(EFFECT_TYPE_SINGLE)
	e1_1:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e1_1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1_1:SetRange(LOCATION_MZONE)
	e1_1:SetValue(aux.tgoval)
	c:RegisterEffect(e1_1)
	local e1_2=Effect.CreateEffect(c)
	e1_2:SetType(EFFECT_TYPE_SINGLE)
	e1_2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1_2:SetRange(LOCATION_MZONE)
	e1_2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e1_2:SetValue(1)
	c:RegisterEffect(e1_2)
	local e1_3=e1_2:Clone()
	e1_3:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	c:RegisterEffect(e1_3)
--
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(35399007,0))
	e2:SetCategory(CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,35399007)
	e2:SetTarget(c35399007.tg2)
	e2:SetOperation(c35399007.op2)
	c:RegisterEffect(e2)
--
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(35399007,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetCountLimit(1,35399008)
	e3:SetCondition(c35399007.con3)
	e3:SetCost(c35399007.cost3)
	e3:SetTarget(c35399007.tg3)
	e3:SetOperation(c35399007.op3)
	c:RegisterEffect(e3)
	local e3_1=e3:Clone()
	e3_1:SetCode(EVENT_REMOVE)
	c:RegisterEffect(e3_1)
--
end
--
function c35399007.MatFilter(c)
	return c:IsRace(RACE_DRAGON)
end
function c35399007.matfilter(c)
	return c:IsRace(RACE_DRAGON) and c:IsType(TYPE_SYNCHRO) 
end
--
function c35399007.val0(e,se,sp,st)
	return not e:GetHandler():IsLocation(LOCATION_EXTRA) or (bit.band(st,SUMMON_TYPE_SYNCHRO)==SUMMON_TYPE_SYNCHRO)
end
--
function c35399007.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,e:GetHandler())
		and not Duel.IsExistingMatchingCard(aux.NOT(Card.IsAbleToRemove),tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,e:GetHandler())
	end
	local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,g:GetCount(),0,0)
end
function c35399007.op2(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,aux.ExceptThisCard(e))
	Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
end
--
function c35399007.con3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousPosition(POS_FACEUP) and c:IsSummonType(SUMMON_TYPE_SYNCHRO)
end
function c35399007.cost3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToRemoveAsCost,tp,LOCATION_HAND,0,1,nil)
		and not Duel.IsExistingMatchingCard(aux.NOT(Card.IsAbleToRemoveAsCost),tp,LOCATION_HAND,0,1,nil)
	end
	local g=Duel.GetMatchingGroup(Card.IsAbleToRemoveAsCost,tp,LOCATION_HAND,0,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c35399007.tg3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c35399007.op3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
end
--