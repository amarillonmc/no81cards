--欲望硬币核心·灼热联组
function c9980797.initial_effect(c)
	--atkup
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(9980797,0))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_HAND)
	e2:SetHintTiming(TIMING_DAMAGE_STEP)
	e2:SetCountLimit(1,99807970)
	e2:SetCondition(c9980797.atkcon)
	e2:SetCost(c9980797.atkcost)
	e2:SetOperation(c9980797.atkop)
	c:RegisterEffect(e2)
	  --to hand
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,9980797)
	e2:SetCondition(c9980797.thcon)
	e2:SetTarget(c9980797.thtg)
	e2:SetOperation(c9980797.thop)
	c:RegisterEffect(e2)
	--spsummon bgm
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e8:SetCode(EVENT_SPSUMMON_SUCCESS)
	e8:SetOperation(c9980797.sumsuc)
	c:RegisterEffect(e8)
	local e9=e8:Clone()
	e9:SetCode(EVENT_SUMMON_SUCCESS)
	c:RegisterEffect(e9)
end
function c9980797.sumsuc(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_MUSIC,0,aux.Stringid(9980797,0))
end
function c9980797.atkcon(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	if ph~=PHASE_DAMAGE or Duel.IsDamageCalculated() then return false end
	local tc=Duel.GetAttacker()
	if tc:IsControler(1-tp) then tc=Duel.GetAttackTarget() end
	e:SetLabelObject(tc)
	return tc and tc:IsFaceup() and tc:IsSetCard(0xabc1) and tc:IsRelateToBattle() and Duel.GetAttackTarget()~=nil
end
function c9980797.atkcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST)
end
function c9980797.atkop(e,tp,eg,ep,ev,re,r,rp,chk)
	local tc=e:GetLabelObject()
	if tc:IsRelateToBattle() and tc:IsFaceup() and tc:IsControler(tp) then
		local atk=tc:GetBaseAttack()
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(atk)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
	end
end
function c9980797.cfilter2(c,tp)
	return c:IsSummonType(SUMMON_TYPE_FUSION) and c:GetSummonPlayer()==tp
end
function c9980797.thcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c9980797.cfilter2,1,nil,tp) and aux.exccon(e)
end
function c9980797.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToHand() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function c9980797.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SendtoHand(c,nil,REASON_EFFECT)
	end
end
