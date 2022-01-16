--术结天缘 莉鹭·弗洛拉
function c67200401.initial_effect(c)
	--Pendulum Summon
	c:EnableCounterPermit(0x1,LOCATION_PZONE)
	c:SetCounterLimit(0x1,6)
	aux.EnablePendulumAttribute(c)
	--Add Counter
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e1:SetCode(EVENT_CHAINING)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetRange(LOCATION_PZONE)
	e1:SetOperation(aux.chainreg)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e2:SetCode(EVENT_CHAIN_SOLVED)
	e2:SetRange(LOCATION_PZONE)
	e2:SetOperation(c67200401.counterop)
	c:RegisterEffect(e2)  
	--pendulum scale up
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetCode(EFFECT_UPDATE_LSCALE)
	e3:SetRange(LOCATION_PZONE)
	e3:SetValue(c67200401.scaleup)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EFFECT_UPDATE_RSCALE)
	c:RegisterEffect(e4)
	--send to grave
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(67200401,0))
	e5:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TODECK)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetRange(LOCATION_PZONE)
	e5:SetCost(c67200401.thcost)
	e5:SetTarget(c67200401.thtg)
	e5:SetOperation(c67200401.thop)
	c:RegisterEffect(e5)  
	--cant be Destroy(effect)
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(67200401,1))
	e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e6:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e6:SetCode(EVENT_LEAVE_FIELD)
	e6:SetCountLimit(1,67200401)
	e6:SetCondition(c67200401.immcon)
	e6:SetOperation(c67200401.immop)
	c:RegisterEffect(e6)  
end
function c67200401.counterop(e,tp,eg,ep,ev,re,r,rp)
	if re:IsHasType(EFFECT_TYPE_ACTIVATE) and re:IsActiveType(TYPE_SPELL) and e:GetHandler():GetFlagEffect(1)>0 then
		e:GetHandler():AddCounter(0x1,2)
	end
end
--
function c67200401.scaleup(e,c)
	return c:GetCounter(0x1)
end
--
function c67200401.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanRemoveCounter(tp,0x1,6,REASON_COST) end
	e:GetHandler():RemoveCounter(tp,0x1,6,REASON_COST)
end
function c67200401.thfilter2(c,e,tp)  
	return c:IsSetCard(0x7671) and c:IsType(TYPE_PENDULUM) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and ((c:IsLocation(LOCATION_DECK) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0) or
		(c:IsLocation(LOCATION_EXTRA) and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0))
end  
function c67200401.thtg(e,tp,eg,ep,ev,re,r,rp,chk)  
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(c67200401.thfilter2,tp,LOCATION_DECK+LOCATION_EXTRA,0,1,nil,e,tp) end  
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_EXTRA) 
	Duel.SetOperationInfo(0,CATEGORY_TODECK,e:GetHandler(),1,0,0)
end  
function c67200401.thop(e,tp,eg,ep,ev,re,r,rp)  
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)  
	local g=Duel.SelectMatchingCard(tp,c67200401.thfilter2,tp,LOCATION_DECK+LOCATION_EXTRA,0,1,1,nil,e,tp) 
	if g:GetCount()>0 then  
		Duel.DisableShuffleCheck()
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)  
	end  
	Duel.BreakEffect()
	Duel.SendtoDeck(e:GetHandler(),nil,1,REASON_EFFECT)
	--Duel.DisableShuffleCheck()
end 
--
function c67200401.immcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousPosition(POS_FACEUP)
end
function c67200401.immop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetTarget(c67200401.target)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetValue(1)
	Duel.RegisterEffect(e1,tp)
	Duel.RegisterFlagEffect(tp,67200401,RESET_PHASE+PHASE_END,0,1)
end
function c67200401.target(e,c)
	return c:IsSetCard(0x7671)
end
