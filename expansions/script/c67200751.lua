--噩梦回廊的守护者
function c67200751.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,c67200751.matfilter,1,1)
	c:EnableReviveLimit()
	--change effect
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(67200751,0))
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,67200751)
	e1:SetCondition(c67200751.chcon)
	e1:SetTarget(c67200751.chtg)
	e1:SetOperation(c67200751.chop)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(67200751,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_LEAVE_FIELD)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetCondition(c67200751.spcon)
	e2:SetTarget(c67200751.sptg)
	e2:SetOperation(c67200751.spop)
	c:RegisterEffect(e2)
end
function c67200751.matfilter(c)
	return c:IsLinkSetCard(0x367d) and not c:IsLinkType(TYPE_LINK)
end
function c67200751.cfilter(c)
	return c:IsCode(67200755) and c:IsFaceup()
end
function c67200751.chcon(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.IsExistingMatchingCard(c67200751.cfilter,tp,LOCATION_ONFIELD,0,1,nil) then return false end
	return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and Duel.IsChainNegatable(ev)
end
function c67200751.chtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c67200751.tgfilter,rp,0,LOCATION_MZONE,1,nil) end
end
function c67200751.chop(e,tp,eg,ep,ev,re,r,rp)
	local g=Group.CreateGroup()
	Duel.ChangeTargetCard(ev,g)
	Duel.ChangeChainOperation(ev,c67200751.repop)
end
function c67200751.tgfilter(c)
	return c:IsFaceup() and c:IsAbleToGrave()
end
function c67200751.repop(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.SelectMatchingCard(tp,c67200751.tgfilter,tp,0,LOCATION_MZONE,1,1,nil)
	if sg:GetCount()>0 then
		Duel.SendtoGrave(sg,REASON_EFFECT)
	end
end
--
function c67200751.spcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsSummonType(SUMMON_TYPE_LINK)
		and (c:IsReason(REASON_BATTLE) or c:IsReason(REASON_EFFECT))
		and c:IsPreviousPosition(POS_FACEUP)
end
function c67200751.spfilter1(c,e,tp)
	return c:IsFaceupEx() and c:IsCode(67200758) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c67200751.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c67200751.spfilter1,tp,LOCATION_REMOVED+LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_REMOVED+LOCATION_GRAVE)
end
function c67200751.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c67200751.spfilter1),tp,LOCATION_REMOVED+LOCATION_GRAVE,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end

