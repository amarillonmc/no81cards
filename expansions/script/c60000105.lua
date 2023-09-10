--NGNL 机凯伪典 天移
if not pcall(function() require("expansions/script/c60000101") end) then require("script/c60000101") end
local m=60000105
local cm=_G["c"..m]
cm.name="NGNL 机凯伪典 天移"
function cm.initial_effect(c)
	--Negate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCondition(cm.condition)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.operation)
	c:RegisterEffect(e1)
	--
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_REMOVE)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCountLimit(1,m)
	e3:SetCondition(jkz.xcon)
	e3:SetTarget(cm.xxtg)
	e3:SetOperation(cm.xxop)
	c:RegisterEffect(e3)
	local ge1 = jkz.GetCountEffect(c)
end
cm.named_with_ExMachina=true 
cm.named_with_WeiDian=true 
function cm.cfilter(c)
	return c:IsOnField() and c:IsType(TYPE_MONSTER)
end
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	if tp==ep or not Duel.IsChainNegatable(ev) then return false end
	if not re:IsActiveType(TYPE_MONSTER) and not re:IsHasType(EFFECT_TYPE_ACTIVATE) then return false end
	local ex,tg,tc=Duel.GetOperationInfo(ev,CATEGORY_DESTROY)
	local ct = Duel.GetTurnCount()
	return ex and tg~=nil and tc+tg:FilterCount(cm.cfilter,nil)-tg:GetCount()>0 and (Duel.GetTurnPlayer() == tp or jkz.GetCount(ct,3))
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end
function cm.xxfilter(c)
	return c:IsSetCard(0x6a0)
end
function cm.mkfilter(c)
	return c.named_with_ExMachina and c:IsType(TYPE_LINK) and c:IsAttackAbove(2500)
end
function cm.ttkfilter(c)
	return c:IsCode(60000112)
end
function cm.xxtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.ConfirmCards(1-tp,Duel.GetFieldGroup(tp,LOCATION_DECK,0))
	if (not Duel.IsExistingMatchingCard(cm.xxfilter,tp,LOCATION_DECK,0,1,nil)) or (Duel.IsExistingMatchingCard(cm.mkfilter,tp,LOCATION_MZONE,0,1,nil) and Duel.IsExistingMatchingCard(cm.ttkfilter,tp,LOCATION_SZONE,0,1,nil)) then 
	e:SetLabel(1)
	end
end

function cm.desfilter1(c)
	return Duel.IsExistingMatchingCard(nil,0,LOCATION_ONFIELD,LOCATION_ONFIELD,1,c)
end
function cm.xxop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if e:GetLabel()==1 then 
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g1=Duel.SelectMatchingCard(tp,cm.desfilter1,tp,LOCATION_ONFIELD,0,1,1,nil)
	if #g1==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g2=Duel.SelectMatchingCard(tp,nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,g1)
	g1:Merge(g2)
	Duel.HintSelection(g1)
	Duel.Remove(g1,POS_FACEUP,REASON_EFFECT)
	end
end 






