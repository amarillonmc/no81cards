--混沌与希望的闪光抽卡
function c75038087.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_DAMAGE)
	e1:SetCountLimit(1,75038087+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c75038087.condition)
	e1:SetTarget(c75038087.target)
	e1:SetOperation(c75038087.activate)
	c:RegisterEffect(e1)
	 --act in hand
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(aux.Stringid(75038087,2))
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e0:SetCost(c75038087.excost)
	e0:SetLabelObject(e1)
	c:RegisterEffect(e0)
end
function c75038087.gcheck(sg)
	return #sg==1 or aux.gfcheck(sg,Card.IsCode,97769122,35906693)
end
function c75038087.excost(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(Card.IsCode,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,e:GetHandler(),97769122,35906693)
	if chk==0 then return #g>0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local sg=g:SelectSubGroup(tp,c75038087.gcheck,false,1,2)
	Duel.ConfirmCards(1-tp,sg)
	Duel.ShuffleHand(tp)
	local ct=sg:IsExists(Card.IsCode,1,nil,97769122) and 1 or 0
	if sg:IsExists(Card.IsCode,1,nil,35906693) then ct=ct|2 end
	e:GetLabelObject():SetLabel(ct)
end
function c75038087.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==0
end
function c75038087.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsType,tp,LOCATION_DECK,0,1,nil,TYPE_SPELL) end
end
function c75038087.activate(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_INACTIVATE)
	e1:SetValue(c75038087.effectfilter)
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_CANNOT_DISEFFECT)
	Duel.RegisterEffect(e2,tp)
	--
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(75038087,0))
	local tc=Duel.SelectMatchingCard(tp,Card.IsType,tp,LOCATION_DECK,0,1,1,nil,TYPE_SPELL):GetFirst()
	if not tc then return end
	Duel.ShuffleDeck(tp)
	Duel.MoveSequence(tc,SEQ_DECKTOP)
	Duel.ConfirmDecktop(tp,1)
	local ct=e:GetLabel()
	e:SetLabel(0)
	if ct&1>0 then
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(75038087,0))
		local g=Duel.SelectMatchingCard(tp,Card.IsType,tp,LOCATION_DECK,0,2,2,nil,TYPE_MONSTER)
		if g:GetCount()>0 then
			Duel.BreakEffect()
			Duel.ConfirmCards(1-tp,g)
			Duel.ShuffleDeck(tp)
			for tc in aux.Next(g) do Duel.MoveSequence(tc,SEQ_DECKTOP) end
			Duel.SortDecktop(tp,tp,g:GetCount())
		end
	end
	if ct&2>0 then
		Duel.BreakEffect()
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_DRAW_COUNT)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetTargetRange(1,0)
		e1:SetValue(3)
		e1:SetCondition(c75038087.drcon)
		if Duel.GetTurnPlayer()==tp and Duel.GetCurrentPhase()==PHASE_DRAW then
			e1:SetReset(RESET_PHASE+PHASE_DRAW+RESET_SELF_TURN,2)
			e1:SetLabel(Duel.GetTurnCount())
		else
			e1:SetReset(RESET_PHASE+PHASE_DRAW+RESET_SELF_TURN)
			e1:SetLabel(0)
		end
		Duel.RegisterEffect(e1,tp)
	end
end
function c75038087.drcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnCount()~=e:GetLabel()
end
function c75038087.effectfilter(e,ct)
	local p,code=Duel.GetChainInfo(ct,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_CODE)
	return e:GetHandler():GetControler()==p and (code==97769122 or code==35906693)
end
