--团团圆圆大家庭
function c62501201.initial_effect(c)
	--Activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	--cannot attack
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_ATTACK)
	e1:SetRange(LOCATION_FZONE)
	e1:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e1:SetTarget(c62501201.atktg)
	c:RegisterEffect(e1)
	--remove
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(62501201,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCountLimit(1,62501201)
	e2:SetTarget(c62501201.rmtg)
	e2:SetOperation(c62501201.rmop)
	c:RegisterEffect(e2)
	--to hand
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(62501201,2))
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCountLimit(1,62501201)
	e3:SetCost(aux.bfgcost)
	e3:SetTarget(c62501201.thtg)
	e3:SetOperation(c62501201.thop)
	c:RegisterEffect(e3)
end
function c62501201.atktg(e,c)
	return not (c:IsLevel(1) or c:IsRank(1) or c:IsLink(1))
end
function c62501201.spfilter(c,e,tp,chk)
	return c:IsSetCard(0xea1) and c:IsFaceupEx() and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and (chk==0 or aux.NecroValleyFilter()(c))-- and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0
end
function c62501201.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,0,LOCATION_DECK)>=2 and Duel.IsPlayerCanRemove(tp) and Duel.IsPlayerCanSpecialSummonCount(tp,2) and Duel.GetMZoneCount(1-tp)>0 and Duel.GetMZoneCount(tp)>0 and Duel.IsExistingMatchingCard(c62501201.spfilter,tp,LOCATION_DECK+LOCATION_REMOVED,0,1,nil,e,tp,0) end
end
function c62501201.chkfilter(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,1-tp) and c:IsAbleToRemove()
end
function c62501201.rmop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetMZoneCount(1-tp)>0 then
		local g=Duel.GetMatchingGroup(c62501201.chkfilter,1-tp,LOCATION_DECK,0,nil,e,tp)
		Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_CONFIRM)
		local sg=g:SelectSubGroup(1-tp,aux.gffcheck,false,2,2,Card.IsAttackAbove,300,Card.IsAttackBelow,100)
		if sg and #sg==2 then
			Duel.ConfirmCards(tp,sg)
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local sc=sg:Select(tp,1,1,nil):GetFirst()
			Duel.SpecialSummonStep(sc,0,tp,1-tp,false,false,POS_FACEUP)
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_DISABLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			sc:RegisterEffect(e1)
			local e2=Effect.CreateEffect(e:GetHandler())
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_DISABLE_EFFECT)
			e2:SetValue(RESET_TURN_SET)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD)
			sc:RegisterEffect(e2)
			Duel.SpecialSummonComplete()
			sg:RemoveCard(sc)
			Duel.Remove(sg,POS_FACEUP,REASON_EFFECT)
			if Duel.GetMZoneCount(tp)>0 then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
				local tc=Duel.SelectMatchingCard(tp,c62501201.spfilter,tp,LOCATION_DECK+LOCATION_REMOVED,0,1,1,nil,e,tp,1):GetFirst()
				if tc then
					Duel.BreakEffect()
					Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
				end
			end
		end
	end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,1)
	e1:SetTarget(c62501201.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c62501201.splimit(e,c)
	return not (c:IsLevel(1) or c:IsRank(1) or c:IsLink(1))
end
function c62501201.thfilter(c)
	return c:IsSetCard(0xea1) and c:IsType(TYPE_SPELL) and c:IsFaceup() and c:IsAbleToHand()
end
function c62501201.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c62501201.thfilter,tp,LOCATION_REMOVED,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_REMOVED)
end
function c62501201.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local tc=Duel.SelectMatchingCard(tp,c62501201.thfilter,tp,LOCATION_REMOVED,0,1,1,nil):GetFirst()
	if tc then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	end
end
