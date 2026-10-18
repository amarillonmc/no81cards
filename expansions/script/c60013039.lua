-- 时崎狂三·时崎狂三
local cm,m,o=GetID()

-- ① 待机状态（用卡的 flag 记录选了哪一项，离开手卡即失效）
-- 计数·标记一律用 m、m+10000000、m+20000000… 的编号规则
local F_OPT1=m+10000000	-- ●双方把怪兽召唤·特殊召唤过5只以上
local F_OPT2=m+20000000	-- ●双方把效果发动过10次以上
local F_OPT3=m+30000000	-- ●双方回合的结束阶段
local F_CNTS=m+40000000	-- 召唤·特殊召唤次数
local F_CNTE=m+50000000	-- 效果发动次数
local F_MARK=m+60000000	-- ②用：狂三在场上期间送去墓地的卡
local EV_SAT=EVENT_CUSTOM+m	-- ①的条件满足（自定义事件）

function cm.initial_effect(c)
	-- 特殊仪式怪兽：任何卡的效果都能特殊召唤，因此不写苏生限制（不加 EnableReviveLimit）
	-- ①：自己·对方回合，把手卡的这张卡持续公开才能发动
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,EFFECT_COUNT_CODE_CHAIN)	-- 没写次数限制的效果，也要限同一连锁1次
	e1:SetRange(LOCATION_HAND)
	e1:SetCost(cm.pubcost)
	e1:SetTarget(cm.pubtg)
	e1:SetOperation(cm.pubop)
	c:RegisterEffect(e1)

	-- ①●1：计数（双方把怪兽召唤·特殊召唤）
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetRange(LOCATION_HAND)
	e2:SetOperation(cm.cntsumop)
	c:RegisterEffect(e2)
	local e2b=e2:Clone()
	e2b:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2b)

	-- ①●2：计数（双方把效果发动）
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_CHAINING)
	e3:SetRange(LOCATION_HAND)
	e3:SetOperation(cm.cnteffop)
	c:RegisterEffect(e3)

	-- ①条件满足：手卡的这张卡仪式召唤
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(m,1))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOHAND+CATEGORY_SEARCH)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EV_SAT)
	e4:SetRange(LOCATION_HAND)
	e4:SetTarget(cm.rittg)
	e4:SetOperation(cm.ritop)
	c:RegisterEffect(e4)

	-- ①●3：双方回合的结束阶段
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(m,3))
	e5:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOHAND+CATEGORY_SEARCH)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e5:SetCode(EVENT_PHASE+PHASE_END)
	e5:SetCountLimit(1)	-- 结束阶段的效果必须限次，否则会在结束阶段反复诱发
	e5:SetRange(LOCATION_HAND)
	e5:SetCondition(cm.endcon)
	e5:SetTarget(cm.rittg)
	e5:SetOperation(cm.ritop)
	c:RegisterEffect(e5)

	-- ②：1回合1次，双方墓地3张回到卡组，从卡组把1张记述卡加入手卡
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(m,5))
	e6:SetCategory(CATEGORY_TODECK+CATEGORY_TOHAND+CATEGORY_SEARCH)
	e6:SetType(EFFECT_TYPE_IGNITION)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCountLimit(1,m)
	e6:SetCost(cm.gycost)
	e6:SetTarget(cm.gytg)
	e6:SetOperation(cm.gyop)
	c:RegisterEffect(e6)

	-- ②用的标记：这张卡在场上存在期间送去墓地的卡
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e7:SetCode(EVENT_TO_GRAVE)
	e7:SetRange(LOCATION_MZONE)
	e7:SetOperation(cm.markop)
	c:RegisterEffect(e7)
end

-- ①的cost：把手卡的这张卡持续公开（照「蜃气楼」的写法：给未公开的卡打标记，再挂 EFFECT_PUBLIC）
function cm.pubcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		-- 已经公开的卡不能再付「持续公开」这个cost；已经在待机中的也不能再选第2项
		return not c:IsPublic()
			and c:GetFlagEffect(F_OPT1)+c:GetFlagEffect(F_OPT2)+c:GetFlagEffect(F_OPT3)==0
	end
	c:RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(m,6))
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_PUBLIC)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	c:RegisterEffect(e1)
end
-- ①的target
function cm.pubtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,tp,LOCATION_HAND)
end
-- ①的operation：选择待机的条件
function cm.pubop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or not c:IsLocation(LOCATION_HAND) then return end
	local op=Duel.SelectOption(tp,aux.Stringid(m,1),aux.Stringid(m,2),aux.Stringid(m,3))
	if op==0 then
		c:RegisterFlagEffect(F_OPT1,RESET_EVENT+RESETS_STANDARD,0,1)
	elseif op==1 then
		c:RegisterFlagEffect(F_OPT2,RESET_EVENT+RESETS_STANDARD,0,1)
	else
		c:RegisterFlagEffect(F_OPT3,RESET_EVENT+RESETS_STANDARD,0,1)
	end
end
-- ①●1：召唤·特殊召唤计数
function cm.cntsumop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:GetFlagEffect(F_OPT1)==0 then return end
	if Duel.GetFlagEffect(tp,F_CNTS)>=5 then return end
	Duel.RegisterFlagEffect(tp,F_CNTS,0,0,1)
	if Duel.GetFlagEffect(tp,F_CNTS)==5 then
		Duel.RaiseEvent(c,EV_SAT,nil,0,tp,tp,0)
	end
end
-- ①●2：效果发动计数
function cm.cnteffop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:GetFlagEffect(F_OPT2)==0 then return end
	if Duel.GetFlagEffect(tp,F_CNTE)>=10 then return end
	Duel.RegisterFlagEffect(tp,F_CNTE,0,0,1)
	if Duel.GetFlagEffect(tp,F_CNTE)==10 then
		Duel.RaiseEvent(c,EV_SAT,nil,0,tp,tp,0)
	end
end
-- ①●3的condition
function cm.endcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(F_OPT3)>0
end
-- ①仪式召唤的target
function cm.rittg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return c:IsLocation(LOCATION_HAND) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,tp,LOCATION_HAND)
end
-- ①仪式召唤的operation：仪式召唤，那之后可以检索通常陷阱
function cm.ritop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	c:ResetFlagEffect(F_OPT1)
	c:ResetFlagEffect(F_OPT2)
	c:ResetFlagEffect(F_OPT3)
	Duel.ResetFlagEffect(tp,F_CNTS)
	Duel.ResetFlagEffect(tp,F_CNTE)
	if not c:IsRelateToEffect(e) or not c:IsLocation(LOCATION_HAND) then return end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	if Duel.SpecialSummon(c,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)==0 then return end
	if Duel.IsExistingMatchingCard(cm.trapfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil)
		and Duel.SelectYesNo(tp,aux.Stringid(m,4)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,cm.trapfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
		if #g>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	end
end
-- 有「时崎狂三·时崎狂三」卡名记述的通常陷阱卡（只认通常陷阱，不认本家的通常魔法）
function cm.trapfilter(c)
	return aux.IsCodeListed(c,m) and c:GetType()==TYPE_TRAP
end
-- ②用：狂三在场上期间送去墓地的卡
-- 照「持续公开」的做法给卡挂 CLIENT_HINT，双方都能在墓地看到标记（=②可以回到卡组的卡）
function cm.markop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsFaceup() then return end
	for tc in aux.Next(eg) do
		-- 已经在墓地且已标记过的卡不重复挂，免得提示叠好几层
		if tc:IsLocation(LOCATION_GRAVE) and tc:GetFlagEffect(F_MARK)==0 then
			tc:RegisterFlagEffect(F_MARK,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(m,7))
		end
	end
end
function cm.markfilter(c)
	return c:GetFlagEffect(F_MARK)>0
end
-- ②的cost：双方墓地选3张标记过的卡回到卡组
function cm.gycost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(cm.markfilter,tp,LOCATION_GRAVE,LOCATION_GRAVE,3,nil)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,cm.markfilter,tp,LOCATION_GRAVE,LOCATION_GRAVE,3,3,nil)
	Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_COST)
end
-- ②的filter：记述这张卡、且不是通常陷阱的卡
function cm.addfilter(c)
	return aux.IsCodeListed(c,m) and not cm.trapfilter(c) and c:IsAbleToHand()
end
-- ②的target
function cm.gytg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.addfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
-- ②的operation：检索
function cm.gyop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,cm.addfilter,tp,LOCATION_DECK,0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
