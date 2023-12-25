--核心硬币 翼角暴联组
function c32100021.initial_effect(c)
	--spsummon
	local e1=Effect.CreateEffect(c)  
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)  
	e1:SetCountLimit(1,32100021+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c32100021.sptg)
	e1:SetOperation(c32100021.spop)
	c:RegisterEffect(e1) 
	--set
	local e2=Effect.CreateEffect(c) 
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_DESTROYED)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_GRAVE) 
	e2:SetCondition(c32100021.thcon)
	e2:SetTarget(c32100021.thtg)
	e2:SetOperation(c32100021.thop)
	c:RegisterEffect(e2)
	--act in hand
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_QP_ACT_IN_NTPHAND)
	e2:SetCondition(function(e)
	local tp=e:GetHandlerPlayer()
	return Duel.IsExistingMatchingCard(function(c) return c:IsFaceup() and c.SetCard_HR_Kmr000 and c:GetOriginalLevel()>=8 end,tp,LOCATION_MZONE,0,1,nil) end)
	c:RegisterEffect(e2)
end  
c32100021.SetCard_HR_Corecoin=true 
c32100021.IsSetName_HR_Kmr000_Listed=true 
function c32100021.ctfil(c,e,tp)
	return c:IsFaceup() and c.SetCard_HR_Kmr000 and Duel.IsExistingMatchingCard(c32100021.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp,c)
end
function c32100021.spfilter(c,e,tp,sc)
	return c:IsCode(32100022) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false)
		and Duel.GetLocationCountFromEx(tp,tp,sc,c)>0 
end
function c32100021.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c32100021.ctfil,tp,LOCATION_MZONE,0,1,nil,e,tp) end 
	local tc=Duel.SelectMatchingCard(tp,c32100021.ctfil,tp,LOCATION_MZONE,0,1,1,nil,e,tp):GetFirst()
	Duel.SendtoGrave(tc,REASON_COST) 
	e:SetLabelObject(tc)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)  
end
function c32100021.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	local tc=e:GetLabelObject()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tc=Duel.SelectMatchingCard(tp,c32100021.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,tc):GetFirst()
	if tc then 
		Duel.SpecialSummon(tc,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP) 
		tc:CompleteProcedure()
	end 
end
function c32100021.setfilter(c,tp)
	return c:IsFaceup() and c:IsReason(REASON_BATTLE+REASON_EFFECT) and c:IsPreviousControler(tp) and c.SetCard_HR_Kmr000 
end
function c32100021.thcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c32100021.setfilter,1,nil,tp)
end
function c32100021.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToHand() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function c32100021.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SendtoHand(c,nil,REASON_EFFECT) 
	end
end






