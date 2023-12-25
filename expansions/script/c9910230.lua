--天空漫步者 我如古茧
function c9910230.initial_effect(c)
	--link summon
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkRace,RACE_PSYCHO),2,2)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(9910230,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_MZONE+LOCATION_GRAVE)
	e1:SetCountLimit(1,9910230)
	e1:SetCondition(c9910230.spcon)
	e1:SetTarget(c9910230.sptg)
	e1:SetOperation(c9910230.spop)
	c:RegisterEffect(e1)
	--copy
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(9910230,1))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,9910230)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e2:SetCost(c9910230.cpcost)
	e2:SetTarget(c9910230.cptg)
	e2:SetOperation(c9910230.cpop)
	c:RegisterEffect(e2)
end
function c9910230.spcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return false end
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	return g and g:IsContains(c)
end
function c9910230.spfilter(c,e,tp)
	return c:IsSetCard(0x955) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c9910230.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c9910230.spfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE)
end
function c9910230.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
		local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c9910230.spfilter),tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,e,tp)
		if g:GetCount()>0 then
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end
function c9910230.costfilter(c)
	return c:IsCode(9910228) and c:IsAbleToRemoveAsCost()
end
function c9910230.cpfilter(c,exc,e,tp,eg,ep,ev,re,r,rp)
	local te=c:CheckActivateEffect(true,true,false)
	if not (c:IsSetCard(0x955) and c:IsType(TYPE_SPELL) and c:IsAbleToRemoveAsCost() and te and te:GetOperation()) then return false end
	local tg=te:GetTarget()
	return (not tg) or tg(e,tp,eg,ep,ev,re,r,rp,0,nil,exc,true)
end
function c9910230.cpcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c9910230.costfilter,tp,LOCATION_GRAVE,0,nil)
	if chk==0 then return #g>0
		and Duel.IsExistingMatchingCard(c9910230.cpfilter,tp,LOCATION_GRAVE,0,1,nil,g:GetFirst(),e,tp,eg,ep,ev,re,r,rp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local sg1=g:Select(tp,1,1,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local sg2=Duel.SelectMatchingCard(tp,c9910230.cpfilter,tp,LOCATION_GRAVE,0,1,1,nil,sg1:GetFirst(),e,tp,eg,ep,ev,re,r,rp)
	local te=sg2:GetFirst():CheckActivateEffect(true,true,false)
	e:SetLabelObject(te)
	sg1:Merge(sg2)
	Duel.Remove(sg1,POS_FACEUP,REASON_COST)
end
function c9910230.cptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local te=e:GetLabelObject()
	if chk==0 then return true end
	e:SetProperty(te:GetProperty())
	e:SetLabel(te:GetLabel())
	e:SetLabelObject(te:GetLabelObject())
	local tg=te:GetTarget()
	if tg then tg(e,tp,eg,ep,ev,re,r,rp,1,nil,nil,true) end
	te:SetLabel(e:GetLabel())
	te:SetLabelObject(e:GetLabelObject())
	e:SetLabelObject(te)
	Duel.ClearOperationInfo(0)
end
function c9910230.cpop(e,tp,eg,ep,ev,re,r,rp)
	local te=e:GetLabelObject()
	e:SetLabel(te:GetLabel())
	e:SetLabelObject(te:GetLabelObject())
	local op=te:GetOperation()
	if op then op(e,tp,eg,ep,ev,re,r,rp) end
	te:SetLabel(e:GetLabel())
	te:SetLabelObject(e:GetLabelObject())
end
