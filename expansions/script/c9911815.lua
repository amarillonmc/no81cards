--磨牙吮血烬灵
function c9911815.initial_effect(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,9911815)
	e1:SetTarget(c9911815.sptg)
	e1:SetOperation(c9911815.spop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	--destroy
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,9911816)
	e3:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e3:SetTarget(c9911815.destg)
	e3:SetOperation(c9911815.desop)
	c:RegisterEffect(e3)
	--set
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_DESTROYED)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetCountLimit(1,9911817)
	e4:SetTarget(c9911815.settg)
	e4:SetOperation(c9911815.setop)
	c:RegisterEffect(e4)
end
function c9911815.spfilter(c,e,tp)
	local b1=c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,tp)
		and (Duel.GetMZoneCount(tp)>0 or Duel.IsExistingMatchingCard(c9911815.unlockfilter,tp,LOCATION_MZONE,0,1,nil,tp))
	local b2=c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,1-tp)
		and (Duel.GetMZoneCount(1-tp)>0 or Duel.IsExistingMatchingCard(c9911815.unlockfilter,tp,0,LOCATION_MZONE,1,nil,1-tp))
	return c:IsSetCard(0xa957) and (b1 or b2)
end
function c9911815.unlockfilter(c,tp)
	return c:GetSequence()<5 and Duel.GetMZoneCount(tp,c)>Duel.GetMZoneCount(tp)
end
function c9911815.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9911815.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c9911815.spop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tc=Duel.SelectMatchingCard(tp,c9911815.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp):GetFirst()
	if not tc then return end
	local b1=Duel.GetMZoneCount(tp)>0 or Duel.IsExistingMatchingCard(c9911815.unlockfilter,tp,LOCATION_MZONE,0,1,nil,tp)
	local b2=Duel.GetMZoneCount(1-tp)>0 or Duel.IsExistingMatchingCard(c9911815.unlockfilter,tp,0,LOCATION_MZONE,1,nil,1-tp)
	local toplayer=aux.SelectFromOptions(tp,{b1,aux.Stringid(9911815,0),tp},{b2,aux.Stringid(9911815,1),1-tp})
	local b3=Duel.GetSZoneCount(toplayer)>0
	local b4=Duel.IsExistingMatchingCard(c9911815.unlockfilter,toplayer,LOCATION_MZONE,0,1,nil,toplayer)
	if b4 and (not b3 or Duel.SelectYesNo(tp,aux.Stringid(9911815,2))) then
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(9911815,3))
		local sc=Duel.SelectMatchingCard(tp,c9911815.unlockfilter,toplayer,LOCATION_MZONE,0,1,1,nil,toplayer):GetFirst()
		local zone=1<<sc:GetSequence()
		Duel.Destroy(sc,REASON_RULE)
		Duel.SpecialSummon(tc,0,tp,toplayer,false,false,POS_FACEUP,zone)
	elseif b3 then
		Duel.SpecialSummon(tc,0,tp,toplayer,false,false,POS_FACEUP)
	end
end
function c9911815.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.IsExistingTarget(aux.TRUE,tp,LOCATION_ONFIELD,0,1,nil)
		and Duel.IsExistingTarget(aux.TRUE,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g1=Duel.SelectTarget(tp,aux.TRUE,tp,LOCATION_ONFIELD,0,1,1,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g2=Duel.SelectTarget(tp,aux.TRUE,tp,0,LOCATION_ONFIELD,1,1,nil)
	g1:Merge(g2)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g1,2,0,0)
end
function c9911815.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local tg=g:Filter(Card.IsRelateToEffect,nil,e)
	if tg:GetCount()>0 then
		Duel.Destroy(tg,REASON_EFFECT)
	end
end
function c9911815.setfilter(c)
	return c:IsSetCard(0xa957) and c:IsRace(RACE_PYRO) and not c:IsForbidden()
end
function c9911815.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9911815.setfilter,tp,LOCATION_DECK,0,1,nil)
		and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 end
end
function c9911815.setop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local g=Duel.SelectMatchingCard(tp,c9911815.setfilter,tp,LOCATION_DECK,0,1,1,nil)
	local tc=g:GetFirst()
	if tc and Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetCode(EFFECT_CHANGE_TYPE)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
		e1:SetValue(TYPE_TRAP+TYPE_CONTINUOUS)
		tc:RegisterEffect(e1)
	end
end
