function c82228519.initial_effect(c)  
	--Activate  
	local e1=Effect.CreateEffect(c)   
	e1:SetDescription(aux.Stringid(82228519,0))
	e1:SetType(EFFECT_TYPE_ACTIVATE)   
	e1:SetCode(EVENT_FREE_CHAIN)  
	e1:SetCost(c82228519.cost)  
	e1:SetOperation(c82228519.activate) 
	c:RegisterEffect(e1)  
	--spsummon
	local e2=Effect.CreateEffect(c)  
	e2:SetDescription(aux.Stringid(82228519,1))  
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DESTROY)  
	e2:SetType(EFFECT_TYPE_IGNITION)  
	e2:SetRange(LOCATION_GRAVE) 
	e2:SetCountLimit(1,82228519)
	e2:SetCost(c82228519.cost2)  
	e2:SetTarget(c82228519.tg)  
	e2:SetOperation(c82228519.op)  
	c:RegisterEffect(e2)   
end   
function c82228519.cost(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return true end  
	Duel.PayLPCost(tp,math.floor(Duel.GetLP(tp)/2))  
end  
function c82228519.activate(e,tp,eg,ep,ev,re,r,rp)  
	local e1=Effect.CreateEffect(e:GetHandler())  
	e1:SetType(EFFECT_TYPE_FIELD)  
	e1:SetCode(EFFECT_IMMUNE_EFFECT)  
	e1:SetTargetRange(LOCATION_MZONE,0)  
	e1:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x291))  
	e1:SetValue(c82228519.efilter)  
	e1:SetReset(RESET_PHASE+PHASE_END)   
	Duel.RegisterEffect(e1,tp)  
end  
function c82228519.efilter(e,re)  
	return e:GetOwnerPlayer()~=re:GetOwnerPlayer() and re:IsActivated() and re:IsActiveType(TYPE_MONSTER)
end  
function c82228519.cost2(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end  
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)  
end  
function c82228519.spfilter(c,e,tp)  
	return c:IsSetCard(0x291) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)  
end  
function c82228519.tg(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0  
		and Duel.IsExistingMatchingCard(c82228519.spfilter,tp,LOCATION_HAND,0,1,nil,e,tp) end  
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)  
end  
function c82228519.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end  
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)  
	local g=Duel.SelectMatchingCard(tp,c82228519.spfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp)  
	local tc=g:GetFirst()  
	if tc and Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)~=0 then  
		local fid=e:GetHandler():GetFieldID()  
		tc:RegisterFlagEffect(82228519,RESET_EVENT+0x1fe0000,0,1,fid)  
		local e1=Effect.CreateEffect(c)  
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)  
		e1:SetCode(EVENT_PHASE+PHASE_END)  
		e1:SetCountLimit(1)  
		e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)  
		e1:SetLabel(fid)  
		e1:SetLabelObject(tc)  
		e1:SetCondition(c82228519.descon)  
		e1:SetOperation(c82228519.desop)  
		Duel.RegisterEffect(e1,tp)
	end  
end  
function c82228519.descon(e,tp,eg,ep,ev,re,r,rp)  
	local tc=e:GetLabelObject()  
	if tc:GetFlagEffectLabel(82228519)==e:GetLabel()  then  
		return true  
	else  
		e:Reset()  
		return false  
	end  
end  
function c82228519.desop(e,tp,eg,ep,ev,re,r,rp)  
	local tc=e:GetLabelObject()  
	Duel.Destroy(tc,REASON_EFFECT)  
end  