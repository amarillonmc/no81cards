--植物娘·香蒲
function c65830010.initial_effect(c)
	c:SetSPSummonOnce(65830010)
	--特招手续
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,c65830010.ffilter,1,false)
	aux.AddContactFusionProcedure(c,Card.IsAbleToGraveAsCost,LOCATION_ONFIELD,0,Duel.SendtoGrave,REASON_COST)
	--不能融合
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e1)
	--炸场上
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(65830010,0))
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,65830010)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetTarget(c65830010.destg)
	e2:SetOperation(c65830010.desop)
	c:RegisterEffect(e2)
	--炸连锁
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(65830010,1))
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_CHAINING)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,65830010)
	e3:SetCondition(c65830010.condition)
	e3:SetTarget(c65830010.target)
	e3:SetOperation(c65830010.operation)
	c:RegisterEffect(e3)
end



function c65830010.ffilter(c,fc,sub,mg,sg)
	return c:IsCode(65830005)
end


function c65830010.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() end
	if chk==0 then return Duel.IsExistingTarget(nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c65830010.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then Duel.Destroy(tc,REASON_EFFECT) end
end


function c65830010.condition(e,tp,eg,ep,ev,re,r,rp)
	local tc=re:GetHandler()
	return tc:IsControler(1-tp) and tc:IsRelateToEffect(re)
end
function c65830010.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return re:GetHandler():IsDestructable() end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
end
function c65830010.operation(e,tp,eg,ep,ev,re,r,rp)
	if re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end


