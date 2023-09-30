--恐汐击龙“煌枪”
local cm,m=GetID()
function cm.initial_effect(c)
	--check
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e0:SetCode(EVENT_REMOVE)
	e0:SetCondition(aux.ThisCardInGraveAlreadyCheckReg)
	c:RegisterEffect(e0)
	--search
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,1))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND+LOCATION_REMOVED)
	e1:SetTarget(cm.thtg)
	e1:SetOperation(cm.thop)
	c:RegisterEffect(e1)
	local e3=e1:Clone()
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetCondition(cm.con2)
	c:RegisterEffect(e3)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,2))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_HAND+LOCATION_REMOVED)
	e2:SetLabelObject(e0)
	e2:SetCondition(cm.spcon)
	e2:SetTarget(cm.sptg)
	e2:SetOperation(cm.spop)
	c:RegisterEffect(e2)
end
function cm.cfilter(c,code)
	return c:IsFaceup() and c:IsCode(code)
end
function cm.thfilter(c)
	return c:IsSetCard(0x9977) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand() and not Duel.IsExistingMatchingCard(cm.cfilter,tp,LOCATION_REMOVED,LOCATION_REMOVED,1,nil,c:GetCode())
end
function cm.con2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(0,11451760)>0
end
function cm.costfilter(c)
	return c:IsAbleToRemove() and c:IsSetCard(0x9977)
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local sa=c:IsLocation(LOCATION_HAND) and Duel.GetFlagEffect(tp,m+1)==0
	local sb=c:IsLocation(LOCATION_REMOVED) and Duel.GetFlagEffect(tp,m+10)==0
	local rg=Duel.GetMatchingGroup(cm.costfilter,tp,LOCATION_HAND,0,c)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_DECK,0,1,nil) and (sa or sb) and Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,LOCATION_HAND,0,1,nil) end
	if c:IsLocation(LOCATION_HAND) then
		Duel.RegisterFlagEffect(tp,m+1,RESET_PHASE+PHASE_END,0,1)
	elseif c:IsLocation(LOCATION_REMOVED) then
		Duel.RegisterFlagEffect(tp,m+10,RESET_PHASE+PHASE_END,0,1)
	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_HAND)
end
function cm.fselect(g,c,tp)
	return g:IsExists(cm.costfilter,1,c) and Duel.IsExistingMatchingCard(cm.thfilter2,tp,LOCATION_DECK,0,1,nil,g)
end
function cm.thfilter2(c,g)
	return c:IsSetCard(0x9977) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand() and not Duel.IsExistingMatchingCard(cm.cfilter,tp,LOCATION_REMOVED,LOCATION_REMOVED,1,nil,c:GetCode()) and not g:IsExists(Card.IsCode,1,nil,c:GetCode())
end
function cm.fselect2(g,c)
	return g:IsExists(cm.costfilter,1,c)
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,cm.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
		local rg=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,LOCATION_HAND,0,nil)
		if #rg>1 then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
			local tg=rg:Select(tp,2,2,nil)
			Duel.Remove(tg,POS_FACEUP,REASON_EFFECT)
		end
	end
end
function cm.spfilter(c,se)
	if not (se==nil or c:GetReasonEffect()~=se) then return false end
	return c:IsFaceup() and c:IsSetCard(0x9977)
end
function cm.spcon(e,tp,eg,ep,ev,re,r,rp)
	local se=e:GetLabelObject():GetLabelObject()
	return eg:IsExists(cm.spfilter,1,nil,se)
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local sa=c:IsLocation(LOCATION_HAND) and Duel.GetFlagEffect(tp,m+1)==0
	local sb=c:IsLocation(LOCATION_REMOVED) and Duel.GetFlagEffect(tp,m+10)==0
	if chk==0 then return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and (sa or sb) end
	if c:IsLocation(LOCATION_HAND) then
		Duel.RegisterFlagEffect(tp,m+1,RESET_PHASE+PHASE_END,0,1)
	elseif c:IsLocation(LOCATION_REMOVED) then
		Duel.RegisterFlagEffect(tp,m+10,RESET_PHASE+PHASE_END,0,1)
	end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,PLAYER_ALL,LOCATION_GRAVE)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(Card.IsAbleToRemove),tp,LOCATION_GRAVE,LOCATION_GRAVE,1,3,nil)
	if #g>0 then
		Duel.HintSelection(g)
		if Duel.Remove(g,POS_FACEUP,REASON_EFFECT)>0 and c:IsRelateToEffect(e) then
			Duel.BreakEffect()
			Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end