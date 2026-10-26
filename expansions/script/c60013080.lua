-- 无人机出击
local cm,m,o=GetID()
Duel.LoadScript("c60013052.lua")
cm.isChaosZeroNightmare=true	-- 有【灵光一闪】效果记述

function cm.initial_effect(c)
	-- ①：以对方场上1只表侧表示的怪兽为对象，直到回合结束效果无效
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_DISABLE+CATEGORY_RECOVER+CATEGORY_DESTROY)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(cm.tg)
	e1:SetOperation(cm.op)
	c:RegisterEffect(e1)

	-- ②：这张卡用抽卡以外的方式加入手卡的场合，观看这张卡抽1张
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,5))
	e2:SetCategory(CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_TO_HAND)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCondition(cm.hcon)
	e2:SetCost(cm.hcost)
	e2:SetTarget(cm.htg)
	e2:SetOperation(cm.hop)
	c:RegisterEffect(e2)
end

function cm.ofil(c)	-- 对方场上的表侧表示怪兽
	return c:IsFaceup() and c:IsType(TYPE_MONSTER)
end
function cm.selfil(c)	-- 自己场上的「失格狙击手 席琳娜」
	return c:IsCode(60013075) and c:IsFaceup()
end
function cm.af(c)	-- 可以破坏的卡
	return c:IsDestructable()
end

-- ①的选项：1=原本 2=灵光I 3=灵光II 4=灵光III
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	local canpay=Lingguang.canpay(c,tp)
	local b0=Duel.IsExistingMatchingCard(cm.ofil,tp,0,LOCATION_MZONE,1,nil)
	local b2=Duel.GetFieldGroupCount(1-tp,LOCATION_ONFIELD,0)>=2
	local b3=canpay and Duel.IsExistingMatchingCard(cm.selfil,tp,LOCATION_MZONE,0,1,nil)
	if chkc then
		return (chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and cm.ofil(chkc))
			or (chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and cm.selfil(chkc))
	end
	if chk==0 then return b0 or b3 end
	local op=Lingguang.select(tp,{
		{b0,aux.Stringid(m,0),1},
		{b0 and canpay,aux.Stringid(m,1),2},
		{b0 and canpay and b2,aux.Stringid(m,2),3},
		{b3,aux.Stringid(m,3),4}})
	if op==0 then return end
	e:SetLabel(op)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	if op==4 then
		Duel.SelectTarget(tp,cm.selfil,tp,LOCATION_MZONE,0,1,1,nil)
	else
		Duel.SelectTarget(tp,cm.ofil,tp,0,LOCATION_MZONE,1,1,nil)
	end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,nil,1,0,0)
end

function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local op=e:GetLabel()
	local tc=Duel.GetFirstTarget()
	if not tc or not tc:IsRelateToEffect(e) then return end
	-- 灵光III：改为选「失格狙击手 席琳娜」得到效果
	if op==4 then
		if not Lingguang.lf(c,tp,e) then return end
		local e1=Effect.CreateEffect(c)
		e1:SetDescription(aux.Stringid(m,4))
		e1:SetCategory(CATEGORY_DAMAGE)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
		e1:SetCode(EVENT_BECOME_TARGET)
		e1:SetProperty(EFFECT_FLAG_DELAY)
		e1:SetRange(LOCATION_MZONE)
		e1:SetCountLimit(2)	-- 效果内的「1回合最多2次」
		e1:SetCondition(cm.dcon)
		e1:SetOperation(cm.dop)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		return
	end
	if op>=2 then
		if not Lingguang.lf(c,tp,e) then return end
	end
	-- 那只怪兽直到回合结束效果无效
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_DISABLE)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	tc:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_DISABLE_EFFECT)
	tc:RegisterEffect(e2)
	if op==2 then
		-- 灵光I：回复那只怪兽攻击力数值的基本分
		local atk=tc:GetAttack()
		if atk>0 then Duel.Recover(tp,atk,REASON_EFFECT) end
	elseif op==3 then
		-- 灵光II：对方场上1张其他卡破坏
		local g=Duel.GetMatchingGroup(cm.af,1-tp,LOCATION_ONFIELD,0,tc)
		if g:GetCount()>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
			local dg=g:Select(tp,1,1,nil)
			Duel.Destroy(dg,REASON_EFFECT)
		end
	end
end

-- 灵光III 给的效果：对方场上的怪兽成为效果的对象的场合，给与对方400伤害
function cm.dfil(c,tp)
	return c:IsLocation(LOCATION_MZONE) and c:IsControler(1-tp) and c:IsType(TYPE_MONSTER)
end
function cm.dcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(cm.dfil,1,nil,tp)
end
function cm.dop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Damage(1-tp,400,REASON_EFFECT)
end

-- ②：抽卡以外的方式加入手卡
function cm.hcon(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsReason(REASON_DRAW)
end
function cm.hcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.ConfirmCards(1-tp,e:GetHandler())
end
function cm.htg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function cm.hop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local canpay=Lingguang.canpay(c,tp)
	local op=Lingguang.select(tp,{
		{true,aux.Stringid(m,5),1},
		{canpay,aux.Stringid(m,6),2}})
	local ct=1
	if op==2 and Lingguang.lf(c,tp,e) then ct=2 end
	Duel.Draw(tp,ct,REASON_EFFECT)
end
