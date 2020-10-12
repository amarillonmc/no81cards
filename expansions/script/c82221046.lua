function c82221046.initial_effect(c)
	aux.EnablePendulumAttribute(c) 
	--negate attack  
	local e1=Effect.CreateEffect(c)  
	e1:SetDescription(aux.Stringid(82221046,0))  
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)  
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)  
	e1:SetCode(EVENT_ATTACK_ANNOUNCE)  
	e1:SetRange(LOCATION_HAND)  
	e1:SetCondition(c82221046.condition)  
	e1:SetTarget(c82221046.target)  
	e1:SetOperation(c82221046.operation)  
	c:RegisterEffect(e1)  
	--scale  
	local e4=Effect.CreateEffect(c)  
	e4:SetType(EFFECT_TYPE_SINGLE)  
	e4:SetCode(EFFECT_CHANGE_LSCALE)  
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)  
	e4:SetRange(LOCATION_PZONE)  
	e4:SetCondition(c82221046.slcon)  
	e4:SetValue(4)  
	c:RegisterEffect(e4)  
	local e5=e4:Clone()  
	e5:SetCode(EFFECT_CHANGE_RSCALE)  
	c:RegisterEffect(e5) 
end
 function c82221046.cfilter(c)  
	return c:IsFaceup() and (c:IsSetCard(0x99) or c:IsSetCard(0x9f))
end  
function c82221046.condition(e,tp,eg,ep,ev,re,r,rp)  
	local at=Duel.GetAttacker()  
	return at:GetControler()~=tp and Duel.IsExistingMatchingCard(c82221046.cfilter,tp,LOCATION_ONFIELD,0,1,nil)  
end  
function c82221046.target(e,tp,eg,ep,ev,re,r,rp,chk)  
	local c=e:GetHandler()  
	if chk==0 then  
		return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)  
	end  
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)  
end  
function c82221046.operation(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler()  
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)>0 then  
		Duel.NegateAttack()  
	end  
end  
function c82221046.slfilter(c)  
	return c:IsSetCard(0x9f) or c:IsSetCard(0x99)
end  
function c82221046.slcon(e)  
	return not Duel.IsExistingMatchingCard(c82221046.slfilter,e:GetHandlerPlayer(),LOCATION_PZONE,0,1,e:GetHandler())  
end  