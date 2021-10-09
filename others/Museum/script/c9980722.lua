--恶魔人阿蒙
function c9980722.initial_effect(c)
	--atkup
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(9980722,0))
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c9980722.atkcon)
	e1:SetCost(c9980722.atkcost)
	e1:SetOperation(c9980722.atkop)
	c:RegisterEffect(e1)
	--spsummon bgm
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e8:SetCode(EVENT_SPSUMMON_SUCCESS)
	e8:SetOperation(c9980722.sumsuc)
	c:RegisterEffect(e8)
end
function c9980722.sumsuc(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_MUSIC,0,aux.Stringid(9980722,0))
end 
function c9980722.atkcon(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetAttackTarget()
	if not tc then return false end
	if tc:IsControler(1-tp) then tc=Duel.GetAttacker() end
	e:SetLabelObject(tc)
	return tc and tc:IsRelateToBattle() and tc:IsType(TYPE_LINK)
end
function c9980722.atkcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST)
end
function c9980722.atkop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	if tc:IsFaceup() and tc:IsRelateToBattle() then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_ATTACK_FINAL)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_DAMAGE_CAL)
		e1:SetValue(tc:GetAttack()*2)
		tc:RegisterEffect(e1)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
		e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
		e1:SetTargetRange(LOCATION_MZONE,0)
		e1:SetValue(aux.indoval)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
	end
   Duel.Hint(HINT_MUSIC,0,aux.Stringid(9980722,0))
end