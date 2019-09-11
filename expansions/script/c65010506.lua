--URBEX-支援者
function c65010506.initial_effect(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_TO_GRAVE)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,65010506)
	e1:SetCondition(c65010506.con)
	e1:SetCost(c65010506.cost)
	e1:SetTarget(c65010506.tg)
	e1:SetOperation(c65010506.op)
	c:RegisterEffect(e1)
	--tog
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,65010507)
	e2:SetTarget(c65010506.wdtg)
	e2:SetOperation(c65010506.wdop)
	c:RegisterEffect(e2)
end
c65010506.setname="URBEX"
function c65010506.confil(c,tp)
	return c.setname=="URBEX" and c:IsPreviousLocation(LOCATION_MZONE) and c:GetPreviousControler()==tp 
end
function c65010506.con(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return eg:IsExists(c65010506.confil,1,nil,tp) and (ph==PHASE_MAIN1 or (ph>=PHASE_BATTLE_START and ph<=PHASE_BATTLE) or ph==PHASE_MAIN2)
end
function c65010506.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetDecktopGroup(tp,3)
	if chk==0 then return g:FilterCount(Card.IsAbleToRemoveAsCost,nil)==3
	 end
	Duel.DisableShuffleCheck()
	Duel.Remove(g,POS_FACEDOWN,REASON_COST)
end
function c65010506.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c65010506.op(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
		Duel.SpecialSummon(e:GetHandler(),0,tp,tp,false,false,POS_FACEUP)
	end
end

function c65010506.wdfil(c)
	return c:IsFacedown() and c:IsAbleToGrave()
end
function c65010506.wdtfil(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c.setname=="URBEX" and c:IsAbleToHand()
end
function c65010506.wdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c65010506.wdfil,tp,LOCATION_REMOVED,0,2,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,2,tp,LOCATION_REMOVED)
end
function c65010506.wdop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c65010506.wdfil,tp,LOCATION_REMOVED,0,nil)
	local sg=g:RandomSelect(tp,2)
	if sg:GetCount()==2 and Duel.SendtoGrave(sg,REASON_EFFECT+REASON_RETURN)~=0 then 
		if sg:IsExists(c65010506.wdtfil,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(65010506,0)) then
			local dg=sg:FilterSelect(tp,c65010506.wdtfil,1,1,nil)
			Duel.SendtoHand(dg,tp,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,dg)
		end
	end
end