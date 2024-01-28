--无形噬体·伪善
function c50204115.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--maintain
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e1:SetCountLimit(1)
	e1:SetCondition(c50204115.descon)
	e1:SetOperation(c50204115.desop)
	c:RegisterEffect(e1)
	--spsummon limit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetTargetRange(1,1)
	e2:SetTarget(c50204115.sumlimit)
	c:RegisterEffect(e2)
	--scale
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CHANGE_LSCALE)
	e3:SetRange(LOCATION_PZONE)
	e3:SetTargetRange(LOCATION_PZONE,LOCATION_PZONE)
	e3:SetTarget(c50204115.sctg)
	e3:SetValue(1)
	c:RegisterEffect(e3)
	local e31=e3:Clone()
	e31:SetCode(EFFECT_CHANGE_RSCALE)
	c:RegisterEffect(e31)
	--to hand
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EVENT_PHASE+PHASE_END)
	e4:SetCountLimit(1)
	e4:SetCondition(c50204115.thcon)
	e4:SetTarget(c50204115.thtg)
	e4:SetOperation(c50204115.thop)
	c:RegisterEffect(e4)
end
function c50204115.descon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function c50204115.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.HintSelection(Group.FromCards(c))
	if Duel.CheckReleaseGroup(tp,nil,1,c) and Duel.SelectYesNo(tp,aux.Stringid(50204115,0)) then
		local g=Duel.SelectReleaseGroup(tp,nil,1,1,c)
		Duel.Release(g,REASON_COST)
	else Duel.Destroy(c,REASON_COST) end
end
function c50204115.sumlimit(e,c,sump,sumtype,sumpos,targetp,se)
	return c:IsLocation(LOCATION_EXTRA) and not c:IsSetCard(0xe0)
end
function c50204115.sctg(e,c)
	return e:GetHandler():GetColumnGroup():IsContains(c)
		or (c:GetControler()==e:GetHandler():GetControler() and c~=e:GetHandler())
end
function c50204115.thcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp
end
function c50204115.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToHand,tp,LOCATION_PZONE,0,1,nil) end
	local g=Duel.GetMatchingGroup(Card.IsAbleToHand,tp,LOCATION_PZONE,0,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,g:GetCount(),0,0)
end
function c50204115.thop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsAbleToHand,tp,LOCATION_PZONE,0,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
	end
end