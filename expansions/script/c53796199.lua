local s,id=GetID()
s.skipdraw=true
local f=Card.RegisterEffect
Card.RegisterEffect=function(c,e,bool)
	if not s.global_check then
		s.global_check=true
		local e1=Effect.GlobalEffect()
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetTargetRange(1,1)
		e1:SetCode(EFFECT_SKIP_DP)
		e1:SetCondition(function(e)return Duel.GetTurnCount()==1 end)
		Duel.RegisterEffect(e1,0)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e2:SetCode(EVENT_PHASE_START+PHASE_STANDBY)
		e2:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
			local tc=Duel.GetFirstMatchingCard(function(c)return c.skipdraw end,0,0xff,0xff,nil)
			if Duel.GetTurnCount()==1 then Duel.ConfirmCards(0,tc) Duel.ConfirmCards(1,tc) end e:Reset()
		end)
		Duel.RegisterEffect(e2,0)
	end
	return f(c,e,bool)
end
function s.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	c:RegisterEffect(e1)
end
