--决斗怪兽试验场3
function c98942050.initial_effect(c)
	--cannot special summon
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(aux.FALSE)
	c:RegisterEffect(e1)
	--show
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_NO_TURN_RESET+EFFECT_FLAG_INITIAL)
	e1:SetCode(EVENT_PREDRAW)
	e1:SetRange(0xff)
	e1:SetCountLimit(1,98942050+EFFECT_COUNT_CODE_DUEL)
	e1:SetOperation(c98942050.op)
	c:RegisterEffect(e1)
	--change effect 
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetCode(98942050)
	e5:SetRange(0xff)
	e5:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e5:SetTargetRange(1,0)
	c:RegisterEffect(e5)
		--workaround
	if not aux.current_phase_hack_check then
		aux.current_phase_hack_check=true
		_Isphase=Duel.GetCurrentPhase()
		function Duel.GetCurrentPhase()
			if Duel.IsPlayerAffectedByEffect(c:GetControler(),98942050) then
				return PHASE_MAIN1
			end
			return Duel.GetCurrentPhase()
		end
		_Isplayer=Duel.GetTurnPlayer()
		function Duel.GetTurnPlayer()
		  	if _Isplayer~=1-c:GetControler() and Duel.IsPlayerAffectedByEffect(c:GetControler(),98942050) then
				return 1-c:GetControler()
			end
			return _Isplayer
	   end
	end
end
function c98942050.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_CARD,0,98942050)
end