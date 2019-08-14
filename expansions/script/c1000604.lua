--废怯的女孩  鹿目圆香
function c1000604.initial_effect(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,1000604)
	e1:SetCondition(c1000604.spcon)
	e1:SetTarget(c1000604.sptg)
	e1:SetOperation(c1000604.spop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	--atk up
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_SET_ATTACK)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCondition(c1000604.con3)
	e4:SetValue(2800)
	c:RegisterEffect(e4)
	--negate
	local e7=Effect.CreateEffect(c)
	e7:SetDescription(aux.Stringid(1000604,1))
	e7:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e7:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e7:SetType(EFFECT_TYPE_QUICK_O)
	e7:SetRange(LOCATION_MZONE)
	e7:SetCountLimit(1,1000604)
	e7:SetCode(EVENT_CHAINING)
	e7:SetCondition(c1000604.discon)
	e7:SetTarget(c1000604.distg)
	e7:SetOperation(c1000604.disop)
	c:RegisterEffect(e7)
	--indes
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e2:SetCondition(c1000604.con1)
	e2:SetValue(1)
	c:RegisterEffect(e2)
end
function c1000604.filter1(c,e,tp)
	return c:IsSetCard(0xc204) and not (c:IsType(TYPE_TUNER) and c:IsType(TYPE_PENDULUM)) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
 end
function c1000604.cfilter(c)
	return c:GetSummonLocation()==LOCATION_EXTRA
end
function c1000604.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c1000604.cfilter,tp,0,LOCATION_MZONE,1,nil) 
end
function c1000604.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c1000604.filter1,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c1000604.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetMZoneCount(tp)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c1000604.filter1,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c1000604.filter9(c,e,tp)
	return c:IsSetCard(0xc204) and c:IsControler(tp) and not c:IsType(TYPE_PENDULUM) 
end
function c1000604.con3(e,tp,eg,ep,ev,re,r,rp)
   local g=Duel.GetMatchingGroup(c1000604.filter9,e:GetHandlerPlayer(),LOCATION_GRAVE,0,nil,e,tp)
	local ct=g:GetClassCount(Card.GetCode)
   return  ct>=6
end
function c1000604.con1(e,tp,eg,ep,ev,re,r,rp)
   local g=Duel.GetMatchingGroup(c1000604.filter9,e:GetHandlerPlayer(),LOCATION_GRAVE,0,nil,e,tp)
	local ct=g:GetClassCount(Card.GetCode)
   return  ct>=3
end
function c1000604.discon(e,tp,eg,ep,ev,re,r,rp)
   local g=Duel.GetMatchingGroup(c1000604.filter9,e:GetHandlerPlayer(),LOCATION_GRAVE,0,nil,e,tp)
	local ct=g:GetClassCount(Card.GetCode)
	return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and ct>=9 and ep==1-tp and re:IsHasType(EFFECT_TYPE_ACTIVATE) and Duel.IsChainNegatable(ev)
end
function c1000604.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c1000604.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateActivation(ev)
	if re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end