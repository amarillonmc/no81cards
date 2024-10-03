--天汐击龙“白凰”
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
	return c:IsSetCard(0x9977) and c:GetType()==TYPE_TRAP and c:IsAbleToHand() and not Duel.IsExistingMatchingCard(cm.cfilter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil,c:GetCode())
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
	if chk==0 then return Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_DECK,0,1,nil) and (sa or sb) and Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,LOCATION_ONFIELD+LOCATION_HAND,0,1,nil) end
	Duel.Hint(HINT_OPSELECTED,tp,e:GetDescription())
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	if c:IsLocation(LOCATION_HAND) then
		Duel.RegisterFlagEffect(tp,m+1,RESET_PHASE+PHASE_END,0,1)
	elseif c:IsLocation(LOCATION_REMOVED) then
		Duel.RegisterFlagEffect(tp,m+10,RESET_PHASE+PHASE_END,0,1)
	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,2,tp,LOCATION_HAND+LOCATION_ONFIELD)
end
function cm.fselect(g)
	return g:IsExists(Card.IsLocation,1,nil,LOCATION_HAND) and g:IsExists(Card.IsLocation,1,nil,LOCATION_ONFIELD)
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,cm.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
		local rg=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,LOCATION_HAND+LOCATION_ONFIELD,0,nil)
		if #rg>1 then --rg:IsExists(Card.IsLocation,1,nil,LOCATION_HAND) and rg:IsExists(Card.IsLocation,1,nil,LOCATION_ONFIELD) then
			--Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
			local tg=rg:Select(tp,2,2,nil) --SubGroup(tp,cm.fselect,false,2,2)
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
	local rg=Duel.GetDecktopGroup(tp,2)
	if chk==0 then return ((c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0) or Duel.GetCurrentChain()==0) and rg:FilterCount(Card.IsAbleToRemove,nil)==2 and (sa or sb) end
	Duel.Hint(HINT_OPSELECTED,tp,e:GetDescription())
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	if c:IsLocation(LOCATION_HAND) then
		Duel.RegisterFlagEffect(tp,m+1,RESET_PHASE+PHASE_END,0,1)
	elseif c:IsLocation(LOCATION_REMOVED) then
		Duel.RegisterFlagEffect(tp,m+10,RESET_PHASE+PHASE_END,0,1)
	end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,rg,2,0,0)
	if Duel.GetCurrentChain()==1 then
		e:SetCategory(CATEGORY_REMOVE)
	else
		e:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_REMOVE)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
	end
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetDecktopGroup(tp,2)
	if #g<=0 then return end
	Duel.DisableShuffleCheck()
	if Duel.Remove(g,POS_FACEUP,REASON_EFFECT)~=0 and Duel.GetCurrentChain()>1 and c:IsRelateToEffect(e) then
		Duel.BreakEffect()
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end