--幻蝶刺客 粉蝶
local m=82209150
local cm=c82209150
function cm.initial_effect(c)
	--special summon (self) 
	local e1=Effect.CreateEffect(c)  
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_POSITION+CATEGORY_DISABLE) 
	e1:SetType(EFFECT_TYPE_IGNITION)  
	e1:SetRange(LOCATION_HAND)  
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)  
	e1:SetCountLimit(1,m)  
	e1:SetCondition(cm.con1)
	e1:SetTarget(cm.sptg)  
	e1:SetOperation(cm.spop)  
	c:RegisterEffect(e1)  
	local e2=e1:Clone()
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(TIMING_END_PHASE)
	e2:SetCondition(cm.con2)
	c:RegisterEffect(e2)
	--special summon
	local e3=Effect.CreateEffect(c)  
	e3:SetDescription(aux.Stringid(m,1))  
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_POSITION)  
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)  
	e3:SetType(EFFECT_TYPE_IGNITION)  
	e3:SetRange(LOCATION_MZONE)  
	e3:SetCountLimit(1,m+10000)   
	e3:SetTarget(cm.sptg2)  
	e3:SetOperation(cm.spop2)  
	c:RegisterEffect(e3)  
end
function cm.spcfilter(c)
	return c:IsType(TYPE_XYZ) and c:IsRace(RACE_WARRIOR) and c:IsFaceup()
end
function cm.con1(e,tp,eg,ep,ev,re,r,rp)  
	return not Duel.IsExistingMatchingCard(cm.spcfilter,tp,LOCATION_MZONE,0,1,nil)
end
function cm.con2(e,tp,eg,ep,ev,re,r,rp)  
	return Duel.IsExistingMatchingCard(cm.spcfilter,tp,LOCATION_MZONE,0,1,nil)
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)  
	local c=e:GetHandler()  
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsCanChangePosition() and chkc:IsControler(1-tp) end  
	if chk==0 then return c:IsCanBeSpecialSummoned(e,0,tp,false,false)  
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0  
		and Duel.IsExistingTarget(Card.IsCanChangePosition,tp,0,LOCATION_MZONE,1,nil) end  
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_POSCHANGE)  
	Duel.SelectTarget(tp,Card.IsCanChangePosition,tp,0,LOCATION_MZONE,1,1,nil)  
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)  
end  
function cm.spop(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler()  
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 and tc:IsRelateToEffect(e) and Duel.ChangePosition(tc,POS_FACEUP_DEFENSE,POS_FACEDOWN_DEFENSE,POS_FACEUP_ATTACK,POS_FACEUP_ATTACK)>0 and ((tc:IsFaceup() and not tc:IsDisabled()) or tc:IsType(TYPE_TRAPMONSTER)) then  
		Duel.NegateRelatedChain(tc,RESET_TURN_SET)  
		local e1=Effect.CreateEffect(c)  
		e1:SetType(EFFECT_TYPE_SINGLE)  
		e1:SetCode(EFFECT_DISABLE)  
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)  
		tc:RegisterEffect(e1)  
		local e2=Effect.CreateEffect(c)  
		e2:SetType(EFFECT_TYPE_SINGLE)  
		e2:SetCode(EFFECT_DISABLE_EFFECT)  
		e2:SetValue(RESET_TURN_SET)  
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)  
		tc:RegisterEffect(e2)   
	end  
	local e3=Effect.CreateEffect(c)  
	e3:SetType(EFFECT_TYPE_FIELD)  
	e3:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)  
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)  
	e3:SetTargetRange(1,0)  
	e3:SetTarget(cm.splimit)  
	e3:SetReset(RESET_PHASE+PHASE_END,2)  
	Duel.RegisterEffect(e3,tp)  
end  
function cm.splimit(e,c)  
	return c:IsLocation(LOCATION_EXTRA) and not c:IsType(TYPE_XYZ)  
end  
function cm.spfilter2(c,e,tp)  
	return c:IsSetCard(0x6a) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)  
end  
function cm.sptg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)  
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE) and cm.spfilter2(chkc,e,tp) end  
	if chk==0 then return e:GetHandler():IsCanChangePosition() and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingTarget(cm.spfilter2,tp,LOCATION_GRAVE,0,1,nil,e,tp) end  
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)  
	local g=Duel.SelectTarget(tp,cm.spfilter2,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)  
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)  
end  
function cm.spop2(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler()  
	if not c:IsRelateToEffect(e) then return end  
	if Duel.ChangePosition(c,POS_FACEUP_DEFENSE,POS_FACEDOWN_DEFENSE,POS_FACEUP_ATTACK,POS_FACEUP_ATTACK)>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
		local tc=Duel.GetFirstTarget()  
		if tc:IsRelateToEffect(e) then  
			Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)  
		end  
	end
end  