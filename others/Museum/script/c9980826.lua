--假面驾驭·风都侦探W疾风王牌极限
function c9980826.initial_effect(c)
	 --fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,c9980826.ffilter,3,false)
	aux.AddContactFusionProcedure(c,Card.IsReleasable,LOCATION_MZONE,0,Duel.Release,REASON_COST+REASON_FUSION+REASON_MATERIAL)
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(c9980826.splimit)
	c:RegisterEffect(e1)
	--spsummon bgm
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e8:SetCode(EVENT_SPSUMMON_SUCCESS)
	e8:SetOperation(c9980826.sumsuc)
	c:RegisterEffect(e8)
	--disable and destroy
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EVENT_CHAIN_SOLVING)
	e1:SetOperation(c9980826.disop)
	c:RegisterEffect(e1)
	--destroy
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(9980826,0))
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCountLimit(1,9980826)
	e2:SetRange(LOCATION_MZONE)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e2:SetCost(c9980826.cost)
	e2:SetTarget(c9980826.target)
	e2:SetOperation(c9980826.operation)
	c:RegisterEffect(e2)
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(9980826,1))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCountLimit(1,9980826)
	e2:SetTarget(c9980826.thtg)
	e2:SetOperation(c9980826.thop)
	c:RegisterEffect(e2)
	--SPSUMMON
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(9980826,2))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,99808260)
	e1:SetCondition(c9980826.spcon)
	e1:SetTarget(c9980826.sptg)
	e1:SetOperation(c9980826.spop)
	c:RegisterEffect(e1)
end
function c9980826.ffilter(c)
	return c:IsFusionSetCard(0x9bcd,0x3bc2) and c:IsType(TYPE_MONSTER)
end
function c9980826.splimit(e,se,sp,st)
	return bit.band(st,SUMMON_TYPE_FUSION)==SUMMON_TYPE_FUSION
end
function c9980826.sumsuc(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_MUSIC,0,aux.Stringid(9980826,3))
end
function c9980826.disop(e,tp,eg,ep,ev,re,r,rp)
	if ep==tp or Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)~=Duel.GetFieldGroupCount(tp,0,LOCATION_HAND) then return end
	local rc=re:GetHandler()
	if Duel.NegateEffect(ev) and rc:IsRelateToEffect(re) then
		Duel.Destroy(rc,REASON_EFFECT)
	end
end
function c9980826.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil) end
	local rt=Duel.GetTargetCount(nil,tp,0,LOCATION_ONFIELD,nil)
	if rt>2 then rt=2 end
	local cg=Duel.DiscardHand(tp,Card.IsDiscardable,1,rt,REASON_COST+REASON_DISCARD,nil)
	e:SetLabel(cg)
end
function c9980826.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsControler(1-tp) end
	if chk==0 then return Duel.IsExistingTarget(nil,tp,0,LOCATION_ONFIELD,1,nil) end
	local ct=e:GetLabel()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,nil,tp,0,LOCATION_ONFIELD,ct,ct,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,ct,0,0)
end
function c9980826.operation(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local rg=tg:Filter(Card.IsRelateToEffect,nil,e)
	if rg:GetCount()>0 then
		Duel.Destroy(rg,REASON_EFFECT)
		Duel.Hint(HINT_MUSIC,0,aux.Stringid(9980826,4))
	end
end
function c9980826.thfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c9980826.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE+LOCATION_GRAVE) and c9980826.thfilter(chkc) end
	if chk==0 then return e:GetHandler():GetFlagEffect(9980826)==0
		and Duel.IsExistingTarget(c9980826.thfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,LOCATION_MZONE+LOCATION_GRAVE,1,nil) end
	local b1=Duel.IsExistingTarget(c9980826.thfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil)
	local b2=Duel.IsExistingTarget(c9980826.thfilter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil)
	local op=0
	if b1 and b2 then
		op=Duel.SelectOption(tp,aux.Stringid(9980826,5),aux.Stringid(9980826,6))
	else
		op=2
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=nil
	if op==0 then
		g=Duel.SelectTarget(tp,c9980826.thfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	elseif op==1 then
		g=Duel.SelectTarget(tp,c9980826.thfilter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,1,nil)
	else
		g=Duel.SelectTarget(tp,c9980826.thfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,LOCATION_MZONE+LOCATION_GRAVE,1,1,nil)
	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c9980826.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.Hint(HINT_MUSIC,0,aux.Stringid(9980826,4))
	end
end
function c9980826.check()
	local tc=Duel.GetFieldCard(0,LOCATION_SZONE,5)
	if tc and tc:IsFaceup() then return true end
	tc=Duel.GetFieldCard(1,LOCATION_SZONE,5)
	return tc and tc:IsFaceup()
end
function c9980826.spcon(e,tp,eg,ep,ev,re,r,rp)
	return c9980826.check()
end
function c9980826.spfilter(c,e,tp)
	return c:IsLevelBelow(3) and c:IsType(TYPE_TUNER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c9980826.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE+LOCATION_REMOVED) and chkc:IsControler(tp) and c9980826.spfilter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c9980826.spfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c9980826.spfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c9980826.spop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end
