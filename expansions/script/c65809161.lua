--资源获取·寡头垄断
local s,id,o=GetID()
function s.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_REMOVE+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_TO_HAND)
	e1:SetCondition(s.e1con)
	e1:SetTarget(s.e1tg)
	e1:SetOperation(s.e1op)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,3))
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetValue(id)
	e2:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
	e2:SetProperty(EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetCondition(s.condition)
	e2:SetCost(s.cost)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_FIELD)
	e3:SetCode(EVENT_TO_HAND)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetDescription(1153)
	e3:SetCondition(s.e3con)
	e3:SetCountLimit(2,id)
	e3:SetCost(s.e3cost)
	e3:SetTarget(s.e3tg)
	e3:SetOperation(s.e3op)
	c:RegisterEffect(e3)
end
function s.e1con(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(Card.IsControler,1,nil,1-tp)
end
function s.e1tg(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)>0
	local b2=Duel.GetFieldGroupCount(tp,0,LOCATION_DECK)>=5
	if chk==0 then return b1 or b2 end
	local op=0
	if b1 and b2 then
		op=Duel.SelectOption(tp,aux.Stringid(id,1),aux.Stringid(id,2))
	elseif b1 then
		op=Duel.SelectOption(tp,aux.Stringid(id,1))
	else op=Duel.SelectOption(tp,aux.Stringid(id,1))+1 end
	e:SetLabel(op)
	if op==0 then
		e:SetCategory(CATEGORY_REMOVE)
		Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,1-tp,LOCATION_HAND)
	else
		e:SetCategory(CATEGORY_TOHAND)
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,2,1-tp,LOCATION_DECK)
	end
end
function s.e1op(e,tp,eg,ep,ev,re,r,rp)
	if e:GetLabel()==0 then
		local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_HAND,nil)
		if g:GetCount()>0 then
			local sg=g:RandomSelect(tp,1)
			Duel.Remove(sg,POS_FACEUP,REASON_EFFECT)
		end
	else
		if Duel.GetFieldGroupCount(tp,0,LOCATION_DECK)>=5 then
			Duel.ConfirmDecktop(1-tp,5)
			local g=Duel.GetDecktopGroup(1-tp,5)
			if g:GetCount()>0 then
				Duel.DisableShuffleCheck()
				if g:IsExists(Card.IsAbleToHand,1,nil) then
					Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_ATOHAND)
					local sg=g:FilterSelect(1-tp,Card.IsAbleToHand,2,2,nil)
					if #sg>0 then
						Duel.SendtoHand(sg,tp,REASON_EFFECT)
						Duel.ConfirmCards(1-tp,sg)
						Duel.ShuffleHand(tp)
					end
				end
			end
		end
	end
end
function s.condition(e)
	return e:GetHandler():IsStatus(STATUS_SET_TURN) and e:GetHandler():IsLocation(LOCATION_ONFIELD)
end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end
function s.e3con(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(Card.IsControler,1,nil,1-tp)
end
function s.e3cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end
function s.e3tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return e:GetHandler():IsSSetable() end
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,e:GetHandler(),1,0,0)
end
function s.e3op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SSet(tp,c)
	end
end