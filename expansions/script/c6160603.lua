--破碎世界 最终审判
function c6160603.initial_effect(c)
	 --Activate  
	local e1=Effect.CreateEffect(c)  
	e1:SetType(EFFECT_TYPE_ACTIVATE)  
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)  
	--banish  
	local e2=Effect.CreateEffect(c)  
	e2:SetDescription(aux.Stringid(6160603,0))  
	e2:SetCategory(CATEGORY_REMOVE)  
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)  
	e2:SetRange(LOCATION_SZONE)  
	e2:SetCountLimit(1,6160603)  
	e2:SetCode(EVENT_PHASE+PHASE_END)  
	e2:SetTarget(c6160603.rmtg)  
	e2:SetOperation(c6160603.rmop)  
	c:RegisterEffect(e2)
	--spsummon  
	local e3=Effect.CreateEffect(c)  
	e3:SetDescription(aux.Stringid(6160603,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)  
	e3:SetType(EFFECT_TYPE_QUICK_O)  
	e3:SetCode(EVENT_FREE_CHAIN)  
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1,6161603)  
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_CARD_TARGET)  
	e3:SetHintTiming(TIMING_DAMAGE_STEP)
	e3:SetCondition(c6160603.condition) 
	e3:SetTarget(c6160603.target)  
	e3:SetOperation(c6160603.activate)  
	c:RegisterEffect(e3)
	--redirect  
	local e4=Effect.CreateEffect(c)  
	e4:SetType(EFFECT_TYPE_SINGLE)  
	e4:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)  
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)  
	e4:SetCondition(c6160603.recon)  
	e4:SetValue(LOCATION_REMOVED)  
	c:RegisterEffect(e4)	
end
function c6160603.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,LOCATION_MZONE,0,1,1,nil) end 
	local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,LOCATION_MZONE,0,1,1,nil)  
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)  
end  
function c6160603.rmop(e,tp,eg,ep,ev,re,r,rp)  
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)  
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToRemove,tp,LOCATION_MZONE,0,1,1,nil)  
	if g:GetCount()>0 then  
		Duel.Remove(g,POS_FACEUP,REASON_EFFECT)  
	end  
end 
function c6160603.cfilter(c)  
	return c:IsFaceup() and c:IsRace(RACE_SPELLCASTER)
end  
function c6160603.condition(e,tp,eg,ep,ev,re,r,rp)  
	return Duel.IsExistingMatchingCard(c6160603.cfilter,tp,LOCATION_ONFIELD,0,1,nil)  
end  
function c6160603.filter(c,e,tp)  
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsLevelBelow(8) 
end  
function c6160603.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)  
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and c6160603.filter(chkc,e,tp) end  
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0  
		and Duel.IsExistingTarget(c6160603.filter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil,e,tp) end  
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)  
	local g=Duel.SelectTarget(tp,c6160603.filter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,1,nil,e,tp)  
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)  
end  
function c6160603.activate(e,tp,eg,ep,ev,re,r,rp)  
	local tc=Duel.GetFirstTarget()  
	if tc:IsRelateToEffect(e) then  
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP_DEFENSE)  
	end  
end  
function c6160603.recon(e)  
	return e:GetHandler():IsFaceup()  
end