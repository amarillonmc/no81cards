--漆黑的忍者 吉尔格鲁斯
function c75009002.initial_effect(c) 
	--code
	aux.EnableChangeCode(c,75030023,LOCATION_MZONE+LOCATION_GRAVE)
	--cannot target
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e1:SetValue(aux.tgoval) 
	e1:SetCondition(function(e)  
	local tp=e:GetHandlerPlayer() 
	return Duel.IsExistingMatchingCard(function(c) return c:IsFaceup() and not c:IsCode(75030023) and c:IsSetCard(0x75e,0x754) end,tp,LOCATION_MZONE,0,1,nil) end)
	c:RegisterEffect(e1)
	--indes
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(1) 
	e2:SetCondition(function(e)  
	local tp=e:GetHandlerPlayer() 
	return Duel.IsExistingMatchingCard(function(c) return c:IsFaceup() and not c:IsCode(75030023) and c:IsSetCard(0x75e,0x754) end,tp,LOCATION_MZONE,0,1,nil) end)
	c:RegisterEffect(e2) 
	--battle 
	local e2=Effect.CreateEffect(c) 
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O) 
	e2:SetCode(EVENT_BE_BATTLE_TARGET)  
	e2:SetCondition(function(e) 
	return e:GetHandler():IsAttackPos() end)
	e2:SetTarget(c75009002.atktg)
	e2:SetOperation(c75009002.atkop)
	c:RegisterEffect(e2) 
	--spsummon
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_BATTLE_DESTROYING)
	e3:SetCountLimit(1,75009002)
	e3:SetCondition(aux.bdocon)
	e3:SetTarget(c75009002.sptg)
	e3:SetOperation(c75009002.spop)
	c:RegisterEffect(e3)
end
function c75009002.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end 
end 
function c75009002.atkop(e,tp,eg,ep,ev,re,r,rp)   
	local c=e:GetHandler()
	local bc=Duel.GetAttacker()  
	if Duel.NegateAttack() and c:IsRelateToEffect(e) then 
		local e1=Effect.CreateEffect(c) 
		e1:SetType(EFFECT_TYPE_SINGLE) 
		e1:SetCode(EFFECT_UPDATE_ATTACK) 
		e1:SetRange(LOCATION_MZONE) 
		e1:SetValue(c:GetDefense()/2) 
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_DAMAGE_CAL) 
		c:RegisterEffect(e1) 
		Duel.CalculateDamage(c,bc,true)  
	end 
end  
function c75009002.spfil(c,e,tp)
	return c:IsLevelBelow(7) and c:IsSetCard(0x75e,0x754) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c75009002.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(c75009002.spfil,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK)
end 
function c75009002.spop(e,tp,eg,ep,ev,re,r,rp)   
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(c75009002.spfil,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil,e,tp) then 
		local sg=Duel.SelectMatchingCard(tp,c75009002.spfil,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil,e,tp) 
		Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP) 
	end 
end 







