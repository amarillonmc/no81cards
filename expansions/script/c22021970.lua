--圣煌暗理 山中老人
function c22021970.initial_effect(c)
	aux.AddCodeList(c,22021960)
	c:EnableReviveLimit()
	--special summon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e2:SetCondition(c22021970.sprcon)
	e2:SetTarget(c22021970.sprtg)
	e2:SetOperation(c22021970.sprop)
	c:RegisterEffect(e2)
	--atk up
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(22021970,0))
	e3:SetCategory(CATEGORY_TOGRAVE)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_HAND)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e3:SetCountLimit(1,22021970)
	e3:SetCondition(c22021970.atkcon)
	e3:SetCost(c22021970.atkcost)
	e3:SetTarget(c22021970.tgtg)
	e3:SetOperation(c22021970.tgop)
	c:RegisterEffect(e3)
	--choose effect
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(22021970,3))
	e4:SetCategory(CATEGORY_TOGRAVE+CATEGORY_TOHAND)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetRange(LOCATION_MZONE)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e4:SetCountLimit(1,22021971)
	e4:SetCondition(c22021970.indcon)
	e4:SetTarget(c22021970.target)
	e4:SetOperation(c22021970.operation)
	c:RegisterEffect(e4)
	--Immune
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e5:SetRange(LOCATION_MZONE)
	e5:SetValue(aux.tgoval)
	c:RegisterEffect(e5)
	local e6=e5:Clone()
	e6:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e6:SetValue(aux.indoval)
	c:RegisterEffect(e6)
end
function c22021970.spcfilter(c)
	return bit.band(c:GetOriginalType(),TYPE_MONSTER)==TYPE_MONSTER and aux.IsCodeListed(c,22021960) and c:IsFaceup() and c:IsAbleToGraveAsCost()
end
function c22021970.sprcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local mg=Duel.GetMatchingGroup(c22021970.spcfilter,tp,LOCATION_MZONE+LOCATION_SZONE,0,nil)
	return mg:CheckSubGroup(aux.mzctcheck,3,3,tp)
end
function c22021970.sprtg(e,tp,eg,ep,ev,re,r,rp,chk,c)
	local mg=Duel.GetMatchingGroup(c22021970.spcfilter,tp,LOCATION_MZONE+LOCATION_SZONE,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local sg=mg:SelectSubGroup(tp,aux.mzctcheck,true,3,3,tp)
	if sg then
		sg:KeepAlive()
		e:SetLabelObject(sg)
		return true
	else return false end
end
function c22021970.sprop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=e:GetLabelObject()
	Duel.SendtoGrave(g,REASON_COST)
	g:DeleteGroup()
end
function c22021970.cfilter1(c)
	return c:IsFaceup() and c:IsCode(22021960)
end
function c22021970.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c22021970.cfilter1,tp,LOCATION_ONFIELD,0,1,nil)
end
function c22021970.atkcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsDiscardable() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST+REASON_DISCARD)
end
function c22021970.tgtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(1-tp) and chkc:IsOnField() and chkc:IsAbleToGrave() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsAbleToGrave,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectTarget(tp,Card.IsAbleToGrave,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,1,0,0)
end
function c22021970.tgop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoGrave(tc,REASON_EFFECT)
	end
end
function c22021970.tgfilter(c,e,tp,ec,spchk)
	return c:IsAbleToGrave() or c:IsAbleToHand()
end
function c22021970.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	local spchk=Duel.IsEnvironment(22702055) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_ONFIELD) and c22021970.tgfilter(chkc,e,tp,c,spchk) end
	if chk==0 then return Duel.IsExistingTarget(c22021970.tgfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil,e,tp,c,spchk) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c22021970.tgfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil,e,tp,c,spchk)
end
function c22021970.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	local b1=tc:IsRelateToEffect(e) and tc:IsAbleToHand()
	local b2=tc:IsRelateToEffect(e) and tc:IsAbleToGrave()
	if b1 or b2 then
		local s
		if b1 and b2 then
			s=Duel.SelectOption(tp,aux.Stringid(22021970,1),aux.Stringid(22021970,2))
		elseif b1 then
			s=Duel.SelectOption(tp,aux.Stringid(22021970,1))
		else
			s=Duel.SelectOption(tp,aux.Stringid(22021970,2))+1
		end
		if s==0 then
			Duel.SendtoHand(tc,nil,REASON_EFFECT)
		end
		if s==1 then
			Duel.SendtoGrave(tc,nil,REASON_RITUAL)
		end
	end
end
function c22021970.indcon(e)
	return Duel.GetFieldGroupCount(e:GetHandlerPlayer(),LOCATION_MZONE,0)<=1 and e:GetHandler():IsPosition(POS_FACEUP_ATTACK)
end
