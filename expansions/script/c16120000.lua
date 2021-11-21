--白苍混成 B.W.M
function c16120000.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddFusionProcMix(c,false,true,c16120000.fusfilter1,c16120000.fusfilter2,c16120000.fusfilter3,c16120000.fusfilter4)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(16120000,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_NO_TURN_RESET)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCondition(c16120000.spcon)
	e1:SetTarget(c16120000.sptg)
	e1:SetOperation(c16120000.spop)
	c:RegisterEffect(e1)
	--negate
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(16120000,1))
	e2:SetCategory(CATEGORY_NEGATE)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_CHAINING)
	e2:SetCondition(c16120000.negcon)
	e2:SetTarget(c16120000.negtg)
	e2:SetOperation(c16120000.negop)
	c:RegisterEffect(e2)
end
function c16120000.fusfilter1(c)
	return c:IsAttribute(ATTRIBUTE_EARTH)
end
function c16120000.fusfilter2(c)
	return c:IsAttribute(ATTRIBUTE_FIRE)
end
function c16120000.fusfilter3(c)
	return c:IsAttribute(ATTRIBUTE_WIND)
end
function c16120000.fusfilter4(c)
	return c:IsAttribute(ATTRIBUTE_WATER)
end
function c16120000.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPosition(POS_FACEUP_ATTACK)
end
function c16120000.spfilter(c,e,tp,att)
	local flag=false
	if Duel.GetLP(tp)<=1000 then
		flag=true
	end
	return c:IsAttribute(att) and c:IsCanBeSpecialSummoned(e,0,tp,flag,false) and (c:IsLocation(LOCATION_DECK) and Duel.GetMZoneCount(tp)>0
			or c:IsLocation(LOCATION_EXTRA) and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0) and c:IsRace(RACE_DRAGON)
end
function c16120000.filter(g,e,tp)
	return g:GetClassCount(Card.GetAttribute)==1 and Duel.IsExistingMatchingCard(c16120000.spfilter,tp,LOCATION_DECK+LOCATION_EXTRA,0,1,nil,e,tp,g:GetFirst():GetAttribute())
end
function c16120000.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,LOCATION_GRAVE,0,nil)
	if chk==0 then return g:CheckSubGroup(c16120000.filter,3,3,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,LOCATION_DECK+LOCATION_EXTRA)
end
function c16120000.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,LOCATION_GRAVE,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local sg=g:SelectSubGroup(tp,c16120000.filter,false,3,3,e,tp)
	if not sg then return end
	Duel.Remove(sg,POS_FACEUP,REASON_EFFECT)
	Duel.BreakEffect()
	local att=sg:GetFirst():GetAttribute()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local ag=Duel.SelectMatchingCard(tp,c16120000.spfilter,tp,LOCATION_DECK+LOCATION_EXTRA,0,1,1,nil,e,tp,att)
	local flag=false
	if Duel.GetLP(tp)<=1000 then
		flag=true
	end
	Duel.SpecialSummon(ag,0,tp,tp,flag,false,POS_FACEUP)
end
function c16120000.negcon(e,tp,eg,ep,ev,re,r,rp)
	return re:GetHandler():IsAttribute(ATTRIBUTE_FIRE+ATTRIBUTE_EARTH+ATTRIBUTE_WATER+ATTRIBUTE_WIND) and Duel.IsChainNegatable(ev)
end
function c16120000.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,16120000)==0 end
	Duel.RegisterFlagEffect(tp,16120000,RESET_CHAIN,0,1)
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
end
function c16120000.negop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateActivation(ev)
end