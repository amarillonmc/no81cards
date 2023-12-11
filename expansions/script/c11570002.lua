--翼冠·结界龙·内布里姆
function c11570002.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(11570002,0))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e1:SetCountLimit(1,11570002+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c11570002.sprcon)
	e1:SetTarget(c11570002.sprtg)
	e1:SetOperation(c11570002.sprop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(11570002,1))
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,11670002)
	e2:SetTarget(c11570002.tftg)
	e2:SetOperation(c11570002.tfop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(11570002,2))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e4:SetCode(EVENT_LEAVE_FIELD)
	e4:SetRange(LOCATION_HAND+LOCATION_MZONE+LOCATION_GRAVE)
	e4:SetCountLimit(1,11770002)
	e4:SetCondition(c11570002.spcon)
	e4:SetCost(c11570002.spcost)
	e4:SetTarget(c11570002.sptg)
	e4:SetOperation(c11570002.spop)
	c:RegisterEffect(e4)
end
function c11570002.sprfilter(c)
	return c:IsFaceupEx() and c:IsAbleToRemoveAsCost()
		and c:IsSetCard(0x810)
end
function c11570002.gcheck(g,tp)
	return Duel.GetMZoneCount(tp,g)>0
end
function c11570002.sprcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local g=Duel.GetMatchingGroup(c11570002.sprfilter,tp,LOCATION_GRAVE+LOCATION_ONFIELD,0,e:GetHandler())
	return g:CheckSubGroup(c11570002.gcheck,1,1,tp) and Duel.IsExistingMatchingCard(c11570002.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c11570002.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x3810)
end
function c11570002.sprtg(e,tp,eg,ep,ev,re,r,rp,chk,c)
	local g=Duel.GetMatchingGroup(c11570002.sprfilter,tp,LOCATION_GRAVE+LOCATION_ONFIELD,0,e:GetHandler())
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local sg=g:SelectSubGroup(tp,c11570002.gcheck,false,1,1,tp)
	if sg then
		sg:KeepAlive()
		e:SetLabelObject(sg)
		return true
	else return false end
end
function c11570002.sprop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=e:GetLabelObject()
	Duel.Remove(g,POS_FACEUP,REASON_COST)
	g:DeleteGroup()
end
function c11570002.tffilter(c,tp)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSetCard(0x810)
		and not c:IsForbidden() and c:CheckUniqueOnField(tp)
end
function c11570002.tftg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingMatchingCard(c11570002.tffilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,tp) end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function c11570002.tfop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local tc=Duel.SelectMatchingCard(tp,c11570002.tffilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,tp):GetFirst()
	if tc and tc:IsType(TYPE_FIELD) then
		local fc=Duel.GetFieldCard(tp,LOCATION_SZONE,5)
		if fc then
			Duel.SendtoGrave(fc,REASON_RULE)
			Duel.BreakEffect()
		end
		Duel.MoveToField(tc,tp,tp,LOCATION_FZONE,POS_FACEUP,true)
	elseif tc then
		Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	end
end
function c11570002.cfilter1(c,tp)
	return c:IsPreviousControler(tp) and c:IsSetCard(0x3810) and c:GetReasonPlayer()==1-tp
end
function c11570002.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg and eg:IsExists(c11570002.cfilter1,1,nil,tp) and not eg:IsContains(e:GetHandler())
end
function c11570002.cfilter2(c)
	return c:IsRace(RACE_DRAGON) and not c:IsType(TYPE_TUNER) and c:IsAbleToRemoveAsCost()
end
function c11570002.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToRemoveAsCost()
		and Duel.IsExistingMatchingCard(c11570002.cfilter2,tp,LOCATION_GRAVE,0,1,c) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c11570002.cfilter2,tp,LOCATION_GRAVE,0,1,1,c)
	g:AddCard(c)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c11570002.spfilter(c,e,tp)
	return c:IsType(TYPE_SYNCHRO) and c:IsCode(11570008)
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_SYNCHRO,tp,false,false)
end
function c11570002.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c11570002.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp)
		and aux.MustMaterialCheck(nil,tp,EFFECT_MUST_BE_SMATERIAL) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c11570002.spop(e,tp,eg,ep,ev,re,r,rp)
	if not aux.MustMaterialCheck(nil,tp,EFFECT_MUST_BE_SMATERIAL) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sc=Duel.SelectMatchingCard(tp,c11570002.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp):GetFirst()
	if sc then
		sc:SetMaterial(nil)
	   if Duel.SpecialSummon(sc,SUMMON_TYPE_SYNCHRO,tp,tp,false,false,POS_FACEUP)>0 then
			sc:CompleteProcedure()
		end
	end
end