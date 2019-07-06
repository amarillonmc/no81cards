--动物朋友 我的朋友
function c33700087.initial_effect(c)
   --Activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
   --self destroy
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_SELF_TOGRAVE)
	e1:SetCondition(c33700087.con)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DISABLE)
	e2:SetType(EFFECT_TYPE_QUICK_F)
	e2:SetCode(EVENT_BECOME_TARGET)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCost(c33700087.cost)
	e2:SetCondition(c33700087.dcon)
	e2:SetTarget(c33700087.dtg)
	e2:SetOperation(c33700087.dop)
	c:RegisterEffect(e2)
	 local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_QUICK_F)
	e3:SetCode(EVENT_BE_BATTLE_TARGET)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCondition(c33700087.atcon)
	e3:SetTarget(c33700087.attg)
	e3:SetOperation(c33700087.atop)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_ATTACK_ANNOUNCE)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCondition(c33700087.condition)
	e4:SetCost(c33700087.cost2)
	e4:SetTarget(c33700087.target)
	e4:SetOperation(c33700087.activate)
	c:RegisterEffect(e4)
end
c33700087.card_code_list={33700056}
function c33700087.con(e)
	 local g=Duel.GetMatchingGroup(nil,e:GetHandlerPlayer(),LOCATION_GRAVE,0,nil)
	return g:GetClassCount(Card.GetCode)<g:GetCount()
end
function c33700087.tgfilter(c,tp)
	return c:IsLocation(LOCATION_MZONE+LOCATION_GRAVE) and c:IsControler(tp) and c:IsSetCard(0x442) and c:IsType(TYPE_MONSTER)
end
function c33700087.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,1000) end
	Duel.PayLPCost(tp,1000)
end
function c33700087.dcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c33700087.tgfilter,1,nil,tp) and rp==1-tp
end
function c33700087.dtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,eg,1,0,0)
end
function c33700087.dop(e,tp,eg,ep,ev,re,r,rp)
	if  not e:GetHandler():IsRelateToEffect(e) then return end 
   Duel.NegateEffect(ev) 
end
function c33700087.atcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c33700087.tgfilter,1,nil,tp) 
end
function c33700087.attg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not Duel.GetAttacker():IsHasEffect(EFFECT_CANNOT_DIRECT_ATTACK) end
	e:SetLabel(1)
end
function c33700087.atop(e,tp,eg,ep,ev,re,r,rp)
   if e:GetLabel()==0 or not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.ChangeAttackTarget(nil)
end
function c33700087.condition(e,tp,eg,ep,ev,re,r,rp)
	local at=Duel.GetAttacker()
	return at:GetControler()==1-tp and Duel.GetAttackTarget()==nil
end
function c33700087.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c33700087.filter,tp,LOCATION_GRAVE,0,1,nil)  end
	local g=Duel.SelectMatchingCard(tp,c33700087.filter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SendtoDeck(g,nil,2,REASON_COST)
end
function c33700087.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local at=Duel.GetAttacker()
	if chk==0 then return  at:IsOnField() and at:GetAttack()>=Duel.GetLP(tp) end
end
function c33700087.filter(c)
	return c:IsSetCard(0x442) and c:IsType(TYPE_MONSTER) and c:IsAbleToDeckAsCost()
end
function c33700087.activate(e,tp,eg,ep,ev,re,r,rp)
	  if  not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.NegateAttack() 
end