local m=82224028
local cm=_G["c"..m]
cm.name="檀杏·花信"
function cm.initial_effect(c)
	--link summon  
	c:EnableReviveLimit()  
	aux.AddLinkProcedure(c,nil,2,2,cm.lcheck)
	--special summon  
	local e2=Effect.CreateEffect(c)  
	e2:SetDescription(aux.Stringid(m,0))  
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)  
	e2:SetType(EFFECT_TYPE_IGNITION)  
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)  
	e2:SetRange(LOCATION_MZONE)  
	e2:SetCountLimit(1,m)  
	e2:SetTarget(cm.sptg)  
	e2:SetOperation(cm.spop)  
	c:RegisterEffect(e2)  
end
function cm.lcheck(g)
	local tc1=g:GetFirst()
	local tc2=g:GetNext()
	if tc1:IsLevelAbove(1) then
		local ct1=tc1:GetLevel()
	else
		if tc1:IsRankAbove(1) then
			local ct1=tc1:GetRank()
		else
			return false
		end
	end
	if tc2:IsLevelAbove(1) then
		local ct2=tc2:GetLevel()
	else
		if tc2:IsRankAbove(1) then
			local ct2=tc2:GetRank()
		else
			return false
		end
	end
	if ct1~=ct2 then return false end
	return true
end
function cm.spfilter(c,e,tp)  
	return c:IsFaceup() and Duel.IsExistingMatchingCard(cm.spfilter2,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil,e,tp,c:GetRace(),c:GetAttribute(),c:GetLevel())  
end  
function cm.spfilter2(c,e,tp,rac,att,lv)  
	return c:IsRace(rac) and c:IsAttribute(att) and c:IsLevel(lv) 
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP)
end  
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)  
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and cm.spfilter(chkc) end  
	if chk==0 then return Duel.IsExistingTarget(cm.spfilter,tp,LOCATION_MZONE,0,1,nil,e,tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end  
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)  
	Duel.SelectTarget(tp,cm.spfilter,tp,LOCATION_MZONE,0,1,1,nil,e,tp)  
end  
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tg=Duel.GetFirstTarget()
	if not tg:IsFaceup() and tg:IsRelateToEffect(e) then return end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end  
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)  
	local g=Duel.SelectMatchingCard(tp,cm.spfilter2,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil,e,tp,tg:GetRace(),tg:GetAttribute(),tg:GetLevel())  
	local tc=g:GetFirst()  
	if tc and Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP) then  
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
		e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)  
		e3:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)  
		e3:SetReset(RESET_EVENT+RESETS_REDIRECT)  
		e3:SetValue(LOCATION_REMOVED)  
		tc:RegisterEffect(e3,true) 
		local e4=Effect.CreateEffect(c)  
		e4:SetType(EFFECT_TYPE_FIELD)  
		e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)  
		e4:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)  
		e4:SetTargetRange(1,0)  
		e4:SetTarget(cm.splimit)  
		e4:SetReset(RESET_PHASE+PHASE_END)  
		Duel.RegisterEffect(e4,tp)  
	end  
	Duel.SpecialSummonComplete()  
end
function cm.splimit(e,c,sump,sumtype,sumpos,targetp,se)  
	return not c:IsType(TYPE_XYZ) and c:IsLocation(LOCATION_EXTRA)  
end  