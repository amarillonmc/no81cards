--金 属 化 祭 坛
local m=22348015
local cm=_G["c"..m]
function cm.initial_effect(c)
	c:SetCounterLimit(0x1613,5)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetDescription(aux.Stringid(22348015,0))
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,22348015+EFFECT_COUNT_CODE_OATH)
	e1:SetOperation(c22348015.activate)
	c:RegisterEffect(e1)
	--add counter
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetOperation(c22348015.ctop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
	--search
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e4:SetDescription(aux.Stringid(22348015,1))
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCountLimit(1)
	e4:SetCost(c22348015.sccost)
	e4:SetTarget(c22348015.sctg)
	e4:SetOperation(c22348015.scop)
	c:RegisterEffect(e4)
end
function c22348015.thfilter(c)
	return c:IsCode(22348012) and c:IsAbleToHand()
end
function c22348015.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c22348015.thfilter,tp,LOCATION_DECK,0,nil)
	if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(22348015,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=g:Select(tp,1,1,nil)
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
	end
end
function c22348015.ctfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x613)
end
function c22348015.ctop(e,tp,eg,ep,ev,re,r,rp)
	if eg:IsExists(c22348015.ctfilter,1,nil) then
		e:GetHandler():AddCounter(0x1613,1)
	end
end
function c22348015.sccost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsCanRemoveCounter(tp,1,0,0x1613,3,REASON_COST) end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.RemoveCounter(tp,1,0,0x1613,3,REASON_COST)
end
function c22348015.filter2(c)
	return c:IsType(TYPE_TRAP+TYPE_SPELL) and c:IsSetCard(0x613) and c:IsAbleToHand()
end
function c22348015.sctg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
  if chk==0 then return Duel.IsExistingMatchingCard(c22348015.filter2,tp,LOCATION_DECK,0,1,nil) end
  Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c22348015.scop(e,tp,eg,ep,ev,re,r,rp)
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
  local g=Duel.SelectMatchingCard(tp,c22348015.filter2,tp,LOCATION_DECK,0,1,1,nil)
  if g:GetCount()>0 then
	  Duel.SendtoHand(g,nil,REASON_EFFECT)
	  Duel.ConfirmCards(1-tp,g)
	end
end
