--灵知隐者 青山的真穗刃
function c29065669.initial_effect(c)
	c:EnableReviveLimit()
	--SpecialSummon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetRange(LOCATION_HAND)
	e1:SetCode(EVENT_DESTROY)
	e1:SetCountLimit(1,29065669)
	e1:SetCondition(c29065669.spcon)
	e1:SetTarget(c29065669.sptg)
	e1:SetOperation(c29065669.spop)
	c:RegisterEffect(e1)
	--Remove
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,29000032)
	e2:SetTarget(c29065669.retg)
	e2:SetOperation(c29065669.reop)
	c:RegisterEffect(e2)
	--SpecialSummon
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCountLimit(1,29000033)
	e3:SetTarget(c29065669.rvtg)
	e3:SetOperation(c29065669.rvop)
	c:RegisterEffect(e3)
end
function c29065669.ctfilter(c,tp)
	return c:IsControler(tp) and c:IsPreviousLocation(LOCATION_ONFIELD) and c:IsSetCard(0x87aa) and c:IsType(TYPE_PENDULUM) and c:IsReason(REASON_EFFECT)
end
function c29065669.spcon(e,tp,eg,ep,ev,re,r,rp)
	local ct=eg:FilterCount(c29065669.ctfilter,nil,tp)
	return ct>0 and Duel.IsExistingMatchingCard(nil,tp,LOCATION_PZONE,0,2,2,nil)
end
function c29065669.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,true,false) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end  
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,tp,LOCATION_HAND)
end
function c29065669.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.SpecialSummon(c,SUMMON_TYPE_RITUAL,tp,tp,true,false,POS_FACEUP)
c:CompleteProcedure()
end
function c29065669.ckfil(c,e,tp)
	return c:IsAbleToRemove() and c:GetSummonPlayer()~=tp 
end
function c29065669.retg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=eg:Filter(c29065669.ckfil,nil,e,tp)
	if chk==0 then return g:GetCount()>0 end	
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,g:GetCount(),1-tp,0)
end
function c29065669.reop(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(c29065669.ckfil,nil,e,tp)
	if Duel.Remove(g,0,REASON_EFFECT+REASON_TEMPORARY) then 
		g:KeepAlive()   
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetReset(RESET_PHASE+PHASE_END)
		e1:SetLabelObject(g)
		e1:SetCountLimit(1)
		e1:SetOperation(c29065669.retop)
		Duel.RegisterEffect(e1,tp)  
	end
end
function c29065669.retop(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	local tc=g:GetFirst()
	while tc do
	Duel.ReturnToField(tc)
	tc=g:GetNext()
	end
end
function c29065669.cnfil(c,e,tp)
	return c:IsSummonType(SUMMON_TYPE_PENDULUM) and c:IsControler(tp)
end
function c29065669.rvtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=eg:Filter(c29065669.cnfil,nil,e,tp)
	if chk==0 then return g:GetCount()>0 and e:GetHandler():IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,false,false) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end  
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,tp,LOCATION_GRAVE)
end
function c29065669.rvop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.SpecialSummon(c,SUMMON_TYPE_RITUAL,tp,tp,false,false,POS_FACEUP)
end