--绰影遗迹的锈铁处女
local m=22348414
local cm=_G["c"..m]
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,22348414)
	e1:SetTarget(c22348414.target)
	e1:SetOperation(c22348414.activate)
	c:RegisterEffect(e1)
	--replace
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(22348414)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,22349413)
	c:RegisterEffect(e2)
	--changeffect
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_REMOVE)
	e3:SetCondition(c22348414.cecon)
	e3:SetOperation(c22348414.ceop)
	c:RegisterEffect(e3)
	
end
function c22348414.cecon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsReason(REASON_REPLACE) and re:IsActivated() and re:IsActiveType(TYPE_MONSTER)
		and re:GetHandler():IsSetCard(0x970a)
end
function c22348414.ceop(e,tp,eg,ep,ev,re,r,rp)
	local tc=re:GetHandler()
	tc:RegisterFlagEffect(22348414,RESET_CHAIN,0,1,1)
end
function c22348414.filter(c,e,tp)
	return c:IsSetCard(0xd70a) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c22348414.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsAbleToRemove() and chkc:IsControler(1-tp) end
	if chk==0 then return Duel.IsExistingTarget(Card.IsAbleToRemove,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,Card.IsAbleToRemove,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
end
function c22348414.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		if Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)~=0 then
		local sc=Duel.GetOperatedGroup():GetFirst()
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_LEAVE_FIELD)
		e1:SetCountLimit(1)
		e1:SetOperation(c22348414.spop)
		e1:SetLabelObject(sc)
		Duel.RegisterEffect(e1,tp)
		end
	end
end
function c22348414.spfilter1(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c22348414.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(1-tp,LOCATION_MZONE)<=0 then return end
	local rc=e:GetLabelObject()
	if rc:IsCanBeSpecialSummoned(e,0,1-tp,false,false) then
		Duel.SpecialSummon(rc,0,tp,1-tp,false,false,POS_FACEUP)
	end
	e:Reset()
end

