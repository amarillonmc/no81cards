--古幻在 拉格纳洛克
function c98373976.initial_effect(c)
	c:SetSPSummonOnce(98373976)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcCodeFun(c,98373952,c98373976.mfilter,1,true,true)
	--aux.AddContactFusionProcedure(c,c98373976.cfilter,LOCATION_ONFIELD+LOCATION_GRAVE,LOCATION_ONFIELD+LOCATION_GRAVE,aux.tdcfop(c))
	--cannot special summon
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetValue(aux.FALSE)
	c:RegisterEffect(e0)
	--spsummon
	local se1=Effect.CreateEffect(c)
	se1:SetType(EFFECT_TYPE_FIELD)
	se1:SetCode(EFFECT_SPSUMMON_PROC)
	se1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	se1:SetRange(LOCATION_EXTRA)
	se1:SetCondition(c98373976.sprcon)
	se1:SetOperation(c98373976.sprop)
	c:RegisterEffect(se1)
	--disable
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(98373976,0))
	e1:SetCategory(CATEGORY_DISABLE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,98373976)
	e1:SetCondition(c98373976.condition)
	e1:SetCost(c98373976.cost)
	e1:SetTarget(c98373976.distg)
	e1:SetOperation(c98373976.disop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetDescription(aux.Stringid(98373976,1))
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetCountLimit(1,98373976+1)
	e2:SetTarget(c98373976.destg)
	e2:SetOperation(c98373976.desop)
	c:RegisterEffect(e2)
	local e3=e1:Clone()
	e3:SetDescription(aux.Stringid(98373976,2))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetCountLimit(1,98373976+2)
	e3:SetTarget(c98373976.sptg)
	e3:SetOperation(c98373976.spop)
	c:RegisterEffect(e3)
end
function c98373976.mfilter(c)
	return not c:IsFusionSetCard(0xaf0) and c:IsExtraDeckMonster()
end
function c98373976.matfilter(c,tp)
	return (c:IsFusionCode(98373952) or not c:IsFusionSetCard(0xaf0) and c:IsExtraDeckMonster() and c:IsType(0x1)) and c:IsAbleToDeckOrExtraAsCost() and (c:IsControler(tp) or c:IsFaceupEx())
end
function c98373976.gcheck(g,tp)
	return aux.gffcheck(g,Card.IsFusionCode,98373952,Card.IsExtraDeckMonster,0) and Duel.GetMZoneCount(tp,g)>0
end
function c98373976.sprcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local mg=Duel.GetMatchingGroup(c98373976.matfilter,tp,LOCATION_GRAVE,LOCATION_GRAVE,nil,tp)
	return mg:CheckSubGroup(c98373976.gcheck,2,2,tp) and Duel.GetCurrentPhase()==PHASE_MAIN2 and Duel.GetTurnPlayer()==tp
end
function c98373976.sprop(e,tp,eg,ep,ev,re,r,rp,c)
	local mg=Duel.GetMatchingGroup(c98373976.matfilter,tp,LOCATION_GRAVE,LOCATION_GRAVE,nil,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local sg=mg:SelectSubGroup(tp,c98373976.gcheck,false,2,2,tp)
	aux.tdcfop(c)(sg)
	--Duel.SendtoDeck(mg,nil,SEQ_DECKSHUFFLE,REASON_COST+REASON_FUSION+REASON_MATERIAL)
end
function c98373976.condition(e,tp,eg,ep,ev,re,r,rp)
	return re:GetHandler()~=e:GetHandler()
end
function c98373976.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function c98373976.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,eg,1,0,0)
end
function c98373976.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateEffect(ev)
end
function c98373976.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	local g=Duel.GetMatchingGroup(nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c98373976.desop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	if g:GetCount()>0 then
		Duel.HintSelection(g)
		Duel.Destroy(g,REASON_EFFECT)
	end
end
function c98373976.spfilter(c,e,tp)
	return c:IsSetCard(0x3af0) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and (c:IsLocation(LOCATION_DECK) and Duel.GetMZoneCount(tp)>0 or c:IsLocation(LOCATION_EXTRA) and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0)
end
function c98373976.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c98373976.spfilter,tp,LOCATION_DECK+LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_EXTRA)
end
function c98373976.spop(e,tp,eg,ep,ev,re,r,rp)
	--if Duel.GetMZoneCount(tp)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sc=Duel.SelectMatchingCard(tp,c98373976.spfilter,tp,LOCATION_DECK+LOCATION_EXTRA,0,1,1,nil,e,tp):GetFirst()
	if sc then
		Duel.SpecialSummon(sc,0,tp,tp,false,false,POS_FACEUP)
	end
end
