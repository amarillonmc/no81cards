local s,id,o=GetID()
function s.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(nil),1)
	c:EnableReviveLimit()
	--apply effect when synchro summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(s.appcon)
	e1:SetOperation(s.appop)
	c:RegisterEffect(e1)
end
function s.appcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_SYNCHRO) 
		and Duel.GetTurnPlayer()==tp
		and Duel.IsMainPhase()
end
function s.appop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	--HOPT check (based on Source 5 logic)
	if Duel.GetFlagEffect(tp,id)~=0 then return end
	Duel.RegisterFlagEffect(tp,id,RESET_PHASE+PHASE_END,0,1)
	
	local op=0
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EFFECT)
	--Option 0: Monster Negate (Now), S/T Negate (Next Turn)
	--Option 1: S/T Negate (Now), Monster Negate (Next Turn)
	op=Duel.SelectOption(tp,aux.Stringid(id,1),aux.Stringid(id,2))
	
	--Apply immediate effect (until turn end)
	s.register_sub_effect(c,op,true)
	
	--Register delayed effect for next turn
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE_START+PHASE_DRAW)
	e1:SetCountLimit(1)
	--Store: current turn count, and the "other" option (1-op)
	e1:SetLabel(Duel.GetTurnCount(),1-op)
	e1:SetCondition(s.delaycon)
	e1:SetOperation(s.delayop)
	--Reset at the end of the next turn cycle ensures it catches the next Draw Phase
	e1:SetReset(RESET_PHASE+PHASE_DRAW) 
	Duel.RegisterEffect(e1,tp)
end

--Helper to register the sub-effects
function s.register_sub_effect(c,op,is_temp)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	
	if is_temp then
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	else
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	end
	
	if op==0 then
		--Negate Monster Effect + Draw
		e1:SetDescription(aux.Stringid(id,1))
		e1:SetCategory(CATEGORY_NEGATE+CATEGORY_DRAW)
		e1:SetCondition(s.discon1)
		e1:SetTarget(s.distg1)
		e1:SetOperation(s.disop1)
	else
		--Negate S/T + Discard
		e1:SetDescription(aux.Stringid(id,2))
		e1:SetCategory(CATEGORY_NEGATE+CATEGORY_HANDES)
		e1:SetCondition(s.discon2)
		e1:SetTarget(s.distg2)
		e1:SetOperation(s.disop2)
	end
	c:RegisterEffect(e1)
end

--Delayed Effect Logic
function s.delaycon(e,tp,eg,ep,ev,re,r,rp)
	local ct,op=e:GetLabel()
	return Duel.GetTurnCount()~=ct --Must be next turn or later
end
function s.delayop(e,tp,eg,ep,ev,re,r,rp)
	local ct,op=e:GetLabel()
	local c=e:GetOwner()
	if c and c:IsFaceup() then
		Duel.Hint(HINT_CARD,0,id)
		s.register_sub_effect(c,op,false) --false means indefinite (no Phase reset)
	end
	e:Reset()
end

--Effect A: Monster Negate + Draw
function s.discon1(e,tp,eg,ep,ev,re,r,rp)
	return rp~=tp and re:IsActiveType(TYPE_MONSTER) and Duel.IsChainNegatable(ev)
end
function s.distg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function s.disop1(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) then
		Duel.Draw(tp,1,REASON_EFFECT)
	end
end

--Effect B: S/T Negate + Random Discard
function s.discon2(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp and re:IsHasType(EFFECT_TYPE_ACTIVATE) and Duel.IsChainNegatable(ev)
end
function s.distg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(1-tp,LOCATION_HAND,0)>0 end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,0,1-tp,1)
end
function s.disop2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) then
		local g=Duel.GetFieldGroup(1-tp,LOCATION_HAND,0)
		if #g>0 then
			local sg=g:RandomSelect(1-tp,1)
			Duel.SendtoGrave(sg,REASON_EFFECT+REASON_DISCARD)
		end
	end
end