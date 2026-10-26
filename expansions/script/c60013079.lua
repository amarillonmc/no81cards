-- 高倍率瞄准镜
local cm,m,o=GetID()
Duel.LoadScript("c60013052.lua")
cm.isChaosZeroNightmare=true	-- 有【灵光一闪】效果记述

function cm.initial_effect(c)
	-- ①：以对方场上1只表侧表示的怪兽为对象
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(cm.tg)
	e1:SetOperation(cm.op)
	c:RegisterEffect(e1)
end

function cm.ofil(c)	-- 对方场上的表侧表示怪兽
	return c:IsFaceup() and c:IsType(TYPE_MONSTER)
end
function cm.selfil(c)	-- 自己场上的「失格狙击手 席琳娜」
	return c:IsCode(60013075) and c:IsFaceup()
end
function cm.thfil(c)	-- 这张卡以外有【灵光一闪】记述的魔陷
	return c.isChaosZeroNightmare and c:IsType(TYPE_SPELL+TYPE_TRAP) and not c:IsCode(m) and c:IsAbleToHand()
end

-- ①的选项：1=原本 2=灵光I 3=灵光II 4=灵光III 5=灵光IV
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	local canpay=Lingguang.canpay(c,tp)
	local b0=Duel.IsExistingMatchingCard(cm.ofil,tp,0,LOCATION_MZONE,1,nil)
	local b3=canpay and Duel.IsExistingMatchingCard(cm.selfil,tp,LOCATION_MZONE,0,1,nil)
	local b4=Duel.IsExistingMatchingCard(cm.thfil,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil)
	if chkc then
		return (chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and cm.ofil(chkc))
			or (chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and cm.selfil(chkc))
	end
	if chk==0 then return b0 or b3 end
	local op=Lingguang.select(tp,{
		{b0,aux.Stringid(m,0),1},
		{b0 and canpay,aux.Stringid(m,1),2},
		{b0 and canpay,aux.Stringid(m,2),3},
		{b3,aux.Stringid(m,3),4},
		{b0 and canpay and b4,aux.Stringid(m,4),5}})
	if op==0 then return end
	e:SetLabel(op)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	if op==4 then
		Duel.SelectTarget(tp,cm.selfil,tp,LOCATION_MZONE,0,1,1,nil)
	else
		Duel.SelectTarget(tp,cm.ofil,tp,0,LOCATION_MZONE,1,1,nil)
	end
	Duel.SetOperationInfo(0,CATEGORY_ATKCHANGE,nil,1,0,0)
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
		e1:SetDescription(aux.Stringid(m,5))
		e1:SetCategory(CATEGORY_DRAW)
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
	if op==3 then
		-- 灵光II：对方场上全部怪兽攻击力变为原本的一半
		local g=Duel.GetMatchingGroup(cm.ofil,tp,0,LOCATION_MZONE,nil)
		for sc in aux.Next(g) do
			cm.half(sc)
		end
	elseif op==2 then
		-- 灵光I：攻击力变为0
		cm.setatk(tc,0)
	else
		-- 原本：攻击力变为原本的一半
		cm.half(tc)
	end
	-- 灵光IV：那之后，检索1张有【灵光一闪】记述的魔陷
	if op==5 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,cm.thfil,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
			Duel.ShuffleDeck(tp)
		end
	end
end

function cm.setatk(tc,v)
	local e1=Effect.CreateEffect(tc)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SET_ATTACK_FINAL)
	e1:SetValue(v)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	tc:RegisterEffect(e1)
end
function cm.half(tc)
	cm.setatk(tc,math.floor(tc:GetBaseAttack()/2))
end

-- 灵光III 给的效果：对方场上的怪兽成为效果的对象的场合，自己抽1张
function cm.dfil(c,tp)
	return c:IsLocation(LOCATION_MZONE) and c:IsControler(1-tp) and c:IsType(TYPE_MONSTER)
end
function cm.dcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(cm.dfil,1,nil,tp)
end
function cm.dop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Draw(tp,1,REASON_EFFECT)
end
