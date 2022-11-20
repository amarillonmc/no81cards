--珀尔修斯
function c10133003.initial_effect(c)
	aux.AddCodeList(c,10133001)
	--xyz summon
	aux.AddXyzProcedure(c,nil,4,2)
	c:EnableReviveLimit()
	aux.EnableChangeCode(c,10133001,LOCATION_EXTRA+LOCATION_MZONE)
	--atk
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(10133003,0))
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e1:SetHintTiming(0,TIMING_DAMAGE_CAL)
	e1:SetCountLimit(1)
	e1:SetCost(c10133003.atkcost)
	e1:SetTarget(c10133003.atktg)
	e1:SetOperation(c10133003.atkop)
	c:RegisterEffect(e1)
	--Destroy
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(10133003,1))
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_DESTROYED)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCondition(c10133003.descon)
	e2:SetTarget(c10133003.destg)
	e2:SetOperation(c10133003.desop)
	c:RegisterEffect(e2)   
	--redirect
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e4:SetCondition(c10133003.recon)
	e4:SetValue(LOCATION_DECK)
	c:RegisterEffect(e4)
end
function c10133003.recon(e)
	local c = e:GetHandler()
	return c:IsPosition(POS_FACEUP) and c:IsType(TYPE_LINK+TYPE_XYZ+TYPE_SYNCHRO+TYPE_FUSION)
end
function c10133003.desfilter(c,tp)
	return c:GetPreviousControler()~=tp and c:IsReason(REASON_EFFECT) and c:IsPreviousLocation(LOCATION_ONFIELD)
end
function c10133003.descon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c10133003.desfilter,1,nil,tp)
end
function c10133003.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_EXTRA,1,nil) end
	local ct=eg:FilterCount(c10133003.desfilter,nil,tp)
	e:SetLabel(ct)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,1-tp,LOCATION_EXTRA)
end
function c10133003.desop(e,tp,eg,ep,ev,re,r,rp)
	local ct=e:GetLabel()
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_EXTRA,nil)
	if #g > 0 then
		Duel.ConfirmCards(tp,g)
		local dg = g:Select(tp,1,ct,nil)
		Duel.Destroy(dg,REASON_EFFECT)
	end
end
function c10133003.atkcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c = e:GetHandler()
	if chk == 0 then return c:CheckRemoveOverlayCard(tp,1,REASON_COST) end
	c:RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c10133003.exfilter(c)
	return c:IsFaceup() and (c:IsCode(10133001) or (c:IsType(TYPE_FUSION) and c:IsSetCard(0x3334)))
end 
function c10133003.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c10133003.exfilter,tp,LOCATION_MZONE,0,1,nil) end
end
function c10133003.atkop(e,tp,eg,ep,ev,re,r,rp)
	local g = Duel.GetMatchingGroup(c10133003.exfilter,tp,LOCATION_MZONE,0,1,nil)
	for tc in aux.Next(g) do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_ATTACK_FINAL)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetValue(tc:GetAttack()*2)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
	end
end