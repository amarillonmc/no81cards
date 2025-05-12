--亚斯克第一王子 阿方冯思
function c75080018.initial_effect(c)
	--change code
	aux.EnableChangeCode(c,75080003,LOCATION_MZONE+LOCATION_GRAVE)
	--link summon
	aux.AddLinkProcedure(c,nil,2,2,c75080018.lcheck)
	c:EnableReviveLimit()
	--indes
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e0:SetCode(EVENT_SPSUMMON_SUCCESS)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e0:SetCondition(c75080018.regcon)
	e0:SetOperation(c75080018.regop)
	c:RegisterEffect(e0)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetHintTiming(0,TIMING_END_PHASE)
	e1:SetCountLimit(1,75080018)
	e1:SetCondition(c75080018.spcon)
	e1:SetTarget(c75080018.sptg)
	e1:SetOperation(c75080018.spop)
	c:RegisterEffect(e1)
	--
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetHintTiming(TIMING_STANDBY_PHASE)
	e2:SetCountLimit(1,75080018)
	e2:SetCost(c75080018.cost)
	e2:SetOperation(c75080018.operation)
	c:RegisterEffect(e2)
end
function c75080018.lcheck(g,lc)
	return g:IsExists(Card.IsLinkSetCard,1,nil,0x3754)
end
function c75080018.regcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function c75080018.regop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():RegisterFlagEffect(75080018,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
end
function c75080018.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(75080018)~=0
end
function c75080018.spfilter(c,e,tp,zone)
	return c:IsSetCard(0x3754) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,tp,zone)
end
function c75080018.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local zone=e:GetHandler():GetLinkedZone()
		return zone~=0 and Duel.GetMZoneCount(tp)>0
			and Duel.IsExistingMatchingCard(c75080018.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp,zone)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c75080018.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local zone=c:GetLinkedZone()
	if c:IsRelateToEffect(e) and zone~=0 and Duel.GetMZoneCount(tp)>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,c75080018.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp,zone)
		if g:GetCount()>0 then
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP,zone)
		end
	end
end
function c75080018.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_COST)
end
function c75080018.operation(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_INACTIVATE)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetValue(c75080018.effectfilter)
	Duel.RegisterEffect(e1,tp)
end
function c75080018.effectfilter(e,ct)
	local te,tp=Duel.GetChainInfo(ct,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_PLAYER)
	return e:GetHandler():GetControler()==tp and te:GetHandler():IsSetCard(0x3754)
end
