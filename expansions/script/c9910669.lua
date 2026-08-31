--拉尼亚凯亚之监督
function c9910669.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e1:SetCountLimit(1,9910669)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetCondition(c9910669.spcon)
	e1:SetTarget(c9910669.sptg)
	e1:SetOperation(c9910669.spop)
	c:RegisterEffect(e1)
	--to grave
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOGRAVE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetTarget(c9910669.tgtg)
	e2:SetOperation(c9910669.tgop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
	--quick activate
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(9910669,0))
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
	e4:SetTargetRange(LOCATION_SZONE,0)
	e4:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTarget(c9910669.qfilter)
	c:RegisterEffect(e4)
	Duel.AddCustomActivityCounter(9910669,ACTIVITY_CHAIN,c9910669.chainfilter)
end
function c9910669.chainfilter(re,tp,cid)
	local rc=re:GetHandler()
	return not ((rc:IsRace(RACE_MACHINE) and re:IsActiveType(TYPE_MONSTER)) or (rc:IsSetCard(0xa952)))
end
function c9910669.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCustomActivityCount(9910669,tp,ACTIVITY_CHAIN)>0
end
function c9910669.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c9910669.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToChain() then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c9910669.cfilter(c)
	return not c:IsPublic()
end
function c9910669.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9910669.cfilter,tp,LOCATION_HAND,0,1,nil)
		and Duel.IsExistingMatchingCard(Card.IsAbleToGrave,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	local g=Duel.GetMatchingGroup(Card.IsAbleToGrave,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,1,0,0)
end
function c9910669.check(g)
	return g:FilterCount(Card.IsType,nil,TYPE_MONSTER)<=1
		and g:FilterCount(Card.IsType,nil,TYPE_SPELL)<=1
		and g:FilterCount(Card.IsType,nil,TYPE_TRAP)<=1
end
function c9910669.tgop(e,tp,eg,ep,ev,re,r,rp)
	local g1=Duel.GetMatchingGroup(c9910669.cfilter,tp,LOCATION_HAND,0,nil)
	local g2=Duel.GetMatchingGroup(Card.IsAbleToGrave,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	if #g1==0 or #g2==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local sg1=g1:SelectSubGroup(tp,c9910669.check,false,1,#g2)
	if not sg1 or #sg1==0 then return end
	Duel.ConfirmCards(1-tp,sg1)
	Duel.ShuffleHand(tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local sg2=g2:Select(tp,#sg1,#sg1,nil)
	if #sg2>0 then
		Duel.HintSelection(sg2)
		Duel.SendtoGrave(sg2,REASON_EFFECT)
	end
end
function c9910669.qfilter(e,c)
	return c:IsSetCard(0xa952)
end
