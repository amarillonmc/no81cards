--承岚 FR-1035B
local cm,m,o=GetID()
function cm.initial_effect(c)
	--to hand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_SPECIAL_SUMMON+CATEGORY_TOGRAVE+CATEGORY_REMOVE+CATEGORY_TODECK+CATEGORY_LEAVE_GRAVE)
	e1:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetTarget(cm.thtg)
	e1:SetOperation(cm.thop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	--indes
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_ADJUST)
	e3:SetRange(0xff)
	e3:SetCost(cm.icost)
	e3:SetCondition(cm.icon)
	e3:SetTarget(cm.itg)
	e3:SetOperation(cm.iop)
	c:RegisterEffect(e3)
end
function cm.fil1(c)
	return c:IsSetCard(0x3623) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function cm.fil2(c,e,tp,code1)
	return c:IsSetCard(0x3623) and c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and not c:IsCode(code1)
end
function cm.fil3(c,code1,code2)
	return c:IsSetCard(0x3623) and c:IsType(TYPE_MONSTER) and c:IsAbleToGrave() and c:IsFaceup()
		and not c:IsCode(code1) and not c:IsCode(code2)
end
function cm.fil4(c,code1,code2,code3)
	return c:IsSetCard(0x3623) and c:IsType(TYPE_MONSTER) and c:IsAbleToRemove()
		and not c:IsCode(code1) and not c:IsCode(code2) and not c:IsCode(code3)
end
function cm.fil5(c,code1,code2,code3,code4)
	return c:IsSetCard(0x3623) and c:IsType(TYPE_MONSTER) and c:IsAbleToDeck()
		and not c:IsCode(code1) and not c:IsCode(code2) and not c:IsCode(code3) and not c:IsCode(code4)
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_MZONE)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_GRAVE)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_REMOVED)
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	local code={}
	if Duel.IsExistingMatchingCard(cm.fil1,tp,LOCATION_DECK,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(m,1)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,cm.thfilter,tp,LOCATION_DECK,0,1,1,nil)
		if g:GetCount()>0 and Duel.SendtoHand(g,nil,REASON_EFFECT)~=0 then
			code[1]=Duel.GetOperatedGroup():GetFirst():GetCode()
			Duel.ConfirmCards(1-tp,g)
		else
			code[1]=0
		end
	else
		code[1]=0
	end
	Duel.BreakEffect()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(cm.fil2,tp,LOCATION_HAND,0,1,nil,e,tp,code[1])
		and Duel.SelectYesNo(tp,aux.Stringid(m,2)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,cm.fil2,tp,LOCATION_HAND,0,1,1,nil,e,tp,code[1])
		if g:GetCount()>0 and Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)~=0 then
			code[2]=Duel.GetOperatedGroup():GetFirst():GetCode()
		else
			code[2]=0
		end
	else
		code[2]=0
	end
	Duel.BreakEffect()
	if Duel.IsExistingMatchingCard(cm.fil3,tp,LOCATION_MZONE,0,1,nil,code[1],code[2]) and Duel.SelectYesNo(tp,aux.Stringid(m,3)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local g=Duel.SelectMatchingCard(tp,cm.fil3,tp,LOCATION_MZONE,0,1,1,nil,code[1],code[2])
		if g:GetCount()>0 and Duel.SendtoGrave(g,REASON_EFFECT)~=0 then
			code[3]=Duel.GetOperatedGroup():GetFirst():GetCode()
		else
			code[3]=0
		end
	else
		code[3]=0
	end
	Duel.BreakEffect()
	if Duel.IsExistingMatchingCard(cm.fil4,tp,LOCATION_GRAVE,0,1,nil,code[1],code[2],code[3]) and Duel.SelectYesNo(tp,aux.Stringid(m,4)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local g=Duel.SelectMatchingCard(tp,cm.fil4,tp,LOCATION_GRAVE,0,1,1,nil,code[1],code[2],code[3])
		if g:GetCount()>0 and Duel.Remove(g,POS_FACEUP,REASON_EFFECT)~=0 then
			code[4]=Duel.GetOperatedGroup():GetFirst():GetCode()
		else
			code[4]=0
		end
	else
		code[4]=0
	end
	Duel.BreakEffect()
	if Duel.IsExistingMatchingCard(cm.fil5,tp,LOCATION_REMOVED,0,1,nil,code[1],code[2],code[3],code[4]) and Duel.SelectYesNo(tp,aux.Stringid(m,5)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local g=Duel.SelectMatchingCard(tp,cm.fil5,tp,LOCATION_REMOVED,0,1,1,nil,code[1],code[2],code[3],code[4])
		if g:GetCount()>0 then
			Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
		end
	end
end

function cm.icost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return true end
	if not (c:IsPublic() or c:IsFaceup() or c:IsLocation(LOCATION_GRAVE)) then Duel.ConfirmCards(1-tp,c) end
end
function cm.icon(e,tp,eg,ep,ev,re,r,rp)
	local tf=false
	local c=e:GetHandler()
	local loc=0
	if c:IsLocation(LOCATION_DECK) then loc=1 
	elseif c:IsLocation(LOCATION_HAND) then loc=2
	elseif c:IsLocation(LOCATION_ONFIELD) then loc=3
	elseif c:IsLocation(LOCATION_GRAVE) then loc=4
	elseif c:IsLocation(LOCATION_REMOVED) then loc=5 end
	if loc==0 then return end
	if e:GetLabel()==0 then
		tf=false
	elseif e:GetLabel()~=loc then
		tf=true
	end
	e:SetLabel(loc)
	return tf
end
function cm.itg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DECKDES,nil,0,tp,1)
end
function cm.iop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_CARD,0,m)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.DiscardDeck(p,d,REASON_EFFECT)
end