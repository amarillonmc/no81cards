--终末旅者指挥 索尔仁尼琴
function c64831007.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(nil),1)
	c:EnableReviveLimit()
	--move
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,64831007)
	e1:SetCost(c64831007.cost)
	e1:SetTarget(c64831007.target)
	e1:SetOperation(c64831007.activate)
	c:RegisterEffect(e1)
	Duel.AddCustomActivityCounter(64831007,ACTIVITY_SPSUMMON,c64831007.counterfilter)
	--synchro level
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_SYNCHRO_LEVEL)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(c64831007.slevel)
	c:RegisterEffect(e2)
end
function c64831007.slevel(e,c)
	local lv=e:GetHandler():GetLevel()
	return 4*65536+lv
end
function c64831007.counterfilter(c)
	return c:IsType(TYPE_SYNCHRO) or c:GetSummonLocation()~=LOCATION_EXTRA 
end
function c64831007.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetCustomActivityCount(64831007,tp,ACTIVITY_SPSUMMON)==0 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c64831007.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c64831007.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return not c:IsType(TYPE_SYNCHRO) and c:IsLocation(LOCATION_EXTRA)
end
function c64831007.filter(c,e,tp)
	return c:IsType(TYPE_SYNCHRO) and c:IsFaceup() and ((c:GetSequence()>4 and Duel.GetLocationCount(tp,LOCATION_MZONE)>2) or Duel.GetLocationCount(tp,LOCATION_MZONE)>1) 
end
function c64831007.spfilter(c,e,tp,race,att)
	return c:IsType(TYPE_TUNER) and c:IsSetCard(0x5410) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c64831007.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c64831007.filter(chkc,e,tp) end
	if chk==0 then return Duel.IsExistingTarget(c64831007.filter,tp,LOCATION_MZONE,0,1,nil,e,tp) end
	local g=Duel.SelectTarget(tp,c64831007.filter,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c64831007.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local c=e:GetHandler()
	if not tc:IsRelateToEffect(e) or (tc:IsControler(tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)<1) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOZONE)
	local s=Duel.SelectDisableField(tp,1,LOCATION_MZONE,0,0)
	local nseq=math.log(s,2)
	Duel.MoveSequence(tc,nseq)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(c64831007.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) then
		Duel.BreakEffect()
		local g=Duel.SelectMatchingCard(tp,c64831007.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
		local gc=g:GetFirst()
		Duel.SpecialSummonStep(gc,0,tp,tp,false,false,POS_FACEUP)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		gc:RegisterEffect(e1,true)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		gc:RegisterEffect(e2,true)
		Duel.SpecialSummonComplete()
	end
end