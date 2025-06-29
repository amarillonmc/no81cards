--翼冠·驭狂龙·奥尔多佐拉
function c11570001.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,aux.FilterBoolFunction(Card.IsFusionSetCard,0x810),2,true)
	--splimit
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e0:SetCode(EVENT_SPSUMMON_SUCCESS)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e0:SetCondition(c11570001.regcon)
	e0:SetOperation(c11570001.regop)
	c:RegisterEffect(e0)
	--spsummon rule
	local se1=Effect.CreateEffect(c)
	se1:SetType(EFFECT_TYPE_FIELD)
	se1:SetCode(EFFECT_SPSUMMON_PROC)
	se1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	--se1:SetCountLimit(1,11570001+EFFECT_COUNT_CODE_OATH)
	se1:SetRange(LOCATION_EXTRA+LOCATION_GRAVE)
	se1:SetCondition(c11570001.spcon)
	se1:SetOperation(c11570001.spop)
	se1:SetValue(SUMMON_VALUE_SELF)
	c:RegisterEffect(se1)
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	--e1:SetRange(LOCATION_EXTRA)
	e1:SetValue(c11570001.splimit)
	c:RegisterEffect(e1)
	--dissummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(11570001,0))
	e2:SetCategory(CATEGORY_DISABLE_SUMMON+CATEGORY_SPECIAL_SUMMON+CATEGORY_TODECK)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_SPSUMMON)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,11670001)
	e2:SetCost(c11570001.cost)
	e2:SetCondition(c11570001.condition)
	e2:SetTarget(c11570001.target)
	e2:SetOperation(c11570001.operation)
	c:RegisterEffect(e2)
	--to grave
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(11570001,1))
	e3:SetCategory(CATEGORY_TOGRAVE)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,11770001)
	e3:SetTarget(c11570001.tgtg)
	e3:SetOperation(c11570001.tgop)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_DISABLE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetValue(1)
	e4:SetCondition(c11570001.condition3)
	c:RegisterEffect(e4)
end
function c11570001.regcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsSummonType(SUMMON_TYPE_FUSION) or c:IsSummonType(SUMMON_VALUE_SELF)
end
function c11570001.regop(e,tp,eg,ep,ev,re,r,rp)
	Duel.RegisterFlagEffect(tp,11570001,RESET_PHASE+PHASE_END,0,1)
end
function c11570001.splimit(e,se,sp,st)
	return (bit.band(st,SUMMON_TYPE_FUSION)==SUMMON_TYPE_FUSION and Duel.GetFlagEffect(sp,11570001)==0) or not e:GetHandler():IsLocation(LOCATION_EXTRA)
end
function c11570001.spcfilter(c)
	return c:IsFaceupEx() and c:IsSetCard(0x810) and c:IsAbleToGraveAsCost()
end
function c11570001.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local mg=Duel.GetMatchingGroup(c11570001.spcfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,nil)
	return mg:CheckSubGroup(aux.mzctcheck,2,2,tp)
end
function c11570001.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local mg=Duel.GetMatchingGroup(c11570001.spcfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local sg=mg:SelectSubGroup(tp,aux.mzctcheck,false,2,2,tp)
	Duel.SendtoGrave(sg,REASON_COST)
end
function c11570001.condition(e,tp,eg,ep,ev,re,r,rp)
	return tp~=ep and Duel.GetCurrentChain()==0
end
function c11570001.cormfilter(c)
	return c:IsSetCard(0x810) and c:IsAbleToRemoveAsCost()
end
function c11570001.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c11570001.cormfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c11570001.cormfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c11570001.filter(c)
	return c:IsSetCard(0x810) and c:IsAbleToRemove()
end
function c11570001.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE_SUMMON,eg,eg:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,eg,eg:GetCount(),0,0)
--  Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,eg,eg:GetCount(),0,0)
end
function c11570001.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
		local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
		if ft<=0 then return end
		Duel.NegateSummon(eg)
		Duel.SendtoDeck(eg,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
		local tg=Duel.GetOperatedGroup()
		if tg:IsExists(Card.IsLocation,1,nil,LOCATION_DECK) then Duel.ShuffleDeck(1-tp) end
		local ssg=tg:Filter(Card.IsLocation,nil,LOCATION_DECK+LOCATION_EXTRA)
		local sg=ssg:Filter(Card.IsCanBeSpecialSummoned,nil,e,0,tp,true,false)
		if sg:GetCount()>1 and Duel.IsPlayerAffectedByEffect(tp,59822133) then return end
		if Duel.SelectYesNo(tp,aux.Stringid(11570001,3)) then
		if sg:GetCount()>ft then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			sg=sg:Select(tp,ft,ft,nil)
		end
		Duel.BreakEffect()
		local sc=sg:GetFirst()
		while sc do
			Duel.SpecialSummonStep(sc,0,tp,tp,true,false,POS_FACEUP)
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetDescription(aux.Stringid(11570001,2))
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CLIENT_HINT)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_ADD_SETCODE)
			e1:SetValue(0x810)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			sc:RegisterEffect(e1)
			local e2=Effect.CreateEffect(e:GetHandler())
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_CHANGE_RACE)
			e2:SetValue(RACE_DRAGON)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD)
			sc:RegisterEffect(e2)
			local e3=Effect.CreateEffect(e:GetHandler())
			e3:SetType(EFFECT_TYPE_SINGLE)
			e3:SetCode(EFFECT_CHANGE_ATTRIBUTE)
			e3:SetValue(ATTRIBUTE_DARK)
			e3:SetReset(RESET_EVENT+RESETS_STANDARD)
			sc:RegisterEffect(e3)
			sc:SetStatus(STATUS_SUMMON_DISABLED,false)
			sc:SetStatus(STATUS_SUMMONING,true)
			sc=sg:GetNext()
		end
		Duel.SpecialSummonComplete()
	end
end
function c11570001.cfilter2(c,tp)
	return c:IsFaceup() and c:IsSetCard(0x810) and c:IsControler(tp)
end
function c11570001.spcon2(e,tp,eg,ep,ev,re,r,rp)
	return not eg:IsContains(e:GetHandler()) and eg:IsExists(c11570001.cfilter2,1,nil,tp) and Duel.IsExistingMatchingCard(c11570001.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c11570001.spfilter(c,e,tp)
	return c:IsSetCard(0x810) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c11570001.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=Duel.GetMatchingGroup(nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,1,0,0)
end
function c11570001.tgop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	if g:GetCount()>0 then
		Duel.HintSelection(g)
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
end
function c11570001.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x3810)
end
function c11570001.condition3(e)
	local tp=e:GetHandler():GetControler()
	return not Duel.IsExistingMatchingCard(c11570001.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
