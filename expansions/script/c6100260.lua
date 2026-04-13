--朦雨的闪断·黎
local s,id,o=GetID()
function s.initial_effect(c)
	--连接召唤
	aux.AddLinkProcedure(c,nil,3,99,s.lcheck)
	c:EnableReviveLimit()

	--②：连接状态的自己的水属性怪兽的攻击宣言时必发（不入连锁连续效果）
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_ATTACK_ANNOUNCE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(s.atkcon)
	e2:SetOperation(s.atkop)
	c:RegisterEffect(e2)

	--③：解放移动、加攻连击与遗言回收
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,1))
	e3:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCost(s.effcost)
	e3:SetTarget(s.efftg)
	e3:SetOperation(s.effop)
	c:RegisterEffect(e3)

	-- 累加追加的攻击次数（根据 FlagEffect 的层数决定）
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_EXTRA_ATTACK)
	e4:SetCondition(function(e) return e:GetHandler():GetFlagEffect(id+1)>0 end)
	e4:SetValue(function(e) return e:GetHandler():GetFlagEffect(id+1) end)
	c:RegisterEffect(e4)

end

-- === 连接条件验证 ===
function s.lfilter(c)
	return c:IsLinkType(TYPE_LINK) and c:IsLinkSetCard(0x613)
end
function s.lcheck(g)
	return g:IsExists(s.lfilter,1,nil)
end

function s.llkfilter(c)
	return c:IsLinkState()
end

-- === 效果②：攻击宣言规则弹卡 ===
function s.atkcon(e,tp,eg,ep,ev,re,r,rp)
	local at=Duel.GetAttacker()
	return at and at:IsControler(tp) and at:IsAttribute(ATTRIBUTE_WATER) and at:IsLinkState()
end

function s.atkop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsAbleToDeck,1-tp,LOCATION_MZONE,0,nil)
	if #g>0 then
		Duel.Hint(HINT_CARD,0,id)
		Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_TODECK)
		local sg=g:Select(1-tp,1,1,nil)
		-- 迫使对方执行规则洗牌
		Duel.SendtoDeck(sg,nil,SEQ_DECKSHUFFLE,REASON_RULE)
	end
end

-- === 效果③：起动移动、强化与遗言回收 ===
function s.costfilter(c,mac,tp)
	-- 必须是那之内的怪兽，不能解放此卡自己，是连接状态，且必须在自己场上能被解放
	if c==mac then return false end
	if not c:IsControler(tp) or not c:IsAbleToDeckOrExtraAsCost() or not c:IsLinkState() then return false end
	return true
end

function s.effcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(s.costfilter,tp,LOCATION_MZONE,0,1,c,c,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,s.costfilter,tp,LOCATION_MZONE,0,1,1,c,c,tp)
	local tc=g:GetFirst()
	local seq=tc:GetSequence()
	
	-- 判断这张卡移动前是否在额外怪兽区域（5或6）
	if c:GetSequence()>=5 then
		e:SetLabel(1)
	else
		e:SetLabel(0)
	end
	
	-- 解放怪兽并进行移动
	if Duel.SendtoDeck(tc,nil,SEQ_DECKSHUFFLE,REASON_COST)>0 then
		Duel.MoveSequence(c,seq)
	end
end

function s.efftg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
end

function s.spfilter(c,e,tp)
	return c:IsSetCard(0x613) and c:IsType(TYPE_LINK) and c:IsLinkBelow(4) 
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end

function s.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return bit.band(sumtype,SUMMON_TYPE_LINK)==SUMMON_TYPE_LINK and not (c:IsSetCard(0x613) and c:IsType(TYPE_LINK))
end

function s.effop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not (c:IsRelateToEffect(e) and c:IsFaceup()) then return end
	
	-- ①.上升1000点攻击力 (直到回合结束)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(1000)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	c:RegisterEffect(e1)
	
	-- ②.加上1次可以直接攻击 (累加)
	c:RegisterFlagEffect(id+1,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
	
	-- ③.额外卡组特殊召唤判断
	if e:GetLabel()==1 then
		-- HOPT判断：1回合只有1次
		if Duel.GetFlagEffect(tp,id)==0 
			and Duel.GetLocationCountFromEx(tp,tp,nil,TYPE_LINK)>0 
			and Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp) 
			and Duel.SelectYesNo(tp,aux.Stringid(id,2)) then
			
			Duel.BreakEffect()
			Duel.RegisterFlagEffect(tp,id,RESET_PHASE+PHASE_END,0,1)
			
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local sg=Duel.SelectMatchingCard(tp,s.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
			if #sg>0 then
				-- 0x60 表示强制特殊召唤进额外怪兽区域
				Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP,0x60)
			end
			
			-- 挂上本回合连接召唤的自肃
			local e3=Effect.CreateEffect(c)
			e3:SetType(EFFECT_TYPE_FIELD)
			e3:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
			e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT)
			e3:SetDescription(aux.Stringid(id,3))
			e3:SetTargetRange(1,0)
			e3:SetTarget(s.splimit)
			e3:SetReset(RESET_PHASE+PHASE_END)
			Duel.RegisterEffect(e3,tp)
		end
	end
end