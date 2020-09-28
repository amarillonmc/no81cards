local m=82228625
local cm=_G["c"..m]
cm.name="孑影之月华"
function cm.initial_effect(c)
	--special summon  
	local e1=Effect.CreateEffect(c)  
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)  
	e1:SetType(EFFECT_TYPE_ACTIVATE)  
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET) 
	e1:SetCountLimit(1,m+EFFECT_COUNT_CODE_OATH)  
	e1:SetCondition(cm.spcon)
	e1:SetTarget(cm.sptg)  
	e1:SetOperation(cm.spop)  
	c:RegisterEffect(e1)  
end
function cm.filter(c)  
	return c:IsFaceup() and c:IsSetCard(0x3299) and c:IsType(TYPE_LINK)
end  
function cm.spfilter(c,e,tp)  
	return c:IsSetCard(0x3299) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE)  
end  
function cm.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(Card.IsDefensePos,tp,0,LOCATION_MZONE,1,nil)  
end  
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)  
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and cm.filter(chkc) end  
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0  
		and Duel.IsExistingTarget(cm.filter,tp,LOCATION_MZONE,0,1,nil)  
		and Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end  
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)  
	Duel.SelectTarget(tp,cm.filter,tp,LOCATION_MZONE,0,1,1,nil)  
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)  
end  
function cm.spop(e,tp,eg,ep,ev,re,r,rp)  
	local tc=Duel.GetFirstTarget()   
	local ft=math.min(Duel.GetLocationCount(tp,LOCATION_MZONE),tc:GetLink())  
	if ft<=0 then return end  
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end  
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)  
	local g=Duel.SelectMatchingCard(tp,cm.spfilter,tp,LOCATION_GRAVE,0,1,ft,nil,e,tp)  
	if g:GetCount()>0 then  
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP_DEFENSE)  
	end  
	if e:IsHasType(EFFECT_TYPE_ACTIVATE) then  
		local e1=Effect.CreateEffect(e:GetHandler())  
		e1:SetType(EFFECT_TYPE_FIELD)  
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)  
		e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)  
		e1:SetTargetRange(1,0)  
		e1:SetTarget(cm.splimit)  
		e1:SetReset(RESET_PHASE+PHASE_END)  
		Duel.RegisterEffect(e1,tp)  
	end  
end  
function cm.splimit(e,c)  
	return not c:IsSetCard(0x3299)
end  