--爱丽丝的旅行地图
local s,id,o=GetID()

local CODE_ALICE = 6100440

function s.initial_effect(c)
	-- 声明记述卡名
	aux.AddCodeList(c,CODE_ALICE)

	-- 魔法卡发动 (可选择弹回1张记述卡作为发动条件)
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	e0:SetCost(s.actcost)
	c:RegisterEffect(e0)

	-- ①：召唤 或 代替检索
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,1))
	e1:SetCategory(CATEGORY_SUMMON+CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCountLimit(1)
	e1:SetTarget(s.efftg)
	e1:SetOperation(s.effop)
	c:RegisterEffect(e1)

	-- ②：被回合玩家送墓的场合
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,3))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCondition(s.tgcon)
	e2:SetTarget(s.tgtg)
	e2:SetOperation(s.tgop)
	c:RegisterEffect(e2)
end

-- === 发动Cost ===
function s.actcostfilter(c,ec)
	return c:IsFaceup() and aux.IsCodeListed(c,CODE_ALICE) and c:IsAbleToHandAsCost() and c~=ec
end

function s.actcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=Duel.GetMatchingGroup(s.actcostfilter,tp,LOCATION_ONFIELD,0,nil,e:GetHandler())
	if #g>0 and Duel.GetFlagEffect(tp,id+1)==0 and Duel.SelectYesNo(tp,aux.Stringid(id,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
		local sg=g:Select(tp,1,1,nil)
		Duel.HintSelection(sg)
		Duel.SendtoHand(sg,nil,REASON_COST)
		Duel.RegisterFlagEffect(tp,id+1,RESET_PHASE+PHASE_END,0,1)
	end
end

-- === 效果① ===
function s.sumfilter(c)
	return c:IsRace(RACE_SPELLCASTER) and c:IsSummonable(true,nil)
end

function s.thfilter(c)
	return c:IsType(TYPE_MONSTER) and aux.IsCodeListed(c,CODE_ALICE) and c:IsAbleToHand()
end

function s.efftg(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=Duel.IsExistingMatchingCard(s.sumfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,nil)
	-- 自己场上没有怪兽存在，且该代用效果此回合尚未用过
	local b2=Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==0
		and Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK,0,1,nil)
		and Duel.GetFlagEffect(tp,id)==0 
		
	if chk==0 then return b1 or b2 end
	
	local op=0
	if b1 and b2 then
		op=Duel.SelectOption(tp,aux.Stringid(id,1),aux.Stringid(id,2))
	elseif b1 then
		op=0
		Duel.SelectOption(tp,aux.Stringid(id,1))
	else
		op=1
		Duel.SelectOption(tp,aux.Stringid(id,2))
	end
	e:SetLabel(op)
	
	if op==0 then
		e:SetCategory(CATEGORY_SUMMON)
		Duel.SetOperationInfo(0,CATEGORY_SUMMON,nil,1,0,0)
	else
		-- 记录代用检索使用标记
		Duel.RegisterFlagEffect(tp,id,RESET_PHASE+PHASE_END,0,1)
		e:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	end
end

function s.effop(e,tp,eg,ep,ev,re,r,rp)
	local op=e:GetLabel()
	if op==0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
		local g=Duel.SelectMatchingCard(tp,s.sumfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,1,nil)
		local tc=g:GetFirst()
		if tc then
			Duel.Summon(tp,tc,true,nil)
		end
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_DECK,0,1,1,nil)
		if #g>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	end
end

-- === 效果② ===
function s.tgcon(e,tp,eg,ep,ev,re,r,rp)
	-- 这张卡被回合玩家送去墓地 (此判断不进行视角翻转)
	return rp==Duel.GetTurnPlayer()
end

function s.pick_filter(c)
	return c:IsAbleToHand()
end

function s.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		-- 双方各自从卡组选3张卡名不同的卡。至少发动方能满足条件。
		local g=Duel.GetMatchingGroup(s.pick_filter,tp,LOCATION_DECK,0,nil)
		return g:GetClassCount(Card.GetCode)>=3
	end
end

function s.tgop(e,tp,eg,ep,ev,re,r,rp)
	-- 辅助函数：处理单个玩家的选卡和随机加入手卡动作
	local function pick_and_add(p)
		local g=Duel.GetMatchingGroup(s.pick_filter,p,LOCATION_DECK,0,nil)
		if g:GetClassCount(Card.GetCode)>=3 then
			local sg=Group.CreateGroup()
			while #sg < 3 do
				Duel.Hint(HINT_SELECTMSG,p,HINTMSG_CONFIRM)
				-- 从卡组中过滤出与已选卡片卡名都不同的卡
				local cg=g:Filter(function(c) return not sg:IsExists(Card.IsCode,1,nil,c:GetCode()) end, nil)
				local tc=cg:Select(p,1,1,nil):GetFirst()
				if not tc then break end
				sg:AddCard(tc)
			end
			
			if #sg==3 then
				Duel.ConfirmCards(1-p,sg)
				-- 随机选那之内的1张加入自身手卡
				local tg=sg:RandomSelect(p,1)
				if #tg>0 then
					Duel.SendtoHand(tg,nil,REASON_EFFECT)
					Duel.ConfirmCards(1-p,tg)
				end
			end
		end
	end
	
	-- 双方依次处理 (因为未涉及交互或回合玩家干涉，所以先后无影响)
	pick_and_add(tp)
	pick_and_add(1-tp)
	
	-- 分别洗切双方卡组
	Duel.ShuffleDeck(tp)
	Duel.ShuffleDeck(1-tp)
end