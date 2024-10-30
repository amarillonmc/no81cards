--奥特维达·库库尔坎
local m=11561068
local cm=_G["c"..m]
function cm.initial_effect(c)
	c:EnableReviveLimit()
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e1)
	--special summon rule
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetCondition(c11561068.sprcon)
	e2:SetTarget(c11561068.sprtg)
	e2:SetOperation(c11561068.sprop)
	c:RegisterEffect(e2)
	--cannot be target
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e3:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetCondition(c11561068.imcon)
	e3:SetTarget(c11561068.imval)
	e3:SetValue(aux.tgoval)
	c:RegisterEffect(e3)
	--special summon
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(11561068,1))
	e4:SetCategory(CATEGORY_TOEXTRA+CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1,11561068)
	e4:SetTarget(c11561068.sptg)
	e4:SetOperation(c11561068.spop)
	c:RegisterEffect(e4)
	
end
function c11561068.cfilter(c,e,tp)
	return c:IsFaceup() and c:IsType(TYPE_SYNCHRO) and c:IsAbleToExtra() and Duel.IsExistingMatchingCard(c11561068.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp,c:GetLevel(),c:GetAttribute(),e:GetHandler())
end
function c11561068.spfilter(c,e,tp,lv,att,ec)
	return c:IsLevel(lv) and c:IsAttribute(att) and c:IsType(TYPE_SYNCHRO) and Duel.GetLocationCountFromEx(tp,tp,ec,c)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c11561068.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c11561068.cfilter(chkc,e,tp) and chkc~=c end
	if chk==0 then return Duel.IsExistingTarget(c11561068.cfilter,tp,LOCATION_MZONE,0,1,c,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c11561068.cfilter,tp,LOCATION_MZONE,0,1,1,c,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_TOEXTRA,e:GetHandler(),1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c11561068.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoDeck(tc,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
	end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sc=Duel.SelectMatchingCard(tp,c11561068.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,tc:GetLevel(),tc:GetAttribute(),nil):GetFirst()
		if sc then
			Duel.SpecialSummon(sc,0,tp,tp,false,false,POS_FACEUP)
		end
end
function c11561068.sprfilter(c)
	return c:IsFaceup() and c:IsLevelAbove(8) and c:IsAbleToGraveAsCost()
end

function c11561068.lfilter(c)
	return c:IsType(TYPE_TUNER) and c:IsType(TYPE_SYNCHRO)
end
function c11561068.fselect(g,tp,sc)
	if not aux.gffcheck(g,Card.IsType,TYPE_TUNER,aux.NOT(Card.IsType),TYPE_TUNER)
		or Duel.GetLocationCountFromEx(tp,tp,g,sc)<=0 then return false end
	local tc1=g:GetFirst()
	local tc2=g:GetNext()
	return tc1:IsLevel(tc2:GetLevel()) and g:IsExists(c11561068.lfilter,1,nil)
end
function c11561068.sprcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local g=Duel.GetMatchingGroup(c11561068.sprfilter,tp,LOCATION_MZONE,0,nil)
	return g:CheckSubGroup(c11561068.fselect,2,2,tp,c)
end
function c11561068.sprtg(e,tp,eg,ep,ev,re,r,rp,chk,c)
	local g=Duel.GetMatchingGroup(c11561068.sprfilter,tp,LOCATION_MZONE,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local sg=g:SelectSubGroup(tp,c11561068.fselect,true,2,2,tp,c)
	if sg then
		sg:KeepAlive()
		e:SetLabelObject(sg)
		return true
	else return false end
end
function c11561068.sprop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=e:GetLabelObject()
	Duel.SendtoGrave(g,REASON_SPSUMMON)
	g:DeleteGroup()
end
function c11561068.imtgfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_SYNCHRO)
end
function c11561068.imcon(e)
	return Duel.IsExistingMatchingCard(c11561068.tgfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,e:GetHandler())
end
function c11561068.imval(e,c)
	return c~=e:GetHandler() and c:IsRace(RACE_DRAGON) and c:IsType(TYPE_SYNCHRO)
end