--神道觉醒 初翎山风
local m=96071002
local set=0xff7
local set=0xff8
local cm=_G["c"..m]
function cm.initial_effect(c)
	c:EnableCounterPermit(0xff)
	c:SetCounterLimit(0xff,5)
	--add counter
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_COUNTER)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_ATTACK_ANNOUNCE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(cm.ctcon)
	e1:SetTarget(cm.cttg)
	e1:SetOperation(cm.ctop)
	c:RegisterEffect(e1)
	--cannot be target/indestructable
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(cm.effcon)
	e2:SetValue(1)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	c:RegisterEffect(e3)
	local e4=e2:Clone()
	e4:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	c:RegisterEffect(e4)
	--atk
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCode(EFFECT_UPDATE_ATTACK)
	e5:SetValue(cm.atkval)
	e5:SetCondition(cm.atkcon)
	c:RegisterEffect(e5)
	--actlimit
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD)
	e6:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e6:SetCode(EFFECT_CANNOT_ACTIVATE)
	e6:SetRange(LOCATION_MZONE)
	e6:SetTargetRange(0,1)
	e6:SetValue(3)
	e6:SetCondition(cm.eqcon)
	c:RegisterEffect(e6)
	--destroy
	local e7=Effect.CreateEffect(c)
	e7:SetDescription(aux.Stringid(m,1))
	e7:SetCategory(CATEGORY_DESTROY)
	e7:SetType(EFFECT_TYPE_QUICK_O)
	e7:SetCode(EVENT_FREE_CHAIN)
	e7:SetRange(LOCATION_MZONE)
	e7:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e7:SetCountLimit(1,m)
	e7:SetCost(cm.descost)
	e7:SetTarget(cm.destg)
	e7:SetOperation(cm.desop)
	c:RegisterEffect(e7)
end
cm.card_code_list={96071000}
cm.assault_name=96071001
	--add counter
function cm.ctcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return (Duel.GetAttacker()==c or Duel.GetAttackTarget()==c)
end
function cm.cttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_COUNTER,nil,1,0,0xff)
end
function cm.ctop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then
		e:GetHandler():AddCounter(0xff,1)
	end
end
	--indestructable
function cm.effcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetCounter(0xff)>=1
end
	--cannot be target
function cm.efilter(e,re,rp)
	return re:IsActiveType(TYPE_MONSTER)
end
	--atk
function cm.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetCounter(0xff)>=2
end
function cm.atkval(e,c)
	return c:GetCounter(0xff)*1000
end
	--actlimit
function cm.eqcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetCounter(0xff)==3
end
	--destroy
function cm.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanRemoveCounter(tp,0xff,1,REASON_COST) end
	e:GetHandler():RemoveCounter(tp,0xff,1,REASON_COST)
end
function cm.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsControler(1-tp) end
	if chk==0 then return Duel.IsExistingTarget(aux.TRUE,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,aux.TRUE,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function cm.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsControler(1-tp) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end
