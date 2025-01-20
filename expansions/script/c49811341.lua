--机壳接口 混乱
function c49811341.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--splimit
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetRange(LOCATION_PZONE)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c49811341.splimit)
	c:RegisterEffect(e1)
	--scale
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_CHANGE_LSCALE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCondition(c49811341.slcon)
	e2:SetValue(c49811341.pval)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_CHANGE_RSCALE)
	c:RegisterEffect(e3)
	--to hand
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(49811341,0))
	e4:SetCategory(CATEGORY_TOHAND)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_SUMMON_SUCCESS)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetRange(LOCATION_PZONE)
	e4:SetCondition(c49811341.thcon)
	e4:SetTarget(c49811341.thtg)
	e4:SetOperation(c49811341.thop)
	c:RegisterEffect(e4)
end
function c49811341.splimit(e,c,tp,sumtp,sumpos)
	return not c:IsSetCard(0xaa)
end
function c49811341.slcon(e)
	return Duel.IsExistingMatchingCard(Card.IsSetCard,e:GetHandlerPlayer(),LOCATION_PZONE,0,1,e:GetHandler(),0xaa)
end
function c49811341.pval(e,tp)
	local tc=Duel.GetMatchingGroup(nil,e:GetHandlerPlayer(),LOCATION_PZONE,0,e:GetHandler()):GetFirst()
	if not (tc and tc:GetType(TYPE_PENDULUM) and tc:IsSetCard(0xaa)) then return 5 end
	return math.max(10-tc:GetLeftScale(),tc:GetLeftScale()-10)
end
function c49811341.chkfilter(c,tp)
	return c:IsControler(tp) and c:IsSetCard(0xaa) and c:IsFaceup() and c:IsSummonType(SUMMON_TYPE_ADVANCE)
end
function c49811341.thcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c49811341.chkfilter,1,nil,tp)
end
function c49811341.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetFieldGroup(tp,LOCATION_PZONE,LOCATION_PZONE)
	if chk==0 then return g:IsExists(Card.IsAbleToHand,1,nil) and Duel.GetFlagEffect(tp,49811341)==0 end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,#g,0,0)
end
function c49811341.thop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(tp,LOCATION_PZONE,LOCATION_PZONE)
	if Duel.SendtoHand(g,nil,REASON_EFFECT)~=0 and Duel.GetFlagEffect(tp,49811341)==0 then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetDescription(aux.Stringid(49811341,1))
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_EXTRA_PENDULUM_SUMMON)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetTargetRange(1,0)
		e1:SetCountLimit(1,29432356)
		e1:SetValue(c49811341.pendvalue)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
		Duel.RegisterFlagEffect(tp,49811341,RESET_PHASE+PHASE_END,0,1)
	end
end
function c49811341.pendvalue(e,c)
	return c:IsSetCard(0xaa)
end
