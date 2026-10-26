-- 凯尔肯的使徒
local cm,m,o=GetID()
Duel.LoadScript("c60013052.lua")

function cm.initial_effect(c)
	-- 卡名记述：「凶兆的使徒 罗丝薇瑟」
	aux.AddCodeList(c,60013050)

	-- 作为场地魔法发动
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(aux.Stringid(m,0))
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	e0:SetCountLimit(1,EFFECT_COUNT_CODE_CHAIN)	-- 同一连锁1次
	e0:SetOperation(cm.actop)
	c:RegisterEffect(e0)

	-- ②：自己有「罗丝薇瑟」卡名记述的魔陷适用【灵光一闪】的场合
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,1))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(Lingguang.EV)
	e1:SetProperty(EFFECT_FLAG_DELAY)	-- 场合类：等那个连锁处理完再另开连锁
	e1:SetRange(LOCATION_FZONE)
	e1:SetCountLimit(3,m)	-- 这个卡名的②1回合最多3次
	e1:SetCondition(cm.f2con)
	e1:SetTarget(cm.f2tg)
	e1:SetOperation(cm.f2op)
	c:RegisterEffect(e1)
end

-- 「神之灵光一闪 凯尔肯」（按「灵光一闪衍生物」标签检索，不按卡名/卡号）
function cm.kfilter(c)
	return Lingguang.kelkenfilter(c)
end
-- ①：作为发动时的效果处理，从卡组·墓地放置「凯尔肯」
function cm.actop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	if not Duel.IsExistingMatchingCard(cm.kfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local g=Duel.SelectMatchingCard(tp,cm.kfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	local tc=g:GetFirst()
	if not tc then return end
	local fd=tc:IsLocation(LOCATION_DECK)
	Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	Duel.ShuffleDeck(tp)
end

-- ②
function cm.f2con(e,tp,eg,ep,ev,re,r,rp)
	return rp==tp and eg:IsExists(Lingguang.isrose,1,nil)
end
function cm.f2tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>=3 end
end
-- 有【灵光一闪】效果记述的卡
function cm.thfil(c)
	return c.isChaosZeroNightmare and c:IsAbleToHand()
end
-- 有「罗丝薇瑟」卡名记述的卡
function cm.rosefil(c)
	return aux.IsCodeListed(c,60013050)
end
function cm.f2op(e,tp,eg,ep,ev,re,r,rp)
	-- 先翻开卡组顶，再取那3张（顺序反了会拿不到「已确认」的卡，选择步骤会被跳过）
	Duel.ConfirmDecktop(tp,3)
	local g=Duel.GetDecktopGroup(tp,3)
	if g:GetCount()==0 then return end
	local sg=g:Filter(cm.thfil,nil)
	local pick=nil
	if sg:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		pick=sg:Select(tp,1,1,nil):GetFirst()
	end
	if pick then
		local can_set=cm.rosefil(pick)
			and (pick:IsType(TYPE_QUICKPLAY) or pick:IsType(TYPE_TRAP))
			and Duel.GetLocationCount(tp,LOCATION_SZONE)>0
			and Duel.SelectYesNo(tp,aux.Stringid(m,2))
		if can_set then
			Duel.SSet(tp,Group.FromCards(pick))
			local code=nil
			if pick:IsType(TYPE_QUICKPLAY) then
				code=EFFECT_QP_ACT_IN_SET_TURN
			else
				code=EFFECT_TRAP_ACT_IN_SET_TURN
			end
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(code)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			pick:RegisterEffect(e1)
		else
			Duel.SendtoHand(Group.FromCards(pick),nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,Group.FromCards(pick))
			Lingguang.pub(pick,e,aux.Stringid(m,3))
		end
	end
	-- 剩下的卡回到卡组
	local rg=g:Filter(function(tc) return tc~=pick end,nil)
	if rg:GetCount()>0 then Duel.SendtoDeck(rg,nil,SEQ_DECKSHUFFLE,REASON_EFFECT) end
end
