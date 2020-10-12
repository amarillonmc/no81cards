local m=82228638
local cm=_G["c"..m]
cm.name="孑影之魔女"
function cm.initial_effect(c)
	--search  
	local e1=Effect.CreateEffect(c)  
	e1:SetDescription(aux.Stringid(m,0))  
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)  
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)  
	e1:SetCode(EVENT_SUMMON_SUCCESS)  
	e1:SetProperty(EFFECT_FLAG_DELAY)  
	e1:SetCountLimit(1,m)  
	e1:SetTarget(cm.thtg1)  
	e1:SetOperation(cm.thop1)  
	c:RegisterEffect(e1)  
	local e2=e1:Clone()  
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)  
	c:RegisterEffect(e2)  
	--to grave  
	local e3=Effect.CreateEffect(c)  
	e3:SetDescription(aux.Stringid(m,1)) 
	e3:SetCategory(CATEGORY_TOGRAVE)  
	e3:SetType(EFFECT_TYPE_IGNITION)  
	e3:SetRange(LOCATION_MZONE)  
	e3:SetCountLimit(1,m+10000)  
	e3:SetTarget(cm.tgtg)  
	e3:SetOperation(cm.tgop)  
	c:RegisterEffect(e3)
	--pierce  
	local e4=Effect.CreateEffect(c)  
	e4:SetType(EFFECT_TYPE_SINGLE)  
	e4:SetCode(EFFECT_PIERCE)  
	c:RegisterEffect(e4)  
end
function cm.thfilter(c)  
	return c:IsSetCard(0x3299) and c:IsAbleToHand() and not c:IsCode(m) 
end  
function cm.thtg1(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_DECK,0,1,nil) end  
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)  
end  
function cm.thop1(e,tp,eg,ep,ev,re,r,rp)  
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)  
	local g=Duel.SelectMatchingCard(tp,cm.thfilter,tp,LOCATION_DECK,0,1,1,nil)  
	if g:GetCount()>0 then  
		Duel.SendtoHand(g,nil,REASON_EFFECT)  
		Duel.ConfirmCards(1-tp,g)  
	end  
	local e3=Effect.CreateEffect(e:GetHandler())  
	e3:SetType(EFFECT_TYPE_FIELD)  
	e3:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)  
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)  
	e3:SetTargetRange(1,0)  
	e3:SetTarget(cm.splimit)  
	e3:SetReset(RESET_PHASE+PHASE_END)  
	Duel.RegisterEffect(e3,tp)  
end  
function cm.splimit(e,c)  
	return not c:IsSetCard(0x3299) 
end  
function cm.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)  
	local ct=Duel.GetFieldGroupCount(tp,0,LOCATION_DECK)
	if chk==0 then return ct>0 end  
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,1-tp,LOCATION_DECK)  
end  
function cm.tgop(e,tp,eg,ep,ev,re,r,rp)  
	local g=Duel.GetMatchingGroup(Card.IsType,1-tp,LOCATION_DECK,0,nil,TYPE_MONSTER)  
	if g:GetCount()>0 then  
		Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_TOGRAVE)  
		local tc=g:Select(1-tp,1,1,nil):GetFirst()
		if tc and Duel.SendtoGrave(tc,REASON_EFFECT)~=0 and tc:IsLocation(LOCATION_GRAVE) then
			local e2=Effect.CreateEffect(e:GetHandler())  
			e2:SetType(EFFECT_TYPE_FIELD)  
			e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)  
			e2:SetCode(EFFECT_CANNOT_ACTIVATE)  
			e2:SetTargetRange(0,1)  
			e2:SetValue(cm.aclimit)  
			e2:SetLabel(tc:GetCode())  
			e2:SetReset(RESET_PHASE+PHASE_END)  
			Duel.RegisterEffect(e2,tp) 
		end
	end  
end  
function cm.aclimit(e,re,tp)  
	return re:GetHandler():IsCode(e:GetLabel())  
end  