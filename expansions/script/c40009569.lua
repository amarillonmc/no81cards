--拂晓之蛋
function c40009569.initial_effect(c)
	aux.AddCodeList(c,40009579)
	--Activate
	local e1=Effect.CreateEffect(c) 
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN) 
	c:RegisterEffect(e1)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(40009569,1))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCountLimit(1,40009569)
	e1:SetCost(c40009569.spcost)
	e1:SetTarget(c40009569.sptg)
	e1:SetOperation(c40009569.spop)
	c:RegisterEffect(e1) 
	--search
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(40009569,2))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1,40009569+1) 
	e2:SetCondition(c40009569.thcon)
	e2:SetTarget(c40009569.thtg)
	e2:SetOperation(c40009569.thop)
	c:RegisterEffect(e2)
end
function c40009569.rlfil(c) 
	return c:IsSetCard(0x3f1b,0x3f1a) and c:IsReleasable()
end 
function c40009569.spcost(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return Duel.IsPlayerCanRelease(tp,e:GetHandler()) and Duel.IsExistingMatchingCard(c40009569.rlfil,tp,LOCATION_MZONE,0,1,nil) end
	local rg=Duel.SelectMatchingCard(tp,c40009569.rlfil,tp,LOCATION_MZONE,0,1,1,nil)
	rg:AddCard(e:GetHandler()) 
	Duel.Release(rg,REASON_COST) 
end
function c40009569.spfilter(c,e,tp)
	return c:IsType(TYPE_RITUAL) and c:IsCode(40009579) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,false,true)
end
function c40009569.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(c40009569.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function c40009569.spop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c40009569.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	if tc and Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,false,false,POS_FACEUP)~=0 then 
		tc:CompleteProcedure() 
		local fid=e:GetHandler():GetFieldID()
		tc:RegisterFlagEffect(40009569,RESET_EVENT+RESETS_STANDARD,0,1,fid)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetCountLimit(1)
		e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		e1:SetLabel(fid)
		e1:SetLabelObject(tc)
		e1:SetCondition(c40009569.descon)
		e1:SetOperation(c40009569.desop)
		Duel.RegisterEffect(e1,tp)
	end
end
function c40009569.descon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	if tc:GetFlagEffectLabel(40009569)~=e:GetLabel() then
		e:Reset()
		return false
	else return true end
end
function c40009569.desop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Destroy(e:GetLabelObject(),REASON_EFFECT)
end
function c40009569.cfilter(c,tp)
	return c:IsSetCard(0x3f1a) and c:IsControler(tp) 
end
function c40009569.thcon(e,tp,eg,ep,ev,re,r,rp) 
	return eg:IsExists(c40009569.cfilter,1,nil,tp) 
end 
function c40009569.thfilter(c)
	return c:IsSetCard(0x3f1b) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end 
function c40009569.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then Duel.IsExistingMatchingCard(c40009569.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c40009569.thop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
