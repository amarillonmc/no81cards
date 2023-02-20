--最后的温柔
local m=60001231
local cm=_G["c"..m]
cm.name="最后的温柔"
function cm.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkType,TYPE_EFFECT),2)
	c:EnableReviveLimit()
	--battle indes
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	--Special Summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetHintTiming(0,TIMING_MAIN_END)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,m)
	e1:SetCondition(cm.spcon)
	e1:SetCost(cm.spcost)
	e1:SetTarget(cm.sptg)
	e1:SetOperation(cm.spop)
	c:RegisterEffect(e1)
end
function cm.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2
end
function cm.costfilter(c,tp)
	if c:IsLocation(LOCATION_HAND) then return c:IsDiscardable() end
	return c:IsFaceup() and c:IsAbleToGraveAsCost()
end
function cm.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable()
		and Duel.IsExistingMatchingCard(cm.costfilter,tp,LOCATION_HAND,0,1,nil,tp) end
	local g=Duel.GetMatchingGroup(cm.costfilter,tp,LOCATION_HAND,0,nil,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
	local tc=g:Select(tp,1,1,nil):GetFirst()
	Duel.Release(e:GetHandler(),REASON_COST)
	Duel.SendtoGrave(tc,REASON_COST+REASON_DISCARD)
end
function cm.spfilter(c,e,tp)
	return c:IsAbleToRemove() and c:IsCode(60000055)
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_EXTRA,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_EXTRA)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,spfilter,tp,LOCATION_EXTRA,0,1,1,nil)
	local tg=g:GetFirst()
	if tg==nil then return end
	if Duel.Remove(tg,POS_FACEUP,REASON_EFFECT)~=0 then
		local g=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_REMOVED,nil)
		Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
		if Duel.GetFlagEffect(tp,60001228)==0 then 
			local g=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_REMOVED,0,nil)
			Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
		else
			Duel.Draw(tp,2,REASON_EFFECT)
		end
		local g=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_ONFIELD,nil)
		Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
		if Duel.GetFlagEffect(tp,60001229)==0 then 
			local g=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_ONFIELD,0,nil)
			Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
		else
			Duel.SetLP(1-tp,math.ceil(Duel.GetLP(1-tp)/2))
		end
		local g=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_GRAVE,nil)
		Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
		if Duel.GetFlagEffect(tp,60001230)==0 then 
			local g=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_GRAVE,0,nil)
			Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
		else
			local g=Duel.GetMatchingGroup(cm.ttkfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,nil)
			Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
		end
	end
end