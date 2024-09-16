--朱罗纪法则
function c49811259.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--disable
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e2:SetCondition(c49811259.discon)
	e2:SetTarget(c49811259.distg)
	e2:SetCode(EFFECT_DISABLE)
	c:RegisterEffect(e2)
	--to grave
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TOGRAVE)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCode(EVENT_PHASE+PHASE_END)
	e3:SetCondition(c49811259.tgcon)
	e3:SetCountLimit(1)
	e3:SetTarget(c49811259.tgtg)
	e3:SetOperation(c49811259.tgop)
	c:RegisterEffect(e3)
	if not c49811259.global_check then
		c49811259.global_check=true
		local ge1=Effect.GlobalEffect()
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_BATTLED)
		ge1:SetOperation(c49811259.checkop)
		Duel.RegisterEffect(ge1,0)
	end
end
function c49811259.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x22)
end
function c49811259.discon(e)
	return (Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2)
		and Duel.IsExistingMatchingCard(c49811259.cfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)
end
function c49811259.distg(e,c)
	return (c:IsType(TYPE_EFFECT) or c:GetOriginalType()&TYPE_EFFECT~=0)
		and c:IsAttackBelow(1700)
end
function c49811259.checkop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetAttacker() then Duel.RegisterFlagEffect(0,49811259,RESET_PHASE+PHASE_END,0,1) end
end
function c49811259.tgcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(0,49811259)==0
end
function c49811259.tgfilter(c)
	return c:IsSetCard(0x22) and c:IsAbleToGrave()
end
function c49811259.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return true end
	if Duel.GetTurnPlayer()==tp then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,e:GetHandler(),1,0,0)
	else
		Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
	end
end
function c49811259.tgop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetTurnPlayer()==tp then
		Duel.Destroy(c,REASON_EFFECT)
	else
		local g=Duel.SelectMatchingCard(tp,c49811259.tgfilter,tp,LOCATION_DECK,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.SendtoGrave(g,REASON_EFFECT)
		end
	end
end