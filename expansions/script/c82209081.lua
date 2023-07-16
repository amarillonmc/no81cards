--壹壹肆伍壹肆世坏-恶臭世界
local m=82209081
local cm=_G["c"..m]
function cm.initial_effect(c)
	--Activate  
	local e1=Effect.CreateEffect(c)  
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)  
	e1:SetType(EFFECT_TYPE_ACTIVATE)  
	e1:SetCountLimit(1,m+EFFECT_COUNT_CODE_OATH)
	e1:SetCode(EVENT_FREE_CHAIN)  
	e1:SetOperation(cm.activate)  
	c:RegisterEffect(e1) 
	--atk&def  
	local e2=Effect.CreateEffect(c)  
	e2:SetType(EFFECT_TYPE_FIELD)  
	e2:SetCode(EFFECT_UPDATE_ATTACK)  
	e2:SetRange(LOCATION_FZONE)  
	e2:SetTargetRange(LOCATION_MZONE,0)  
	e2:SetTarget(aux.TargetBoolFunction(Card.IsRace,RACE_BEAST))  
	e2:SetValue(514)  
	c:RegisterEffect(e2)  
	--cannot set  
	local e31=Effect.CreateEffect(c)  
	e31:SetType(EFFECT_TYPE_FIELD)
	e31:SetProperty(EFFECT_FLAG_PLAYER_TARGET)  
	e31:SetRange(LOCATION_FZONE)  
	e31:SetCode(EFFECT_CANNOT_SSET)  
	e31:SetTargetRange(1,1)  
	e31:SetTarget(cm.setlimit)  
	c:RegisterEffect(e31) 
	--cannot activate
	local e32=Effect.CreateEffect(c)  
	e32:SetType(EFFECT_TYPE_FIELD)  
	e32:SetProperty(EFFECT_FLAG_PLAYER_TARGET)  
	e32:SetRange(LOCATION_FZONE)  
	e32:SetCode(EFFECT_CANNOT_ACTIVATE)  
	e32:SetTargetRange(1,1)  
	e32:SetValue(cm.aclimit)  
	c:RegisterEffect(e32)  
	--draw
	local e4=Effect.CreateEffect(c)  
	e4:SetDescription(aux.Stringid(m,1))  
	e4:SetCategory(CATEGORY_DRAW+CATEGORY_TOHAND)  
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)  
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)  
	e4:SetProperty(EFFECT_FLAG_DELAY)  
	e4:SetRange(LOCATION_FZONE)  
	e4:SetCountLimit(1,m+10000)  
	e4:SetCondition(cm.drcon)  
	e4:SetTarget(cm.drtg)  
	e4:SetOperation(cm.drop)  
	c:RegisterEffect(e4)  
end
function cm.thfilter(c)  
	return c:IsType(TYPE_MONSTER) and c:IsRace(RACE_BEAST) and c:IsAbleToHand()  
end  
function cm.activate(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end  
	local g=Duel.GetMatchingGroup(cm.thfilter,tp,LOCATION_DECK,0,nil)  
	if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(m,0)) then  
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)  
		local sg=g:Select(tp,1,1,nil)  
		if Duel.SendtoHand(sg,nil,REASON_EFFECT)~=0 then
			Duel.ConfirmCards(1-tp,sg)
			local e1=Effect.CreateEffect(c)  
			e1:SetType(EFFECT_TYPE_FIELD)  
			e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)  
			e1:SetCode(EFFECT_CANNOT_ACTIVATE)  
			e1:SetTargetRange(1,0)  
			e1:SetValue(cm.maclimit)  
			e1:SetLabel(sg:GetFirst():GetCode())  
			e1:SetReset(RESET_PHASE+PHASE_END)  
			Duel.RegisterEffect(e1,tp)  
		end
	end  
end  
function cm.maclimit(e,re,tp)  
	return re:GetHandler():IsCode(e:GetLabel()) and re:IsActiveType(TYPE_MONSTER)
end  
function cm.aclimit(e,re,tp) 
	local code=re:GetHandler():GetCode()
	return re:IsHasType(EFFECT_TYPE_ACTIVATE) and (code==77103950 or code==56063182 or code==82460246)
end  
function cm.setlimit(e,c,tp)  
	local code=c:GetCode()
	return code==77103950 or code==56063182 or code==82460246
end  
function cm.drfilter(c,tp)  
	return c:IsFaceup() and c:IsRace(RACE_BEAST) and c:IsLevelAbove(5) and c:GetSummonPlayer()==tp  
end  
function cm.drcon(e,tp,eg,ep,ev,re,r,rp)  
	return eg:IsExists(cm.drfilter,1,nil,tp)  
end  
function cm.thfilter2(c) 
	return c:IsFaceup() and c:IsAbleToHand()
end
function cm.drtg(e,tp,eg,ep,ev,re,r,rp,chk)  
	local c=e:GetHandler()
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) and Duel.IsExistingMatchingCard(cm.thfilter2,tp,LOCATION_ONFIELD,0,1,c) end  
	local g=Duel.GetMatchingGroup(cm.thfilter2,tp,LOCATION_ONFIELD,0,c)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1) 
end  
function cm.drop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local g=Duel.GetMatchingGroup(cm.thfilter2,tp,LOCATION_ONFIELD,0,c)
	if g:GetCount()>0 then
		local og=g:Select(tp,1,1,nil)
		Duel.HintSelection(og)
		if Duel.SendtoHand(og,nil,REASON_EFFECT)~=0 and Duel.IsPlayerCanDraw(tp,1) then
			Duel.ConfirmCards(1-tp,og)
			Duel.Draw(tp,1,REASON_EFFECT)
		end
	end
end