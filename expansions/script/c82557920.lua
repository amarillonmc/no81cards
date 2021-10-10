--反旗钢战-ΞGUNDAM
function c82557920.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetOperation(c82557920.spop)
	e1:SetCondition(c82557920.spcon)
	c:RegisterEffect(e1)
	--special summon2
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_DAMAGE+CATEGORY_DESTROY)
	e4:SetDescription(aux.Stringid(82557920,1))
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e4:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	e4:SetTarget(c82557920.regtg)
	e4:SetOperation(c82557920.regop)
	c:RegisterEffect(e4)
end
function c82557920.tgfilter(c)
	return c:IsFaceup()
end
function c82557920.xifilter(c)
	return c:IsFaceup() and c:IsCode(82557920)
end
function c82557920.regtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_ONFIELD) and chkc:GetControler()~=tp end
	if chk==0 then return Duel.IsExistingTarget(c82557920.tgfilter,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPPO)
	local g=Duel.SelectTarget(tp,c82557920.tgfilter,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,LOCATION_ONFIELD,g,1,0,0)
end
function c82557920.regop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetCountLimit(1)
	e1:SetCondition(c82557920.dmcon)
	e1:SetOperation(c82557920.dmop)
	e1:SetLabelObject(tc)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c82557920.dmcon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	return tc:IsOnField()
end
function c82557920.dmop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,82557920)
	if Duel.Damage(tp,2500,REASON_EFFECT)~=0 and
		Duel.GetMatchingGroupCount(c82557920.xifilter,tp,LOCATION_ONFIELD,0,1,1,nil)>0 then
	local g=Duel.GetMatchingGroup(c82557920.xifilter,tp,LOCATION_ONFIELD,0,1,1,nil)
	Duel.Destroy(g,REASON_EFFECT)
	end
end
function c82557920.spcon(e,c)
	if c==nil then return true end
	return Duel.GetFieldGroupCount(c:GetControler(),LOCATION_MZONE,0)==0
		and Duel.GetFieldGroupCount(c:GetControler(),0,LOCATION_MZONE)>0
		and Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
end
function c82557920.spop(e,tp,eg,ep,ev,re,r,rp,c)
	--change base attack
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetReset(RESET_EVENT+0xff0000)
	e1:SetCode(EFFECT_SET_BASE_ATTACK)
	e1:SetValue(c:GetBaseAttack()/2)
	c:RegisterEffect(e1)
end
