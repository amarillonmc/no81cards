local m=82209044
local cm=_G["c"..m]
--久远的受灵
function cm.initial_effect(c)
	--Activate  
	local e1=Effect.CreateEffect(c)   
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)  
	e1:SetType(EFFECT_TYPE_ACTIVATE)  
	e1:SetCode(EVENT_FREE_CHAIN)  
	e1:SetCondition(cm.con)
	e1:SetTarget(cm.tg)  
	e1:SetOperation(cm.act)  
	c:RegisterEffect(e1)  
end
function cm.isKieju(code)
	local ccode=_G["c"..code]
	return ccode.SetCard_01_Kieju
end
function cm.confilter(c)  
	return c:IsFaceup() and not cm.isKieju(c:GetCode())
end  
function cm.con(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsExistingMatchingCard(cm.confilter,tp,LOCATION_MZONE,0,1,nil)
end
function cm.thfilter0(c)  
	return c:IsSummonType(SUMMON_TYPE_SPECIAL) and c:GetSummonLocation()==LOCATION_EXTRA
end  
function cm.thfilter(c)  
	return cm.isKieju(c:GetCode()) and c:IsAbleToHand()  
end  
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_DECK,0,1,nil) end  
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)  
end  
function cm.act(e,tp,eg,ep,ev,re,r,rp)  
	local g=Duel.GetMatchingGroup(cm.thfilter,tp,LOCATION_DECK,0,nil)  
	if g:GetCount()>0 then
		local ct=1
		local g0=Duel.GetMatchingGroup(cm.thfilter0,tp,0,LOCATION_MZONE,nil)  
		if g0:GetCount()>0 then ct=ct+g0:GetCount() end  
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)  
		local sg=g:SelectSubGroup(tp,aux.dncheck,false,1,ct)  
		if sg and sg:GetCount()>0 then  
			local dmct=Duel.SendtoHand(sg,nil,REASON_EFFECT)  
			Duel.ConfirmCards(1-tp,sg) 
			if dmct>0 then
				Duel.SetLP(tp,Duel.GetLP(tp)-dmct*1000)
			end
		end 
	end
	local e1=Effect.CreateEffect(e:GetHandler())  
	e1:SetType(EFFECT_TYPE_FIELD)  
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)  
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)  
	e1:SetTargetRange(1,0)  
	e1:SetTarget(cm.splimit)  
	e1:SetReset(RESET_PHASE+PHASE_END)  
	Duel.RegisterEffect(e1,tp)  
end  
function cm.splimit(e,c)  
	return not cm.isKieju(c:GetCode()) and (c:IsLocation(LOCATION_DECK) or c:IsLocation(LOCATION_HAND) or c:IsLocation(LOCATION_GRAVE)) 
end  