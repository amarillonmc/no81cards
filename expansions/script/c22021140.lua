--咕哒子-幻想长夜
function c22021140.initial_effect(c)
	--spsummon proc
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND+LOCATION_DECK)
	e1:SetCondition(c22021140.spcon)
	e1:SetOperation(c22021140.spop)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	--tohand
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(22021140,0))
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCost(c22021140.cost)
	e3:SetTarget(c22021140.target)
	e3:SetOperation(c22021140.operation)
	c:RegisterEffect(e3)
end
function c22021140.spfilter(c)
	return c:IsFaceup() and c:IsCode(22020000) and c:IsAttribute(ATTRIBUTE_LIGHT)
end
function c22021140.spcon(e,c)
	if c==nil then return true end
	return Duel.CheckReleaseGroup(c:GetControler(),c22021140.spfilter,1,nil)
end
function c22021140.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.SelectReleaseGroup(tp,c22021140.spfilter,1,1,nil)
	Duel.Hint(HINT_CARD,0,22020000)
	Duel.Release(g,REASON_COST)
	Duel.SelectOption(tp,aux.Stringid(22021140,1))
	Duel.Hint(HINT_CARD,0,22020210)
	Duel.SelectOption(tp,aux.Stringid(22021140,2))
	Duel.Hint(HINT_CARD,0,22020300)
	Duel.SelectOption(tp,aux.Stringid(22021140,3))
	Duel.Hint(HINT_CARD,0,22020310)
	Duel.SelectOption(tp,aux.Stringid(22021140,4))
end
function c22021140.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,e:GetHandler()) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end
function c22021140.filter(c)
	return c:IsSetCard(0x1ff1) and not c:IsCode(22020000) and c:IsType(TYPE_MONSTER) and (c:IsAbleToHand() or chk and c:IsCanBeSpecialSummoned(e,0,tp,false,false))
end
function c22021140.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local res=Duel.GetFieldGroupCount(tp,LOCATION_ONFIELD,0)<=1 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		return Duel.IsExistingMatchingCard(c22021140.filter,tp,LOCATION_DECK,0,1,nil,e,tp,res)
	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,0,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,0,tp,LOCATION_DECK)
end
function c22021140.operation(e,tp,eg,ep,ev,re,r,rp)
	local res=Duel.GetFieldGroupCount(tp,LOCATION_ONFIELD,0)<=1 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local tc=Duel.SelectMatchingCard(tp,c22021140.filter,tp,LOCATION_DECK,0,1,1,nil,e,tp,res):GetFirst()
	if tc then
		if res and tc:IsCanBeSpecialSummoned(e,0,tp,false,false)
			and (not tc:IsAbleToHand() or Duel.SelectOption(tp,1190,1152)==1) then
			Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
		else
			Duel.SendtoHand(tc,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,tc)
		end
	end
end