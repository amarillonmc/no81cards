--元祖地樱之化龙
function c95101236.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsRace,RACE_DRAGON),aux.NonTuner(c95101236.sfilter),1,1)
	c:EnableReviveLimit()
	--cannot special summon
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	e0:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetRange(LOCATION_EXTRA)
	e0:SetValue(c95101236.synlimit)
	c:RegisterEffect(e0)
	--equip
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,95101236)
	e1:SetCondition(c95101236.eqcon)
	e1:SetCost(c95101236.cost)
	e1:SetTarget(c95101236.eqtg)
	e1:SetOperation(c95101236.eqop)
	c:RegisterEffect(e1)
	--to hand(equip)
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(95101236,1))
	e4:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCountLimit(1,95101236+1)
	e4:SetCondition(c95101236.thcon)
	e4:SetCost(c95101236.cost)
	e4:SetTarget(c95101236.thtg)
	e4:SetOperation(c95101236.thop)
	c:RegisterEffect(e4)
	--draw
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(95101236,1))
	e5:SetCategory(CATEGORY_DRAW)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e5:SetCode(EVENT_TO_GRAVE)
	e5:SetProperty(EFFECT_FLAG_DELAY)
	e5:SetCountLimit(1,95101236+2)
	e5:SetCost(c95101236.cost)
	e5:SetTarget(c95101236.drtg)
	e5:SetOperation(c95101236.drop)
	c:RegisterEffect(e5)
	--counter
	Duel.AddCustomActivityCounter(95101236,ACTIVITY_SPSUMMON,c95101236.counterfilter)
end
c95101236.material_type=TYPE_SYNCHRO 
function c95101236.counterfilter(c)
	return c:IsSetCard(0x5bb0)
end
function c95101236.sfilter(c)
	return c:IsRace(RACE_DINOSAUR+RACE_SEASERPENT+RACE_WYRM) and c:IsType(TYPE_SYNCHRO)
end
function c95101236.synlimit(e,se,sp,st)
	return st&SUMMON_TYPE_SYNCHRO==SUMMON_TYPE_SYNCHRO and not se
end
function c95101236.eqcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_SYNCHRO)
end
function c95101236.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetCustomActivityCount(95101236,tp,ACTIVITY_SPSUMMON)==0 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c95101236.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c95101236.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return not c:IsSetCard(0x5bb0)
end
function c95101236.eqfilter(c,tp)
	return c:IsSetCard(0x5bb0) and (c:IsFaceupEx() or c:IsLocation(LOCATION_EXTRA)) and c:IsType(TYPE_SYNCHRO) and not c:IsForbidden()
end
function c95101236.eqtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and Duel.IsExistingMatchingCard(c95101236.eqfilter,tp,LOCATION_MZONE+LOCATION_GRAVE+LOCATION_EXTRA,0,1,nil,e:GetHandler(),tp) end
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,nil,1,tp,LOCATION_MZONE+LOCATION_GRAVE+LOCATION_EXTRA)
end
function c95101236.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 and c:IsFacedown() or not c:IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local tc=Duel.SelectMatchingCard(tp,c95101236.eqfilter,tp,LOCATION_MZONE+LOCATION_GRAVE+LOCATION_EXTRA,0,1,1,nil):GetFirst()
	if tc then
		Duel.HintSelection(Group.FromCards(tc))
		if not Duel.Equip(tp,tc,c) then return end
		--Add Equip limit
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_EQUIP_LIMIT)
		e1:SetProperty(EFFECT_FLAG_OWNER_RELATE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetValue(c95101236.eqlimit)
		tc:RegisterEffect(e1)
	end
end
function c95101236.eqlimit(e,c)
	return e:GetOwner()==c
end
function c95101236.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetEquipTarget()
end
function c95101236.thfilter(c)
	return c:IsSetCard(0x5bb0) and c:IsAbleToHand()
end
function c95101236.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c95101236.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c95101236.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c95101236.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c95101236.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c95101236.drop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
