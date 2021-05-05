--真武神器-蜂
function c40009371.initial_effect(c)
	--destroy
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(40009371,0))
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetCountLimit(1,40009372)
	e1:SetCondition(c40009371.descon)
	e1:SetCost(aux.bfgcost)
	e1:SetTarget(c40009371.destg)
	e1:SetOperation(c40009371.desop)
	c:RegisterEffect(e1)
	--remove
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
	e2:SetValue(0x20)
	c:RegisterEffect(e2)
	--special summon
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_SPSUMMON_PROC)
	e3:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e3:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e3:SetCountLimit(1,40009371)
	e3:SetCondition(c40009371.spcon)
	c:RegisterEffect(e3)	   
end
function c40009371.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x88) and c:IsRace(RACE_BEASTWARRIOR)
end
function c40009371.descon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c40009371.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c40009371.filter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function c40009371.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsControler(1-tp) and c40009371.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c40009371.filter,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c40009371.filter,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c40009371.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end
function c40009371.filter1(c)
	return c:IsFaceup() and c:IsSetCard(0x88) and c:IsRace(RACE_BEASTWARRIOR)
end
function c40009371.spcon(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0 and
		Duel.IsExistingMatchingCard(c40009371.filter1,c:GetControler(),LOCATION_MZONE,0,1,nil)
end

