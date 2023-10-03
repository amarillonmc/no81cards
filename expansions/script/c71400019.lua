--幻异梦像-魔女
if not c71401001 then dofile("expansions/script/c71400001.lua") end
function c71400019.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetDescription(aux.Stringid(71400019,0))
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,71400019+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c71400019.target)
	e1:SetCondition(yume.YumeCon)
	e1:SetOperation(c71400019.operation)
	c:RegisterEffect(e1)
	--draw
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(71400019,1))
	e2:SetCategory(CATEGORY_DRAW+CATEGORY_DAMAGE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCountLimit(1,71500019)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCost(c71400019.cost2)
	e2:SetTarget(c71400019.tg2)
	e2:SetOperation(c71400019.op2)
	c:RegisterEffect(e2)
end
function c71400019.filter(c,e,tp)
	return c:IsSetCard(0x714) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c71400019.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c71400019.filter,tp,LOCATION_DECK+LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_HAND)
end
function c71400019.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c71400019.filter,tp,LOCATION_DECK+LOCATION_HAND,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c71400019.filter2(c)
	return c:IsSetCard(0xb714) and c:IsFaceup() and c:IsAbleToDeckAsCost()
end
function c71400019.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToDeckAsCost() and Duel.IsExistingMatchingCard(c71400019.filter2,tp,LOCATION_FZONE,0,1,nil) end
	local g=Duel.GetMatchingGroup(c71400019.filter2,tp,LOCATION_FZONE,0,nil)
	g:AddCard(e:GetHandler())
	Duel.SendtoDeck(g,nil,2,REASON_COST)
end
function c71400019.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,tp,50)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c71400019.op2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.Damage(tp,50,REASON_EFFECT)>0 then
		Duel.Draw(tp,1,REASON_EFFECT)
	end
end