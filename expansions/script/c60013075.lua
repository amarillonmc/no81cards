-- 失格狙击手 席琳娜
local cm,m,o=GetID()

local F_SUMMONED=m+10000000	-- 本场决斗中召唤过怪兽（0=没有召唤过，才能从手卡·墓地特殊召唤）
local F_GYSP=m+20000000		-- 从墓地特殊召唤的1回合1次（手卡不限次数）

function cm.initial_effect(c)
	c:EnableReviveLimit()

	-- 不能通常召唤
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(aux.FALSE)
	c:RegisterEffect(e1)

	-- 手卡：自己没有把怪兽召唤过的决斗中才能特殊召唤（手卡不限次数）
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,0))
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_HAND)
	e2:SetCondition(cm.spcon)
	c:RegisterEffect(e2)
	-- 墓地：每回合1次
	local e3=e2:Clone()
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCountLimit(1,F_GYSP)
	c:RegisterEffect(e3)

	-- 全局记录：谁召唤过怪兽
	if not cm.global_check then
		cm.global_check=true
		local ge=Effect.CreateEffect(c)
		ge:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge:SetCode(EVENT_SUMMON_SUCCESS)
		ge:SetOperation(cm.checkop)
		Duel.RegisterEffect(ge,0)
	end

	-- ①：1回合1次，以对方场上1只表侧表示的怪兽为对象，这张卡得到以下效果
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(m,1))
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1)	-- 效果内写明的「1回合1次」：这张卡自己1次，离场再回来就刷新，所以不带 m
	e4:SetTarget(cm.tgtg)
	e4:SetOperation(cm.tgop)
	c:RegisterEffect(e4)

	-- ②：这张卡从场上离开的场合，放置灵光一闪衍生物
	-- 卡文（效果外）：「这个卡名的②的效果1回合只能使用1次」→ 用 m 记次
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(m,3))
	e5:SetCategory(CATEGORY_TOKEN)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e5:SetCode(EVENT_LEAVE_FIELD)
	e5:SetProperty(EFFECT_FLAG_DELAY)
	e5:SetCountLimit(1,m)
	e5:SetCondition(cm.lvcon)
	e5:SetTarget(cm.lvtg)
	e5:SetOperation(cm.lvop)
	c:RegisterEffect(e5)
end

-- 召唤记录
function cm.checkop(e,tp,eg,ep,ev,re,r,rp)
	for tc in aux.Next(eg) do
		Duel.RegisterFlagEffect(tc:GetControler(),F_SUMMONED,0,0,1)
	end
end
-- 特殊召唤条件
function cm.spcon(e,c)
	if c==nil then return true end
	return Duel.GetFlagEffect(e:GetHandlerPlayer(),F_SUMMONED)==0
end

-- ①：对方场上的表侧表示怪兽
function cm.tgfil(c)
	return c:IsFaceup() and c:IsType(TYPE_MONSTER)
end
function cm.tgtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and cm.tgfil(chkc) end
	if chk==0 then return Duel.IsExistingTarget(cm.tgfil,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,cm.tgfil,tp,0,LOCATION_MZONE,1,1,nil)
end
function cm.tgop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if not c:IsRelateToEffect(e) or not tc or not tc:IsRelateToEffect(e) then return end
	-- ●那只怪兽成为效果的对象的场合，给与对方400伤害
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,2))
	e1:SetCategory(CATEGORY_DAMAGE)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_BECOME_TARGET)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,EFFECT_COUNT_CODE_CHAIN)	-- 卡文：（同一连锁上最多1次）
	e1:SetLabelObject(tc)
	e1:SetCondition(cm.bcon)
	e1:SetOperation(cm.bop)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	c:RegisterEffect(e1)
end
function cm.bcon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	return tc~=nil and eg:IsContains(tc)
end
function cm.bop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Damage(1-tp,400,REASON_EFFECT)
end

-- ②
function cm.lvcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(LOCATION_MZONE) and c:IsPreviousPosition(POS_FACEUP)
end
function cm.lvtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0 end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
end
function cm.lvop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	cm.tokenop(c,tp)
end
-- 放置「灵光一闪衍生物」并给它效果
function cm.tokenop(c,tp)
	local token=Duel.CreateToken(tp,60013076)
	Duel.MoveToField(token,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	-- 原本属性相同
	local ea=Effect.CreateEffect(c)
	ea:SetType(EFFECT_TYPE_SINGLE)
	ea:SetCode(EFFECT_CHANGE_ATTRIBUTE)
	ea:SetValue(c:GetOriginalAttribute())
	ea:SetReset(RESET_EVENT+RESETS_STANDARD)
	token:RegisterEffect(ea)
	-- ●这张卡破坏。从卡组把1张有【灵光一闪】效果记述的魔法·陷阱加入手卡。这个效果1回合只能使用1次
	local e1=Effect.CreateEffect(token)
	e1:SetDescription(aux.Stringid(m,4))
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_SEARCH+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCountLimit(1)
	e1:SetTarget(cm.thtg)
	e1:SetOperation(cm.thop)
	token:RegisterEffect(e1)
end
function cm.thfil(c)
	return c.isChaosZeroNightmare and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToHand()
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return c:IsDestructable() and Duel.IsExistingMatchingCard(cm.thfil,tp,LOCATION_DECK,0,1,nil)
	end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,c,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if Duel.Destroy(c,REASON_EFFECT)==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,cm.thfil,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
