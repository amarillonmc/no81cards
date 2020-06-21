--无人机衍生物
function c79029029.initial_effect(c)
	c:SetUniqueOnField(1,0,79029029)
	--Recover
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_RECOVER)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetOperation(c79029029.reop)
	e1:SetCondition(c79029029.recon)
	c:RegisterEffect(e1)
end
function c79029029.recon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp 
	and Duel.GetCounter(tp,LOCATION_ONFIELD,0,0x1099)~=0
end
function c79029029.reop(e,tp,eg,ep,ev,re,r,rp)  
		Duel.Recover(tp,Duel.GetCounter(tp,LOCATION_ONFIELD,0,0x1099)*300,REASON_EFFECT)
end
