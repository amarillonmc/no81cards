--源于黑影 反应
local s,id,o=GetID()
function s.initial_effect(c)
	-- 对方怪兽合计ATK≥自己LP时，对方回合从手卡发动
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(aux.Stringid(id,0))
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_QP_ACT_IN_NTPHAND)
	e0:SetCondition(s.qpcon)
	c:RegisterEffect(e0)

	-- ① 发动
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(s.maintg)
	e1:SetOperation(s.mainop)
	c:RegisterEffect(e1)

	-- ② 墓地：本家让自己LP脱离0的场合，除外自身，盖放墓地·除外的本家魔法
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_SSET)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_CUSTOM+65820000)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,id)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(s.settg2)
	e2:SetOperation(s.setop2)
	c:RegisterEffect(e2)
end

s.effect_lixiaoguo=true

-- 对方回合从手卡发动的条件
function s.qpcon(e)
	local tp=e:GetHandlerPlayer()
	local atk_sum=Duel.GetMatchingGroup(Card.IsFaceup,1-tp,LOCATION_MZONE,0,nil):GetSum(Card.GetAttack)
	return atk_sum>=Duel.GetLP(tp)
end

-- 消耗 1 次「源于黑影 ○效果」使用次数
function s.consume_use_counter(e,tp)
	for i=0,10 do
		Duel.ResetFlagEffect(tp,EFFECT_FLAG_EFFECT+65820000+i)
	end
	local count=math.max(Duel.GetFlagEffect(tp,65820099)-1,0)
	Duel.ResetFlagEffect(tp,65820099)
	for i=1,count do
		Duel.RegisterFlagEffect(tp,65820099,0,0,1)
	end
	local te=Effect.CreateEffect(e:GetHandler())
	te:SetDescription(aux.Stringid(65820000,count))
	te:SetType(EFFECT_TYPE_FIELD)
	te:SetCode(EFFECT_FLAG_EFFECT+65820000+count)
	te:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT)
	te:SetTargetRange(1,0)
	Duel.RegisterEffect(te,tp)
end

-- 分支A 检索 filter：本家魔法（不含自身），可加入手卡
function s.thfilter1(c)
	return c:IsSetCard(0x3a32) and c:IsType(TYPE_SPELL) and c:IsAbleToHand() and not c:IsCode(id)
end

-- ① target
function s.maintg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local has_use=Duel.GetFlagEffect(tp,65820099)>0
	local is_flipped=c:GetFlagEffect(65820010)>0
	if (has_use and not is_flipped) or (not has_use and is_flipped) then
		-- 分支A：从卡组检索本家魔法加入手卡
		if chk==0 then
			return Duel.IsExistingMatchingCard(s.thfilter1,tp,LOCATION_DECK,0,1,nil)
		end
		if has_use then s.consume_use_counter(e,tp) end
		e:SetLabel(1)
		e:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	else
		-- 分支B（○代替效果）：翻3张，选1张魔陷加入手卡，剩下回卡组
		if chk==0 then
			return Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>=3
		end
		if has_use then s.consume_use_counter(e,tp) end
		e:SetLabel(2)
		e:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	end
end

-- ① operation
function s.mainop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if e:GetLabel()==1 then
		-- 分支A：检索1张本家魔法加入手卡，持续公开 + 速攻赋予对方回合从手卡发动能力
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,s.thfilter1,tp,LOCATION_DECK,0,1,1,nil)
		if #g==0 then return end
		local tc=g:GetFirst()
		if Duel.SendtoHand(g,nil,REASON_EFFECT)==0 then return end
		Duel.ConfirmCards(1-tp,g)
		-- 持续公开到回合结束
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_PUBLIC)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		-- 速攻魔法：对方回合也能从手卡发动
		if tc:IsType(TYPE_QUICKPLAY) then
			local e2=Effect.CreateEffect(c)
			e2:SetDescription(aux.Stringid(id,0))
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_QP_ACT_IN_NTPHAND)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e2)
		end
	else
		-- 分支B：翻3张，可以选其中1张魔法·陷阱卡加入手卡，剩下的卡回到卡组
		local ct=math.min(3,Duel.GetFieldGroupCount(tp,LOCATION_DECK,0))
		if ct==0 then return end
		Duel.ConfirmDecktop(tp,ct)
		local g=Duel.GetDecktopGroup(tp,ct)
		local sg=g:Filter(Card.IsType,nil,TYPE_SPELL+TYPE_TRAP)
		if #sg>0 and Duel.SelectYesNo(tp,aux.Stringid(id,2)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local tg=sg:Select(tp,1,1,nil)
			if #tg>0 then
				Duel.SendtoHand(tg,nil,REASON_EFFECT)
				Duel.ConfirmCards(1-tp,tg)
			end
		end
		Duel.ShuffleDeck(tp)
	end
end

-- ② filter：本家魔法，可盖放
function s.setfilter2(c)
	return c:IsSetCard(0x3a32) and c:IsType(TYPE_SPELL) and c:IsSSetable()
end

-- ② 卡名不同检测
function s.dncheck(g)
	return g:GetClassCount(Card.GetOriginalCode)==#g
end

-- ② target
function s.settg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return false end
		return Duel.IsExistingMatchingCard(s.setfilter2,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil)
	end
	Duel.SetOperationInfo(0,CATEGORY_SSET,nil,1,tp,LOCATION_GRAVE+LOCATION_REMOVED)
end

-- ② operation：从墓地·除外选最多2张卡名不同的本家魔法盖放
function s.setop2(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetLocationCount(tp,LOCATION_SZONE)
	if ft<=0 then return end
	if ft>2 then ft=2 end
	local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(s.setfilter2),tp,LOCATION_GRAVE+LOCATION_REMOVED,0,nil)
	if #g==0 then return end
	local maxn=math.min(ft,#g)
	if maxn<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local sg=g:SelectSubGroup(tp,s.dncheck,true,1,maxn)
	if sg and #sg>0 then
		Duel.SSet(tp,sg)
	end
end