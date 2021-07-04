--天使-冰结傀儡
local m=33400502
local cm=_G["c"..m]
function cm.initial_effect(c)
c:SetUniqueOnField(1,0,m)
	 --atc
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	  --add counter
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCondition(cm.condition)
	e1:SetOperation(cm.counter)
	c:RegisterEffect(e1)
--destroy
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_DESTROY+CATEGORY_SEARCH+CATEGORY_TOHAND+CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetCountLimit(1,m)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCost(cm.cost)
	e3:SetTarget(cm.destg)
	e3:SetOperation(cm.desop)
	c:RegisterEffect(e3)
end
function cm.cnfilter(c)
	return c:IsSetCard(0x6341) and c:IsFaceup()
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,1000) or Duel.IsExistingMatchingCard(cm.cnfilter,tp,LOCATION_ONFIELD,0,1,nil) end
	if not Duel.IsExistingMatchingCard(cm.cnfilter,tp,LOCATION_ONFIELD,0,1,nil)then Duel.PayLPCost(tp,1000)
	end
end

function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	return re:GetHandler():IsOnField() and re:GetHandler():IsRelateToEffect(re) and re:GetHandler()~=e:GetHandler() and re:GetHandler():IsCanAddCounter(0x1015,1)
end
function cm.counter(e,tp,eg,ep,ev,re,r,rp)
	local c=re:GetHandler()
	if  c:IsLocation(LOCATION_ONFIELD) and re:GetHandler():IsRelateToEffect(re) then 
			c:AddCounter(0x1015,1)
		end
end

function cm.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(nil,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,e:GetHandler()) end
	local g=Duel.GetMatchingGroup(nil,tp,LOCATION_HAND+LOCATION_ONFIELD,0,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function cm.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,nil,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,1,c)
	local tc=g:GetFirst()
	if tc and  Duel.Destroy(tc,REASON_EFFECT)~=0 then
		if tc:IsSetCard(0x3344) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(cm.spfilter1,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,e,tp)
		and Duel.SelectYesNo(tp,aux.Stringid(m,1)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local tg=Duel.SelectMatchingCard(tp,cm.spfilter1,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,e,tp)
			Duel.SpecialSummon(tg,0,tp,tp,false,false,POS_FACEUP)
		end 
		if tc:IsSetCard(0x6341) and Duel.IsExistingMatchingCard(cm.thfilter1,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil)  and Duel.SelectYesNo(tp,aux.Stringid(m,2)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local tg2=Duel.SelectMatchingCard(tp,cm.thfilter1,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
			Duel.SendtoHand(tg2,nil,REASON_EFFECT)
		end 
	end
end
function cm.spfilter1(c,e,tp)
	return c:IsSetCard(0x6341) and c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.thfilter1(c)
	return c:IsSetCard(0x3344) and c:IsAbleToHand() 
end