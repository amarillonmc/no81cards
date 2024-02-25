--超能力探查
local s,id,o=GetID()
function s.initial_effect(c)
	
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,id)
	e1:SetTarget(s.target)
	e1:SetOperation(s.prop)
	c:RegisterEffect(e1)

	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_REMOVE)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,id+o)
	e2:SetCondition(s.con2)
	e2:SetOperation(s.prop2)
	c:RegisterEffect(e2)
end

function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>=3 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CODE)
	getmetatable(e:GetHandler()).announce_filter={TYPE_FUSION+TYPE_SYNCHRO+TYPE_XYZ+TYPE_LINK,OPCODE_ISTYPE,OPCODE_NOT}
	local ac=Duel.AnnounceCard(tp,table.unpack(getmetatable(e:GetHandler()).announce_filter))
	Duel.SetTargetParam(ac)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,0,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_ANNOUNCE,nil,0,tp,0)
end
function s.thfilter(c,ac)
	return (c:IsSetCard(0x605) or c:IsCode(ac)) and c:IsAbleToHand()
end
function s.filter(c)
	return c:IsSetCard(0x603) and c:IsAbleToDeck() and ((c:IsLocation(LOCATION_REMOVED) and c:IsFaceup()) or c:IsLocation(LOCATION_DECK))
end
function s.filter2(c)
	return c:IsSetCard(0x603) and c:IsFaceup()
end
function s.prop(e,tp,eg,ep,ev,re,r,rp)
	local ac=Duel.GetChainInfo(0,CHAININFO_TARGET_PARAM)
	
	Duel.ConfirmDecktop(tp,3)
	local g=Duel.GetDecktopGroup(tp,3)
	if g:GetCount()>0 then
		if g:IsExists(s.thfilter,1,nil,ac) and Duel.SelectYesNo(tp,aux.Stringid(id,4)) then
			Duel.Hint(HINT_SELECTMSG,p,HINTMSG_ATOHAND)
			local sg=g:FilterSelect(tp,s.thfilter,1,1,nil,ac)
			Duel.SendtoHand(sg,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,sg)
			Duel.ShuffleHand(tp)
		end
		Duel.ShuffleDeck(tp)
		
		Duel.BreakEffect()
		
		if Duel.IsExistingMatchingCard(s.filter2,tp,LOCATION_REMOVED,0,1,nil) and Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_DECK+LOCATION_REMOVED,0,1,e:GetHandler()) and Duel.SelectYesNo(tp,aux.Stringid(id,2)) then 
			
			Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(id,3))
			local g=Duel.SelectMatchingCard(tp,s.filter,tp,LOCATION_DECK+LOCATION_REMOVED,0,1,1,nil)
			local tc=g:GetFirst()
			if tc then
				Duel.SendtoDeck(tc,nil,0,REASON_EFFECT)
				Duel.ShuffleDeck(tp)
				Duel.MoveSequence(tc,SEQ_DECKTOP)
				Duel.ConfirmDecktop(tp,1)
			end
		end
	end
end

function s.con2(e,tp,eg,ep,ev,re,r,rp)
	return re and re:GetHandler():IsSetCard(0x603) and re:GetHandler():IsType(TYPE_MONSTER) and bit.band(r,REASON_EFFECT)>0
end
function s.prop2(e,tp,eg,ep,ev,re,r,rp)
	local c = e:GetHandler()
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,6))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e2:SetCountLimit(1)
	e2:SetLabel(Duel.GetTurnCount())
	e2:SetCondition(s.spcon)
	e2:SetOperation(s.spop)
	if Duel.GetCurrentPhase()<=PHASE_STANDBY then
		e2:SetReset(RESET_PHASE+PHASE_STANDBY+RESET_SELF_TURN,2)
	else
		e2:SetReset(RESET_PHASE+PHASE_STANDBY+RESET_SELF_TURN)
	end
	Duel.RegisterEffect(e2,tp)
end
function s.filter22(c)
	return c:IsSetCard(0x603) and c:IsAbleToHand() and c:IsFaceup()
end
function s.spcon(e,tp,eg,ep,ev,re,r,rp)
	return tp==Duel.GetTurnPlayer() and Duel.GetTurnCount()~=e:GetLabel() and Duel.IsExistingMatchingCard(s.filter22,tp,LOCATION_REMOVED,0,1,nil)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local result = Duel.SelectYesNo(tp,aux.Stringid(id,5))
	if not result then return end
	Duel.Hint(HINT_CARD,0,id)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g2=Duel.SelectMatchingCard(tp,s.filter22,tp,LOCATION_REMOVED,0,1,1,nil)
	if g2:GetCount()>0 then
		Duel.SendtoHand(g2,tp,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g2)
	end
end