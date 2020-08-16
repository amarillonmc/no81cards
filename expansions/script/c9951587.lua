--丧尸暴龙兽
function c9951587.initial_effect(c)
	aux.AddCodeList(c,59419719)
	 --fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFun2(c,aux.FilterBoolFunction(Card.IsRace,RACE_DRAGON),aux.FilterBoolFunction(Card.IsRace,RACE_ROCK),true)
---spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(c9951587.splimit)
	c:RegisterEffect(e1)
 --disable spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,1)
	c:RegisterEffect(e1)
	--destroy
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(9951587,0))
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetTarget(c9951587.target)
	e2:SetOperation(c9951587.operation)
	c:RegisterEffect(e2)
  --search
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(9951587,0))
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCountLimit(1,9951587)
	e3:SetCost(aux.bfgcost)
	e3:SetTarget(c9951587.thtg)
	e3:SetOperation(c9951587.thop)
	c:RegisterEffect(e3)
--spsummon bgm
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e8:SetCode(EVENT_SPSUMMON_SUCCESS)
	e8:SetOperation(c9951587.sumsuc)
	c:RegisterEffect(e8)
	local e9=e8:Clone()
	e9:SetCode(EVENT_SUMMON_SUCCESS)
	c:RegisterEffect(e9)
end
function c9951587.sumsuc(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_MUSIC,0,aux.Stringid(9951587,0))
end
function c9951587.splimit(e,se,sp,st)
	return se:GetHandler():IsCode(59419719) or not e:GetHandler():IsLocation(LOCATION_EXTRA)
end
function c9951587.thfilter(c)
	return c:IsCode(59419719) and c:IsAbleToHand()
end
function c9951587.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9951587.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c9951587.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c9951587.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c9951587.filter(c)
	return c:IsSummonType(SUMMON_TYPE_SPECIAL)
end
function c9951587.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=Duel.GetMatchingGroup(c9951587.filter,tp,0,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c9951587.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c9951587.filter,tp,0,LOCATION_MZONE,nil)
	Duel.Destroy(g,REASON_EFFECT)
end