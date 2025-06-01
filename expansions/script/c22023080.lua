--人理之基 约翰·埃德加·胡佛
function c22023080.initial_effect(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(22023080,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,22023080)
	e1:SetCondition(c22023080.spcon1)
	e1:SetTarget(c22023080.sptg1)
	e1:SetOperation(c22023080.spop1)
	c:RegisterEffect(e1)
	--Activate
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(22023080,1))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,22023081)
	e2:SetCost(c22023080.cost)
	e2:SetTarget(c22023080.target)
	e2:SetOperation(c22023080.operation)
	c:RegisterEffect(e2)
	--Activate
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(22023080,2))
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCountLimit(1,22023081)
	e3:SetCondition(c22023080.erescon)
	e3:SetCost(c22023080.cost1)
	e3:SetTarget(c22023080.target)
	e3:SetOperation(c22023080.operation)
	c:RegisterEffect(e3)
end
c22023080.effect_with_darkguda=true
function c22023080.cfilter(c)
	return c:IsFaceup() and c:IsCode(22020000) and c:GetOriginalAttribute()==ATTRIBUTE_DARK 
end
function c22023080.spcon1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c22023080.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c22023080.sptg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c22023080.spop1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
end
function c22023080.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CODE)
	local ac=Duel.AnnounceCard(tp)
	Duel.SetTargetParam(ac)
	Duel.SetOperationInfo(0,CATEGORY_ANNOUNCE,nil,0,tp,0)
end
function c22023080.operation(e,tp,eg,ep,ev,re,r,rp)
	local ac=Duel.GetChainInfo(0,CHAININFO_TARGET_PARAM)
	e:GetHandler():SetHint(CHINT_CARD,ac)
	--forbidden
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetCode(EFFECT_FORBIDDEN)
	e1:SetTargetRange(0xff,0xff)
	e1:SetTarget(c22023080.bantg)
	e1:SetLabel(ac)
	e1:SetReset(RESET_PHASE+PHASE_END+RESET_OPPO_TURN)
	Duel.RegisterEffect(e1,tp)
end
function c22023080.bantg(e,c)
	local fcode=e:GetLabel()
	return c:IsOriginalCodeRule(fcode)
end
function c22023080.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(1-tp,LOCATION_HAND,0)~=0
		and not Duel.IsExistingMatchingCard(Card.IsPublic,1-tp,LOCATION_HAND,0,1,nil) and Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
	local g=Duel.GetFieldGroup(1-tp,LOCATION_HAND,0)
	Duel.ConfirmCards(tp,g)
	Duel.ShuffleHand(1-tp)
end
function c22023080.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(1-tp,LOCATION_HAND,0)~=0
		and not Duel.IsExistingMatchingCard(Card.IsPublic,1-tp,LOCATION_HAND,0,1,nil) and Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
	local g=Duel.GetFieldGroup(1-tp,LOCATION_HAND,0)
	Duel.ConfirmCards(tp,g)
	Duel.ShuffleHand(1-tp)
	Duel.Hint(HINT_CARD,0,22020980)
	Duel.PayLPCost(tp,math.floor(Duel.GetLP(tp)/2))
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end
function c22023080.erescon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsPlayerAffectedByEffect(tp,22020980)
end