--红帽单调士
function c9310005.initial_effect(c)
	--destroy replace
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_DESTROY_REPLACE)
	e1:SetCondition(c9310005.cona)
	e1:SetTarget(c9310005.reptg)
	e1:SetOperation(c9310005.repop)
	c:RegisterEffect(e1)
	--nontuner
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_NONTUNER)
	e2:SetValue(c9310005.tnval)
	c:RegisterEffect(e2)
end
function c9310005.cona(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsAttackPos()
end
function c9310005.repfilter(c,e)
	return c:IsDestructable(e) and not c:IsStatus(STATUS_DESTROY_CONFIRMED)
end
function c9310005.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local g=Duel.GetDecktopGroup(e:GetHandlerPlayer(),1)
	local tc=g:GetFirst()
	if chk==0 then return c:IsReason(REASON_BATTLE+REASON_EFFECT) and not c:IsReason(REASON_REPLACE)
		and Duel.GetFieldGroupCount(e:GetHandlerPlayer(),LOCATION_DECK,0)>0 and tc:IsDestructable(e) 
		and not tc:IsStatus(STATUS_DESTROY_CONFIRMED) end
	if Duel.SelectEffectYesNo(tp,c,96) then
		Duel.SetTargetCard(g)
		tc:SetStatus(STATUS_DESTROY_CONFIRMED,true)
		return true
	else return false end
end
function c9310005.repop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	g:GetFirst():SetStatus(STATUS_DESTROY_CONFIRMED,false)
	Duel.Destroy(g,REASON_EFFECT+REASON_REPLACE)
end
function c9310005.tnval(e,c)
	return e:GetHandler():IsDefensePos()
end
