--神秘学司书 魅
local s,id,o=GetID()
function s.initial_effect(c)
	-- 1. 融合素材与接触融合手续
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,s.ffilter,2,false)
	
	local e1 = aux.AddContactFusionProcedure(c,s.cffilter,LOCATION_MZONE,0,Duel.Release,REASON_COST)
	-- 包装接触融合的 Condition，追加“不在对方抽卡的回合不能进行”的限制
	local old_con = e1:GetCondition()
	e1:SetCondition(function(e, c)
		if c == nil then return true end
		if Duel.GetFlagEffect(1 - c:GetControler(), id) == 0 then return false end
		return old_con(e, c)
	end)

	-- 2. 特殊召唤条件限制（只能使用上述接触融合手续从额外特召）
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	e0:SetValue(aux.fuslimit)
	c:RegisterEffect(e0)

	-- 3. 全局监听：记录对方是否抽卡
	if not s.global_check then
		s.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_DRAW)
		ge1:SetOperation(s.drcheck)
		Duel.RegisterEffect(ge1,0)
	end

	-- ①：检索持有仪式效果的恶魔族怪兽
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_HANDES)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,id)
	e2:SetTarget(s.thtg)
	e2:SetOperation(s.thop)
	c:RegisterEffect(e2)

	-- ②：解放特殊召唤的怪兽
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,1))
	e3:SetCategory(CATEGORY_TODECK+CATEGORY_RELEASE)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_CHAINING)
	e3:SetRange(LOCATION_MZONE+LOCATION_GRAVE+LOCATION_REMOVED)
	e3:SetCountLimit(1,id+1)
	e3:SetCondition(s.rlcon)
	e3:SetTarget(s.rltg)
	e3:SetOperation(s.rlop)
	c:RegisterEffect(e3)
end

-- === 融合相关 ===
function s.ffilter(c,fc,sub,mg,sg)
	return c:IsRace(RACE_FIEND) and (not sg or not sg:IsExists(Card.IsFusionCode, 1, c, c:GetFusionCode()))
end
function s.cffilter(c,fc)
	return c:IsReleasable() and c:IsControler(fc:GetControler())
end

-- === 抽卡监听 ===
function s.drcheck(e,tp,eg,ep,ev,re,r,rp)
	-- 规避对局开始时的初始抽卡
	if Duel.GetTurnCount() == 0 or Duel.GetCurrentPhase() == 0 then return end
	Duel.RegisterFlagEffect(ep, id, RESET_PHASE+PHASE_END, 0, 1)
end

-- === 效果①：检索并丢弃 ===
function s.thfilter(c)
	-- 【极其干净的检索判定】：直接判定种族、可否加入手卡，以及您配置好的内置字段
	return c:IsRace(RACE_FIEND) and c:IsAbleToHand() and c.CATEGORY_RITUAL_SUMMON
end

function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
	Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,0,tp,1)
end

function s.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g = Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.thfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	if #g > 0 and Duel.SendtoHand(g,nil,REASON_EFFECT) > 0 then
		Duel.ConfirmCards(1-tp,g)
		Duel.ShuffleHand(tp)
		Duel.BreakEffect()
		Duel.DiscardHand(tp,nil,1,1,REASON_EFFECT+REASON_DISCARD)
	end
end

-- === 效果②：在仪式与连锁定中发动，解放对方特召的怪兽 ===
function s.rit_filter(c)
	return c:IsType(TYPE_RITUAL) and c:IsType(TYPE_MONSTER) and (c:IsFaceup() or c:IsLocation(LOCATION_GRAVE))
end

function s.rlcon(e,tp,eg,ep,ev,re,r,rp)
	-- 仪式怪兽在自己的场上·墓地存在
	if not Duel.IsExistingMatchingCard(s.rit_filter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,1,nil) then return false end
	-- 特殊召唤的怪兽把效果发动时
	local loc=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION)
	if loc~=LOCATION_MZONE then return false end
	local rc=re:GetHandler()
	return rc:IsSummonType(SUMMON_TYPE_SPECIAL) and re:IsActiveType(TYPE_MONSTER)
end

function s.tdfilter(c)
	return c:IsRace(RACE_FIEND) and c:IsType(TYPE_MONSTER) and c:IsAbleToDeck() and (c:IsFaceup() or c:IsLocation(LOCATION_GRAVE) or c:IsLocation(LOCATION_REMOVED))
end

function s.rltg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return c:IsAbleToDeck() 
			and Duel.IsExistingMatchingCard(s.tdfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,2,c)
			and re:GetHandler():IsRelateToEffect(re) and re:GetHandler():IsReleasableByEffect()
	end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,3,tp,LOCATION_GRAVE+LOCATION_REMOVED+LOCATION_MZONE)
	Duel.SetOperationInfo(0,CATEGORY_RELEASE,eg,1,0,0)
end

function s.rlop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	-- 包含这张卡的自己的墓地·除外状态的3只恶魔族怪兽回到卡组
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.tdfilter),tp,LOCATION_GRAVE+LOCATION_REMOVED,0,2,2,c)
	if #g==2 then
		g:AddCard(c)
		if Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_EFFECT) > 0 then
			local og=Duel.GetOperatedGroup()
			if og:IsExists(Card.IsLocation,1,nil,LOCATION_DECK+LOCATION_EXTRA) then
				local rc=re:GetHandler()
				-- 那只怪兽解放
				if rc:IsRelateToEffect(re) then
					Duel.Release(rc,REASON_EFFECT)
				end
			end
		end
	end
end