--方舟之骑士·幽灵鲨
c29010014.named_with_Arknight=1
function c29010014.initial_effect(c)
	--sp summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(29010014,0))
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e1:SetCountLimit(1,29010014)
	e1:SetCondition(c29010014.tgcon)
	e1:SetTarget(c29010014.tgtg)
	e1:SetOperation(c29010014.tgop)
	c:RegisterEffect(e1) 
	--battle 
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(29010014,1))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,19010014)
	e2:SetCondition(c29010014.defcon)
	e2:SetOperation(c29010014.defop)
	c:RegisterEffect(e2)  
end 
function c29010014.tgcon(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp and re:IsActiveType(TYPE_MONSTER) and re:GetHandler():IsAttribute(ATTRIBUTE_WATER)
end
function c29010014.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c29010014.tgop(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler() 
	if c:IsRelateToEffect(e) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then 
	Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP) 
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
	Duel.Destroy(eg,REASON_EFFECT)
	end 
	end 
end
function c29010014.defcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	return bc and bc:IsControler(1-tp) and bc:IsFaceup() and bc:GetAttack()>0 and Duel.GetFlagEffect(tp,29010014)==0 
end
function c29010014.defop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	if c:IsRelateToBattle() and c:IsFaceup() and bc:IsRelateToBattle() and bc:IsFaceup() and bc:IsControler(1-tp) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetValue(1)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
		c:RegisterEffect(e2)
		local e3=e2:Clone()
		e3:SetCode(EFFECT_AVOID_BATTLE_DAMAGE)
		c:RegisterEffect(e3)
	--atklimit
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_CANNOT_ATTACK)
	e4:SetCondition(c29010014.atkcon)
	e4:SetLabel(Duel.GetTurnCount())
	e4:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,2)
	c:RegisterEffect(e4) 
	Duel.RegisterFlagEffect(tp,29010014,RESET_PHASE+PHASE_END,0,2)
	end
end
function c29010014.atkcon(e)
	return Duel.GetTurnCount()~=e:GetLabel()
end





