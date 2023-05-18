local m=82209047
local cm=_G["c"..m]
function cm.initial_effect(c)
	--Activate  
	local e1=Effect.CreateEffect(c)  
	e1:SetType(EFFECT_TYPE_ACTIVATE)  
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1) 
	--immune  
	local e3=Effect.CreateEffect(c)  
	e3:SetType(EFFECT_TYPE_FIELD)  
	e3:SetCode(EFFECT_IMMUNE_EFFECT)  
	e3:SetRange(LOCATION_SZONE)  
	e3:SetTargetRange(LOCATION_MZONE+LOCATION_PZONE,0)  
	e3:SetTarget(cm.efilter)  
	e3:SetValue(cm.efilter2)  
	c:RegisterEffect(e3)  
	--instant  
	local e4=Effect.CreateEffect(c)  
	e4:SetDescription(aux.Stringid(m,0))
	e4:SetCategory(CATEGORY_SUMMON)  
	e4:SetType(EFFECT_TYPE_IGNITION)  
	e4:SetRange(LOCATION_SZONE)  
	e4:SetCountLimit(1,m)  
	e4:SetTarget(cm.smtg)  
	e4:SetOperation(cm.smop)  
	c:RegisterEffect(e4) 
	--set
	local e5=Effect.CreateEffect(c)  
	e5:SetDescription(aux.Stringid(m,1))
	e5:SetType(EFFECT_TYPE_IGNITION)  
	e5:SetRange(LOCATION_SZONE)
	e5:SetCountLimit(1,m)  
	e5:SetTarget(cm.settg)  
	e5:SetOperation(cm.setop)  
	c:RegisterEffect(e5)  
end
cm.has_text_type=TYPE_DUAL
cm.SetCard_01_Kieju=true
function cm.isKieju(code)
	local ccode=_G["c"..code]
	return ccode.SetCard_01_Kieju
end
function cm.efilter(e,c)  
	return cm.isKieju(c:GetCode())
end  
function cm.efilter2(e,te)  
	return not te:GetHandler().SetCard_01_Kieju and (te:IsActiveType(TYPE_SPELL) or te:IsActiveType(TYPE_TRAP)) and te:GetHandler():IsType(TYPE_CONTINUOUS)
end  
function cm.filter(c)  
	return c:IsType(TYPE_DUAL) and cm.isKieju(c:GetCode()) and c:IsFaceup() and c:IsSummonable(true,nil)
end  
function cm.smtg(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_MZONE,0,1,nil) end  
	Duel.SetOperationInfo(0,CATEGORY_SUMMON,nil,1,0,0)  
end  
function cm.smop(e,tp,eg,ep,ev,re,r,rp)  
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)  
	local g=Duel.SelectMatchingCard(tp,cm.filter,tp,LOCATION_MZONE,0,1,1,nil)  
	local tc=g:GetFirst()  
	if tc then  
		Duel.Summon(tp,tc,true,nil)  
	end  
end  
function cm.setfilter(c)  
	return c:IsType(TYPE_PENDULUM) and cm.isKieju(c:GetCode()) and not c:IsForbidden() and c:CheckUniqueOnField(tp)
end  
function cm.settg(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return (Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1)) and Duel.IsExistingMatchingCard(cm.setfilter,tp,LOCATION_DECK,0,1,nil) end 
end  
function cm.setop(e,tp,eg,ep,ev,re,r,rp) 
	if not e:GetHandler():IsRelateToEffect(e) then return end 
	if not Duel.CheckLocation(tp,LOCATION_PZONE,0) and not Duel.CheckLocation(tp,LOCATION_PZONE,1) then return end  
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)  
	local g=Duel.SelectMatchingCard(tp,cm.setfilter,tp,LOCATION_DECK,0,1,1,nil)  
	if g:GetCount()>0 then  
		Duel.MoveToField(g:GetFirst(),tp,tp,LOCATION_PZONE,POS_FACEUP,true)
	end  
end  