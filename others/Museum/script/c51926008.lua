--炼金工具 银之钥匙
function c51926008.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c51926008.condition)
	e1:SetTarget(c51926008.target)
	e1:SetOperation(c51926008.activate)
	c:RegisterEffect(e1)
	--remove
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_REMOVED)
	e2:SetCost(c51926008.cost)
	e2:SetTarget(c51926008.removetg)
	e2:SetOperation(c51926008.removeop)
	c:RegisterEffect(e2)
end
function c51926008.cfilter(c)
	return c:IsCode(51926001) and c:IsFaceup()
end
function c51926008.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c51926008.cfilter,tp,LOCATION_ONFIELD,0,1,nil)
end
function c51926008.spfilter(c,e,tp)
	return c:IsSetCard(0x3257) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c51926008.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c51926008.spfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil,e,tp)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK)
end
function c51926008.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetMZoneCount(tp)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sc=Duel.SelectMatchingCard(tp,c51926008.spfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil,e,tp):GetFirst()
	if sc and Duel.SpecialSummon(sc,0,tp,tp,false,false,POS_FACEUP)~=0 and sc:IsCode(51926014) and 
		Duel.IsExistingMatchingCard(Card.IsControlerCanBeChanged,tp,0,LOCATION_MZONE,1,nil) and
		Duel.SelectYesNo(tp,aux.Stringid(51926008,0)) then
		Duel.BreakEffect()
		local g=Duel.SelectMatchingCard(tp,Card.IsControlerCanBeChanged,tp,0,LOCATION_MZONE,1,1,nil)
		if g:GetCount()>0 then
			Duel.GetControl(g:GetFirst(),tp,nil,nil)
		end
	end
end
function c51926008.tdfilter(c)
	return c:IsCode(51926014) and c:IsFaceup() and c:IsAbleToDeckAsCost()
end
function c51926008.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(c51926008.tdfilter,tp,LOCATION_REMOVED,0,1,nil)
		and c:IsAbleToDeckAsCost() end
	local g=Duel.SelectMatchingCard(tp,c51926008.tdfilter,tp,LOCATION_REMOVED,0,1,1,nil)
	g:AddCard(c)
	Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_COST)
end
function c51926008.snfilter(c)
	if c:IsSetCard(0x3257) then return 1
	elseif c:IsSetCard(0x5257) then return 2
	end
end
function c51926008.rfilter(c)
	return c:IsAbleToRemove() and not c:IsCode(c51926008) and 
	(c:IsSetCard(0x3257) or c:IsSetCard(0x5257))
end
function c51926008.namefilter(c)
	return c:GetClassCount(c51926008.snfilter)==2
end
function c51926008.removetg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(c51926008.rfilter,tp,LOCATION_DECK,0,nil)
	if chk==0 then 
		return g:CheckSubGroup(c51926008.namefilter,2,2) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,2,tp,LOCATION_DECK)
end
function c51926008.removeop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c51926008.rfilter,tp,LOCATION_DECK,0,nil)
	local sg=g:SelectSubGroup(tp,c51926008.namefilter,false,2,2)
	if sg:GetCount()>0 then
		Duel.Remove(sg,POS_FACEUP,REASON_EFFECT)
	end
end
