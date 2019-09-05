--深界探窟者 苍笛
--24560001可  改  任  意  卡  密  啥  的
function c33330036.initial_effect(c)
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkSetCard,0x556),2)
	c:EnableReviveLimit()
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_RECOVER)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_DAMAGE_STEP_END)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTarget(c33330036.tg2)
	e2:SetOperation(c33330036.op2)
	c:RegisterEffect(e2)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(33330036,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetTarget(c33330036.tg1)
	e1:SetOperation(c33330036.op1)
	c:RegisterEffect(e1)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e3:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetTarget(c33330036.tg3)
	e3:SetValue(aux.tgoval)
	c:RegisterEffect(e3)
end
--下  面  的  0x1019  改  成  上  升  负  荷  指  示  物
function c33330036.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetCounter(tp,LOCATION_ONFIELD,0,0x1556)>0 end
	Duel.SetTargetPlayer(tp)
	local ct=Duel.GetCounter(tp,LOCATION_ONFIELD,0,0x1556)
	Duel.SetTargetParam(ct*200)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,ct*200)
end
function c33330036.tg3(e,c)
	return c:IsFaceup() and c:IsLinkState() and c:IsSetCard(0x556)
end
function c33330036.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c33330036.fil1,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil) and Duel.GetFieldCard(tp,LOCATION_SZONE,5) end
	local tc2=Duel.GetFieldCard(tp,LOCATION_SZONE,5)
	local tc=Duel.IsExistingMatchingCard(c33330036.fil1,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,tc2,1,tp,LOCATION_SZONE)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,tc,1,tp,LOCATION_GRAVE)
end
function c33330036.fil1(c)
	return c:IsSetCard(0x556) and c:IsAbleToHand()
end
function c33330036.op1(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFieldCard(tp,LOCATION_SZONE,5)
	if tc then
	if Duel.Destroy(tc,REASON_EFFECT)~=0 then
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectMatchingCard(tp,c33330036.fil1,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
	end
	end
end
function c33330036.op2(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Recover(p,d,REASON_EFFECT)
end