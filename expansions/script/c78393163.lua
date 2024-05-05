--银河列车·希儿
function c78393163.initial_effect(c)
	--remove
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_BATTLE_START)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,78393163)
	e1:SetCondition(c78393163.rmcon)
	e1:SetTarget(c78393163.rmtg)
	e1:SetOperation(c78393163.rmop)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_REMOVE+CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetHintTiming(0,TIMING_MAIN_END)
	e2:SetCountLimit(1,88393163)
	e2:SetCondition(c78393163.spcon)
	e2:SetTarget(c78393163.sptg)
	e2:SetOperation(c78393163.spop)
	c:RegisterEffect(e2)
end
function c78393163.rmcon(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetAttacker()
	local bc=Duel.GetAttackTarget()
	if not bc then return false end
	if tc:IsControler(1-tp) then tc,bc=bc,tc end
	if tc:IsSetCard(0x746) and bc:GetLevel()>0 and tc:GetLevel()>0 and tc:GetLevel()>bc:GetLevel() then
		e:SetLabelObject(bc)
		return true
	else return false end
end
function c78393163.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local bc=e:GetLabelObject()
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,bc,1,0,0)
end
function c78393163.rmop(e,tp,eg,ep,ev,re,r,rp)
	local bc=e:GetLabelObject()
	if bc:IsRelateToBattle() then
		Duel.Remove(bc,POS_FACEDOWN,REASON_EFFECT)
	end
end
function c78393163.spcon(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return ph==PHASE_MAIN1 or ph==PHASE_MAIN2
end
function c78393163.spfilter(c,e,tp)
	return c:IsFaceup() and c:IsSetCard(0x746) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c78393163.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c78393163.spfilter,tp,LOCATION_REMOVED,0,1,nil,e,tp) end
	local g=Duel.GetMatchingGroup(c78393163.spfilter,tp,LOCATION_REMOVED,0,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c78393163.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.Remove(c,POS_FACEUP,REASON_EFFECT)~=0 then
		local g=Duel.SelectMatchingCard(tp,c78393163.spfilter,tp,LOCATION_REMOVED,0,1,1,c,e,tp)
		if g:GetCount()>0 then Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP) end
	end
end
