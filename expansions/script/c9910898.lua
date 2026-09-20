--悲歌的奥斯忒茜
function c9910898.initial_effect(c)
	aux.AddCodeList(c,9910871)
	--spsummon rule
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c9910898.sprcon)
	c:RegisterEffect(e1)
	--immune
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_IMMUNE_EFFECT)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_ONFIELD,0)
	e2:SetCondition(c9910898.indcon)
	e2:SetTarget(c9910898.indtg)
	e2:SetValue(c9910898.efilter)
	c:RegisterEffect(e2)
	--extra BP
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCountLimit(1,9910898)
	e3:SetCondition(c9910898.ebcon)
	e3:SetCost(aux.bfgcost)
	e3:SetOperation(c9910898.ebop)
	c:RegisterEffect(e3)
end
function c9910898.sprcon(e,c)
	if c==nil then return true end
	local g=Duel.GetFieldGroup(0,LOCATION_MZONE,LOCATION_MZONE)
	local sg=g:Filter(Card.IsFaceup,nil)
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0 and sg and sg:GetClassCount(Card.GetRace)>=2
end
function c9910898.indcon(e)
	return Duel.GetTurnPlayer()==e:GetHandlerPlayer()
end
function c9910898.indtg(e,c)
	return aux.IsCodeListed(c,9910871) and c~=e:GetHandler()
end
function c9910898.efilter(e,te)
	return te:GetOwnerPlayer()~=e:GetHandlerPlayer() and te:IsActivated()
end
function c9910898.cfilter2(c)
	return c:IsSummonLocation(LOCATION_EXTRA) and c:IsFaceup() and c:IsRace(RACE_FISH)
end
function c9910898.ebcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c9910898.cfilter2,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil)
end
function c9910898.ebop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_BP_TWICE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	if Duel.GetTurnPlayer()==tp and (Duel.GetCurrentPhase()>=PHASE_BATTLE_START and Duel.GetCurrentPhase()<=PHASE_BATTLE) then
		e1:SetLabel(Duel.GetTurnCount())
		e1:SetCondition(c9910898.bpcon)
		e1:SetReset(RESET_PHASE+PHASE_BATTLE+RESET_SELF_TURN,2)
	else
		e1:SetReset(RESET_PHASE+PHASE_BATTLE+RESET_SELF_TURN,1)
	end
	Duel.RegisterEffect(e1,tp)
end
function c9910898.bpcon(e)
	return Duel.GetTurnCount()~=e:GetLabel()
end
