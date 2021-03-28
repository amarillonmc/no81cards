--龙界炎辉 超太阳之龙
function c99700265.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,99700265+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c99700265.spcon)
	e1:SetOperation(c99700265.spop)
	c:RegisterEffect(e1)
	--immune
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_IMMUNE_EFFECT)
	e2:SetValue(c99700265.efilter)
	c:RegisterEffect(e2)
	--tograve
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(99700265,0))
	e3:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,99700266)
	e3:SetCost(c99700265.amcost)
	e3:SetTarget(c99700265.target)
	e3:SetOperation(c99700265.operation)
	c:RegisterEffect(e3)
end
function c99700265.rfilter(c,ft,tp)
	return c:IsCode(94455263)
		and (ft>0 or (c:IsControler(tp) and c:GetSequence()<5)) and (c:IsControler(tp) or c:IsFaceup())
end
function c99700265.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	return ft>-1 and Duel.CheckReleaseGroup(tp,c99700265.rfilter,1,nil,ft,tp)
end
function c99700265.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local g=Duel.SelectReleaseGroup(tp,c99700265.rfilter,1,1,nil,ft,tp)
	Duel.Release(g,REASON_COST)
end
function c99700265.efilter(e,re)
	return e:GetOwnerPlayer()~=re:GetOwnerPlayer() and re:IsActiveType(TYPE_SPELL+TYPE_TRAP)
end
function c99700265.filter(c)
	return c:IsSetCard(0xfd04) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToHand()
end
function c99700265.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c99700265.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_REMOVED)
end
function c99700265.tgfilter(c)
	return c:IsSetCard(0xfd04) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToGrave()
end
function c99700265.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local dg=Duel.SelectMatchingCard(tp,c99700265.tgfilter,tp,LOCATION_DECK,0,1,1,nil)
	Duel.SendtoGrave(dg,REASON_EFFECT)
	Duel.BreakEffect()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c99700265.filter,tp,LOCATION_REMOVED,0,1,1,nil)
	if g:GetCount()==0 then return end
	Duel.SendtoHand(g,nil,REASON_EFFECT)
	Duel.ConfirmCards(1-tp,g)
	Duel.ShuffleHand(tp)
end
function c99700265.amcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetCustomActivityCount(99700265,tp,ACTIVITY_CHAIN+ACTIVITY_SUMMON+ACTIVITY_SPSUMMON+ACTIVITY_FLIPSUMMON+ACTIVITY_NORMALSUMMON)==0 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c99700265.splimit)
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_CANNOT_SUMMON)
	Duel.RegisterEffect(e2,tp)
	local e4=e1:Clone()
	e4:SetCode(EFFECT_CANNOT_FLIP_SUMMON)
	Duel.RegisterEffect(e4,tp)
	local e3=Effect.CreateEffect(e:GetHandler())
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e3:SetCode(EFFECT_CANNOT_ACTIVATE)
	e3:SetTargetRange(1,0)
	e3:SetValue(c99700265.aclimit)
	Duel.RegisterEffect(e3,tp)
end
function c99700265.splimit(e,c)
	return not (c:IsSetCard(0xfd00) or c:IsSetCard(0xfd01) or c:IsSetCard(0xfd02) or c:IsSetCard(0xfd03) or c:IsSetCard(0xfd04))
end
function c99700265.aclimit(e,re,tp)
	return not (re:GetHandler():IsSetCard(0xfd00) or re:GetHandler():IsSetCard(0xfd01) or re:GetHandler():IsSetCard(0xfd02) or re:GetHandler():IsSetCard(0xfd03) or re:GetHandler():IsSetCard(0xfd04))
end