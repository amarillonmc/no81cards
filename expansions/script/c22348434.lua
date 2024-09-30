--骑乘！拉特金骑士
function c22348434.initial_effect(c)
	c:SetSPSummonOnce(22348434)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFun2(c,aux.FilterBoolFunction(Card.IsFusionType,TYPE_UNION),aux.FilterBoolFunction(Card.IsFusionType,TYPE_EFFECT),true)
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(aux.fuslimit)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetCondition(c22348434.hspcon)
	e2:SetOperation(c22348434.hspop)
	c:RegisterEffect(e2)
	--atk
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetValue(c22348434.atkval)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e4)
	--to hand
	local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_TOHAND+CATEGORY_LEAVE_GRAVE)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e5:SetCode(EVENT_LEAVE_FIELD)
	e5:SetProperty(EFFECT_FLAG_DELAY)
	e5:SetCondition(c22348434.thcon)
	e5:SetTarget(c22348434.thtg)
	e5:SetOperation(c22348434.thop)
	c:RegisterEffect(e5)
end
c22348434.has_text_type=TYPE_UNION
function c22348434.eqspfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x970b)
end
function c22348434.hspfilter(c,tp,sc)
	return c:GetEquipGroup():IsExists(c22348434.eqspfilter,1,nil) and c:IsReleasable(REASON_SPSUMMON) and Duel.GetLocationCountFromEx(tp,tp,c,sc)>0 and c:IsCanBeFusionMaterial(sc,SUMMON_TYPE_SPECIAL)
end
function c22348434.hspcon(e,c)
	if c==nil then return true end
	return Duel.IsExistingMatchingCard(c22348434.hspfilter,c:GetControler(),LOCATION_MZONE,LOCATION_MZONE,1,nil,c:GetControler(),c)
end
function c22348434.hspop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.SelectMatchingCard(tp,c22348434.hspfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,tp,c)
	c:SetMaterial(g)
	Duel.Release(g,REASON_COST)
end
function c22348434.atkval(e,c)
	return Duel.GetMatchingGroupCount(Card.IsType,0,LOCATION_SZONE,LOCATION_SZONE,nil,TYPE_EQUIP)*700
end
function c22348434.thcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(LOCATION_ONFIELD)
		and c:IsPreviousControler(tp) and c:GetReasonPlayer()==1-tp
end
function c22348434.thfilter(c)
	return c:IsSetCard(0x970b) and c:IsType(TYPE_UNION) and c:IsAbleToHand()
end
function c22348434.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c22348434.thfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
end
function c22348434.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local tg=Duel.SelectMatchingCard(tp,c22348434.thfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	if #tg==1 and Duel.SendtoHand(tg,nil,REASON_EFFECT)~=0 then
		Duel.ConfirmCards(1-tp,tg)
	end
end
