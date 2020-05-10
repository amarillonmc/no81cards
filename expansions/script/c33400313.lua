--夜刀神天香 慵懒
function c33400313.initial_effect(c)
	 --xyz summon
	aux.AddXyzProcedure(c,c33400313.mfilter,4,2,c33400313.ovfilter,aux.Stringid(33400313,0),2,nil)
	c:EnableReviveLimit()
	 --SpecialSummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(33400313,1))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,33400313)
	e1:SetCost(c33400313.spcost)
	e1:SetTarget(c33400313.sptg)
	e1:SetOperation(c33400313.spop)
	c:RegisterEffect(e1)
	--material
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(33400313,2))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCountLimit(1,33400313+10000)
	e2:SetTarget(c33400313.matg)
	e2:SetOperation(c33400313.maop)
	c:RegisterEffect(e2) 
end
function c33400313.mfilter(c)
	return c:IsType(TYPE_RITUAL)
end
function c33400313.ovfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x3343) and c:IsType(TYPE_RITUAL)
end
function c33400313.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	  local ft=0
	if e:GetHandler():GetFlagEffect(33401301)>0 then ft=1 end
	if chk==0 then return  ((ft==1) or e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST)) end   
	if ft==0 then 
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
	end
end
function c33400313.filter(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE)
end
function c33400313.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c33400313.filter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c33400313.filter,tp,LOCATION_GRAVE+LOCATION_REMOVED,LOCATION_GRAVE+LOCATION_REMOVED,1,nil,e,tp) end 
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function c33400313.spop(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetLocationCount(1-tp,LOCATION_MZONE)
	if ft<=0 or not Duel.IsExistingMatchingCard(c33400313.filter,tp,LOCATION_GRAVE+LOCATION_REMOVED,LOCATION_GRAVE+LOCATION_REMOVED,1,nil,e,tp) then return end
	if ft>2 then ft=2 end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg=Duel.SelectMatchingCard(tp,c33400313.filter,tp,LOCATION_GRAVE+LOCATION_REMOVED,LOCATION_GRAVE+LOCATION_REMOVED,1,ft,nil,e,tp)
	local tc=sg:GetFirst()
	while tc do 
	  if  Duel.SpecialSummonStep(tc,0,tp,1-tp,false,false,POS_FACEUP_DEFENSE) then
		local c=e:GetHandler()
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e2)
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetCode(EFFECT_SET_ATTACK_FINAL)
		e3:SetValue(0)
		e3:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e3)
		local e4=Effect.CreateEffect(c)
		e4:SetType(EFFECT_TYPE_SINGLE)
		e4:SetCode(EFFECT_SET_DEFENSE)  
		e4:SetValue(0)
		e4:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e4)
	  end
	 tc=sg:GetNext()
	 end
	 Duel.SpecialSummonComplete()
	 if Duel.IsExistingMatchingCard(c33400313.thfilter,tp,LOCATION_GRAVE,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(33400313,4)) then 
		local tc2=Duel.SelectMatchingCard(tp,c33400313.thfilter,tp,LOCATION_GRAVE,0,1,1,nil)
		Duel.SendtoHand(tc2,tp,REASON_EFFECT)
	 end
end
function c33400313.thfilter(c)
	return c:IsSetCard(0x5341) and c:IsAbleToHand()
end

function c33400313.cfilter1(c)
	return c:IsSetCard(0x341) and c:IsCanOverlay() and c:IsFaceup()
end
function c33400313.matg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(c33400313.cfilter1,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil) end   
end
function c33400313.maop(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.IsExistingMatchingCard(c33400313.cfilter1,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil) then return false end
	local c=e:GetHandler()  
	if  c:IsRelateToEffect(e)then   
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
		local tc=Duel.SelectMatchingCard(tp,c33400313.cfilter1,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil)
		if Duel.Overlay(c,tc)~=0 then
		 e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_EFFECT)
		end
	end
end