--トリックスター・フェス
function c10105506.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,10105506+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c10105506.cost)
	e1:SetTarget(c10105506.target)
	e1:SetOperation(c10105506.activate)
	c:RegisterEffect(e1)
--search
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(10105506,1))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,10105506)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c10105506.thtg)
	e2:SetOperation(c10105506.thop)
	c:RegisterEffect(e2)	Duel.AddCustomActivityCounter(10105506,ACTIVITY_SUMMON,c10105506.counterfilter)
	Duel.AddCustomActivityCounter(10105506,ACTIVITY_SPSUMMON,c10105506.counterfilter)
end
function c10105506.counterfilter(c)
	return c:IsRace(RACE_BEAST)
end
function c10105506.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetCustomActivityCount(10105506,tp,ACTIVITY_SUMMON)==0
		and Duel.GetCustomActivityCount(10105506,tp,ACTIVITY_SPSUMMON)==0 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c10105506.sumlimit)
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_CANNOT_SUMMON)
	Duel.RegisterEffect(e2,tp)
end
function c10105506.sumlimit(e,c,sump,sumtype,sumpos,targetp,se)
	return not c:IsRace(RACE_BEAST)
end
function c10105506.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not Duel.IsPlayerAffectedByEffect(tp,59822133)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>1
		and Duel.IsPlayerCanSpecialSummonMonster(tp,10105500,0x7ccd,TYPES_TOKEN_MONSTER,0,0,2,RACE_BEAST,ATTRIBUTE_EARTH) end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,2,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,0,0)
end
function c10105506.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsPlayerAffectedByEffect(tp,10105500) then return end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>1
		and Duel.IsPlayerCanSpecialSummonMonster(tp,10105500,0x7ccd,TYPES_TOKEN_MONSTER,0,0,2,RACE_BEAST,ATTRIBUTE_EARTH) then
		for i=1,2 do
			local token=Duel.CreateToken(tp,10105500)
			Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP)
		end
		Duel.SpecialSummonComplete()
	end
end
function c10105506.dfilter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function c10105506.thfilter(c)
	return c:IsSetCard(0x7ccd) and c:IsType(TYPE_TRAP) and c:IsAbleToHand()
end
function c10105506.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c10105506.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c10105506.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c10105506.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end