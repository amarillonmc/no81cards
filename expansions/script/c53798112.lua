local s,id,o=GetID()
function s.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(nil),1)
	c:EnableReviveLimit()
	
	--cannot draw (self during opponent's turn)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_DRAW)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(1,0)
	e1:SetCondition(s.nodrawcon1)
	c:RegisterEffect(e1)
	
	--cannot draw (opponent during my turn)
	local e2=e1:Clone()
	e2:SetTargetRange(0,1)
	e2:SetCondition(s.nodrawcon2)
	c:RegisterEffect(e2)
	
	--extra draw trigger
	aux.RegisterMergedDelayedEvent(c,id,EVENT_TO_HAND)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,0))
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_CUSTOM+id)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,EFFECT_COUNT_CODE_CHAIN)
	e3:SetCondition(s.drcon)
	e3:SetOperation(s.drop)
	c:RegisterEffect(e3)
end

function s.nodrawcon1(e)
	local tp=e:GetHandlerPlayer()
	return Duel.GetTurnPlayer()~=tp
end

function s.nodrawcon2(e)
	local tp=e:GetHandlerPlayer()
	return Duel.GetTurnPlayer()==tp
end

function s.cfilter(c)
	return not c:IsReason(REASON_DRAW)
end

function s.drcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(s.cfilter,1,nil)
end

function s.pfilter(c,p)
	return c:IsControler(p) and not c:IsReason(REASON_DRAW)
end

function s.drop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	--Check for each player if they added cards
	for p=0,1 do
		if eg:IsExists(s.pfilter,1,nil,p) then
			local opp=1-p
			local current_draw=Duel.GetDrawCount(opp)
			
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_FIELD)
			e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
			e1:SetCode(EFFECT_DRAW_COUNT)
			e1:SetTargetRange(1,0)
			e1:SetValue(current_draw+1)
			e1:SetReset(RESET_PHASE+PHASE_DRAW+RESET_SELF_TURN)
			Duel.RegisterEffect(e1,opp)
		end
	end
end