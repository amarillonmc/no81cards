--陷阵营花-吕姬
function c9330019.initial_effect(c)
	c:SetSPSummonOnce(9330019)
	aux.AddCodeList(c,9330001,9330019)
	--synchro and xyz limit
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetValue(1)
	c:RegisterEffect(e0)
	--synchro limit
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_TUNER_MATERIAL_LIMIT)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetTarget(c9330019.synlimit)
	c:RegisterEffect(e1)
	--fusion limit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_TUNE_MAGICIAN_F)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetValue(c9330019.limit)
	c:RegisterEffect(e2)
	--xyz limit
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_TUNE_MAGICIAN_X)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e3:SetValue(c9330019.limit)
	c:RegisterEffect(e3)
	--special summon
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetCode(EVENT_TO_GRAVE)
	e4:SetRange(LOCATION_HAND)
	e4:SetCondition(c9330019.con)
	e4:SetTarget(c9330019.tg)
	e4:SetOperation(c9330019.op)
	c:RegisterEffect(e4)
	--special summon2
	local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e5:SetType(EFFECT_TYPE_QUICK_O)
	e5:SetCode(EVENT_FREE_CHAIN)
	e5:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e5:SetRange(LOCATION_HAND)
	e5:SetTarget(c9330019.sptg)
	e5:SetOperation(c9330019.spop)
	c:RegisterEffect(e5)
	--cannot attack
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(9330019,0))
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetOperation(c9330019.limop)
	c:RegisterEffect(e1)
end
function c9330019.synlimit(e,c)
	return c:IsSetCard(0xaf93)
end
function c9330019.limit(e,c)
	return not c:IsSetCard(0xaf93)
end
function c9330019.cfilter(c,tp)
	return bit.band(c:GetPreviousTypeOnField(),TYPE_SPELL+TYPE_TRAP)~=0 and c:IsPreviousControler(tp)
		and c:GetReasonPlayer()==1-tp and c:IsPreviousLocation(LOCATION_ONFIELD)
end
function c9330019.con(e,tp,eg,ep,ev,re,r,rp)
	 return eg:IsExists(c9330019.cfilter,1,nil,tp)
end
function c9330019.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:GetFlagEffect(9330019)==0
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	c:RegisterFlagEffect(9330019,RESET_CHAIN,0,1)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c9330019.setfilter(c,tid)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsLocation(LOCATION_GRAVE) and c:IsSSetable()
		   and c:GetTurnID()==tid and not c:IsReason(REASON_RETURN)
end
function c9330019.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 then
		local ft=Duel.GetLocationCount(tp,LOCATION_SZONE)
		local tg=Duel.GetMatchingGroup(aux.NecroValleyFilter(c9330019.setfilter),tp,LOCATION_GRAVE,0,e,tp,Duel.GetTurnCount())
		if ft>1 and tg:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(9330019,1)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
			local sg=tg:Select(tp,ft,ft,nil)
			Duel.SSet(tp,sg)
		end
	end
end
function c9330019.cfilter(c)
	return c:IsCode(9330001) and c:IsFaceup()
end
function c9330019.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local p=e:GetHandlerPlayer()
	if chk==0 then return c:GetFlagEffect(9330021)==0 and
		((Duel.GetLocationCount(1-p,LOCATION_MZONE)>0
		and c:IsCanBeSpecialSummoned(e,0,p,false,false,POS_FACEUP,1-p))
		or (Duel.GetLocationCount(p,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c9330019.cfilter,p,LOCATION_ONFIELD,0,1,nil)
		and c:IsCanBeSpecialSummoned(e,0,p,false,false,POS_FACEUP))) end
	c:RegisterFlagEffect(9330021,RESET_CHAIN,0,1)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c9330019.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local p=e:GetHandlerPlayer()
	if not c:IsRelateToEffect(e) then return end
	if Duel.IsExistingMatchingCard(c9330019.cfilter,p,LOCATION_ONFIELD,0,1,nil)
	   and Duel.SelectYesNo(p,aux.Stringid(9330019,0)) then
	   Duel.SpecialSummon(c,0,p,p,false,false,POS_FACEUP)
	else
	   Duel.SpecialSummon(c,0,p,1-p,false,false,POS_FACEUP)
	end
end
function c9330019.limop(e,tp,eg,ep,ev,re,r,rp,c)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_ATTACK)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetTarget(c9330019.atktg)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end 
function c9330019.atktg(e,c)
	return not c:IsSetCard(0xaf93)
end
