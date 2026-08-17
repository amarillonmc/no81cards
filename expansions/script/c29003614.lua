--方舟骑士团-远山
local s,id,o=GetID()
function s.initial_effect(c)
--search
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCountLimit(1,id)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCost(s.cost)
	e1:SetTarget(s.target)
	e1:SetOperation(s.operation)
	c:RegisterEffect(e1)
--
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCountLimit(1,id+1)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCost(s.cost1)
	e2:SetTarget(s.target1)
	e2:SetOperation(s.operation1)
	c:RegisterEffect(e2)
--
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_POSITION)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EVENT_PHASE+PHASE_BATTLE)
	e4:SetCondition(s.con)
	e4:SetOperation(s.op)
	c:RegisterEffect(e4)

end
---
function s.con(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetBattledGroupCount()>0
end
function s.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFaceup() and c:IsAttackPos() then
		Duel.ChangePosition(c,POS_FACEUP_DEFENSE)
	end
end


--
function s.cfilter(c,tp)
	return c:IsSetCard(0x57af) and c:IsAbleToGraveAsCost()
end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.cfilter,tp,LOCATION_DECK,0,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,s.cfilter,tp,LOCATION_DECK,0,1,1,nil,tp)
	Duel.SendtoGrave(g,REASON_COST)
end
function s.filter(c)
	return c:IsRace(RACE_SPELLCASTER) and c:IsSetCard(0x87af) and not c:IsCode(id) and c:IsAbleToHand()
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_DECK,0,1,nil,tp) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,s.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
--------
function s.costfilter(c)
	return c:IsType(TYPE_TOKEN) and c:IsReleasable()
end
function s.excostfilter(c,tp)
	return c:IsAbleToRemoveAsCost() and c:IsHasEffect(29088383,tp)
end
function s.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(s.costfilter,tp,LOCATION_MZONE,0,nil,tp)
	local g2=Duel.GetMatchingGroup(s.excostfilter,tp,LOCATION_GRAVE,0,nil,tp)
	if #g2>0 then g:AddCard(g2) end
	if chk==0 then return #g>0 end
	local tc
	if #g2>0 then
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(29088383,0))
		tc=g:Select(tp,1,1,nil):GetFirst()
	else
		tc=g:Select(tp,1,1,nil):GetFirst()
	end
	local te=tc:IsHasEffect(29088383,tp)
	if te then
		Duel.Remove(tc,POS_FACEUP,REASON_COST+REASON_REPLACE)
	else
		Duel.Release(tc,REASON_COST)
	end
end
function s.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.NOT(Card.IsPublic),tp,0,LOCATION_HAND,1,nil) or Duel.GetFieldGroupCount(1-tp,LOCATION_DECK,0)>0 end
end
function s.operation1(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(tp,0,LOCATION_HAND)
	local g1=Duel.GetDecktopGroup(1-tp,1)
	if g:GetCount()>0 then
		Duel.ConfirmCards(tp,g)
		Duel.ShuffleHand(1-tp)
	end
	if g1:GetCount()>0 then
		Duel.ConfirmCards(tp,g1)
	end
end




