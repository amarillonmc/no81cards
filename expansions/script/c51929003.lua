--集光少女 魔法七色光
function c51929003.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,c51929003.ffilter,7,true)
	aux.AddContactFusionProcedure(c,c51929003.sprfilter,LOCATION_MZONE+LOCATION_GRAVE+LOCATION_REMOVED,0,aux.tdcfop(c))
	--spsummon condition
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetValue(c51929003.splimit)
	c:RegisterEffect(e0)
	--set-mzone
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,51929003)
	e1:SetTarget(c51929003.settg)
	e1:SetOperation(c51929003.setop)
	c:RegisterEffect(e1)
	--set and spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetHintTiming(0,TIMING_MAIN_END)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,51929004)
	e2:SetCondition(c51929003.sscon)
	e2:SetTarget(c51929003.sstg)
	e2:SetOperation(c51929003.ssop)
	c:RegisterEffect(e2)
	--spsummon-self
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(1152)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_CHAINING)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1,51929005)
	e3:SetCondition(c51929003.spcon)
	e3:SetTarget(c51929003.sptg)
	e3:SetOperation(c51929003.spop)
	c:RegisterEffect(e3)
end
function c51929003.ffilter(c,fc,sub,mg,sg)
	return c:IsFusionSetCard(0x3258) and (not sg or not sg:IsExists(Card.IsFusionCode,1,c,c:GetFusionCode()))
end
function c51929003.sprfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToDeckOrExtraAsCost() and (not c:IsLocation(LOCATION_REMOVED) or c:IsFaceup())
end
function c51929003.splimit(e,se,sp,st)
	return bit.band(st,SUMMON_TYPE_FUSION)==SUMMON_TYPE_FUSION
end
function c51929003.setfilter(c)
	return c:GetSequence()<5
end
function c51929003.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingTarget(c51929003.setfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,c) end
end
function c51929003.seqfilter(c,seq)
	return c:GetSequence()==seq
end
function c51929003.setop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c51929003.setfilter,tp,LOCATION_MZONE,LOCATION_MZONE,aux.ExceptThisCard(e))
	for tc in aux.Next(g) do
		if not tc:IsImmuneToEffect(e) then
			local p=tc:GetControler()
			local zone=1<<tc:GetSequence()
			local oc=Duel.GetMatchingGroup(c51929003.seqfilter,p,LOCATION_SZONE,0,nil,tc:GetSequence()):GetFirst()
			if oc then
				Duel.Destroy(oc,REASON_RULE)
			end
			if Duel.MoveToField(tc,p,p,LOCATION_SZONE,POS_FACEUP,true,zone) then
				local e1=Effect.CreateEffect(e:GetHandler())
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_CHANGE_TYPE)
				e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
				e1:SetValue(TYPE_SPELL+TYPE_CONTINUOUS)
				tc:RegisterEffect(e1)
			end
		end
	end
end
function c51929003.sscon(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return ph==PHASE_MAIN1 or ph==PHASE_MAIN2
end
function c51929003.spfilter(c,e,tp)
	return c:GetType()==TYPE_SPELL+TYPE_CONTINUOUS and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsFaceup()
end
function c51929003.sstg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_SZONE) and c51929003.spfilter(chkc) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingMatchingCard(nil,tp,LOCATION_MZONE,0,1,nil)
		and Duel.IsExistingTarget(c51929003.spfilter,tp,LOCATION_SZONE,LOCATION_SZONE,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c51929003.spfilter,tp,LOCATION_SZONE,LOCATION_SZONE,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c51929003.ssop(e,tp,eg,ep,ev,re,r,rp)
	--set
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
	--spsummon
	local sc=Duel.GetFirstTarget()
	if sc:IsRelateToEffect(e) then
		Duel.SpecialSummon(sc,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c51929003.spcon(e,tp,eg,ep,ev,re,r,rp)
	return re:IsActiveType(TYPE_SPELL) and e:GetHandler():GetType()==TYPE_SPELL+TYPE_CONTINUOUS
end
function c51929003.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local zone=1<<c:GetSequence()
	if chk==0 then return c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,tp,zone) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c51929003.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local zone=1<<c:GetSequence()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP,zone)
	end
end
