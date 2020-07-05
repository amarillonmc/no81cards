--罗德岛·近卫干员-宴
function c79029178.initial_effect(c)
	c:EnableReviveLimit()
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(13313278,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetRange(LOCATION_HAND)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_DAMAGE)
	e1:SetCondition(c79029178.spcon)
	e1:SetTarget(c79029178.sptg)
	e1:SetOperation(c79029178.spop)
	c:RegisterEffect(e1)
	--chain attack
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_DAMAGE_STEP_END)
	e2:SetCountLimit(1)
	e2:SetCost(c79029178.atcost)
	e2:SetOperation(c79029178.atop)
	c:RegisterEffect(e2)
	--destroy replace
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EFFECT_DESTROY_REPLACE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTarget(c79029178.reptg)
	e3:SetOperation(c79029178.repop)
	c:RegisterEffect(e3)
end
function c79029178.spcon(e,tp,eg,ep,ev,re,r,rp)
	return ep==tp
end
function c79029178.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c79029178.spop(e,tp,eg,ep,ev,re,r,rp)
	 local c=e:GetHandler()
	 if Duel.SpecialSummon(c,0,tp,tp,true,true,POS_FACEUP)~=0 then
	 local e1=Effect.CreateEffect(c)
	 e1:SetType(EFFECT_TYPE_SINGLE)
	 e1:SetCode(EFFECT_UPDATE_ATTACK)
	 e1:SetValue(ev)
	 e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	 c:RegisterEffect(e1)
	 local e1=Effect.CreateEffect(c)
	 e1:SetType(EFFECT_TYPE_SINGLE)
	 e1:SetCode(EFFECT_UPDATE_DEFENSE)
	 e1:SetValue(ev)
	 e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	 c:RegisterEffect(e1)
	end
end
function c79029178.costfilter(c)
	return c:IsSetCard(0xa900) and c:IsAbleToGraveAsCost()
end
function c79029178.atcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c79029178.costfilter,tp,LOCATION_EXTRA,0,1,nil) and Duel.GetAttacker()==e:GetHandler() 
	and e:GetHandler():IsChainAttackable(0) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c79029178.costfilter,tp,LOCATION_EXTRA,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
end
function c79029178.atop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ChainAttack()
end
function c79029178.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetDefense()>=1000 end
	return Duel.SelectEffectYesNo(tp,e:GetHandler(),79029096)
end
function c79029178.repop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_DEFENSE)
	e1:SetValue(-1000)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	c:RegisterEffect(e1)
end
