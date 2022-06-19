--征冥天的歪域魔
function c67200608.initial_effect(c)
	aux.EnablePendulumAttribute(c)
	--revive limit
	aux.EnableReviveLimitPendulumSummonable(c,LOCATION_HAND)
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(aux.ritlimit)
	c:RegisterEffect(e1) 
	--token
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(67200608,1))
	e2:SetCategory(CATEGORY_CONTROL)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(c67200608.sscon)
	e2:SetTarget(c67200608.sstg)
	e2:SetOperation(c67200608.ssop)
	c:RegisterEffect(e2) 

	--to hand
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(67200608,3))
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e4:SetCode(EVENT_TO_DECK)
	e4:SetCondition(c67200608.thcon)
	e4:SetTarget(c67200608.thtg)
	e4:SetOperation(c67200608.thop)
	c:RegisterEffect(e4)	 
end
--
function c67200608.cfilter2(c,tp)
	return c:GetSummonPlayer()==tp and c:IsSetCard(0x677) and c:IsFaceup() and c:IsSummonType(SUMMON_TYPE_RITUAL)
end
function c67200608.sscon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c67200608.cfilter2,1,nil,tp)
end
function c67200608.ctfilter1(c,tp)
	return c:IsControler(1-tp) and c:IsAbleToChangeControler() and Duel.GetMZoneCount(1-tp,c,1-tp,LOCATION_REASON_CONTROL)>0
end
function c67200608.sstg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return eg:GetCount()==1 and Duel.IsExistingMatchingCard(c67200608.ctfilter1,tp,LOCATION_MZONE,0,1,c,tp) and eg:IsExists(c67200608.cfilter2,1,nil,1-tp) end
	Duel.SetOperationInfo(0,CATEGORY_CONTROL,g,2,0,0)
end
function c67200608.ssop(e,tp,eg,ep,ev,re,r,rp)
	local a=eg:GetFirst()
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(67200608,3))
	local bb=Duel.SelectMatchingCard(tp,c67200608.ctfilter1,tp,0,LOCATION_MZONE,1,1,c,tp)
	local b=bb:GetFirst()
	if a and b then
		Duel.SwapControl(a,b)
	end
end
--

--
function c67200608.thcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsFaceup() and c:IsControler(tp) and c:IsLocation(LOCATION_EXTRA)
end
function c67200608.thfilter(c)
	return c:IsSetCard(0x677) and c:IsType(TYPE_PENDULUM) and c:IsAbleToHand() and c:IsFaceup() and not c:IsCode(67200608)
end
function c67200608.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c67200608.thfilter,tp,LOCATION_EXTRA,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_EXTRA)
end
function c67200608.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c67200608.thfilter,tp,LOCATION_EXTRA,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
--