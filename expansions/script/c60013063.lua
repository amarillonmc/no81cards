-- 帝国执行官 蒂菲拉
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

	-- ①：1回合1次，选1张手卡回到卡组；那之后可以放置灵光一闪衍生物
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(m,1))
	e4:SetCategory(CATEGORY_TODECK+CATEGORY_TOKEN)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1)
	e4:SetTarget(cm.tgtg)
	e4:SetOperation(cm.tgop)
	c:RegisterEffect(e4)
end

function cm.checkop(e,tp,eg,ep,ev,re,r,rp)
	for tc in aux.Next(eg) do
		Duel.RegisterFlagEffect(tc:GetControler(),F_SUMMONED,0,0,1)
	end
end
function cm.spcon(e,c)
	if c==nil then return true end
	return Duel.GetFlagEffect(e:GetHandlerPlayer(),F_SUMMONED)==0
end

-- ①
function cm.tdfil(c)
	return c:IsAbleToDeck()
end
function cm.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(cm.tdfil,tp,LOCATION_HAND,0,1,nil)
	end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_HAND)
end
function cm.tgop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,cm.tdfil,tp,LOCATION_HAND,0,1,1,nil)
	if g:GetCount()==0 then return end
	if Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)==0 then return end
	-- 那之后，可以放置「灵光一闪衍生物」
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	if not Duel.SelectYesNo(tp,aux.Stringid(m,2)) then return end
	cm.tokenop(c,tp)
end
-- 放置「灵光一闪衍生物」并给它效果
function cm.tokenop(c,tp)
	local token=Duel.CreateToken(tp,60013064)
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
	e1:SetDescription(aux.Stringid(m,3))
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
