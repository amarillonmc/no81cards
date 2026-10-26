-- 凶兆的使徒 罗丝薇瑟
local cm,m,o=GetID()
Duel.LoadScript("c60013052.lua")

local F_SUMMONED=m+10000000	-- 本场决斗中召唤过怪兽（0=没有召唤过，才能从手卡·墓地特殊召唤）
local F_GYSP=m+20000000		-- 从墓地特殊召唤的1回合1次

function cm.initial_effect(c)
	-- 卡名记述：「凶兆的使徒 罗丝薇瑟」（用于「剑穗」的代替破坏等判定）
	aux.AddCodeList(c,60013050)
	c:EnableReviveLimit()

	-- 不能通常召唤
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(aux.FALSE)
	c:RegisterEffect(e1)

	-- 手卡：自己没有把怪兽召唤过的决斗中才能特殊召唤
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,0))
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_HAND)
	e2:SetCountLimit(1,F_GYSP)	-- 手卡·墓地合计每回合1次
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

	-- ①：特殊召唤成功的场合，公开手卡并送墓不符合的卡；没有送墓的场合可以放置专属衍生物
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(m,1))
	e4:SetCategory(CATEGORY_TOGRAVE+CATEGORY_TOKEN+CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetCountLimit(1,EFFECT_COUNT_CODE_CHAIN)
	e4:SetTarget(cm.tgtg)
	e4:SetOperation(cm.tgop)
	c:RegisterEffect(e4)

	-- ②：自己·对方回合，把2只灵光一闪衍生物破坏，从卡组·墓地放置「凯尔肯」
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(m,3))
	e5:SetCategory(CATEGORY_DESTROY)
	e5:SetType(EFFECT_TYPE_QUICK_O)
	e5:SetCode(EVENT_FREE_CHAIN)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCountLimit(1,m)
	e5:SetCondition(cm.kcon)
	e5:SetTarget(cm.ktg)
	e5:SetOperation(cm.kop)
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

-- ①：留在手卡的卡（有【灵光一闪】记述，或有「罗丝薇瑟」卡名记述）
function cm.keepfil(c)
	return c.isChaosZeroNightmare or aux.IsCodeListed(c,60013050)
end
function cm.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,0,tp,LOCATION_HAND)
end
function cm.tgop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local sent=false
	local hg=Duel.GetFieldGroup(tp,LOCATION_HAND,0)
	if hg:GetCount()>0 then
		Duel.ConfirmCards(1-tp,hg)
		local sg=hg:Filter(function(tc) return not cm.keepfil(tc) end,nil)
		if sg:GetCount()>0 and Duel.SendtoGrave(sg,REASON_EFFECT)>0 then sent=true end
	end
	-- 有因这个效果把卡送去墓地的场合，不放置衍生物
	if sent then return end
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	if not Duel.SelectYesNo(tp,aux.Stringid(m,2)) then return end
	cm.tokenop(c,tp)
end
-- 放置「灵光一闪衍生物」并给它效果
function cm.tokenop(c,tp)
	local token=Duel.CreateToken(tp,60013052)
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
-- ●的检索
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

-- ②：「神之灵光一闪 凯尔肯」（按「灵光一闪衍生物」标签检索，不按卡名/卡号）
function cm.kfilter(c)
	return Lingguang.kelkenfilter(c)
end
function cm.kcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingMatchingCard(Lingguang.tokfilter,tp,LOCATION_SZONE,0,2,nil)
		and Duel.IsExistingMatchingCard(cm.kfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil)
end
function cm.ktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return cm.kcon(e,tp,eg,ep,ev,re,r,rp) end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,2,tp,LOCATION_SZONE)
end
function cm.kop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local dg=Duel.GetMatchingGroup(Lingguang.tokfilter,tp,LOCATION_SZONE,0,nil):Select(tp,2,2,nil)
	if dg:GetCount()<2 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local g=Duel.SelectMatchingCard(tp,cm.kfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	local tc=g:GetFirst()
	if not tc then return end
	local fd=tc:IsLocation(LOCATION_DECK)
	Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	Duel.ShuffleDeck(tp)
	-- 那之后，那些选择的卡破坏
	Duel.Destroy(dg,REASON_EFFECT)
end
