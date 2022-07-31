--破碎世界的皇帝
function c6160010.initial_effect(c)
	c:EnableReviveLimit()
	--recover  
	local e1=Effect.CreateEffect(c)  
	e1:SetDescription(aux.Stringid(6160010,0))  
	e1:SetCategory(CATEGORY_RECOVER)  
	e1:SetType(EFFECT_TYPE_QUICK_O)  
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)  
	e1:SetCode(EVENT_FREE_CHAIN)  
	e1:SetRange(LOCATION_MZONE)  
	e1:SetCountLimit(1)   
	e1:SetTarget(c6160010.rectg)  
	e1:SetOperation(c6160010.recop)  
	c:RegisterEffect(e1) 
	--spsummon  
	local e2=Effect.CreateEffect(c)  
	e2:SetDescription(aux.Stringid(6160010,1))  
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)  
	e2:SetType(EFFECT_TYPE_IGNITION)  
	e2:SetRange(LOCATION_GRAVE)  
	e2:SetCountLimit(1,6160010)  
	e2:SetCost(aux.bfgcost)  
	e2:SetTarget(c6160010.sptg)  
	e2:SetOperation(c6160010.spop)  
	c:RegisterEffect(e2)  
end
function c6160010.recfilter(c)  
	return c:IsRace(RACE_SPELLCASTER) and c:GetAttack()>0  
end  
function c6160010.rectg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)  
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c6160010.recfilter(chkc) end  
	if chk==0 then return Duel.IsExistingTarget(c6160010.recfilter,tp,LOCATION_MZONE,0,1,nil) end  
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)  
	local g=Duel.SelectTarget(tp,c6160010.recfilter,tp,LOCATION_MZONE,0,1,1,nil)  
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,g:GetFirst():GetAttack())  
end  
function c6160010.recop(e,tp,eg,ep,ev,re,r,rp)  
	local tc=Duel.GetFirstTarget()  
	if tc:IsRelateToEffect(e) and tc:GetAttack()>0 then  
		Duel.Recover(tp,tc:GetAttack(),REASON_EFFECT)  
	end  
end  
function c6160010.spfilter(c,e,tp)  
	return c:IsSetCard(0x616) and c:IsLevelBelow(3)and c:IsCanBeSpecialSummoned(e,0,tp,false,false)  
end  
function c6160010.sptg(e,tp,eg,ep,ev,re,r,rp,chk)  
	local c=e:GetHandler()  
	if chk==0 then return Duel.GetMZoneCount(tp,c)>0 and Duel.IsExistingMatchingCard(c6160010.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end  
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)  
end  
function c6160010.spop(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler()  
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then  
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)  
		local g=Duel.SelectMatchingCard(tp,c6160010.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)  
		local tc=g:GetFirst()  
		if tc and Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP) then  
			local e1=Effect.CreateEffect(c)  
			e1:SetType(EFFECT_TYPE_SINGLE)  
			e1:SetCode(EFFECT_DISABLE)  
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)  
			tc:RegisterEffect(e1,true)  
			local e2=Effect.CreateEffect(c)  
			e2:SetType(EFFECT_TYPE_SINGLE)  
			e2:SetCode(EFFECT_DISABLE_EFFECT)  
			e2:SetReset(RESET_EVENT+RESETS_STANDARD)  
			tc:RegisterEffect(e2,true) 
			local e3=Effect.CreateEffect(c)  
			e3:SetType(EFFECT_TYPE_FIELD)  
			e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)  
			e3:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)  
			e3:SetRange(LOCATION_MZONE)  
			e3:SetAbsoluteRange(tp,1,0)  
			e3:SetTarget(c6160010.splimit)  
			e3:SetReset(RESET_EVENT+RESETS_STANDARD)  
			tc:RegisterEffect(e3,true)   
		end  
		Duel.SpecialSummonComplete()  
	end  
end 
function c6160010.splimit(e,c) 
	return not c:IsRace(RACE_SPELLCASTER)
end