--翼冠·树海龙·博尔赫斯
function c11570007.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(11570002,0))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e1:SetCountLimit(1,11570007+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c11570007.sprcon)
	e1:SetTarget(c11570007.sprtg)
	e1:SetOperation(c11570007.sprop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(11570002,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,11670007)
	e2:SetCost(c11570007.spcost)
	e2:SetTarget(c11570007.sptg)
	e2:SetOperation(c11570007.spop)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_SET_ATTACK)
	e3:SetCondition(c11570007.atkcon)
	e3:SetValue(0)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EFFECT_SET_DEFENSE)
	c:RegisterEffect(e4)
end
function c11570007.sprfilter(c)
	return c:IsFaceupEx() and c:IsAbleToRemoveAsCost()
		and c:IsSetCard(0x810)
end
function c11570007.gcheck(g,tp)
	return Duel.GetMZoneCount(tp,g)>0 and #g==1
end
function c11570007.sprcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local g=Duel.GetMatchingGroup(c11570007.sprfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,e:GetHandler())
	return g:CheckSubGroup(c11570007.gcheck,1,1,tp) and Duel.IsExistingMatchingCard(c11570007.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c11570007.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x3810)
end
function c11570007.sprtg(e,tp,eg,ep,ev,re,r,rp,chk,c)
	local g=Duel.GetMatchingGroup(c11570007.sprfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,e:GetHandler())
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local sg=g:SelectSubGroup(tp,c11570007.gcheck,false,1,1,tp)
	if sg then
		sg:KeepAlive()
		e:SetLabelObject(sg)
		return true
	else return false end
end
function c11570007.sprop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=e:GetLabelObject()
	Duel.Remove(g,POS_FACEUP,REASON_COST)
	g:DeleteGroup()
end
function c11570007.cfilter2(c)
	return c:IsRace(RACE_DRAGON) and c:IsType(TYPE_TUNER) and c:IsAbleToRemoveAsCost()
end
function c11570007.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToRemoveAsCost()
		and Duel.IsExistingMatchingCard(c11570007.cfilter2,tp,LOCATION_HAND+LOCATION_MZONE+LOCATION_GRAVE,0,1,c) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c11570007.cfilter2,tp,LOCATION_HAND+LOCATION_MZONE+LOCATION_GRAVE,0,1,1,c)
	g:AddCard(c)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c11570007.spfilter(c,e,tp)
	return c:IsType(TYPE_SYNCHRO) and c:IsSetCard(0x3810)
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_SYNCHRO,tp,false,false)
end
function c11570007.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c11570007.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp)
		and aux.MustMaterialCheck(nil,tp,EFFECT_MUST_BE_SMATERIAL) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c11570007.spop(e,tp,eg,ep,ev,re,r,rp)
	if not aux.MustMaterialCheck(nil,tp,EFFECT_MUST_BE_SMATERIAL) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sc=Duel.SelectMatchingCard(tp,c11570007.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp):GetFirst()
	if sc then
		sc:SetMaterial(nil)
	   if Duel.SpecialSummon(sc,SUMMON_TYPE_SYNCHRO,tp,tp,false,false,POS_FACEUP)>0 then
			sc:CompleteProcedure()
		end
	end
end
function c11570007.atkcon(e)
	return Duel.GetMatchingGroupCount(c11570007.cfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,nil)==0
end