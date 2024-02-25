--咒念树
local m=33330413
local cm=_G["c"..m]
function cm.initial_effect(c)
	c:EnableReviveLimit()

	aux.AddFusionProcFun2(c,aux.FilterBoolFunction(Card.IsRace,RACE_FIEND),aux.FilterBoolFunction(Card.IsRace,RACE_PLANT),true) 

	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_SPSUMMON_PROC)
	e0:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e0:SetRange(LOCATION_EXTRA)
	e0:SetCondition(cm.con)
	e0:SetOperation(cm.op)
	c:RegisterEffect(e0)

	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,m)
	e1:SetCost(cm.cost)
	e1:SetTarget(cm.sptg)
	e1:SetOperation(cm.spop)
	c:RegisterEffect(e1)

	local e2=Effect.CreateEffect(c) 
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_IMMUNE_EFFECT)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(cm.imcon)
	e2:SetValue(cm.imval)
	c:RegisterEffect(e2)
end 
function cm.con(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCountFromEx(tp,tp,nil,c)>0 and Duel.IsExistingMatchingCard(cm.resfilter,tp,LOCATION_SZONE,0,1,nil)
end
function cm.resfilter(c)
	return c:GetOriginalType()&TYPE_MONSTER~=0 and c:IsReleasable(REASON_SPSUMMON) and c:IsType(TYPE_TRAP)
end
function cm.op(e,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g=Duel.SelectMatchingCard(tp,cm.resfilter,tp,LOCATION_SZONE,0,1,1,nil)
	Duel.Release(g,REASON_SPSUMMON)
end
function cm.cfilter(c,e,tp)
	return c:IsReleasable() and Duel.GetMZoneCount(tp,c,tp)>0
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.cfilter,tp,LOCATION_ONFIELD,0,1,nil,e,tp) end
	local g=Duel.SelectMatchingCard(tp,cm.cfilter,tp,LOCATION_ONFIELD,0,1,1,nil,e,tp)
	Duel.Release(g,REASON_COST)
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function cm.spfilter(c,e,tp)
	return c:IsRace(RACE_FIEND) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEDOWN_DEFENSE) 
end
function cm.spop(e,tp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetTargetRange(1,0)
	e1:SetTarget(cm.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(cm.spfilter),tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	if #sg>0 and Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEDOWN_DEFENSE)>0 then
		Duel.ConfirmCards(1-tp,sg)
	end
end
function cm.splimit(e,c)
	return not c:IsRace(RACE_FIEND)
end
function cm.imcon(e)
	local c=e:GetHandler()
	local tp=c:GetControler()
	return Duel.IsExistingMatchingCard(Card.IsFacedown,tp,LOCATION_MZONE,0,1,c)
end
function cm.imval(e,re)
	return re:GetHandler()~=e:GetHandler()
end