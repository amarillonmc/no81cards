--绰影遗迹的禁忌知识
local m=22348413
local cm=_G["c"..m]
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DECKDES)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,22348413)
	e1:SetCost(c22348413.cost)
	e1:SetTarget(c22348413.target)
	e1:SetOperation(c22348413.activate)
	c:RegisterEffect(e1)
	--replace
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(22348413)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,22349413)
	c:RegisterEffect(e2)
	--changeffect
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_REMOVE)
	e3:SetCondition(c22348413.cecon)
	e3:SetOperation(c22348413.ceop)
	c:RegisterEffect(e3)
	
end
function c22348413.cecon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsReason(REASON_REPLACE) and re:IsActivated() and re:IsActiveType(TYPE_MONSTER)
		and re:GetHandler():IsSetCard(0x970a)
end
function c22348413.ceop(e,tp,eg,ep,ev,re,r,rp)
	local tc=re:GetHandler()
	tc:RegisterFlagEffect(22348413,RESET_CHAIN,0,1,1)
end
function c22348413.costfilter(c)
	return c:IsSetCard(0x970a) and c:IsDiscardable()
end
function c22348413.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c22348413.costfilter,tp,LOCATION_HAND,0,1,e:GetHandler()) end
	Duel.DiscardHand(tp,c22348413.costfilter,1,1,REASON_COST+REASON_DISCARD,e:GetHandler())
end

function c22348413.filter(c,e,tp)
	return c:IsSetCard(0xd70a) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c22348413.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c22348413.filter,tp,LOCATION_DECK,0,1,nil,e,tp) and Duel.IsPlayerCanDiscardDeck(tp,2) and Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>=3 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_DECKDES,nil,0,tp,2)
end
function c22348413.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c22348413.filter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()>0 and Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)>0 then
		Duel.BreakEffect()
		Duel.DiscardDeck(tp,2,REASON_EFFECT)
	end
end