--魔导礼记
local s,id,o=GetID()
function s.initial_effect(c)

	--Debug.Message(o)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,id)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
	
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_TOGRAVE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,id+10000)
	e2:SetCost(s.bfgcost)
	e2:SetTarget(s.tgtg)
	e2:SetOperation(s.tgop)
	c:RegisterEffect(e2)
end

function s.bfgcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1 = e:GetHandler():IsAbleToRemoveAsCost()
	--Debug.Message("liji mudi cost:"..tostring(b1))
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end

function s.tgfilter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToGrave()
end
function s.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1 = Duel.IsExistingMatchingCard(s.tgfilter,tp,LOCATION_ONFIELD+LOCATION_HAND,0,1,nil) 
	--Debug.Message("liji mudi:"..tostring(b1))
	if chk==0 then 
		return Duel.IsExistingMatchingCard(s.tgfilter,tp,LOCATION_ONFIELD+LOCATION_HAND,0,1,nil) 
	end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_HAND+LOCATION_ONFIELD)
end
function s.tgop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,s.tgfilter,tp,LOCATION_ONFIELD+LOCATION_HAND,0,1,99,nil)
	if g:GetCount()>0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
		local gg = g:Filter(Card.IsLocation,nil,LOCATION_GRAVE)
		gg = gg:Filter(Card.IsType,nil,TYPE_QUICKPLAY)
		if #gg>0 and Duel.IsPlayerCanDraw(tp,#gg) and Duel.SelectYesNo(tp,aux.Stringid(id,2)) then
			Duel.Draw(tp,#gg,REASON_EFFECT)
		end
	end
end


function s.filter(c)
	return c:IsSetCard(0xcd70) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local b1 = Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_DECK,0,1,nil)
		--Debug.Message("liji fadong:"..tostring(b1))
		return Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_DECK,0,1,nil) 
	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,s.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end