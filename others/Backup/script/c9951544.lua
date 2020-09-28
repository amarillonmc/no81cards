--奥特兄弟-共斗
function c9951544.initial_effect(c)
	 --activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCost(c9951544.cost)
	e1:SetTarget(c9951544.target)
	e1:SetOperation(c9951544.activate)
	c:RegisterEffect(e1)
 --special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(9951544,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c9951544.sptg)
	e2:SetOperation(c9951544.spop)
	c:RegisterEffect(e2)
end
function c9951544.cfilter(c)
	return c:IsSetCard(0x5bd4) and c:IsLevel(6,7) and c:IsAbleToGraveAsCost()
end
function c9951544.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9951544.cfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,c9951544.cfilter,1,1,REASON_COST,nil)
end
function c9951544.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,2) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(2)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
end
function c9951544.tgfilter(c)
	return c:IsSetCard(0x5bd4) and c:IsLevel(6,7) and c:IsAbleToGrave()
end
function c9951544.activate(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	local dr=Duel.Draw(p,d,REASON_EFFECT)
	local g=Duel.GetMatchingGroup(c9951544.tgfilter,p,LOCATION_DECK,0,nil)
	if dr~=0 and g:GetCount()>0 and Duel.SelectYesNo(p,aux.Stringid(9951544,0)) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,p,HINTMSG_TOGRAVE)
		local sg=g:Select(p,1,1,nil)
		Duel.SendtoGrave(sg,REASON_EFFECT)
	end
end
function c9951544.spfilter(c,e,tp)
	return c:IsSetCard(0x5bd4) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c9951544.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c9951544.spfilter,tp,LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c9951544.spop(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local g=Duel.GetMatchingGroup(c9951544.spfilter,tp,LOCATION_HAND,0,nil,e,tp)
	if ct<=0 or g:GetCount()==0 then return end
	ct=math.min(ct,g:GetClassCount(Card.GetCode))
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then ct=1 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg=g:SelectSubGroup(tp,aux.dncheck,false,ct,ct)
	if sg and sg:GetCount()>0 then
		Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
	end
end

