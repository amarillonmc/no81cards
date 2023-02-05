--LV进 化 区 域
local m=22348156
local cm=_G["c"..m]
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,22348156)
	e1:SetTarget(c22348156.target)
	e1:SetOperation(c22348156.activate)
	c:RegisterEffect(e1)
	--spsummon or set
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(22348156,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCountLimit(1,22348156)
	e2:SetCost(c22348156.spcost)
	e2:SetTarget(c22348156.sptg)
	e2:SetOperation(c22348156.spop)
	c:RegisterEffect(e2)
	--atk up
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetRange(LOCATION_FZONE)
	e3:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e3:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x41))
	e3:SetValue(c22348156.atkval)
	c:RegisterEffect(e3)
end 
function c22348156.atkval(e,c)
	return c:GetLevel()*100
end
function c22348156.filter(c)
	return c:IsSetCard(0x41) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c22348156.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c22348156.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c22348156.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c22348156.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c22348156.costfilter(c,e,tp)
	if not c:IsSetCard(0x41) or not c:IsAbleToRemoveAsCost() then return false end
	local code=c:GetOriginalCode()
	local class=_G["c"..code]
	if class==nil or class.lvup==nil then return false end
	return Duel.IsExistingMatchingCard(c22348156.spfilter,tp,LOCATION_DECK,0,1,nil,class,e,tp)
end
function c22348156.spfilter(c,class,e,tp)
	local code=c:GetCode()
	return c:IsCode(table.unpack(class.lvup)) and c:IsCanBeSpecialSummoned(e,0,tp,true,true)
end
function c22348156.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c22348156.costfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c22348156.costfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
	e:SetLabel(g:GetFirst():GetOriginalCode())
end
function c22348156.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c22348156.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local code=e:GetLabel()
	local class=_G["c"..code]
	if class==nil or class.lvup==nil then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c22348156.spfilter,tp,LOCATION_DECK,0,1,1,nil,class,e,tp)
	local tc=g:GetFirst()
	if tc then
		Duel.SpecialSummon(tc,0,tp,tp,true,true,POS_FACEUP)
		Duel.ShuffleDeck(tp)
	end
end

