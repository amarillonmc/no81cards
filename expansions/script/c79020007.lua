--整合运动·萨卡兹佣兵领袖-W
function c79020007.initial_effect(c)
   --fusion material
   c:EnableReviveLimit()
   aux.AddFusionProcFunRep2(c,c79020007.ffilter,5,5,false)
   aux.AddContactFusionProcedure(c,Card.IsReleasable,LOCATION_MZONE,0,Duel.Release,REASON_COST+REASON_FUSION+REASON_MATERIAL)   
	--Destroy
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e1:SetRange(LOCATION_EXTRA+LOCATION_MZONE)
	e1:SetCode(EVENT_TO_GRAVE)
	e1:SetCondition(c79020007.condition)
	e1:SetTarget(c79020007.target)
	e1:SetOperation(c79020007.operation)
	c:RegisterEffect(e1)   
	--Recover
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DAMAGE)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetRange(LOCATION_EXTRA+LOCATION_MZONE)
	e2:SetOperation(c79020007.operation1)
	c:RegisterEffect(e2)
	--Destroy fusion
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetCountLimit(1,79020007)
	e3:SetTarget(c79020007.lztg)
	e3:SetOperation(c79020007.lzop)
	c:RegisterEffect(e3)
	--cannot target
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e4:SetValue(aux.tgoval)
	c:RegisterEffect(e4)
	--indes
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetValue(1)
	c:RegisterEffect(e4)
	--SendtoGrave
	local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_DAMAGE)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e5:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e5:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
	e5:SetTarget(c79020007.target2)
	e5:SetOperation(c79020007.operation2)
	c:RegisterEffect(e5)
end
function c79020007.ffilter(c)
	return c:IsSetCard(0x3900)
end
function c79020007.condition(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	while tc do
	   return tc:IsReason(REASON_DESTROY) and tc:IsSetCard(0x3900) and tc:IsPreviousLocation(LOCATION_ONFIELD)
end
end
function c79020007.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,tp,LOCATION_ONFIELD)
end
function c79020007.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,aux.TRUE,tp,0,LOCATION_ONFIELD,1,1,nil)
	if g:GetCount()>0 then
	Duel.Destroy(g,REASON_EFFECT)
end
end
function c79020007.filter1(c,tp)
	return c:GetControler()==1-tp
end
function c79020007.operation1(e,tp,eg,ep,ev,re,r,rp)
	if not eg:IsExists(c79020007.filter1,1,nil,tp) then return end
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Recover(tp,300,REASON_EFFECT)
	Debug.Message("比起被人给予，我还是更乐意自己抢过来啊。")
end
function c79020007.lztg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=Duel.GetFieldGroup(tp,0,LOCATION_HAND)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c79020007.lzop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(tp,0,LOCATION_HAND)
	local x=g:GetCount()
	if g:GetCount()>0 then
		a=g:RandomSelect(tp,2)
		Duel.Destroy(a,REASON_EFFECT)
		Duel.Damage(1-tp,2000,REASON_EFFECT)
	end
end
function c79020007.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_ONFIELD)
end
function c79020007.operation2(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(tp,0,LOCATION_ONFIELD)
	local x=g:GetCount()
	if g:GetCount()>0 then
	   a=g:RandomSelect(tp,1)
	   Duel.SendtoGrave(a,REASON_EFFECT)
end
end



