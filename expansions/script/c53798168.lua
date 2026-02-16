--User Card
local s,id,o=GetID()
function s.initial_effect(c)
	--Synchro Summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(nil),1)
	c:EnableReviveLimit()
	--Effect 1: Destroy & Change Effect
	local custom_code=aux.RegisterMergedDelayedEvent_ToSingleCard(c,id,{EVENT_SUMMON_SUCCESS,EVENT_SPSUMMON_SUCCESS})
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(custom_code)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,id)
	e1:SetTarget(s.destg)
	e1:SetOperation(s.desop)
	c:RegisterEffect(e1)
	--Effect 2: Destroy Replace
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,1))
	e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_DESTROY_REPLACE)
	e3:SetCountLimit(1,id+o)
	e3:SetTarget(s.reptg)
	e3:SetValue(s.repval)
	c:RegisterEffect(e3)
end

--Effect 1 Filters & Functions
function s.tgfilter(c,e,tp)
	return c:IsSummonPlayer(1-tp) and c:IsLocation(LOCATION_MZONE) and c:IsCanBeEffectTarget(e)
end
function s.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return eg:IsContains(chkc) and s.tgfilter(chkc,e,tp) end
	if chk==0 then return eg:IsExists(s.tgfilter,1,nil,e,tp) end
	local dg=eg
	if #eg>1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		dg=eg:FilterSelect(tp,s.tgfilter,1,1,nil,e,tp)
	end
	Duel.SetTargetCard(dg)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,dg,1,0,0)
end
function s.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.Destroy(tc,REASON_EFFECT)~=0 then
		--Check Chain for Effect Change (Reference: Icejade Aegirine Rahn / Amatsu)
		local ch=Duel.GetCurrentChain()
		if ch>1 then
			local te=Duel.GetChainInfo(ch-1,CHAININFO_TRIGGERING_EFFECT)
			--If the previous chain link was activated by the destroyed monster
			if te and te:GetHandler()==tc then
				--Change effect to "Destroy 1 Defense Position monster on opponent's field"
				--Note: "Opponent" here is relative to the player resolving the effect (Original Opponent)
				--So they destroy a monster on YOUR field (their opponent).
				Duel.ChangeChainOperation(ch-1,s.repop)
			end
		end
	end
end
function s.repop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	--Opponent (tp) selects 1 Defense monster on their Opponent's field (0, LOCATION_MZONE)
	local g=Duel.SelectMatchingCard(tp,Card.IsPosition,tp,0,LOCATION_MZONE,1,1,nil,POS_DEFENSE)
	if #g>0 then
		Duel.HintSelection(g)
		Duel.Destroy(g,REASON_EFFECT)
	end
end

--Effect 2 Filters & Functions
function s.repfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToRemove()
end
function s.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	--Trigger: Destroyed by opponent (Reason Player is 1-tp)
	--Cost/Action: Confirm hand, banish 1 monster
	if chk==0 then return not c:IsReason(REASON_REPLACE)
		and c:GetReasonPlayer()==1-tp
		and Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)>0 
		and Duel.IsExistingMatchingCard(s.repfilter,tp,0,LOCATION_HAND,1,nil) end
	
	if Duel.SelectEffectYesNo(tp,c,96) then
		--Logic from K9-EX Werewolf (Confirm -> Select -> Banish -> Register Return)
		local g0=Duel.GetFieldGroup(tp,0,LOCATION_HAND)
		Duel.ConfirmCards(tp,g0)
		local g=Duel.GetMatchingGroup(s.repfilter,tp,0,LOCATION_HAND,nil)
		if #g>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
			local sg=g:Select(tp,1,1,nil)
			local tc=sg:GetFirst()
			--Banish face-up
			if Duel.Remove(tc,POS_FACEUP,REASON_EFFECT+REASON_REPLACE)~=0 then
				--Register delayed return
				tc:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD,0,1)
				local ct=1
				--Logic from PSY-Frame Accelerator for phase counting
				--Current Turn is Opponent's and Phase is Standby -> Need 2 Standby Phases to be "Next"
				if Duel.GetTurnPlayer()==1-tp and Duel.GetCurrentPhase()==PHASE_STANDBY then ct=2 end
				
				local e1=Effect.CreateEffect(e:GetHandler())
				e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
				e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
				e1:SetCountLimit(1)
				if Duel.GetTurnPlayer()==1-tp and Duel.GetCurrentPhase()==PHASE_STANDBY then
					e1:SetReset(RESET_PHASE+PHASE_STANDBY+RESET_OPPO_TURN,2)
				else
					e1:SetReset(RESET_PHASE+PHASE_STANDBY+RESET_OPPO_TURN)
				end
				e1:SetLabel(ct)
				e1:SetLabelObject(tc)
				e1:SetCondition(s.retcon)
				e1:SetOperation(s.retrop)
				Duel.RegisterEffect(e1,tp)
			end
		end
		Duel.ShuffleHand(1-tp)
		return true
	else return false end
end
function s.repval(e,c)
	return false
end
function s.retcon(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetTurnPlayer()==tp then return false end --Must be Opponent's Standby
	local ct=e:GetLabel()
	if ct==1 then return true end
	e:SetLabel(ct-1)
	return false
end
function s.retrop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	if tc:GetFlagEffect(id)~=0 then
		Duel.SendtoHand(tc,1-tp,REASON_EFFECT)
	end
end