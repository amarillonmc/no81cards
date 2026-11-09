--Humancare
function c33741108.initial_effect(c)
	--Activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	--select
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(33741108,0))
	e1:SetCategory(CATEGORY_TOGRAVE+CATEGORY_DECKDES+CATEGORY_SPECIAL_SUMMON+CATEGORY_GRAVE_SPSUMMON+CATEGORY_RECOVER)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_TO_GRAVE)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCondition(c33741108.tgcon)
	e1:SetTarget(c33741108.tgtg)
	e1:SetOperation(c33741108.tgop)
	c:RegisterEffect(e1)
	--immune
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_IMMUNE_EFFECT)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(c33741108.immtg)
	e2:SetValue(c33741108.efilter)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e3:SetValue(1)
	c:RegisterEffect(e3)
end
function c33741108.cfilter(c,tp)
	return c:IsPreviousLocation(LOCATION_MZONE) and c:IsPreviousControler(tp) and c:IsReason(REASON_DESTROY) and (c:GetPreviousRaceOnField()&RACE_WARRIOR)~=0 and c:GetReasonPlayer()==1-tp
end
function c33741108.tgcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c33741108.cfilter,1,nil,tp)-- and #eg==1
end
function c33741108.tgfilter(c,atk)
	return c:IsAttackAbove(atk+1) and c:IsAbleToGrave()
end
function c33741108.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=eg:Filter(c33741108.cfilter,nil,tp)
	local _,atk=g:GetMinGroup(Card.GetTextAttack)
	if chk==0 then return Duel.IsExistingMatchingCard(c33741108.tgfilter,tp,LOCATION_DECK,0,1,nil,atk) end
	Duel.HintSelection(g)
	Duel.SetTargetCard(g)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function c33741108.tgop(e,tp,eg,ep,ev,re,r,rp)
	--local sc=Duel.GetFirstTarget()
	local g=Duel.GetTargetsRelateToChain()
	local _,atk=g:GetMinGroup(Card.GetTextAttack)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local tc=Duel.SelectMatchingCard(tp,c33741108.tgfilter,tp,LOCATION_DECK,0,1,1,nil,atk):GetFirst()
	if not tc or Duel.SendtoGrave(tc,REASON_EFFECT)==0 then return end
	local p=tc:IsRace(RACE_BEAST) and tp or 1-tp
	local ct=g:FilterCount(Card.IsCanBeSpecialSummoned,nil,e,0,tp,false,false)
	local b1=ct>0 and Duel.GetMZoneCount(tp)>=ct and (not Duel.IsPlayerAffectedByEffect(tp,59822133) or ct==1)-- and sc:IsCanBeSpecialSummoned(e,0,tp,false,false) and sc:IsRelateToChain()
	local b2=true
	local op=aux.SelectFromOptions(p,
		{b1,aux.Stringid(33741108,1)},
		{b2,aux.Stringid(33741108,2)})
	if op==1 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		for sc in aux.Next(g) do
			e:GetHandler():SetCardTarget(sc)
		end
	else
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetCountLimit(1)
		e1:SetOperation(c33741108.recop)
		e1:SetLabel(tc:GetAttack())
		Duel.RegisterEffect(e1,tp)
	end
end
function c33741108.recop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,33741108)
	Duel.Recover(tp,e:GetLabel(),REASON_EFFECT)
end
function c33741108.immtg(e,c)
	return e:GetHandler():GetCardTarget():IsContains(c)
end
function c33741108.efilter(e,re)
	return re:GetOwner()~=e:GetOwner()
end
