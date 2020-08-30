local m=82224042
local cm=_G["c"..m]
cm.name="昴秀"
function cm.initial_effect(c)
	--link summon  
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkType,TYPE_EFFECT),2,2)  
	c:EnableReviveLimit()
	--spsummon
	local e1=Effect.CreateEffect(c)  
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)  
	e1:SetType(EFFECT_TYPE_IGNITION)	
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)  
	e1:SetRange(LOCATION_MZONE)  
	e1:SetCountLimit(1,m)  
	e1:SetTarget(cm.sptg)  
	e1:SetOperation(cm.spop)  
	c:RegisterEffect(e1)  
end  
function cm.spfilter1(c,e,tp)  
	local lv=c:GetOriginalLevel()  
	return lv>0 and c:IsFaceup() and Duel.IsExistingMatchingCard(cm.spfilter2,tp,LOCATION_GRAVE,0,1,nil,e,tp,lv)  
end  
function cm.spfilter2(c,e,tp,lv)  
	return c:GetOriginalLevel()==lv and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE)  
end  
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)  
	local c=e:GetHandler()   
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and cm.spfilter1(chkc,e,tp) end  
	if chk==0 then return Duel.IsExistingTarget(cm.spfilter1,tp,LOCATION_MZONE,0,1,nil,e,tp) end  
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)  
	local g=Duel.SelectTarget(tp,cm.spfilter1,tp,LOCATION_MZONE,0,1,1,nil,e,tp)  
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)  
	e:SetLabel(g:GetFirst():GetOriginalLevel())  
end  
function cm.spop(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler()  
	local tc=Duel.GetFirstTarget()  
	if not tc:IsRelateToEffect(e) or tc:IsFacedown() then return end  
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)  
	local g=Duel.SelectMatchingCard(tp,cm.spfilter2,tp,LOCATION_GRAVE,0,1,1,nil,e,tp,tc:GetOriginalLevel())  
	local sc=g:GetFirst()  
	if sc then  
		if Duel.SpecialSummonStep(sc,0,tp,tp,false,false,POS_FACEUP_DEFENSE) then 
			local e1=Effect.CreateEffect(c)  
			e1:SetType(EFFECT_TYPE_SINGLE)  
			e1:SetCode(EFFECT_DISABLE)  
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)  
			sc:RegisterEffect(e1)  
			local e2=Effect.CreateEffect(c)  
			e2:SetType(EFFECT_TYPE_SINGLE)  
			e2:SetCode(EFFECT_DISABLE_EFFECT)  
			e2:SetReset(RESET_EVENT+RESETS_STANDARD)  
			sc:RegisterEffect(e2)  
			local e3=Effect.CreateEffect(c)  
			e3:SetType(EFFECT_TYPE_SINGLE)  
			e3:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)  
			e3:SetValue(1)  
			e3:SetReset(RESET_EVENT+RESETS_STANDARD)  
			sc:RegisterEffect(e3)   
			local e4=Effect.CreateEffect(c)  
			e4:SetType(EFFECT_TYPE_SINGLE)  
			e4:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)  
			e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)  
			e4:SetReset(RESET_EVENT+RESETS_REDIRECT)  
			e4:SetValue(LOCATION_REMOVED)  
			sc:RegisterEffect(e4,true) 
			Duel.SpecialSummonComplete() 
		end  
	end  
end  