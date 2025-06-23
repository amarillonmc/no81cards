--资源获取
local s,id=GetID()
function c65809001.initial_effect(c)
local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_TO_HAND)
	e2:SetRange(LOCATION_REMOVED)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,id)
	e2:SetCondition(s.con2)
	e2:SetTarget(s.tg2)
	e2:SetOperation(s.op2)
	c:RegisterEffect(e2)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if Duel.GetFieldGroupCount(tp,0,LOCATION_DECK)<4 then return false end
		local g=Duel.GetDecktopGroup(1-tp,5)
		local result=g:FilterCount(Card.IsAbleToHand,nil)>0
		return result
	end
	Duel.SetTargetPlayer(1-tp)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,0,LOCATION_DECK)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	Duel.ConfirmDecktop(p,5)
	local g=Duel.GetDecktopGroup(p,5)
	if g:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,p,HINTMSG_ATOHAND)
		local sg=g:Select(tp,1,1,nil)
		if sg:GetFirst():IsAbleToHand() then
			Duel.SendtoHand(sg,tp,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,sg)
			Duel.ShuffleHand(tp)
		g:Sub(sg)
		else
			Duel.SendtoGrave(sg,REASON_RULE)
		g:Sub(sg)
		end
		Duel.SortDecktop(tp,1-tp,4)
		for i=1,4 do
			local mg=Duel.GetDecktopGroup(1-tp,1)
			Duel.MoveSequence(mg:GetFirst(),SEQ_DECKBOTTOM)
		end
	end
end
function s.con2filter(c,tp)
	return c:GetOwner()~=tp and c:GetControler()==tp
end
function s.con2(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(s.con2filter,1,nil,tp)
end
function s.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToHand() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function s.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SendtoHand(c,nil,REASON_EFFECT)
	end
end