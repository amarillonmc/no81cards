--最终的决心  鹿目圆香
function c1000606.initial_effect(c)
	--fusion
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_REMOVE)
	e1:SetDescription(aux.Stringid(1000606,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCountLimit(1,1000624+EFFECT_COUNT_CODE_DUEL)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c1000606.condition)
	e1:SetCost(c1000606.cost)
	e1:SetTarget(c1000606.sptg)
	e1:SetOperation(c1000606.spop)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCountLimit(1,1000606)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCondition(aux.exccon)
	e2:SetCost(c1000606.syncost)
	e2:SetTarget(c1000606.tg)
	e2:SetOperation(c1000606.op)
	c:RegisterEffect(e2)
	--special summon1
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,10006060)
	e1:SetCondition(c1000606.spcon)
	c:RegisterEffect(e1)
end
function c1000606.condition(e,tp,eg,ep,ev,re,r,rp)
	local ct1=Duel.GetFieldGroupCount(tp,LOCATION_ONFIELD,0)
	local ct2=Duel.GetFieldGroupCount(tp,0,LOCATION_ONFIELD)
	local ct3=Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)
	return not Duel.IsExistingMatchingCard(nil,tp,LOCATION_ONFIELD,0,1,e:GetHandler())
	and ct3==0 and ct2>ct1 
end
function c1000606.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLP(tp)>1 and e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.PayLPCost(tp,Duel.GetLP(tp)-1)
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function c1000606.spfilter(c,e,tp)
	return c:IsSetCard(0xc204) and c:IsType(TYPE_FUSION+TYPE_SYNCHRO) and not c:IsType(TYPE_PENDULUM) and c:IsCanBeSpecialSummoned(e,0,tp,true,false)
end
function c1000606.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetMZoneCount(tp)>0
		and Duel.IsExistingMatchingCard(c1000606.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
	Duel.SetChainLimit(c1000606.chlimit)
end
function c1000606.chlimit(e,ep,tp)
	return tp==ep
end
function c1000606.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetMZoneCount(tp)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c1000606.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,true,false,POS_FACEUP)
	end
end
function c1000606.filter(c,e,tp)
	local lv=c:GetLevel()
	return lv>0 and c:IsSetCard(0xc204) and not c:IsType(TYPE_TUNER) and c:IsAbleToRemoveAsCost()
		and Duel.IsExistingMatchingCard(c1000606.exfilter,tp,LOCATION_EXTRA,0,1,nil,lv+3,e,tp)
end
function c1000606.exfilter(c,lv,e,tp)
	return c:IsSetCard(0xc204) and c:GetLevel()==lv 
	and c:IsType(TYPE_SYNCHRO) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_SYNCHRO,tp,false,false)
end
function c1000606.syncost(e,tp,eg,ep,ev,re,r,rp,chk)
	 if chk==0 then return Duel.IsExistingMatchingCard(c1000606.filter,tp,LOCATION_GRAVE,0,1,e:GetHandler(),e,tp) 
	 and e:GetHandler():IsAbleToRemoveAsCost() end
	 Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c1000606.filter,tp,LOCATION_GRAVE,0,1,1,e:GetHandler(),e,tp)
	e:SetLabel(g:GetFirst():GetLevel())
	g:AddCard(e:GetHandler())
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c1000606.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetMZoneCount(tp)>0 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c1000606.op(e,tp,eg,ep,ev,re,r,rp)
	local lv=e:GetLabel()
	local c=e:GetHandler()
	if  Duel.GetMZoneCount(tp)>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=Duel.SelectMatchingCard(tp,c1000606.exfilter,tp,LOCATION_EXTRA,0,1,1,nil,lv+3,e,tp)
		local sc=sg:GetFirst()
		if sc then
		Duel.SpecialSummon(sg,SUMMON_TYPE_SYNCHRO,tp,tp,false,false,POS_FACEUP)
	end
end
end
function c1000606.filter1(c)
	return c:IsFaceup() and c:IsSetCard(0xc204) and c:GetCode()~=1000606 and not c:IsType(TYPE_PENDULUM)
end
function c1000606.spcon(e,c)
	if c==nil then return true end
	return Duel.GetMZoneCount(c:GetControler())>0 and
		Duel.IsExistingMatchingCard(c1000606.filter1,c:GetControler(),LOCATION_MZONE,0,1,nil)
end