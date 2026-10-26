-- 狙击手的领域
local cm,m,o=GetID()
Duel.LoadScript("c60013052.lua")

function cm.initial_effect(c)
	-- 作为场地魔法发动
	-- ①：发动时的效果处理，由对方从以下选1项适用
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(aux.Stringid(m,4))
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	e0:SetOperation(cm.actop)
	c:RegisterEffect(e0)

	-- ②：对方的怪兽从场上离开的场合
	-- 卡文（效果外）：「这个卡名的②的效果1回合最多使用2次」→ 用 m 记次
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,2))
	e1:SetCategory(CATEGORY_DRAW+CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_LEAVE_FIELD)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetRange(LOCATION_FZONE)
	e1:SetCountLimit(2,m)
	e1:SetCondition(cm.con2)
	e1:SetTarget(cm.tg2)
	e1:SetOperation(cm.op2)
	c:RegisterEffect(e1)
end

-- ①：4星以下的怪兽（可特殊召唤）
function cm.lv4fil(c,e,p)
	return c:IsType(TYPE_MONSTER) and c:IsLevelBelow(4) and c:IsCanBeSpecialSummoned(e,0,p,false,false)
end

-- ①：由「对方」选1项，所以选项用 Duel.SelectOption(1-tp,...) 让对方来选
function cm.actop(e,tp,eg,ep,ev,re,r,rp)
	local op=Duel.SelectOption(1-tp,aux.Stringid(m,0),aux.Stringid(m,1))
	-- ●对方从自己手卡把1只4星以下的怪兽特殊召唤，那之后对方抽1张
	-- ●我方翻开自己卡组最上面3张，从那之中或自己手卡选1只4星以下的怪兽特殊召唤，那之后自己抽1张
	cm.sumop(e,(op==0) and 1-tp or tp,(op==0))
end
-- p=特殊召唤·抽卡的人；fromhand=true 时只从手卡选
function cm.sumop(e,p,fromhand)
	local g
	if fromhand then
		g=Duel.GetMatchingGroup(cm.lv4fil,p,LOCATION_HAND,0,nil,e,p)
	else
		-- 先翻开，再取那些卡（顺序不能反，否则选择步骤会被跳过）
		Duel.ConfirmDecktop(p,3)
		local dg=Duel.GetDecktopGroup(p,3):Filter(cm.lv4fil,nil,e,p)
		local hg=Duel.GetMatchingGroup(cm.lv4fil,p,LOCATION_HAND,0,nil,e,p)
		g=dg:Merge(hg)
	end
	local function endop()
		if not fromhand then Duel.ShuffleDeck(p) end
	end
	if Duel.GetLocationCount(p,LOCATION_MZONE)<=0 or g:GetCount()==0 then
		endop()
		return
	end
	Duel.Hint(HINT_SELECTMSG,p,HINTMSG_SPSUMMON)
	local sg=g:Select(p,1,1,nil)
	if sg:GetCount()==0 then
		endop()
		return
	end
	local ct=Duel.SpecialSummon(sg,0,p,p,false,false,POS_FACEUP)
	endop()
	if ct==0 then return end
	-- 这个效果特殊召唤的怪兽效果无效化
	for tc in aux.Next(sg) do
		if tc:IsLocation(LOCATION_MZONE) then
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_DISABLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e1)
			local e2=e1:Clone()
			e2:SetCode(EFFECT_DISABLE_EFFECT)
			tc:RegisterEffect(e2)
		end
	end
	-- 那之后，自己抽1张
	Duel.Draw(p,1,REASON_EFFECT)
end

-- ②：对方场上的怪兽离开场上
function cm.lvfil(c,tp)
	return c:IsType(TYPE_MONSTER) and c:IsPreviousLocation(LOCATION_MZONE) and c:GetPreviousControler()==tp
end
function cm.con2(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(cm.lvfil,1,nil,1-tp)
end
function cm.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Lingguang.canlf(tp) end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,tp,LOCATION_SZONE)
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	-- 选自己场上1只灵光一闪衍生物
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.GetMatchingGroup(Lingguang.tokfilter,tp,LOCATION_SZONE,0,nil):Select(tp,1,1,nil)
	local tc=g:GetFirst()
	if not tc then return end
	local attr=tc:GetAttribute()
	if attr==ATTRIBUTE_FIRE then
		-- ●炎：自己抽1张，那之后可以把这个卡发动时的效果适用
		Duel.Draw(tp,1,REASON_EFFECT)
		if Duel.SelectYesNo(tp,aux.Stringid(m,3)) then
			cm.actop(e,tp,eg,ep,ev,re,r,rp)
		end
	else
		-- ●那以外：翻开自己卡组最上面3张，选1张有【灵光一闪】效果记述的卡加入手卡
		Duel.ConfirmDecktop(tp,3)
		local dg=Duel.GetDecktopGroup(tp,3)
		local sg=dg:Filter(cm.thfil,nil)
		if sg:GetCount()>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local pick=sg:Select(tp,1,1,nil)
			Duel.SendtoHand(pick,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,pick)
		end
		Duel.ShuffleDeck(tp)
	end
	-- 那之后，那衍生物破坏
	Duel.Destroy(tc,REASON_EFFECT)
end
-- 有【灵光一闪】效果记述的卡
function cm.thfil(c)
	return c.isChaosZeroNightmare and c:IsAbleToHand()
end
