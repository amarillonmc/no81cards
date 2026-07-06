--归心遗计 祭酒·妄言
function c88888321.initial_effect(c)
	--fusion material
	aux.AddFusionProcFunRep(c,aux.FilterBoolFunction(Card.IsFusionSetCard,0x8907),2,true)
	c:EnableReviveLimit()
	--special summon
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(aux.Stringid(88888321,0))
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_SPSUMMON_PROC)
	e0:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e0:SetRange(LOCATION_GRAVE)
	e0:SetCountLimit(1,88888321+EFFECT_COUNT_CODE_OATH)
	e0:SetCondition(c88888321.spcon)
	e0:SetTarget(c88888321.sptg)
	e0:SetOperation(c88888321.spop)
	c:RegisterEffect(e0)
	--destroy
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(88888321,0))
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,18888321)
	e3:SetCondition(c88888321.setcon)
	e3:SetCost(c88888321.setcost)
	e3:SetTarget(c88888321.settg)
	e3:SetOperation(c88888321.setop)
	c:RegisterEffect(e3)
end
function c88888321.spfilter(c,tp)
	return c:IsFaceup() and c:IsSetCard(0x8907) and c:GetOriginalType()&TYPE_MONSTER~=0 
		and (c:IsAbleToHandAsCost() or c:IsAbleToExtraAsCost()) and Duel.GetMZoneCount(tp,c)>0
end
function c88888321.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.IsExistingMatchingCard(c88888321.spfilter,tp,LOCATION_ONFIELD,0,2,nil,tp) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c88888321.sptg(e,tp,eg,ep,ev,re,r,rp,chk,c)
	local g=Duel.GetMatchingGroup(c88888321.spfilter,tp,LOCATION_ONFIELD,0,nil,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local sg=g:SelectSubGroup(tp,aux.mzctcheck,true,2,2,tp)
	if sg then
		sg:KeepAlive()
		e:SetLabelObject(sg)
		return true
	else return false end
end
function c88888321.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=e:GetLabelObject()
	Duel.SendtoHand(g,nil,REASON_SPSUMMON)
end
function c88888321.setcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsStatus(STATUS_SPSUMMON_TURN) and Duel.IsMainPhase()
end
function c88888321.setfilter(c,tp)
	return c:IsType(TYPE_CONTINUOUS)
		and c:IsSetCard(0x8907)
		and not c:IsForbidden() and c:CheckUniqueOnField(tp)
end
function c88888321.costfilter(c,tp)
	return c:IsFaceup() and c:IsSetCard(0x8907) and c:GetOriginalType()&TYPE_MONSTER~=0 
		and (c:IsAbleToHandAsCost() or c:IsAbleToExtraAsCost())
		and (Duel.GetLocationCount(tp,LOCATION_SZONE)>0 or c:IsLocation(LOCATION_SZONE) and not c:IsLocation(LOCATION_FZONE))
end
function c88888321.setcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c88888321.costfilter,tp,LOCATION_ONFIELD,0,1,e:GetHandler(),tp) end
	local ct=0
	local g=Duel.GetMatchingGroup(c88888321.setfilter,tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED,0,nil,e,tp)
	if g:GetClassCount(Card.GetCode)==0 then return false end
	if g:GetClassCount(Card.GetCode)>=2 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
		local tg=Duel.SelectMatchingCard(tp,c88888321.costfilter,tp,LOCATION_ONFIELD,0,1,2,e:GetHandler(),tp)
		ct=Duel.SendtoHand(tg,nil,REASON_COST)
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
		local tg=Duel.SelectMatchingCard(tp,c88888321.costfilter,tp,LOCATION_ONFIELD,0,1,1,e:GetHandler(),tp)
		ct=Duel.SendtoHand(tg,nil,REASON_COST)
	end
	e:SetLabel(ct)
end
function c88888321.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c88888321.setfilter,tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil) end
end
function c88888321.setop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(c88888321.setfilter),tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED,0,nil)
	if g:GetCount()>0 then
		local ct=e:GetLabel()
		if Duel.GetLocationCount(tp,LOCATION_SZONE)<ct then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
		local pg=g:SelectSubGroup(tp,aux.dncheck,false,ct,ct)
		for tc in aux.Next(pg) do
			Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
		end
	end
end