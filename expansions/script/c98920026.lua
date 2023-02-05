--小调七音服·阿米涅蒂娅 
function c98920026.initial_effect(c)
		--pendulum summon
	aux.EnablePendulumAttribute(c)   
 --search
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(98920026,0))
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCountLimit(1,98920026)
	e1:SetCondition(c98920026.scon)
	e1:SetTarget(c98920026.stg)
	e1:SetOperation(c98920026.sop)
	c:RegisterEffect(e1)	
--spsummon (deck)
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(98920026,2))
	e5:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e5:SetCode(EVENT_SUMMON_SUCCESS)
	e5:SetProperty(EFFECT_FLAG_DELAY)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCountLimit(1,98930026)
	e5:SetTarget(c98920026.sptg2)
	e5:SetOperation(c98920026.spop2)
	c:RegisterEffect(e5)   
	local e2=e5:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)  
  --disable
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(98920026,0))
	e4:SetCategory(CATEGORY_DISABLE)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_CHAINING)
	e4:SetRange(LOCATION_MZONE+LOCATION_HAND)
	e4:SetCountLimit(1,98940026)
	e4:SetCondition(c98920026.discon)
	e4:SetCost(c98920026.discost)
	e4:SetTarget(c98920026.distg)
	e4:SetOperation(c98920026.disop)
	c:RegisterEffect(e4)
end
function c98920026.cfilter(c)
	return c:GetCurrentScale()%2~=0
end
function c98920026.scon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c98920026.cfilter,tp,LOCATION_PZONE,0,1,e:GetHandler())
end
function c98920026.sfilter(c)
	return c:IsSetCard(0x162) and c:IsType(TYPE_PENDULUM) and c:IsAbleToHand()
end
function c98920026.stg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c98920026.sfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c98920026.sop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c98920026.srfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c98920026.spfilter(c,e,tp)
	return c:IsSetCard(0x162) and c:IsType(TYPE_PENDULUM) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c98920026.sptg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c98920026.spfilter,tp,LOCATION_GRAVE+LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,LOCATION_GRAVE+LOCATION_EXTRA)
end
function c98920026.spop2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<1 then return end
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c98920026.spfilter,tp,LOCATION_GRAVE+LOCATION_EXTRA,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	if tc then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
		local fid=c:GetFieldID()
		tc:RegisterFlagEffect(98920026,RESET_EVENT+RESETS_STANDARD,0,1,fid)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetCountLimit(1)
		e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		e1:SetLabel(fid)
		e1:SetLabelObject(tc)
		e1:SetCondition(c98920026.thcon2)
		e1:SetOperation(c98920026.thop2)
		Duel.RegisterEffect(e1,tp)
	end
end
function c98920026.thcon2(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	if tc:GetFlagEffectLabel(98920026)~=e:GetLabel() then
		e:Reset()
		return false
	else return true end
end
function c98920026.thop2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Destroy(e:GetLabelObject(),nil,REASON_EFFECT)
end
function c98920026.tfilter(c,tp)
	return c:IsLocation(LOCATION_MZONE) and c:IsControler(tp)
end
function c98920026.pfilter1(c)
	return c:GetCurrentScale()%2==0
end
function c98920026.discon(e,tp,eg,ep,ev,re,r,rp)
	local tp=e:GetHandlerPlayer()
	return Duel.IsExistingMatchingCard(c98920026.pfilter2,tp,LOCATION_PZONE,0,1,nil)  and ep~=tp and re:IsActiveType(TYPE_SPELL+TYPE_TRAP) and Duel.IsChainDisablable(ev)
end
function c98920026.discost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_COST)
end
function c98920026.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,eg,1,0,0)
end
function c98920026.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateEffect(ev)
end