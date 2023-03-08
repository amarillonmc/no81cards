--新陷阱反应机·空式 
function c13131322.initial_effect(c) 
	--change effect
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(13131322,0))
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING) 
	e1:SetProperty(EFFECT_FLAG_CANNOT_INACTIVATE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,13131322)
	e1:SetCondition(c13131322.chcon)
	e1:SetTarget(c13131322.chtg)
	e1:SetOperation(c13131322.chop)
	c:RegisterEffect(e1)
	--tohand
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(13131322,1))
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetCountLimit(1,23131322)
	e3:SetCondition(c13131322.thcon)
	e3:SetTarget(c13131322.thtg)
	e3:SetOperation(c13131322.thop)
	c:RegisterEffect(e3)	
end
function c13131322.chcon(e,tp,eg,ep,ev,re,r,rp)
	return  rp==1-tp and re:IsActiveType(TYPE_TRAP) and re:IsHasType(EFFECT_TYPE_ACTIVATE)
end
function c13131322.spfil(c,e,tp) 
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsSetCard(0x63)  
end 
function c13131322.chtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1)
		and Duel.IsExistingMatchingCard(c13131322.spfil,tp,LOCATION_HAND,0,1,nil,e,tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
end
function c13131322.chop(e,tp,eg,ep,ev,re,r,rp)
	local g=Group.CreateGroup()
	Duel.ChangeTargetCard(ev,g)
	Duel.ChangeChainOperation(ev,c13131322.repop)
end
function c13131322.repop(e,tp,eg,ep,ev,re,r,rp) 
	Duel.Draw(1-tp,1,REASON_EFFECT) 
	local g=Duel.GetMatchingGroup(c13131322.spfil,1-tp,LOCATION_HAND,0,nil,e,1-tp) 
	if g:GetCount()>0 and Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0 then 
	local sg=g:Select(1-tp,1,1,nil) 
	Duel.SpecialSummon(sg,0,1-tp,1-tp,false,false,POS_FACEUP)
	Duel.BreakEffect() 
	local dg=Duel.GetMatchingGroup(Card.IsAbleToGrave,tp,LOCATION_ONFIELD,0,nil)
	if dg:GetCount()<=0 then return end  
	Duel.SendtoGrave(dg,REASON_EFFECT) 
	end 
end
function c13131322.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end
function c13131322.thfilter(c)
	return c:IsSetCard(0x63) and not c:IsCode(13131322) and c:IsAbleToHand()
end
function c13131322.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c13131322.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c13131322.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c13131322.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end






