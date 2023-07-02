--己生转生
local m=82209119
local cm=_G["c"..m]
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)  
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)  
	e1:SetType(EFFECT_TYPE_ACTIVATE)  
	e1:SetCode(EVENT_FREE_CHAIN)   
	e1:SetCost(cm.cost)  
	e1:SetTarget(cm.target)  
	e1:SetOperation(cm.activate)  
	c:RegisterEffect(e1)  
	Duel.AddCustomActivityCounter(m,ACTIVITY_SPSUMMON,cm.counterfilter) 
end
function cm.counterfilter(c)  
	return c:IsSetCard(0x83)  
end  
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return Duel.GetLP(tp)>100 and Duel.GetCustomActivityCount(m,tp,ACTIVITY_SPSUMMON)==0 end  
	Duel.PayLPCost(tp,Duel.GetLP(tp)-100)
	Debug.Message("那并不是医疗忍术，而是转生忍术……")
	Debug.Message("……千代婆婆死了！")
	local e1=Effect.CreateEffect(e:GetHandler())  
	e1:SetType(EFFECT_TYPE_FIELD)  
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)  
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)  
	e1:SetReset(RESET_PHASE+PHASE_END)  
	e1:SetTargetRange(1,0)  
	e1:SetLabelObject(e)  
	e1:SetTarget(cm.splimit)  
	Duel.RegisterEffect(e1,tp)  
end  
function cm.splimit(e,c,sump,sumtype,sumpos,targetp,se)  
	return (not c:IsSetCard(0x1083)) and se~=e:GetLabelObject()
end  
function cm.spfilter(c,e,tp)  
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
end  
function cm.spfilter2(c,e,tp)  
	return c:IsAttackBelow(3000) and c:IsSetCard(0x1083) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false) and c:GetOriginalCodeRule()~=6165656 and Duel.GetLocationCountFromEx(tp,tp,nil,c)
end  
function cm.ovfilter(c)  
	return c:IsCanOverlay() and c:IsSetCard(0x1083) and c:IsType(TYPE_MONSTER)
end  
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return 
		(Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp)
		or (Duel.IsExistingMatchingCard(cm.spfilter2,tp,LOCATION_EXTRA,0,1,nil,e,tp)
		and Duel.IsExistingMatchingCard(cm.ovfilter,tp,LOCATION_DECK,0,2,nil))) end  
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,LOCATION_DECK+LOCATION_HAND+LOCATION_GRAVE)  
end  
function cm.activate(e,tp,eg,ep,ev,re,r,rp)  
	local gsp=Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp)
	local esp=Duel.IsExistingMatchingCard(cm.spfilter2,tp,LOCATION_EXTRA,0,1,nil,e,tp) and Duel.IsExistingMatchingCard(cm.ovfilter,tp,LOCATION_DECK,0,2,nil)
	local area=0
	if not (gsp or esp) then return end
	if (not gsp) and esp then area=1 end
	if gsp and esp then area=Duel.SelectOption(tp,aux.Stringid(m,0),aux.Stringid(m,1)) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	if area==0 then
		local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(cm.spfilter),tp,LOCATION_GRAVE,0,1,1,nil,e,tp)  
		if g:GetCount()>0 then  
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)  
		end  
	end
	if area==1 then
		local g=Duel.SelectMatchingCard(tp,cm.spfilter2,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)  
		if g:GetCount()>0 and Duel.SpecialSummonStep(g:GetFirst(),SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP) then 
			local tc=g:GetFirst()
			local e1=Effect.CreateEffect(e:GetHandler()) 
			e1:SetDescription(aux.Stringid(m,2))
			e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
			e1:SetType(EFFECT_TYPE_SINGLE)  
			e1:SetCode(EFFECT_IMMUNE_EFFECT)  
			e1:SetValue(cm.efilter)  
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)  
			tc:RegisterEffect(e1)  
			local e2=Effect.CreateEffect(e:GetHandler())  
			e2:SetType(EFFECT_TYPE_SINGLE)  
			e2:SetCode(EFFECT_CHANGE_RACE)  
			e2:SetValue(RACE_WARRIOR)  
			e2:SetReset(RESET_EVENT+RESETS_STANDARD)  
			tc:RegisterEffect(e2)  
			Duel.SpecialSummonComplete()
			tc:CompleteProcedure()
			local og=Duel.SelectMatchingCard(tp,cm.ovfilter,tp,LOCATION_DECK,0,2,2,nil)
			if og:GetCount()>0 then
				Duel.Overlay(tc,og)
			end
		end
	end  
end  
function cm.efilter(e,re)  
	return e:GetHandler()~=re:GetOwner() and re:IsActiveType(TYPE_MONSTER)  
end  