--暗之数码兽 座天使兽·X抗体
function c16368165.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcCodeFun(c,50218137,aux.FilterBoolFunction(Card.IsFusionSetCard,0xdc3),1,false,false)
	--spsummon condition
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	e0:SetValue(c16368165.splimit)
	c:RegisterEffect(e0)
	--atkdown
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(0,LOCATION_MZONE)
	e1:SetValue(c16368165.atkval)
	c:RegisterEffect(e1)
	--draw
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(16368165,1))
	e2:SetCategory(CATEGORY_DRAW+CATEGORY_TOGRAVE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCountLimit(1,16368165)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER,TIMING_END_PHASE)
	e2:SetTarget(c16368165.target)
	e2:SetOperation(c16368165.activate)
	c:RegisterEffect(e2)
	--spsummon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(16368165,2))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_RECOVER)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_MZONE)
	e3:SetHintTiming(0,TIMING_END_PHASE)
	e3:SetCountLimit(1,16368165+1)
	e3:SetCondition(c16368165.spcon)
	e3:SetTarget(c16368165.sptg)
	e3:SetOperation(c16368165.spop)
	c:RegisterEffect(e3)
end
function c16368165.splimit(e,se,sp,st)
	return bit.band(st,SUMMON_TYPE_FUSION)==SUMMON_TYPE_FUSION or se:GetHandler():IsCode(16364073)
		or not e:GetHandler():IsLocation(LOCATION_EXTRA)
end
function c16368165.atkfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xdc3,0xcb1)
end
function c16368165.atkval(e,c)
	return Duel.GetMatchingGroupCount(c16368165.atkfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,nil)*-300
end
function c16368165.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c16368165.tgfilter(c,atk)
	return c:IsAbleToGrave() and c:IsFaceup() and c:IsAttackBelow(atk)
end
function c16368165.activate(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	if Duel.Draw(p,d,REASON_EFFECT)>0 then
		local atk=Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)*1000
		if Duel.IsExistingMatchingCard(c16368165.tgfilter,tp,0,LOCATION_MZONE,1,nil,atk)
			and Duel.SelectYesNo(tp,aux.Stringid(16368165,0)) then
			local g=Duel.SelectMatchingCard(tp,c16368165.tgfilter,tp,0,LOCATION_MZONE,1,1,nil,atk)
			Duel.BreakEffect()
			Duel.SendtoGrave(g,0x40)
		end
	end
end
function c16368165.spfilter(c,e,tp)
	return c:IsSetCard(0xcb1) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and c:IsFaceupEx() and c:GetAttack()>0
end
function c16368165.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_GRAVE,0,1,nil,50218137,16364073)
end
function c16368165.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c16368165.spfilter,tp,LOCATION_HAND+LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE+LOCATION_REMOVED)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,0)
end
function c16368165.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c16368165.spfilter),tp,LOCATION_HAND+LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil,e,tp)
	if g:GetCount()>0 and Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)>0 then
		local rec=g:GetFirst():GetAttack()
		if rec>0 then
			Duel.BreakEffect()
			Duel.Recover(tp,math.ceil(rec/2),0x40)
		end
	end
end