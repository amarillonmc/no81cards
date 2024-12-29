--集光少女 魔法交错光
function c51929000.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,aux.FilterBoolFunction(Card.IsFusionSetCard,0x3258),2,true)
	aux.AddContactFusionProcedure(c,c51929000.sprfilter,LOCATION_MZONE+LOCATION_GRAVE+LOCATION_REMOVED,0,aux.tdcfop(c))
	--spsummon condition
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetValue(c51929000.splimit)
	c:RegisterEffect(e0)
	--set-deck
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,51929000)
	e1:SetTarget(c51929000.settg)
	e1:SetOperation(c51929000.setop)
	c:RegisterEffect(e1)
	--set-mzone
	local e2=Effect.CreateEffect(c)
	e2:SetHintTiming(0,TIMING_MAIN_END)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,51929001)
	e2:SetCondition(c51929000.setcon2)
	e2:SetTarget(c51929000.settg2)
	e2:SetOperation(c51929000.setop2)
	c:RegisterEffect(e2)
	--spsummon-self
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(1152)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_CHAINING)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1,51929002)
	e3:SetCondition(c51929000.spcon)
	e3:SetTarget(c51929000.sptg)
	e3:SetOperation(c51929000.spop)
	c:RegisterEffect(e3)
	--cannot be fusion material
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_CANNOT_BE_FUSION_MATERIAL)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e4:SetValue(1)
	c:RegisterEffect(e4)
end
function c51929000.sprfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToDeckOrExtraAsCost() and (not c:IsLocation(LOCATION_REMOVED) or c:IsFaceup())
end
function c51929000.splimit(e,se,sp,st)
	return bit.band(st,SUMMON_TYPE_FUSION)==SUMMON_TYPE_FUSION
end
function c51929000.setfilter1(c,tp)
	return c:IsSetCard(0x3258) and c:IsType(TYPE_MONSTER) and not c:IsForbidden()
		and Duel.IsExistingMatchingCard(c51929000.setfilter2,tp,LOCATION_DECK,0,1,nil,c:GetCode())
end
function c51929000.setfilter2(c,code)
	return c:IsSetCard(0x3258) and c:IsType(TYPE_MONSTER) and not c:IsForbidden() and not c:IsCode(code)
end
function c51929000.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>=2
		and Duel.IsExistingMatchingCard(c51929000.setfilter1,tp,LOCATION_DECK,0,1,nil,tp) end
end
function c51929000.setop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<2 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local tc1=Duel.SelectMatchingCard(tp,c51929000.setfilter1,tp,LOCATION_DECK,0,1,1,nil,tp):GetFirst()
	if not tc1 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local tc2=Duel.SelectMatchingCard(tp,c51929000.setfilter2,tp,LOCATION_DECK,0,1,1,nil,tc1:GetCode()):GetFirst()
	if Duel.MoveToField(tc1,tp,tp,LOCATION_SZONE,POS_FACEUP,false) then
		if Duel.MoveToField(tc2,tp,tp,LOCATION_SZONE,POS_FACEUP,false) then
			tc2:SetStatus(STATUS_EFFECT_ENABLED,true)
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_CHANGE_TYPE)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetValue(TYPE_SPELL+TYPE_CONTINUOUS)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
			tc2:RegisterEffect(e1)
		end
		tc1:SetStatus(STATUS_EFFECT_ENABLED,true)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_TYPE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetValue(TYPE_SPELL+TYPE_CONTINUOUS)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
		tc1:RegisterEffect(e1)
	end
end
function c51929000.setcon2(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return ph==PHASE_MAIN1 or ph==PHASE_MAIN2
end
function c51929000.ffilter(c,tp)
	return c:IsCode(51929013) and c:IsType(TYPE_FIELD) and not c:IsForbidden() and c:CheckUniqueOnField(tp)
end
function c51929000.settg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingMatchingCard(nil,tp,LOCATION_MZONE,0,1,nil)
		and Duel.IsExistingMatchingCard(c51929000.ffilter,tp,LOCATION_DECK,0,1,1,nil,tp) end
end
function c51929000.setop2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
	local mc=Duel.SelectMatchingCard(tp,nil,tp,LOCATION_MZONE,0,1,1,nil):GetFirst()
	if not mc then return end
	Duel.HintSelection(Group.FromCards(mc))
	if mc:IsImmuneToEffect(e) then return end
	Duel.MoveToField(mc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetCode(EFFECT_CHANGE_TYPE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
	e1:SetValue(TYPE_SPELL+TYPE_CONTINUOUS)
	mc:RegisterEffect(e1)
	--field
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local tc=Duel.SelectMatchingCard(tp,c51929000.ffilter,tp,LOCATION_DECK,0,1,1,nil,tp):GetFirst()
	if tc then
		local fc=Duel.GetFieldCard(tp,LOCATION_SZONE,5)
		if fc then
			Duel.SendtoGrave(fc,REASON_RULE)
			Duel.BreakEffect()
		end
		Duel.MoveToField(tc,tp,tp,LOCATION_FZONE,POS_FACEUP,true)
	end
end
function c51929000.spcon(e,tp,eg,ep,ev,re,r,rp)
	return re:IsActiveType(TYPE_SPELL) and e:GetHandler():GetType()==TYPE_SPELL+TYPE_CONTINUOUS
end
function c51929000.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local zone=1<<c:GetSequence()
	if chk==0 then return c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,tp,zone) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c51929000.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local zone=1<<c:GetSequence()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP,zone)
	end
end
