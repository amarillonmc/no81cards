--对极之心
function c33711010.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetHintTiming(0,TIMING_END_PHASE)
	e1:SetCondition(c33711010.con)
	e1:SetCost(c33711010.cost)
	e1:SetTarget(c33711010.tg)
	e1:SetOperation(c33711010.op)
	c:RegisterEffect(e1)	
end
function c33711010.con(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp and Duel.GetCurrentPhase()==PHASE_END
end
function c33711010.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,5000) end
	Duel.PayLPCost(tp,5000)
end
function c33711010.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_HAND,LOCATION_HAND)>0 end
end
function c33711010.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_SKIP_TURN)
	e1:SetTargetRange(0,1)
	e1:SetReset(RESET_PHASE+PHASE_END+RESET_OPPO_TURN)
	Duel.RegisterEffect(e1,tp)
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(EVENT_PREDRAW)
	e2:SetTargetRange(1,0)
	e2:SetCondition(c33711010.condition1)
	e2:SetOperation(c33711010.drawop)
	Duel.RegisterEffect(e2,tp)
	local g1=Duel.GetFieldGroup(tp,LOCATION_HAND,0)
	local g2=Duel.GetFieldGroup(tp,0,LOCATION_HAND)
	if g1:GetCount()==0 and g2:GetCount()==0 then return end
	Duel.ConfirmCards(tp,g2)
	Duel.ConfirmCards(1-tp,g1)
	Duel.SendtoHand(g1,1-tp,REASON_EFFECT)
	Duel.SendtoHand(g2,tp,REASON_EFFECT)
	Duel.ShuffleHand(tp)
	Duel.ShuffleHand(1-tp)
end
function c33711010.condition1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function c33711010.drawop(e,tp,eg,ep,ev,re,r,rp)
	local dt=Duel.GetDrawCount(tp)
	if dt~=0 then
		if Duel.SelectYesNo(tp,aux.Stringid(33711010,1)) then
			aux.DrawReplaceCount=0
			aux.DrawReplaceMax=dt
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_FIELD)
			e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
			e1:SetCode(EFFECT_DRAW_COUNT)
			e1:SetTargetRange(1,0)
			e1:SetReset(RESET_PHASE+PHASE_DRAW)
			e1:SetValue(0)
			Duel.RegisterEffect(e1,tp)
			local g=Duel.GetDecktopGroup(1-tp,dt)
			Duel.DisableShuffleCheck()
			Duel.SendtoHand(g,tp,REASON_EFFECT)
		end
	end
	local e2=Effect.CreateEffect(e:GetHandler())
			e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e2:SetCode(EVENT_PHASE+PHASE_END)
			e2:SetCountLimit(1)
			e2:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)
				return true
			end)
			e2:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
				local g1=Duel.GetFieldGroup(tp,LOCATION_HAND,0)
				local g2=Duel.GetFieldGroup(tp,0,LOCATION_HAND)
				Duel.ConfirmCards(tp,g2)
				Duel.ConfirmCards(1-tp,g1)
				Duel.SendtoHand(g1,1-tp,REASON_EFFECT)
				Duel.SendtoHand(g2,tp,REASON_EFFECT)
				Duel.ShuffleHand(tp)
				Duel.ShuffleHand(1-tp)
				local tfg=Duel.GetFieldGroup(tp,LOCATION_ONFIELD,0)
				for tc in aux.Next(tfg) do
					if tc:IsAbleToChangeControler() then
						if tc:IsLocation(LOCATION_MZONE) and Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0 then
							Duel.GetControl(tc,1-tp)
						elseif tc:IsLocation(LOCATION_FZONE) then
							local fc=Duel.GetFieldCard(tp,LOCATION_FZONE,0)
							if fc then
								Duel.SendtoGrave(fc,REASON_RULE)
								Duel.BreakEffect()
							end
							local pos=tc:GetPosition()
							Duel.MoveToField(tc,tp,1-tp,LOCATION_FZONE,pos,true)
						else
							if Duel.GetLocationCount(1-tp,LOCATION_SZONE)>0 then
								local pos=tc:GetPosition()
								Duel.MoveToField(tc,tp,1-tp,LOCATION_SZONE,pos,true)
							end
						end
					end
				end
			end)
			e2:SetReset(RESET_PHASE+PHASE_END)
			Duel.RegisterEffect(e2,tp)
	e:Reset()
end












