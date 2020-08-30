--救世主式·狂风领主
function c40009166.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,40009166+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c40009166.target)
	c:RegisterEffect(e1)   
	--atkup
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e2:SetTarget(aux.TargetBoolFunction(Card.IsRace,RACE_WARRIOR))
	e2:SetValue(1000)
	c:RegisterEffect(e2) 
	--atkdown
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(40009166,1))
	e3:SetCategory(CATEGORY_ATKCHANGE)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1,40009166+EFFECT_COUNT_CODE_DUEL)
	e3:SetCondition(c40009166.atkcon2)
	e3:SetTarget(c40009166.atkktg)
	e3:SetCost(c40009166.spcost)
	e3:SetOperation(c40009166.atkop)
	c:RegisterEffect(e3)
end

function c40009166.tgfilter(c)
	return c:IsCode(40009154) and c:IsAbleToGrave()
end
function c40009166.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	if Duel.IsExistingMatchingCard(c40009166.tgfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil)
		and Duel.SelectEffectYesNo(tp,e:GetHandler(),aux.Stringid(40009166,0)) then
		e:SetCategory(CATEGORY_SPECIAL_SUMMON)
		e:SetOperation(c40009166.activate)
		local rg=Duel.SelectMatchingCard(tp,c40009166.tgfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil)
		e:SetLabel(1)
		Duel.SendtoGrave(rg,REASON_EFFECT)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
	else
		e:SetLabel(0)
		e:SetCategory(0)
		e:SetOperation(nil)
	end
end
function c40009166.spfilter(c,e,tp)
	return c:IsSetCard(0xbf1d) and c:IsType(TYPE_MONSTER) 
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c40009166.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	if e:GetHandler():IsRelateToEffect(e) and e:GetLabel()==1 then
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c40009166.spfilter),tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c40009166.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
end
function c40009166.splimit(e,c)
	return not c:IsSetCard(0xbf1d) and c:IsLocation(LOCATION_EXTRA)
end
function c40009166.atkcon2(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(Card.IsCode,1,nil,tp,SUMMON_TYPE_LINK,40009156)
end
function c40009166.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToGraveAsCost() end
	Duel.SendtoGrave(c,REASON_COST)
end
function c40009166.atkktg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	Duel.SetChainLimit(c40009166.chlimit)
end
function c40009166.chlimit(e,ep,tp)
	return tp==ep
end
function c40009166.atkop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetCondition(c40009166.discon)
	e1:SetTarget(c40009166.atktg)
	e1:SetValue(2000)
	Duel.RegisterEffect(e1,tp)
	Duel.SetChainLimit(c40009166.chlimit)
end
function c40009166.discon(e)
	local ph=Duel.GetCurrentPhase()
	return ph>=PHASE_BATTLE_START and ph<=PHASE_BATTLE
end
function c40009166.atktg(e,c)
	return c:GetSequence()>=5
end

