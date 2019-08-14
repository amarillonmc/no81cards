--『星光歌剧』舞台-Starlight Revue
function c65010124.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--indes
	local e2=Effect.CreateEffect(c)
	e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_FZONE)
	e2:SetTargetRange(LOCATION_ONFIELD,0)
	e2:SetTarget(c65010124.notgtg)
	e2:SetValue(aux.tgoval)
	c:RegisterEffect(e2)
	--atk
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetRange(LOCATION_FZONE)
	e3:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e3:SetCondition(c65010124.atkcon)
	e3:SetTarget(c65010124.atktg)
	e3:SetValue(500)
	c:RegisterEffect(e3)
	--SearchCard
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_FZONE)
	e4:SetCountLimit(1,65010124)
	e4:SetCost(c65010124.cost)
	e4:SetTarget(c65010124.tg)
	e4:SetOperation(c65010124.op)
	c:RegisterEffect(e4)
end
function c65010124.notgtg(e,c)
	return c:IsFaceup() and c:IsSetCard(0x9da0) and not c==e:GetHandler()
end
function c65010124.atkcon(e)
	return Duel.GetCurrentPhase()==PHASE_DAMAGE_CAL 
end
function c65010124.atktg(e,c)
	return c:IsSummonType(SUMMON_TYPE_ADVANCE)
end
function c65010124.costfil(c,tp)
	local code=c:GetCode()
	return c:IsSetCard(0x9da0) and c:IsType(TYPE_MONSTER) and c:IsAbleToDeckOrExtraAsCost() and (c:IsFaceup() or c:IsLocation(LOCATION_HAND)) and Duel.IsExistingMatchingCard(c65010124.searfil,tp,LOCATION_DECK,0,1,nil,code)
end
function c65010124.searfil(c,code)
	return c:IsSetCard(0x9da0) and c:IsType(TYPE_MONSTER) and not c:IsCode(code) and c:IsAbleToHand()
end
function c65010124.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c65010124.costfil,tp,LOCATION_HAND+LOCATION_MZONE+LOCATION_REMOVED,0,1,nil,tp) end
	local g=Duel.SelectMatchingCard(tp,c65010124.costfil,tp,LOCATION_HAND+LOCATION_MZONE+LOCATION_REMOVED,0,1,1,nil,tp)
	if g:GetFirst():IsLocation(LOCATION_HAND) then
		Duel.ConfirmCards(1-tp,g)
	end
	Duel.SendtoDeck(g,nil,2,REASON_COST)
	e:SetLabelObject(g:GetFirst())
end
function c65010124.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c65010124.op(e,tp,eg,ep,ev,re,r,rp)
	local code=e:GetLabelObject():GetCode()
	local c=e:GetHandler()
	local g=Duel.SelectMatchingCard(tp,c65010124.searfil,tp,LOCATION_DECK,0,1,1,nil,code)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,tp,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c65010124.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_CANNOT_SUMMON)
	Duel.RegisterEffect(e2,tp)
end
function c65010124.splimit(e,c)
	return not c:IsSetCard(0x9da0)
end