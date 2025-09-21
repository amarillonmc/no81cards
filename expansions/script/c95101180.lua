--不可思议之国<机械降神>暗黑舞台装置-古·兰·吉·涅·尔
function c95101180.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcCodeFun(c,95101001,aux.FilterBoolFunction(Card.IsFusionSetCard,0xbbe),4,true,true)
	--turn skip
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(95101180,0))
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,95101180)
	e1:SetTarget(c95101180.skiptg)
	e1:SetOperation(c95101180.skipop)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetHintTiming(0,TIMING_END_PHASE)
	e2:SetDescription(aux.Stringid(95101180,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,95101180+1)
	e2:SetTarget(c95101180.sptg)
	e2:SetOperation(c95101180.spop)
	c:RegisterEffect(e2)
	--special summon-self
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(95101180,2))
	e3:SetCategory(CATEGORY_REMOVE)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_REMOVE)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetRange(LOCATION_REMOVED)
	e3:SetCountLimit(1,95101180+2)
	e3:SetCondition(c95101180.spscon)
	e3:SetCost(c95101180.spscost)
	e3:SetTarget(c95101180.spstg)
	e3:SetOperation(c95101180.spsop)
	c:RegisterEffect(e3)
end
function c95101180.skiptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local p=Duel.GetTurnPlayer()
	if chk==0 then return not Duel.IsPlayerAffectedByEffect(p,EFFECT_SKIP_TURN) end
end
function c95101180.skipop(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetTurnPlayer()
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SKIP_TURN)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetReset(RESET_PHASE+PHASE_END,2)
	Duel.RegisterEffect(e1,p)
end
function c95101180.spfilter(c,e,tp)
	return c:IsSetCard(0xbbe) and c:IsType(TYPE_FUSION) and not c:IsCode(95101180) and c:CheckFusionMaterial() and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0
end
function c95101180.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return aux.MustMaterialCheck(nil,tp,EFFECT_MUST_BE_FMATERIAL)
		and Duel.IsExistingMatchingCard(c95101180.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c95101180.spop(e,tp,eg,ep,ev,re,r,rp)
	if not aux.MustMaterialCheck(nil,tp,EFFECT_MUST_BE_FMATERIAL) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tc=Duel.SelectMatchingCard(tp,c95101180.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp):GetFirst()
	if not tc then return end
	tc:SetMaterial(nil)
	if Duel.SpecialSummon(tc,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP)~=0 then
		tc:CompleteProcedure()
	end
end
function c95101180.chkfilter(c)
	return not c:IsType(TYPE_TOKEN)
end
function c95101180.spscon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c95101180.chkfilter,1,nil)
end
function c95101180.spscost(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(Card.IsReleasable,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	if chk==0 then return #g==12 and Duel.GetMZoneCount(tp,g>0 end
	Duel.Release(g,REASON_COST)
end
function c95101180.spstg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c95101180.spsop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
