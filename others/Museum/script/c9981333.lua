--天空璋自机 极寒中颤抖的魔法使
function c9981333.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkType,TYPE_EFFECT),2,99,c9981333.lcheck)
	--negate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(9981333,0))
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,9981333)
	e1:SetCondition(c9981333.discon)
	e1:SetCost(c9981333.discost)
	e1:SetTarget(c9981333.distg)
	e1:SetOperation(c9981333.disop)
	c:RegisterEffect(e1)
	--special summon
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(9981333,1))
	e6:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e6:SetCode(EVENT_SPSUMMON_SUCCESS)
	e6:SetProperty(EFFECT_FLAG_DELAY)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCountLimit(1,99813330)
	e6:SetCondition(c9981333.spcon)
	e6:SetTarget(c9981333.sptg)
	e6:SetOperation(c9981333.spop)
	c:RegisterEffect(e6)
   --spsummon bgm
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e8:SetCode(EVENT_SPSUMMON_SUCCESS)
	e8:SetOperation(c9981333.sumsuc)
	c:RegisterEffect(e8)
	local e9=e8:Clone()
	e9:SetCode(EVENT_SUMMON_SUCCESS)
	c:RegisterEffect(e9)
end
function c9981333.sumsuc(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_MUSIC,0,aux.Stringid(9981333,0))
end
function c9981333.lcheck(g,lc)
	return g:IsExists(c9981333.mzfilter,1,nil)
end
function c9981333.mzfilter(c)
	return c:IsLinkSetCard(0x6bd1) and c:IsLinkType(TYPE_MONSTER)
end
function c9981333.discon(e,tp,eg,ep,ev,re,r,rp)
	return re:IsActiveType(TYPE_SPELL+TYPE_TRAP) and not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and Duel.IsChainNegatable(ev)
end
function c9981333.disfilter(c)
	return c:IsAttribute(ATTRIBUTE_WIND) and c:IsAbleToGraveAsCost()
end
function c9981333.discost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9981333.disfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c9981333.disfilter,tp,LOCATION_HAND,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
end
function c9981333.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
 Duel.Hint(HINT_MUSIC,0,aux.Stringid(9981333,0))
end
function c9981333.cfilter(c,tp)
	return c:GetSummonPlayer()==tp and c:IsPreviousLocation(LOCATION_EXTRA)
end
function c9981333.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c9981333.cfilter,1,nil,1-tp)
end
function c9981333.spfilter(c,e,tp)
	return c:IsSetCard(0x6bd1) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c9981333.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c9981333.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c9981333.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c9981333.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end