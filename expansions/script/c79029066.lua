--企鹅物流·重装干员-拜松
function c79029066.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep2(c,c79029066.ffilter,2,2,false)
	 --SpecialSummon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_ATTACK_ANNOUNCE)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCountLimit(1,79029066)
	e1:SetCondition(c79029066.condition)
	e1:SetCost(c79029066.cost)
	e1:SetOperation(c79029066.operation)
	c:RegisterEffect(e1) 
	--atk limit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_SELECT_BATTLE_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(0,LOCATION_MZONE)
	e2:SetValue(c79029066.atklimit)
	c:RegisterEffect(e2) 
	 --negate attack
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_BE_BATTLE_TARGET)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,790290669999999999999)
	e3:SetCondition(c79029066.condition2)
	e3:SetOperation(c79029066.operation2)
	c:RegisterEffect(e3)
end
function c79029066.condition(e,tp,eg,ep,ev,re,r,rp)
   return Duel.GetAttacker():IsControler(1-tp) and Duel.GetAttackTarget():IsSetCard(0xa900)
end
function c79029066.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c79029066.operation(e,tp,eg,ep,ev,re,r,rp)
	  local x=Duel.GetAttackTarget()
	  local c=e:GetHandler()
	  if c:IsRelateToEffect(e) then
		Duel.SendtoHand(x,tp,REASON_COST)
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
end
end
function c79029066.atklimit(e,c)
	return c~=e:GetHandler()
end
function c79029066.condition2(e,tp,eg,ep,ev,re,r,rp)
	local ec=eg:GetFirst()
	return ec:IsFaceup() and ec==e:GetHandler()
end
function c79029066.operation2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,nil,tp,0,LOCATION_MZONE,1,1,nil)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() and tc:IsControler(1-tp) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CANNOT_ATTACK)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_OATH)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
end
end



