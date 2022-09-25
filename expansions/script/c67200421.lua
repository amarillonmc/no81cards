--术结天缘 莉鹭·芙罗拉
function c67200421.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	c:EnableCounterPermit(0x671,LOCATION_PZONE+LOCATION_MZONE)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(67200421,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetRange(LOCATION_HAND)
	e1:SetCode(EVENT_TO_HAND)
	e1:SetCondition(c67200421.scon)
	e1:SetTarget(c67200421.stg)
	e1:SetOperation(c67200421.sop)
	c:RegisterEffect(e1)
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e0:SetCode(EVENT_LEAVE_FIELD_P)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e0:SetOperation(c67200421.regop)
	e0:SetLabelObject(e1)
	c:RegisterEffect(e0)
	--add counter
	local e2=Effect.CreateEffect(c)
	--e2:SetCategory(CATEGORY_COUNTER)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCode(EVENT_TO_HAND)
	e2:SetCondition(c67200421.ctcon)
	--e2:SetTarget(c67200421.cttg)
	e2:SetOperation(c67200421.ctop)
	c:RegisterEffect(e2) 
	--pendulum scale up
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetCode(EFFECT_UPDATE_LSCALE)
	e3:SetRange(LOCATION_PZONE)
	e3:SetValue(c67200421.scaleup)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EFFECT_UPDATE_RSCALE)
	c:RegisterEffect(e4)	
end
--
function c67200421.regop(e,tp,eg,ep,ev,re,r,rp)
	e:GetLabelObject():SetLabel(e:GetHandler():GetCounter(0x671))
end
function c67200421.scon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ct=e:GetLabel()
	return c:IsPreviousPosition(POS_FACEUP) and c:IsPreviousLocation(LOCATION_ONFIELD) and ct>0
end
function c67200421.spfilter(c,e,tp)
	return c:IsSetCard(0x7671) and c:IsCanHaveCounter(0x671) and Duel.IsCanAddCounter(tp,0x671,1,c) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c67200421.stg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>=2 and not Duel.IsPlayerAffectedByEffect(tp,59822133)
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.IsCanAddCounter(tp,0x1,1,c)
		and Duel.IsExistingMatchingCard(c67200421.spfilter,tp,LOCATION_DECK+LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,2,tp,LOCATION_DECK)
end
function c67200421.sop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or not c:IsCanBeSpecialSummoned(e,0,tp,false,false) then return end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<2 or Duel.IsPlayerAffectedByEffect(tp,59822133) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c67200421.spfilter,tp,LOCATION_DECK+LOCATION_HAND,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		g:AddCard(c)
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		for tc in aux.Next(g) do
			tc:AddCounter(0x671,1)
		end
	end
end


--
function c67200421.ctfilter(c,tp)
	return c:IsPreviousLocation(LOCATION_ONFIELD) and c:IsPreviousPosition(POS_FACEUP) and c:IsPreviousControler(tp)
		and c:IsType(TYPE_PENDULUM) and c:IsPreviousSetCard(0x5671)
end
function c67200421.ctcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c67200421.ctfilter,1,nil,tp)
end
function c67200421.actfilter(c,e,tp)
	return c:IsSetCard(0x7671) and c:IsCanBeSpecialSummoned(e,0,tp,tp,false)
end
--function c67200421.cttg(e,tp,eg,ep,ev,re,r,rp,chk)

function c67200421.ctop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	e:GetHandler():AddCounter(0x671,2)
	if Duel.IsExistingMatchingCard(c67200421.actfilter,tp,LOCATION_DECK,0,1,nil,e,tp) and c:GetCounter(0x671)>5 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsAbleToHand() and Duel.SelectYesNo(tp,aux.Stringid(67200421,2)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,c67200421.actfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
		if Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)~=0 then
			Duel.SendtoHand(c,nil,REASON_EFFECT)
		end
	end
end
--
function c67200421.scaleup(e,c)
	local count=c:GetCounter(0x671)
	local a=0
	if count>6 then
		a=6
	else
		a=count
	end
	return a
end