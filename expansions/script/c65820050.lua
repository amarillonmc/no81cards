--源于黑影 涨潮
local s,id,o=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,id+EFFECT_COUNT_CODE_DUEL+EFFECT_COUNT_CODE_OATH)
	e1:SetOperation(s.regop)
	c:RegisterEffect(e1)
end

function s.regop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PREDRAW)
	e1:SetCountLimit(1)
	e1:SetCondition(s.condition)
	e1:SetOperation(s.op)
	e1:SetReset(RESET_PHASE+PHASE_DRAW+RESET_SELF_TURN)
	Duel.RegisterEffect(e1,tp)
end
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	return tp==Duel.GetTurnPlayer()
end
function s.thfilter(c)
	return c:IsSetCard(0x3a32) and c:IsAbleToHand()
end
function s.op(e,tp,eg,ep,ev,re,r,rp)
	if not aux.IsPlayerCanNormalDraw(tp) then return end
	Duel.Hint(HINT_CARD,0,id)
	aux.GiveUpNormalDraw(e,tp)
	local g=Duel.GetMatchingGroup(s.thfilter,tp,LOCATION_DECK,0,nil)
	local dcount=Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)
	local ct=5-Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)
	if ct<1 then return end
	if dcount==0 then return end
	for i=1,ct do
		if #g>0 then
			seq=-1
			local tc=g:GetFirst()
			local rtc=g:GetFirst()
			while tc do
				if tc:GetSequence()>seq then
					seq=tc:GetSequence()
					rtc=tc
				end
				tc=g:GetNext()
			end
			g:RemoveCard(rtc)
		end
	end
	if seq==-1 then
		Duel.ConfirmDecktop(tp,dcount)
		Duel.DisableShuffleCheck()
		local g1=Duel.GetMatchingGroup(s.thfilter,tp,LOCATION_DECK,0,nil)
		Duel.SendtoHand(g1,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g1)
		Duel.ShuffleDeck(tp)
		return
	end
	Duel.ConfirmDecktop(tp,dcount-seq)
	local thg=Duel.GetDecktopGroup(tp,dcount-seq):Filter(s.thfilter,nil)
	if thg and #thg>0 then
		Duel.DisableShuffleCheck()
		Duel.SendtoHand(thg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,thg)
		Duel.ShuffleHand(tp)
	end
end