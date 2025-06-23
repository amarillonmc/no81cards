--闪耀的紫焰光 白濑咲耶
function c28317560.initial_effect(c)
	--antica spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DAMAGE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,28317560)
	e1:SetCondition(c28317560.spcon)
	e1:SetTarget(c28317560.sptg)
	e1:SetOperation(c28317560.spop)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(28317560,1))
	e2:SetCategory(CATEGORY_DAMAGE+CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,38317560)
	e2:SetCondition(c28317560.spcon2)
	e2:SetTarget(c28317560.sptg2)
	e2:SetOperation(c28317560.spop2)
	c:RegisterEffect(e2)
end
function c28317560.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp or (Duel.GetCurrentPhase()>=PHASE_BATTLE_START and Duel.GetCurrentPhase()<=PHASE_BATTLE)
end
function c28317560.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetMZoneCount(tp)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
	if Duel.GetLP(tp)>3000 then
		Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,tp,2000)
	end
end
function c28317560.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.GetMZoneCount(tp)>0 then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
	if Duel.GetLP(tp)>3000 then
		Duel.Damage(tp,2000,REASON_EFFECT)
	end
end
function c28317560.cfilter(c,tp)
	return c:IsFaceup() and c:IsSetCard(0x283) and c:IsControler(tp)
end
function c28317560.spcon2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp and not eg:IsContains(e:GetHandler()) and eg:IsExists(c28317560.cfilter,1,nil,tp)
end
function c28317560.spfilter(c,e,tp)
	return c:IsSetCard(0x283) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c28317560.sptg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(500)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,500)
end
function c28317560.spop2(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Damage(p,d,REASON_EFFECT)
	if Duel.GetLP(tp)<=3000 and Duel.IsExistingMatchingCard(c28317560.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.SelectYesNo(tp,aux.Stringid(28317560,2)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c28317560.spfilter),tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
		if g:GetCount()>0 then
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end
