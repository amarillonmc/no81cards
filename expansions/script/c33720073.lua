--Confusione Totale - Noia
--Scripted by: XGlitchy30

local s,id=GetID()

function s.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1)
	e1:SetCondition(s.condition)
	e1:SetOperation(s.activate)
	e1:SetHintTiming(TIMING_END_PHASE,0)
	c:RegisterEffect(e1)
end

function s.condition(e,tp)
	return Duel.GetTurnPlayer()==tp and Duel.GetCurrentPhase()==PHASE_END and e:GetHandler():IsOnField() and Duel.GetFieldGroupCount(tp,LOCATION_ONFIELD,0)==1
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsOnField() or Duel.GetFieldGroupCount(tp,LOCATION_ONFIELD,0)~=1 then return false end
	local c=e:GetHandler()
	local rct = Duel.GetTurnPlayer()~=tp and 1 or 2
	local rct2 = Duel.GetTurnPlayer()==tp and 1 or 2
	--
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,1))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CHANGE_DAMAGE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT)
	e1:SetTargetRange(1,0)
	e1:SetValue(s.rev)
	e1:SetReset(RESET_PHASE+PHASE_END+RESET_SELF_TURN,rct)
	Duel.RegisterEffect(e1,tp)
	--
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,2))
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_PHASE+PHASE_END)
	e3:SetCountLimit(1)
	e3:SetLabel(Duel.GetTurnCount()+rct2)
	e3:SetCondition(s.btcon)
	e3:SetOperation(s.btop)
	e3:SetReset(RESET_PHASE+PHASE_END+RESET_OPPO_TURN,rct2)
	Duel.RegisterEffect(e3,tp)
end
function s.rev(e,re,dam,r)
	if bit.band(r,REASON_BATTLE+REASON_EFFECT)~=0 then
		return math.floor(dam/2)
	else return dam end
end

function s.btcon(e,tp)
	return Duel.GetTurnPlayer()==1-tp and Duel.GetTurnCount()==e:GetLabel()
end
function s.filter(c)
	return c:IsLocation(LOCATION_MZONE) and c:IsControlerCanBeChanged() or not c:IsLocation(LOCATION_MZONE) and c:IsAbleToChangeControler()
end
function s.backrow(c)
	return c:IsLocation(LOCATION_SZONE) and c:GetSequence()<5
end
function s.btop(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.GetFieldGroupCount(tp,0,LOCATION_ONFIELD)
	if Duel.GetFieldGroupCount(tp,LOCATION_ONFIELD,0)==0 and Duel.IsExistingMatchingCard(s.filter,tp,0,LOCATION_ONFIELD,math.ceil(ct/2),nil) then
		Duel.Hint(HINT_CARD,tp,id)
		local g=Duel.SelectMatchingCard(1-tp,s.filter,tp,0,LOCATION_ONFIELD,math.ceil(ct/2),math.ceil(ct/2),nil)
		if #g<math.ceil(ct/2) then return end
		local monsters=g:Filter(Card.IsLocation,nil,LOCATION_MZONE)
		local pendulums=g:Filter(Card.IsLocation,nil,LOCATION_PZONE)
		local fieldsp=g:Filter(Card.IsLocation,nil,LOCATION_FZONE)
		local backrow=g:Filter(s.backrow,nil)
		if #monsters>0 then
			Duel.GetControl(monsters,tp,0,0,0xff,1-tp)
		end
		if #pendulums>0 then
			for pc in aux.Next(pendulums) do
				Duel.MoveToField(pc,1-tp,tp,LOCATION_PZONE,pc:GetPosition(),true)
			end
		end
		if #fieldsp>0 then
			local fc=Duel.GetFieldCard(tp,LOCATION_SZONE,5)
			if fc then
				Duel.SendtoGrave(fc,REASON_RULE)
				Duel.BreakEffect()
			end
			local pc=fieldsp:GetFirst()
			Duel.MoveToField(pc,1-tp,tp,LOCATION_FZONE,pc:GetPosition(),true)
		end
		if #backrow>0 then
			for pc in aux.Next(backrow) do
				Duel.MoveToField(pc,1-tp,tp,LOCATION_SZONE,pc:GetPosition(),true)
			end
		end
	end
end