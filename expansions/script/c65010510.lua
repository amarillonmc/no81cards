--URBEX-领地切入者
function c65010510.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,65010510)
	e1:SetCost(c65010510.spcost)
	e1:SetTarget(c65010510.sptg)
	e1:SetOperation(c65010510.spop)
	c:RegisterEffect(e1)
	--token
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TODECK+CATEGORY_SEARCH+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCountLimit(1,65010510)
	e2:SetCondition(c65010510.tkcon)
	e2:SetTarget(c65010510.tktg)
	e2:SetOperation(c65010510.tkop)
	c:RegisterEffect(e2)
end
c65010510.setname="URBEX"
function c65010510.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetDecktopGroup(tp,7)
	if chk==0 then return g:FilterCount(Card.IsAbleToRemoveAsCost,nil)==7 end
	Duel.DisableShuffleCheck()
	Duel.Remove(g,POS_FACEDOWN,REASON_COST)
end
function c65010510.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c65010510.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end


function c65010510.tkcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end
function c65010510.wdfil(c)
	return c:IsFacedown() and c:IsAbleToDeck()
end
function c65010510.thfil(c)
	return c.setname=="URBEX" and c:IsAbleToHand() and c:IsType(TYPE_MONSTER)
end
function c65010510.tktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c65010510.wdfil,tp,LOCATION_REMOVED,0,2,nil)
		and Duel.IsExistingMatchingCard(c65010510.thfil,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,2,tp,LOCATION_REMOVED)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c65010510.tkop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c65010510.wdfil,tp,LOCATION_REMOVED,0,nil)
	local sg=g:RandomSelect(tp,2)
	if sg:GetCount()==2 and Duel.SendtoDeck(sg,nil,2,REASON_EFFECT)~=0 then 
		local dg=Duel.SelectMatchingCard(tp,c65010510.thfil,tp,LOCATION_DECK,0,1,1,nil)
		if dg:GetCount()>0 then
			Duel.SendtoHand(dg,tp,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,dg)
			local dc=dg:GetFirst()
			local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_CANNOT_ACTIVATE)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetTargetRange(1,0)
		e1:SetTarget(c65010510.aclimit)
		e1:SetLabel(dc:GetCode())
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
		end
	end
end
function c65010510.aclimit(e,re,tp)
	return re:GetHandler():IsCode(e:GetLabel()) and re:IsActiveType(TYPE_MONSTER) and (re:GetActivateLocation()==LOCATION_HAND or re:GetActivateLocation()==LOCATION_GRAVE)
end