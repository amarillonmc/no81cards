--薪火阵 凤凰
function c60001035.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c60001035.cost)
	e1:SetOperation(c60001035.activate)
	c:RegisterEffect(e1)
	local e9=Effect.CreateEffect(c)
	e9:SetType(EFFECT_TYPE_SINGLE)
	e9:SetCode(EFFECT_QP_ACT_IN_NTPHAND)
	e9:SetCondition(c60001035.handcon)
	c:RegisterEffect(e9)
	--a.&d.
	--local e2=Effect.CreateEffect(c)
	--e2:SetType(EFFECT_TYPE_FIELD)
	--e2:SetCode(EFFECT_UPDATE_ATTACK)
	--e2:SetRange(LOCATION_ONFIELD+LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE)
	--e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	--e2:SetValue(1000)
	--e2:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x626))
	--c:RegisterEffect(e2)
	--local e3=e2:Clone()
	--e3:SetCode(EFFECT_UPDATE_DEFENSE)
	--c:RegisterEffect(e3)
	--spsummon
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(60001035,0))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_FZONE)
	e4:SetCountLimit(1)
	e4:SetTarget(c60001035.target)
	e4:SetOperation(c60001035.operation)
	c:RegisterEffect(e4)
	--to hand
	--local e5=Effect.CreateEffect(c)
	--e5:SetCategory(CATEGORY_TOHAND)
	--e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	--e5:SetCode(EVENT_TO_GRAVE)
	--e5:SetProperty(EFFECT_FLAG_DELAY)
	--e5:SetTarget(c60001035.thtg)
	--e5:SetOperation(c60001035.thop)
	--c:RegisterEffect(e5)
end
function c60001035.thfilter(c)
	return c:IsAbleToHand()
end
function c60001035.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c60001035.thfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
end
function c60001035.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c60001035.thfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c60001035.filter(c)
	return c:IsCode(60461804) 
end
function c60001035.target(e,tp,eg,ep,ev,re,r,rp,chk,tc)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,c60001035.filter,0x8,TYPES_TOKEN_MONSTER,nil,nil,nil,RACE_WARRIOR,ATTRIBUTE_DARK)  and Duel.GetLocationCountFromEx(tp,tp,tc,c)>0 end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function c60001035.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0
		or not Duel.IsPlayerCanSpecialSummonMonster(tp,c60001035.filter,0x8,TYPES_TOKEN_MONSTER,nil,nil,nil,RACE_WARRIOR,ATTRIBUTE_DARK) then return end
	local token=Duel.CreateToken(tp,60461804)
	Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP)
end
function c60001035.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetCustomActivityCount(60001035,tp,ACTIVITY_SUMMON)==0 and Duel.GetCustomActivityCount(60001035,tp,ACTIVITY_SPSUMMON)==0 end
end
function c60001035.filter(c)
	return c:IsSetCard(0x626)
end
function c60001035.activate(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local g=Duel.GetMatchingGroup(c60001035.filter,tp,LOCATION_DECK,0,nil)
	if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(60001035,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=g:Select(tp,1,1,nil)
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
	end
end
function c60001035.chainlm(e,rp,tp)
	return tp==rp
end
function c60001035.handcon(e)
	return Duel.GetFieldGroupCount(e:GetHandlerPlayer(),LOCATION_MZONE,0)==0
end
