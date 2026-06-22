--撕裂平行而来的龙 撒格纳特
function c19210000.initial_effect(c)
	--copy
	local e1=Effect.CreateEffect(c)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)--TIMING_END_PHASE
	e1:SetDescription(aux.Stringid(19210000,0))
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(2)
	e1:SetCost(c19210000.cpcost)
	e1:SetTarget(c19210000.cptg)
	e1:SetOperation(c19210000.cpop)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(19210000,1))
	e2:SetCategory(CATEGORY_REMOVE+CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_REMOVE)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,19210000)
	e2:SetTarget(c19210000.sptg)
	e2:SetOperation(c19210000.spop)
	c:RegisterEffect(e2)
	--
	if not c19210000.global_check then
		c19210000.global_check=true
		c19210000.effect_list={}
	end
end
function c19210000.cpcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,19210000)==0 end
	Duel.RegisterFlagEffect(tp,19210000,RESET_CHAIN,0,1)
end
function c19210000.efilter(e)
	local ct=#c19210000.effect_list
	if e:GetCode()==EVENT_SPSUMMON_SUCCESS and (e:GetType()&EFFECT_TYPE_SINGLE)~=0 and e:IsActivated() then c19210000.effect_list[ct+1]=e end
	return false--(e:GetCode()==EVENT_SUMMON_SUCCESS or e:GetCode()==EVENT_SPSUMMON_SUCCESS) and e:IsActivated()
end
function c19210000.cfilter(c,e,tp,eg,ep,ev,re,r,rp)
	if not ((c:IsSetCard(0xb56) or aux.IsSetNameMonsterListed(c,0xb56)) and c:IsType(TYPE_MONSTER) and c:IsFaceup() and not c:IsHasEffect(19210000)) then return false end
	c19210000.effect_list={}
	c:IsOriginalEffectProperty(c19210000.efilter)
	for _,te in ipairs(c19210000.effect_list) do
		local tg=te:GetTarget()
		if (not tg or tg(e,tp,eg,ep,ev,re,r,rp,0)) then return true end
	end
	return false
end
function c19210000.cptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingTarget(c19210000.cfilter,tp,LOCATION_REMOVED,0,1,nil,e,tp,eg,ep,ev,re,r,rp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
	local tc=Duel.SelectTarget(tp,c19210000.cfilter,tp,LOCATION_REMOVED,0,1,1,nil,e,tp,eg,ep,ev,re,r,rp):GetFirst()
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(19210000)
	e1:SetTargetRange(LOCATION_REMOVED,0)
	e1:SetTarget(aux.TargetBoolFunction(Card.IsCode,tc:GetCode()))
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c19210000.cpop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToChain() then return end
	c19210000.effect_list={}
	tc:IsOriginalEffectProperty(c19210000.efilter)
	local e_list={}
	for _,te in ipairs(c19210000.effect_list) do
		local tg=te:GetTarget()
		if not tg or tg(e,tp,eg,ep,ev,re,r,rp,0) then table.insert(e_list,te) end--if tg and not tg(e,tp,eg,ep,ev,re,r,rp,0) then table.remove(c19210000.effect_list,i) end
	end
	local te=e_list[1]
	if #e_list>1 then
		local des_list={}
		for _,te in ipairs(e_list) do table.insert(des_list,te:GetDescription()) end
		local op=Duel.SelectOption(tp,table.unpack(des_list))
		te=e_list[op+1]
	end
	c19210000.effect_list={}
	--copy
	e:SetProperty(te:GetProperty())
	local tg=te:GetTarget()
	if tg then tg(e,tp,eg,ep,ev,re,r,rp,1) end
	local op=te:GetOperation()
	if op then op(e,tp,eg,ep,ev,re,r,rp) end
	e:SetProperty(EFFECT_FLAG_CARD_TARGET)--Original Property
end
function c19210000.rmfilter(c)
	return (c:IsSetCard(0xb56) and c:IsType(TYPE_MONSTER) or aux.IsSetNameMonsterListed(c,0xb56)) and c:IsAbleToRemove()
end
function c19210000.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetMZoneCount(tp)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.IsExistingMatchingCard(c19210000.rmfilter,tp,LOCATION_DECK+LOCATION_EXTRA,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_DECK+LOCATION_EXTRA)
end
function c19210000.spop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local tc=Duel.SelectMatchingCard(tp,c19210000.rmfilter,tp,LOCATION_DECK+LOCATION_EXTRA,0,1,1,nil):GetFirst()
	if tc and Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)~=0 then
		local c=e:GetHandler()
		if c:IsRelateToChain() then
			Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
		end
	end
	--if not c:IsRelateToChain() or Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)==0 then return end
end
