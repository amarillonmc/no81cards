--人理之基 布伦希尔德
function c22023860.initial_effect(c)
	--synchro summon
	c:EnableReviveLimit()
	aux.AddSynchroMixProcedure(c,c22023860.matfilter1,nil,nil,aux.NonTuner(Card.IsSetCard,0xff1),1,99)
	--change effect type
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(22023860)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(1,0)
	c:RegisterEffect(e1)
	--draw
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(22023860,0))
	e2:SetCategory(CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCountLimit(1,22023860)
	e2:SetCondition(c22023860.drcon)
	e2:SetTarget(c22023860.drtg)
	e2:SetOperation(c22023860.drop)
	c:RegisterEffect(e2)
	--disable spsummon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(22023860,1))
	e3:SetCategory(CATEGORY_DISABLE_SUMMON+CATEGORY_DESTROY+CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EVENT_SPSUMMON)
	e3:SetCountLimit(1,22023861)
	e3:SetCondition(c22023860.condition)
	e3:SetCost(c22023860.cost)
	e3:SetTarget(c22023860.target)
	e3:SetOperation(c22023860.operation)
	c:RegisterEffect(e3)
	--disable spsummon
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(22023860,2))
	e4:SetCategory(CATEGORY_DISABLE_SUMMON+CATEGORY_DESTROY+CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetRange(LOCATION_GRAVE)
	e4:SetCode(EVENT_SPSUMMON)
	e4:SetCountLimit(1,22023861)
	e4:SetCondition(c22023860.condition1)
	e4:SetCost(c22023860.cost1)
	e4:SetTarget(c22023860.target)
	e4:SetOperation(c22023860.operation)
	c:RegisterEffect(e4)
end
function c22023860.matfilter1(c,syncard)
	return c:IsTuner(syncard) or c:IsSetCard(0xff1)
end
function c22023860.pmfilter(c)
	return c:IsCode(22023851)
end
function c22023860.drcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsSummonType(SUMMON_TYPE_SYNCHRO) and c:GetMaterial():IsExists(c22023860.pmfilter,1,nil)
end
function c22023860.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,2) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(2)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
end
function c22023860.drop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
function c22023860.condition(e,tp,eg,ep,ev,re,r,rp)
	return tp~=ep and Duel.GetCurrentChain()==0
end
function c22023860.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end
function c22023860.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,22023851,0x6ff1,TYPES_TOKEN_MONSTER,1400,700,4,RACE_WARRIOR,ATTRIBUTE_LIGHT) end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DISABLE_SUMMON,eg,eg:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,eg:GetCount(),0,0)
end
function c22023860.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateSummon(eg)
	Duel.Destroy(eg,REASON_EFFECT)
	if Duel.GetLocationCount(1-tp,LOCATION_MZONE)<=0
		or not Duel.IsPlayerCanSpecialSummonMonster(tp,22023851,0x6ff1,TYPES_TOKEN_MONSTER,1400,700,4,RACE_WARRIOR,ATTRIBUTE_LIGHT) then return end
	Duel.BreakEffect()
	local token1=Duel.CreateToken(tp,22023851)
	local token2=Duel.CreateToken(tp,22023852)
	local token3=Duel.CreateToken(tp,22023853)
	if Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)>=0 and Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)<=2 then 
		Duel.SpecialSummonStep(token1,0,tp,1-tp,false,false,POS_FACEUP)
	elseif Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)>=3 and Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)<=5 then
		Duel.SpecialSummonStep(token2,0,tp,1-tp,false,false,POS_FACEUP)
	elseif Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)>=6 then
		Duel.SpecialSummonStep(token3,0,tp,1-tp,false,false,POS_FACEUP)
	Duel.SpecialSummonComplete()
	end
end
function c22023860.condition1(e,tp,eg,ep,ev,re,r,rp)
	return tp~=ep and Duel.GetCurrentChain()==0 and Duel.IsPlayerAffectedByEffect(tp,22020980)
end
function c22023860.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
	Duel.Hint(HINT_CARD,0,22020980)
	Duel.PayLPCost(tp,math.floor(Duel.GetLP(tp)/2))
end