--33200038
local s,id,o=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
	--act in hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_QP_ACT_IN_NTPHAND)
	e2:SetCondition(s.handcon)
	c:RegisterEffect(e2)
end
function s.handcon(e)
	return Duel.GetFieldGroupCount(e:GetHandlerPlayer(),LOCATION_MZONE,0)==0
end

function s.sw(ep)
	Duel.ConfirmDecktop(1-ep,5)
	local g=Duel.GetDecktopGroup(1-ep,5)
	if g:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,ep,HINTMSG_ATOHAND)
		local sg=g:Select(ep,1,1,nil)
		if sg:GetFirst():IsAbleToHand() then
			Duel.SendtoHand(sg,ep,REASON_EFFECT)
			Duel.ConfirmCards(1-ep,sg)
			Duel.ShuffleHand(ep)
		else
			Duel.SendtoGrave(sg,REASON_RULE)
		end
		Duel.ShuffleDeck(1-ep)
	end
end

function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if Duel.GetFieldGroupCount(1-tp,LOCATION_DECK,0)<5 then return false end
		local g=Duel.GetDecktopGroup(1-tp,5)
		local result=g:FilterCount(Card.IsAbleToHand,nil)>0
		return result
	end
	Duel.SetTargetPlayer(tp)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,0,LOCATION_DECK)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local tp=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	s.sw(tp)
	local c=e:GetHandler()
	if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>4 and Duel.GetDecktopGroup(tp,5):FilterCount(Card.IsAbleToHand,nil)>0 and c:IsRelateToEffect(e) and c:IsCanTurnSet() and Duel.SelectYesNo(1-tp,aux.Stringid(id,2)) then
		Duel.BreakEffect()
		c:CancelToGrave()
		Duel.ChangePosition(c,POS_FACEDOWN)
		Duel.RaiseEvent(c,EVENT_SSET,e,REASON_EFFECT,tp,tp,0)
		s.sw(1-tp)
	end
end
