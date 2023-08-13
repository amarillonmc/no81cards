--萝卜-R 秘密兵工厂
function c98930213.initial_effect(c)
 --Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOGRAVE+CATEGORY_DECKDES)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,98930213+EFFECT_COUNT_CODE_OATH)
	e1:SetOperation(c98930213.activate)
	c:RegisterEffect(e1)
--?
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_INDESTRUCTABLE_COUNT)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(c98930213.indtg)
	e2:SetCountLimit(1)
	e2:SetValue(c98930213.valcon)
	c:RegisterEffect(e2)
	--to hand
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(98930213,0))
	e4:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	e4:SetCountLimit(1)
	e4:SetRange(LOCATION_FZONE)
	e4:SetCondition(c98930213.thcon)
	e4:SetTarget(c98930213.thtg)
	e4:SetOperation(c98930213.thop)
	c:RegisterEffect(e4)
end
function c98930213.thfilter1(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0xad2) and c:IsAbleToGrave()
end
function c98930213.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c98930213.thfilter1,tp,LOCATION_DECK,0,nil)
	if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(98930213,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local sg=g:Select(tp,1,1,nil)
		Duel.SendtoGrave(sg,REASON_EFFECT)
	end
end
function c98930213.indtg(e,c)
	return c:IsSetCard(0xad2) and c:IsType(TYPE_MONSTER)
end
function c98930213.valcon(e,re,r,rp)
	return bit.band(r,REASON_EFFECT)~=0
end
function c98930213.counterfilter(c)
	return not (c:IsType(TYPE_XYZ) and c:IsRace(RACE_MACHINE)) or c:isSummonLocation(LOCATION_EXTRA)
end
function c98930213.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return c:IsLocation(LOCATION_EXTRA) and not (c:IsType(TYPE_XYZ) and c:IsRace(RACE_MACHINE))
end
function c98930213.thcon(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst() 
	return ep==tp and Duel.GetTurnPlayer()==tp and eg:GetCount()==1 and tc:IsSummonPlayer(tp) and tc:IsFaceup() and tc:IsType(TYPE_XYZ) and tc:IsSetCard(0xad2)
end
function c98930213.thfilter(c)
	return c:IsSetCard(0x95) and c:IsAbleToHand()
end
function c98930213.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function c98930213.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c98930213.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTarget(c98930213.splimit)
	Duel.RegisterEffect(e1,tp)
end
function c98930213.splimit(e,c)
	return c:IsLocation(LOCATION_EXTRA) and not (c:IsType(TYPE_XYZ) and c:IsRace(RACE_MACHINE))
end