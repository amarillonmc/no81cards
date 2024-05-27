--谜题大奖赛
local s,id,o=GetID()
function s.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_ANNOUNCE+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_FZONE)
	e2:SetProperty(EFFECT_FLAG_BOTH_SIDE+EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCountLimit(1)
	e2:SetTarget(s.target)
	e2:SetOperation(s.activate)
	c:RegisterEffect(e2)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToHand,tp,LOCATION_DECK,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CODE)
	getmetatable(e:GetHandler()).announce_filter={TYPE_FUSION+TYPE_SYNCHRO+TYPE_XYZ+TYPE_LINK,OPCODE_ISTYPE,OPCODE_NOT}
	local ac=Duel.AnnounceCard(tp,table.unpack(getmetatable(e:GetHandler()).announce_filter))
	Duel.SetTargetParam(ac)
	Duel.SetOperationInfo(0,CATEGORY_ANNOUNCE,nil,0,tp,0)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local ac=Duel.GetChainInfo(0,CHAININFO_TARGET_PARAM)
	Duel.Hint(HINT_MESSAGE,1-tp,aux.Stringid(id,0))
	Duel.Hint(HINT_MESSAGE,1-tp,aux.Stringid(id,1))
	Duel.Hint(HINT_MESSAGE,1-tp,aux.Stringid(id,2))
	Duel.Hint(HINT_SELECTMSG,1-tp,aux.Stringid(id,3))
	local ct1=Duel.SelectOption(1-tp,aux.Stringid(id,4),aux.Stringid(id,5))
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_HAND,0,nil)
	Duel.ConfirmCards(1-tp,g)
	if (Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_HAND,0,1,nil,ac) and ct1==0) or not Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_HAND,0,1,nil,ac) and ct1==1 then
		Duel.Hint(HINT_MESSAGE,1-tp,aux.Stringid(id,6))
		Duel.Hint(HINT_MESSAGE,1-tp,aux.Stringid(id,7))
		local sg=g:RandomSelect(1-tp,1)
		Duel.SendtoGrave(sg,REASON_DISCARD+REASON_EFFECT)
	else
		Duel.Hint(HINT_MESSAGE,1-tp,aux.Stringid(id,8))
		Duel.Hint(HINT_MESSAGE,1-tp,aux.Stringid(id,9))
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,aux.AND(Card.IsAbleToHand,Card.IsCode),tp,LOCATION_DECK,0,1,1,nil,ac)
		if g:GetCount()>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	end
	Duel.ShuffleHand(tp)
end