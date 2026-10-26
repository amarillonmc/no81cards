-- 捕捉目标
local cm,m,o=GetID()
Duel.LoadScript("c60013052.lua")
cm.isChaosZeroNightmare=true	-- 有【灵光一闪】效果记述

function cm.initial_effect(c)
	-- ①：以对方场上1只表侧表示的怪兽为对象，回到持有者手卡
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_TODECK+CATEGORY_REMOVE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(cm.tg)
	e1:SetOperation(cm.op)
	c:RegisterEffect(e1)

	-- ②：这张卡用抽卡以外的方式加入手卡的场合，观看这张卡，选席琳娜得到效果
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,5))
	e2:SetCategory(CATEGORY_REMOVE)
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

-- ①的选项：1=原本 2=灵光I 3=灵光II 4=灵光III 5=灵光IV
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	local canpay=Lingguang.canpay(c,tp)
	local b0=Duel.IsExistingMatchingCard(cm.ofil,tp,0,LOCATION_MZONE,1,nil)
	local b2=Duel.GetFieldGroupCount(1-tp,LOCATION_MZONE,0)>=2
	local b4=Duel.GetFieldGroupCount(1-tp,LOCATION_EXTRA,0)>0
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and cm.ofil(chkc) end
	if chk==0 then return b0 end
	local op=Lingguang.select(tp,{
		{b0,aux.Stringid(m,0),1},
		{b0 and canpay,aux.Stringid(m,1),2},
		{b0 and canpay and b2,aux.Stringid(m,2),3},
		{b0 and canpay,aux.Stringid(m,3),4},
		{b0 and canpay and b4,aux.Stringid(m,4),5}})
	if op==0 then return end
	e:SetLabel(op)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,cm.ofil,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,1-tp,LOCATION_MZONE)
end

function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local op=e:GetLabel()
	local tc=Duel.GetFirstTarget()
	if not tc or not tc:IsRelateToEffect(e) then return end
	if op>=2 then
		if not Lingguang.lf(c,tp,e) then return end
	end
	local attr=tc:GetAttribute()	-- 先记下属性，卡离开场上之后还要用
	if op==2 then
		-- 灵光I：回到卡组
		Duel.SendtoDeck(tc,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
	elseif op==3 then
		-- 灵光II：对方场上其他怪兽回到持有者手卡
		local g=Duel.GetMatchingGroup(cm.ofil,1-tp,LOCATION_MZONE,0,tc)
		if g:GetCount()>0 then
			Duel.SendtoHand(g,1-tp,REASON_EFFECT)
			Duel.ConfirmCards(tp,g)
		end
	else
		-- 原本：回到持有者手卡
		Duel.SendtoHand(tc,1-tp,REASON_EFFECT)
		Duel.ConfirmCards(tp,tc)
	end
	if op==4 then
		-- 灵光III：这个回合，对方不能把和那只怪兽属性相同的怪兽从墓地特殊召唤
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
		e1:SetTargetRange(0,1)
		e1:SetLabel(attr)
		e1:SetTarget(cm.splim)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
	elseif op==5 then
		-- 灵光IV：确认对方额外卡组，选1只相同属性的怪兽除外
		local g=Duel.GetFieldGroup(tp,0,LOCATION_EXTRA)
		if g:GetCount()>0 then
			Duel.ConfirmCards(tp,g)
			local sg=g:Filter(cm.extrafil,nil,attr)
			if sg:GetCount()>0 then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
				local rg=sg:Select(tp,1,1,nil)
				Duel.Remove(rg,POS_FACEUP,REASON_EFFECT)
			end
		end
	end
end
-- 灵光III：墓地里同属性的怪兽不能特殊召唤
function cm.splim(e,c,sump,sumtype,sumpos,targetp,se)
	return c:IsLocation(LOCATION_GRAVE) and c:IsAttribute(e:GetLabel())
end
-- 灵光IV：额外卡组里同属性的怪兽
function cm.extrafil(c,attr)
	return c:IsType(TYPE_MONSTER) and c:IsAttribute(attr)
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
	if chk==0 then return Duel.IsExistingMatchingCard(cm.selfil,tp,LOCATION_MZONE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,1-tp,LOCATION_ONFIELD)
end
function cm.hop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectMatchingCard(tp,cm.selfil,tp,LOCATION_MZONE,0,1,1,nil)
	local tc=g:GetFirst()
	if not tc then return end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetDescription(aux.Stringid(m,6))
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_BECOME_TARGET)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(2)	-- 效果内的「1回合最多2次」
	e1:SetCondition(cm.dcon)
	e1:SetTarget(cm.dtg)
	e1:SetOperation(cm.dop)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	tc:RegisterEffect(e1)
end
-- ②给的效果：对方场上的怪兽成为效果的对象的场合，选对方场上1张卡除外
function cm.dfil(c,tp)
	return c:IsLocation(LOCATION_MZONE) and c:IsControler(1-tp) and c:IsType(TYPE_MONSTER)
end
function cm.dcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(cm.dfil,1,nil,tp)
end
function cm.dtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,1-tp,LOCATION_ONFIELD)
end
function cm.dop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,1,1,nil)
	if g:GetCount()>0 then
		Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
	end
end
