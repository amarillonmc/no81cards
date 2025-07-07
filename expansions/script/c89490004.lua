--炯眼角龙
local s,id,o=GetID()
function s.initial_effect(c)
	aux.AddCodeList(c,89490003)
	c:EnableReviveLimit()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_CANNOT_BE_BATTLE_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(s.atlimit)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_IMMUNE_EFFECT)
	e2:SetValue(s.efilter)
	c:RegisterEffect(e2)
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(id,0))
	e5:SetCategory(CATEGORY_REMOVE)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCountLimit(1,EFFECT_COUNT_CODE_SINGLE)
	e5:SetCondition(aux.NOT(s.qcon))
	e5:SetCost(s.rcost)
	e5:SetTarget(s.rtg)
	e5:SetOperation(s.rop)
	c:RegisterEffect(e5)
	local e55=e5:Clone()
	e55:SetType(EFFECT_TYPE_QUICK_O)
	e55:SetCode(EVENT_FREE_CHAIN)
	e55:SetCondition(s.qcon)
	c:RegisterEffect(e55)
	local e6=e5:Clone()
	e6:SetDescription(aux.Stringid(id,1))
	e6:SetTarget(s.rtg2)
	e6:SetOperation(s.rop2)
	c:RegisterEffect(e6)
	local e66=e6:Clone()
	e66:SetType(EFFECT_TYPE_QUICK_O)
	e66:SetCode(EVENT_FREE_CHAIN)
	e66:SetCondition(s.qcon)
	c:RegisterEffect(e66)
	local e7=e5:Clone()
	e7:SetDescription(aux.Stringid(id,2))
	e7:SetTarget(s.rtg3)
	e7:SetOperation(s.rop3)
	c:RegisterEffect(e7)
	local e77=e7:Clone()
	e77:SetType(EFFECT_TYPE_QUICK_O)
	e77:SetCode(EVENT_FREE_CHAIN)
	e77:SetCondition(s.qcon)
	c:RegisterEffect(e77)
end
function s.atlimit(e,c)
	return c:IsSummonLocation(LOCATION_EXTRA) and not c:IsImmuneToEffect(e)
end
function s.efilter(e,te)
	return te:GetOwner():IsSummonLocation(LOCATION_EXTRA)
end
function s.qcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return Duel.IsPlayerAffectedByEffect(tp,89490011)~=nil and c:IsOriginalSetCard(0xc30) and c:IsLocation(LOCATION_MZONE) and c:IsType(TYPE_MONSTER)
end
function s.costfilter(c)
	return c:IsRace(RACE_WYRM) and c:IsAttribute(ATTRIBUTE_FIRE)
end
function s.tgfilter(c)
	return c:IsRace(RACE_WYRM) and c:IsAttribute(ATTRIBUTE_FIRE) and c:IsType(TYPE_MONSTER) and c:IsAbleToGraveAsCost()
end
function s.rcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local fe=Duel.IsPlayerAffectedByEffect(tp,89490052)
	local b1=fe and Duel.IsExistingMatchingCard(s.tgfilter,tp,LOCATION_DECK,0,1,nil)
	local b2=Duel.CheckReleaseGroup(tp,s.costfilter,1,e:GetHandler())
	if chk==0 then return b1 or b2 end
	if b1 and (not b2 or Duel.SelectYesNo(tp,fe:GetDescription())) then
		Duel.Hint(HINT_CARD,0,89490052)
		fe:UseCountLimit(tp)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local g=Duel.SelectMatchingCard(tp,s.tgfilter,tp,LOCATION_DECK,0,1,1,nil)
		Duel.SendtoGrave(g,REASON_COST)
	else
		local g=Duel.SelectReleaseGroup(tp,s.costfilter,1,1,e:GetHandler())
		local tc=g:GetFirst()
		Duel.Release(tc,REASON_COST)
		if tc:IsSetCard(0xc30) then
			e:SetProperty(e:GetProperty()|EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_INACTIVATE+EFFECT_FLAG_CAN_FORBIDDEN)
		else
			e:SetProperty(e:GetProperty()&~(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_INACTIVATE+EFFECT_FLAG_CAN_FORBIDDEN))
		end
	end
end
function s.rtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,1-tp,LOCATION_ONFIELD)
end
function s.rop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,nil)
	if g:GetCount()>0 then
		Duel.ConfirmCards(tp,Duel.GetMatchingGroup(Card.IsFacedown,tp,0,LOCATION_ONFIELD,nil))
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local sg=g:Select(tp,1,1,nil)
		Duel.HintSelection(sg)
		Duel.Remove(sg,POS_FACEUP,REASON_EFFECT)
	end
end
function s.rtg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_HAND,1,nil) end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,1-tp,LOCATION_HAND)
end
function s.rop2(e,tp,eg,ep,ev,re,r,rp)
	local g0=Duel.GetFieldGroup(tp,0,LOCATION_HAND)
	Duel.ConfirmCards(tp,g0)
	local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_HAND,nil)
	if g:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local sg=g:Select(tp,1,1,nil)
		Duel.Remove(sg,POS_FACEUP,REASON_EFFECT)
	end
	Duel.ShuffleHand(1-tp)
end
function s.rtg3(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetDecktopGroup(1-tp,1)
	if chk==0 then return #g>0 and g:GetFirst():IsAbleToRemove(tp) end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,1-tp,LOCATION_DECK)
end
function s.rop3(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.GetFieldGroupCount(tp,0,LOCATION_DECK)
	if ct>5 then ct=5 end
	if ct>1 then
		local tbl={}
		for i=1,ct do
			table.insert(tbl,i)
		end
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(94392192,3))
		ct=Duel.AnnounceNumber(tp,table.unpack(tbl))
	end
	Duel.ConfirmDecktop(1-tp,ct)
	local g=Duel.GetDecktopGroup(1-tp,ct)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	Duel.RevealSelectDeckSequence(true)
	local sg=g:FilterSelect(tp,Card.IsAbleToRemove,1,1,nil,tp)
	Duel.RevealSelectDeckSequence(false)
	if #sg>0 then
		Duel.DisableShuffleCheck(true)
		Duel.Remove(sg,POS_FACEUP,REASON_EFFECT)
	end
end
