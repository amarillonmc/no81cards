--方舟骑士.阿米娅
function c29065577.initial_effect(c)
	aux.AddCodeList(c,29065577)
	c:EnableCounterPermit(0x11ae)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(29065577,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,29065577)
	e1:SetCost(c29065577.spcost)
	e1:SetTarget(c29065577.sptg)
	e1:SetOperation(c29065577.spop)
	c:RegisterEffect(e1)
	--copy
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(29065577,2)) 
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,29000006)
	e2:SetCost(c29065577.cocost)
	e2:SetTarget(c29065577.cotg)
	e2:SetOperation(c29065577.coop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
	--tohand	
	local e4=Effect.CreateEffect(c)   
	e4:SetDescription(aux.Stringid(29065577,3))  
	e4:SetCategory(CATEGORY_COUNTER)	
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)	
	e4:SetProperty(EFFECT_FLAG_DELAY)   
	e4:SetCode(EVENT_TO_GRAVE)  
	e4:SetCountLimit(1,29000007) 
	e4:SetCondition(c29065577.thcon)	
	e4:SetTarget(c29065577.thtg)	
	e4:SetOperation(c29065577.thop)  
	c:RegisterEffect(e4)	
	local e5=e4:Clone()  
	e5:SetCode(EVENT_TO_HAND)   
	c:RegisterEffect(e5)
end
function c29065577.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsCanRemoveCounter(tp,1,0,0x11ae,1,REASON_COST) or Duel.IsPlayerAffectedByEffect(tp,29065592) end
	if Duel.IsPlayerAffectedByEffect(tp,29065592) and (not Duel.IsCanRemoveCounter(tp,1,0,0x11ae,1,REASON_COST) or Duel.SelectYesNo(tp,aux.Stringid(29065592,0))) then
	Duel.RegisterFlagEffect(tp,29065592,RESET_PHASE+PHASE_END,0,1)
	else
	Duel.RemoveCounter(tp,1,0,0x11ae,1,REASON_COST)
	end
end
function c29065577.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
	end Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c29065577.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c29065577.efil(c,e,tp,eg,ep,ev,re,r,rp) 
	if not (c:IsSetCard(0x87af) and c:IsType(TYPE_MONSTER) and c:IsAbleToGraveAsCost() and not c:IsCode(29065577)) then return false end 
	local m=_G["c"..c:GetCode()]
	if not m then return false end 
	local te=m.summon_effect	if not te then return false end
	local tg=te:GetTarget()
	return not tg or tg and tg(e,tp,eg,ep,ev,re,r,rp,0)
 end
function c29065577.cocost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c29065577.efil,tp,LOCATION_DECK,0,1,nil,e,tp,eg,ep,ev,re,r,rp) end
	local tc=Duel.SelectMatchingCard(tp,c29065577.efil,tp,LOCATION_DECK,0,1,1,nil,e,tp,eg,ep,re,r,rp):GetFirst()
	Duel.SendtoGrave(tc,REASON_COST)
	e:SetLabelObject(tc)
end
function c29065577.cotg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return true end
	local tc=e:GetLabelObject()
	tc:CreateEffectRelation(e)
	local m=_G["c"..tc:GetCode()]
	local te=m.summon_effect
	local tg=te:GetTarget()
	if tg then tg(e,tp,eg,ep,ev,re,r,rp,1) end
end
function c29065577.coop(e,tp,eg,ep,ev,re,r,rp,chk)
	local tc=e:GetLabelObject()
		local m=_G["c"..tc:GetCode()]
		local te=m.summon_effect
		local op=te:GetOperation()
		if op then op(e,tp,eg,ep,ev,re,r,rp) 
end
end
function c29065577.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD) 
end 
function c29065577.thfilter(c)
	return c:IsSetCard(0x87af) and c:IsCanAddCounter(0x11ae,1)
 end 
function c29065577.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
 if chk==0 then return Duel.IsExistingMatchingCard(c29065577.thfilter,tp,LOCATION_ONFIELD,0,1,nil) end 
end
 function c29065577.thop(e,tp,eg,ep,ev,re,r,rp) 
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP) 
	local tc=Duel.SelectMatchingCard(tp,c29065577.thfilter,tp,LOCATION_ONFIELD,0,1,1,nil):GetFirst()	
	local n=1 
	if Duel.IsPlayerAffectedByEffect(tp,29065580) then
	n=n+1
	end
	tc:AddCounter(0x11ae,n)
end