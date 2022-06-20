--Confusione Totale - Determinazione
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
	if not s.global_check then
		s.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_DESTROYED)
		ge1:SetOperation(s.checkop)
		Duel.RegisterEffect(ge1,0)
	end
end
function s.cfilter(c,tp)
	return c:IsPreviousControler(tp)
end
function s.checkop(e,tp,eg,ep,ev,re,r,rp)
	for p=0,1 do
		local ct=eg:FilterCount(s.cfilter,nil,p)
		if ct>0 then
			for i=1,ct do
				Duel.RegisterFlagEffect(p,id,RESET_PHASE+PHASE_END,0,1)
			end
		end
	end
end

function s.condition(e,tp)
	return Duel.GetTurnPlayer()==tp and Duel.GetCurrentPhase()==PHASE_END and Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==0 and Duel.GetFlagEffect(tp,id)>=2
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)>0 or Duel.GetFlagEffect(tp,id)<2 then return false end
	local c=e:GetHandler()
	local rct = Duel.GetTurnPlayer()~=tp and 1 or 2
	local rct2 = Duel.GetTurnPlayer()==tp and 1 or 2
	--
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,1))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_REVERSE_DAMAGE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT)
	e1:SetTargetRange(1,0)
	e1:SetValue(s.rev)
	e1:SetReset(RESET_PHASE+PHASE_END+RESET_SELF_TURN,rct)
	Duel.RegisterEffect(e1,tp)
	--
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,2))
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_MUST_ATTACK)
	e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_CLIENT_HINT)
	e2:SetTargetRange(0,LOCATION_MZONE)
	e2:SetLabel(Duel.GetTurnCount()+rct2)
	e2:SetCondition(s.con)
	e2:SetReset(RESET_PHASE+PHASE_END+RESET_OPPO_TURN,rct2)
	Duel.RegisterEffect(e2,tp)
	--
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,3))
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_PHASE+PHASE_BATTLE_START)
	e3:SetCountLimit(1)
	e3:SetLabel(Duel.GetTurnCount()+1)
	e3:SetCondition(s.btcon)
	e3:SetOperation(s.btop)
	e3:SetReset(RESET_PHASE+PHASE_END,2)
	Duel.RegisterEffect(e3,tp)
end
function s.rev(e,re,r,rp,rc)
	return bit.band(r,REASON_BATTLE)~=0
end

function s.con(e)
	local tp=e:GetOwnerPlayer()
	return Duel.GetTurnPlayer()==1-tp and Duel.GetTurnCount()==e:GetLabel()
end

function s.btcon(e)
	return Duel.GetTurnCount()==e:GetLabel()
end
function s.btop(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.IsExistingMatchingCard(aux.NOT(Card.IsControlerCanBeChanged),tp,0,LOCATION_MZONE,1,nil) and Duel.SelectYesNo(1-tp,aux.Stringid(id,4)) then
		Duel.Hint(HINT_CARD,tp,id)
		local g=Duel.GetMatchingGroup(Card.IsControlerCanBeChanged,tp,0,LOCATION_MZONE,nil)
		if not Duel.GetControl(g,tp,0,0,0xff,1-tp) then return end
		local ph=Duel.GetCurrentPhase()
		if g:FilterCount(Card.IsControler,nil,tp)==#g and ph>=PHASE_BATTLE_START and ph<=PHASE_BATTLE then
			Duel.SkipPhase(Duel.GetTurnPlayer(),PHASE_BATTLE,RESET_PHASE+PHASE_BATTLE_STEP,1)
		end
	end
end