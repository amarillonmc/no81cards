--汐击龙的汐征
local cm,m=GetID()
function cm.initial_effect(c)
	--check
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e0:SetCode(EVENT_REMOVE)
	e0:SetCondition(aux.ThisCardInGraveAlreadyCheckReg)
	c:RegisterEffect(e0)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,2))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
	--spsummon
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(m,1))
	e4:SetCategory(CATEGORY_TODECK+CATEGORY_TOHAND)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_CUSTOM+m)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetRange(LOCATION_REMOVED)
	e4:SetLabelObject(e0)
	e4:SetCondition(cm.spcon)
	e4:SetTarget(cm.sptg)
	e4:SetOperation(cm.spop)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e5:SetCode(EVENT_MOVE)
	e5:SetCondition(cm.spcon2)
	c:RegisterEffect(e5)
	aux.RegisterMergedDelayedEvent(c,m,EVENT_SPSUMMON_SUCCESS)
end
function cm.filter(c,e,tp)
	return c:IsSetCard(0x9977) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.RegisterFlagEffect(0,11451760,RESET_CHAIN,0,1)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,cm.filter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
function cm.spfilter(c,se)
	return c:IsFaceup() and c:IsSetCard(0x9977)
end
function cm.spcon(e,tp,eg,ep,ev,re,r,rp)
	local se=e:GetLabelObject():GetLabelObject()
	return eg:IsExists(cm.spfilter,1,nil,se)
end
function cm.spcon2(e,tp,eg,ep,ev,re,r,rp)
	local bool,ceg=Duel.CheckEvent(EVENT_CUSTOM+m,true)
	return eg:IsContains(e:GetHandler()) and bool and ceg:IsExists(cm.spfilter,1,nil) and (re==nil or not re:IsActivated())
end
function cm.tdfilter(c,se)
	return c:IsFaceup() and c:IsSetCard(0x9977) and c:IsAbleToDeck()
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return eg:IsExists(cm.tdfilter,1,nil,se) and c:IsAbleToHand() and c:GetFlagEffect(m-10)==0 end
	c:RegisterFlagEffect(m-10,RESET_EVENT+RESETS_STANDARD+RESET_CHAIN,0,1)
	local g=eg:Filter(cm.tdfilter,nil,se)
	Duel.SetTargetCard(g)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,c,1,0,0)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if #g==0 then
		return
	elseif #g>1 then
		Duel.Hint(HINT_SELECTMSG,HINTMSG_TODECK)
		g=g:Select(tp,1,1,nil)
	end
	if Duel.SendtoDeck(g,nil,2,REASON_EFFECT)>0 and Duel.GetOperatedGroup():IsExists(Card.IsLocation,1,nil,LOCATION_DECK+LOCATION_EXTRA) and c:IsRelateToEffect(e) and c:IsAbleToHand() then
		Duel.SendtoHand(c,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,c)
	end
end