--三个猎人走上海岸
function c29020954.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(29020954,0))
	e1:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,29020954+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c29020954.condition)
	e1:SetTarget(c29020954.target)
	e1:SetOperation(c29020954.operation)
	c:RegisterEffect(e1)
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(29020954,1))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_ACTIVATE)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetCountLimit(1,29020954+EFFECT_COUNT_CODE_OATH)
	e4:SetTarget(c29020954.sptg)
	e4:SetOperation(c29020954.spop)
	c:RegisterEffect(e4)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e2:SetCondition(c29020954.handcon)
	c:RegisterEffect(e2)
	--"Arknights-Specter the Unchained":ACTIVATE FROM GRAVE
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(29020954,0))
	e3:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
	e3:SetType(EFFECT_TYPE_ACTIVATE)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCountLimit(1,29063234)
	e3:SetCondition(c29020954.condition1)
	e3:SetCost(c29020954.cost)
	e3:SetTarget(c29020954.target)
	e3:SetOperation(c29020954.operation2(c29020954.operation))
	e3:SetLabelObject(e1)
	c:RegisterEffect(e3)
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(29020954,1))
	e5:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e5:SetType(EFFECT_TYPE_ACTIVATE)
	e5:SetCode(EVENT_FREE_CHAIN)
	e5:SetRange(LOCATION_GRAVE)
	e5:SetCountLimit(1,29063234)
	e5:SetCondition(c29020954.condition2)
	e5:SetCost(c29020954.cost)
	e5:SetTarget(c29020954.sptg)
	e5:SetOperation(c29020954.operation2(c29020954.spop))
	e5:SetLabelObject(e4)
	c:RegisterEffect(e5)
end
function c29020954.condition2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsPlayerAffectedByEffect(tp,29063234) and e:GetLabelObject():CheckCountLimit(tp)
end
function c29020954.filter(c,e,tp)
	return c:IsRace(RACE_FISH) and c:IsSetCard(0x87af) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP)
end
function c29020954.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c29020954.spfilter,tp,LOCATION_GRAVE+LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE+LOCATION_HAND)
end
function c29020954.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c29020954.filter),tp,LOCATION_GRAVE+LOCATION_HAND,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
--e3
function c29020954.condition1(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return Duel.IsPlayerAffectedByEffect(tp,29063234) and e:GetLabelObject():CheckCountLimit(tp) and (ph==PHASE_MAIN2 or ph==PHASE_END)
end
function c29020954.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0 end
	Duel.MoveToField(e:GetHandler(),tp,tp,LOCATION_SZONE,POS_FACEUP,false)
end
function c29020954.operation2(op)
	return function(e,tp,eg,ep,ev,re,r,rp)
				op(e,tp,eg,ep,ev,re,r,rp)
				local c=e:GetHandler()
				c:CancelToGrave()
				Duel.SendtoDeck(c,nil,2,REASON_EFFECT)
			end
end
--e1
function c29020954.condition(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return (ph==PHASE_MAIN2 or ph==PHASE_END)
end
function c29020954.tdfilter(c)
	return ((c:IsRace(RACE_FISH) and c:IsSetCard(0x87af)) or c:IsType(TYPE_TRAP)) and c:IsAbleToDeck()
end
function c29020954.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1)
		and Duel.IsExistingMatchingCard(c29020954.tdfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,3,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,3,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c29020954.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c29020954.tdfilter),tp,LOCATION_GRAVE+LOCATION_REMOVED,0,3,3,nil)   
	Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
	if g:IsExists(Card.IsLocation,1,nil,LOCATION_DECK) then Duel.ShuffleDeck(tp) end
	local ct=g:FilterCount(Card.IsLocation,nil,LOCATION_DECK+LOCATION_EXTRA)
	if ct==3 then
		Duel.BreakEffect()
		Duel.Draw(tp,1,REASON_EFFECT)
	end
end
function c29020954.actfilter(c)
	return c:IsFaceup() and c:IsRace(RACE_FISH) and c:IsSetCard(0x87af)
end
function c29020954.handcon(e)
	local g=Duel.GetMatchingGroup(c29020954.actfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,nil)
	return g:GetCount()>=1
end