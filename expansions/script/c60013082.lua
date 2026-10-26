-- 启动战术
local cm,m,o=GetID()
Duel.LoadScript("c60013052.lua")
cm.isChaosZeroNightmare=true	-- 有【灵光一闪】效果记述

function cm.initial_effect(c)
	-- 作为装备魔法发动
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(aux.Stringid(m,0))
	e0:SetCategory(CATEGORY_EQUIP)
	e0:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	e0:SetTarget(cm.eqtg)
	e0:SetOperation(cm.eqop)
	c:RegisterEffect(e0)

	-- ①：装备怪兽攻击力上升800，可以直接攻击
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_EQUIP)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(800)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_EQUIP)
	e2:SetCode(EFFECT_DIRECT_ATTACK)
	c:RegisterEffect(e2)

	-- ②：1回合2次，装备怪兽成为效果的对象的场合，翻开卡组最上面5张
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,1))
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_TOGRAVE+CATEGORY_ATKCHANGE)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_BECOME_TARGET)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(2)	-- 效果内写明的「1回合2次」，不用 m
	e3:SetCondition(cm.bcon)
	e3:SetTarget(cm.btg)
	e3:SetOperation(cm.bop)
	c:RegisterEffect(e3)
end

-- 装备对象：表侧表示的怪兽
function cm.eqfil(c)
	return c:IsFaceup() and c:IsType(TYPE_MONSTER)
end
function cm.eqlimit(e,c)
	return c:IsFaceup() and c:IsType(TYPE_MONSTER)
end
function cm.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and cm.eqfil(chkc) end
	if chk==0 then
		return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
			and Duel.IsExistingTarget(cm.eqfil,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local g=Duel.SelectTarget(tp,cm.eqfil,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,g,1,0,0)
end
function cm.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if not c:IsRelateToEffect(e) or not tc or not tc:IsRelateToEffect(e) then return end
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	Duel.Equip(tp,c,tc)
	-- 装备限制
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetCode(EFFECT_EQUIP_LIMIT)
	e1:SetValue(cm.eqlimit)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	c:RegisterEffect(e1)
end

-- ②：装备怪兽成为效果的对象的场合
function cm.bcon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetHandler():GetEquipTarget()
	return tc~=nil and eg:IsContains(tc)
end
function cm.btg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>0 end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
-- 选项：1=原本 2=灵光I 3=灵光II 4=灵光III 5=灵光IV
function cm.bop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local canpay=Lingguang.canpay(c,tp)
	local op=Lingguang.select(tp,{
		{true,aux.Stringid(m,1),1},
		{canpay,aux.Stringid(m,2),2},
		{canpay,aux.Stringid(m,3),3},
		{canpay,aux.Stringid(m,4),4},
		{canpay,aux.Stringid(m,5),5}})
	if op==0 then return end
	if op>=2 then
		if not Lingguang.lf(c,tp,e) then return end
	end
	local ct=(op==2) and 10 or 5
	if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)<1 then return end
	-- 先翻开，再取那些卡（顺序不能反，否则选择步骤会被跳过）
	Duel.ConfirmDecktop(tp,ct)
	local g=Duel.GetDecktopGroup(tp,ct)
	if g:GetCount()==0 then return end
	local sg=g:Filter(cm.thfil,nil)
	if sg:GetCount()==0 then
		Duel.ShuffleDeck(tp)
		return
	end
	-- 原本·I·IV：由对方选；灵光II：由自己选
	local chooser=(op==3) and tp or (1-tp)
	Duel.Hint(HINT_SELECTMSG,chooser,HINTMSG_ATOHAND)
	local pick=sg:Select(chooser,1,1,nil):GetFirst()
	if not pick then
		Duel.ShuffleDeck(tp)
		return
	end
	Duel.SendtoHand(pick,tp,REASON_EFFECT)
	Duel.ConfirmCards(1-tp,pick)
	g:RemoveCard(pick)
	if op==4 then
		-- 灵光III：自己从其余的卡中选1张送去墓地
		local rg=g:Filter(Card.IsAbleToGrave,nil)
		if rg:GetCount()>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
			local dg=rg:Select(tp,1,1,nil)
			Duel.SendtoGrave(dg,REASON_EFFECT)
		end
	elseif op==5 then
		-- 灵光IV：装备怪兽攻击力·守备力上升2000
		local ec=c:GetEquipTarget()
		if ec then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetValue(2000)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			ec:RegisterEffect(e1)
			local e2=e1:Clone()
			e2:SetCode(EFFECT_UPDATE_DEFENSE)
			ec:RegisterEffect(e2)
		end
	end
	Duel.ShuffleDeck(tp)
end
-- 有【灵光一闪】效果记述的卡
function cm.thfil(c)
	return c.isChaosZeroNightmare and c:IsAbleToHand()
end
