local m=53755002
local cm=_G["c"..m]
cm.name="SRT兔子小队 咲"
cm.Rabbit_Team_Number_2=true
if not pcall(function() require("expansions/script/c53702500") end) then require("script/c53702500") end
function cm.initial_effect(c)
	SNNM.RabbitTeam(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetCost(cm.accost)
	e1:SetOperation(cm.acop)
	c:RegisterEffect(e1)
end
function cm.accost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>3 end
	Duel.ConfirmDecktop(tp,4)
	local g=Duel.GetDecktopGroup(tp,4)
	local ct=g:FilterCount(Card.IsSetCard,nil,0x5536)
	e:SetLabel(ct)
	Duel.SetTargetCard(g)
end
function cm.acop(e,tp,eg,ep,ev,re,r,rp)
	local exg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	local ct=exg:GetCount()
	if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)<=ct then return end
	if ct>0 then
		for exc in aux.Next(exg) do Duel.MoveSequence(exc,0) end
		Duel.SortDecktop(tp,tp,ct)
		for i=1,ct do
			local mg=Duel.GetDecktopGroup(tp,1)
			Duel.MoveSequence(mg:GetFirst(),1)
		end
		ct=e:GetLabel()
		local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
		if ct>0 and #g>0 and Duel.SelectYesNo(tp,aux.Stringid(m,1)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPPO)
			local sg=g:Select(tp,1,ct,nil)
			Duel.HintSelection(sg)
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetDescription(aux.Stringid(m,2))
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CLIENT_HINT)
			e1:SetCode(EFFECT_CANNOT_ATTACK)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			local e2=e1:Clone()
			e2:SetCode(EFFECT_CANNOT_TRIGGER)
			sg:ForEach(Card.RegisterEffect,e1)
			sg:ForEach(Card.RegisterEffect,e2)
		end
	end
end
