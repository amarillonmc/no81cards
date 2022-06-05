--钢铁律命“殿堂”德拉库拉
function c60001148.initial_effect(c)
	--xyz summon
	c:EnableReviveLimit()
	aux.AddXyzProcedureLevelFree(c,c60001148.mfilter,c60001148.xyzcheck,3,3)  
	--spsummon proc
	local e1=Effect.CreateEffect(c) 
	e1:SetDescription(aux.Stringid(60001145,0))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCountLimit(1,60001145+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c60001148.hspcon)
	e1:SetOperation(c60001148.hspop)
	c:RegisterEffect(e1) 
	--xx
	local e2=Effect.CreateEffect(c)  
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O) 
	e2:SetCode(EVENT_PHASE+PHASE_END) 
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1) 
	e2:SetTarget(c60001148.actg) 
	e2:SetOperation(c60001148.acop) 
	c:RegisterEffect(e2) 
	--sp 
	local e3=Effect.CreateEffect(c) 
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON) 
	e3:SetType(EFFECT_TYPE_IGNITION) 
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetRange(LOCATION_GRAVE) 
	e3:SetTarget(c60001148.sptg) 
	e3:SetOperation(c60001148.spop) 
	c:RegisterEffect(e3)
end
function c60001148.mfilter(c) 
	return c:IsLevelAbove(1) and not c:IsType(TYPE_EFFECT)
end
function c60001148.xyzcheck(g)
	return g:GetClassCount(Card.GetLevel)==g:GetCount()  
end 
function c60001148.ovfil(c)  
	return c:IsCanOverlay() 
end  
function c60001148.hspcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local ft=Duel.GetLocationCountFromEx(tp,tp,nil,c) 
	local g=Duel.GetMatchingGroup(c60001148.ovfil,tp,LOCATION_FZONE,LOCATION_FZONE,nil)
	return ft>0 and g:GetCount()==2 and Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==0  
end
function c60001148.hspop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.GetMatchingGroup(c60001148.ovfil,tp,LOCATION_FZONE,LOCATION_FZONE,nil)
	Duel.Overlay(c,g)   
end 
function c60001148.acfil(c) 
	return c:IsType(TYPE_FIELD) and c:CheckActivateEffect(true,true,false)~=nil 
end 
function c60001148.rmfil(c,g) 
	return c:IsAbleToGrave() and g:IsExists(c60001148.acfil,1,c)   
end 
function c60001148.actg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()  
	local og=c:GetOverlayGroup() 
	local b1=Duel.CheckLocation(tp,LOCATION_SZONE,5) 
	local b2=Duel.CheckLocation(1-tp,LOCATION_SZONE,5) 
	if chk==0 then return (b1 or b2) and og:IsExists(c60001148.rmfil,1,nil,og) end 
end 
function c60001148.acop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	local og=c:GetOverlayGroup() 
	local b1=Duel.CheckLocation(tp,LOCATION_SZONE,5) 
	local b2=Duel.CheckLocation(1-tp,LOCATION_SZONE,5) 
	if not b1 and not b2 then return end 
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(60001148,3))
	local tc1=og:FilterSelect(tp,c60001148.rmfil,1,1,nil,og):GetFirst() 
	Duel.SendtoGrave(tc1,REASON_EFFECT)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(60001148,4))
	local tc2=og:FilterSelect(tp,c60001148.acfil,1,1,tc1):GetFirst() 
	local op=0 
	if b1 and b2 then 
	op=Duel.SelectOption(tp,aux.Stringid(60001148,1),aux.Stringid(60001148,2)) 
	elseif b1 then 
	op=Duel.SelectOption(tp,aux.Stringid(60001148,1))
	elseif b2 then 
	op=Duel.SelectOption(tp,aux.Stringid(60001148,2))+1 
	end  
	local te=tc2:GetActivateEffect()
	if op==0 then 
	Duel.MoveToField(tc2,tp,tp,LOCATION_FZONE,POS_FACEUP,true) 
	te:UseCountLimit(tp,1,true)   
	elseif op==1 then  
	Duel.MoveToField(tc2,tp,1-tp,LOCATION_FZONE,POS_FACEUP,true) 
	te:UseCountLimit(1-tp,1,true)   
	end 
	local tep=tc2:GetControler()
	local cost=te:GetCost()
	if cost then cost(te,tep,eg,ep,ev,re,r,rp,1) end
	Duel.RaiseEvent(tc2,4179255,te,0,tp,tp,Duel.GetCurrentChain())	 
end 
function c60001148.fovfil(c) 
	return c:IsType(TYPE_FIELD) and c:IsCanOverlay() 
end 
function c60001148.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingTarget(c60001148.fovfil,tp,LOCATION_FZONE,LOCATION_FZONE,1,nil) end 
	Duel.SelectTarget(tp,c60001148.fovfil,tp,LOCATION_FZONE,LOCATION_FZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0) 
end 
function c60001148.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()  
	local tc=Duel.GetFirstTarget()  
	if c:IsRelateToEffect(e) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and tc:IsRelateToEffect(e) then 
	if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP) then 
	Duel.Overlay(c,tc) 
	end 
	end 
end 






