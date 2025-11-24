--幻叙指引
local s,id,o=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end
function s.filter(c)
	return c:IsSetCard(0x838) and c:IsType(TYPE_MONSTER)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return true end 
	local codes={}
	while true do
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CODE)
		local ac = 0 
		getmetatable(c).announce_filter={0x838,OPCODE_ISSETCARD,TYPE_MONSTER,OPCODE_ISTYPE,OPCODE_AND,code,OPCODE_ISCODE,OPCODE_NOT,OPCODE_AND,TYPE_FUSION+TYPE_SYNCHRO+TYPE_XYZ+TYPE_LINK,OPCODE_ISTYPE,OPCODE_NOT}
		local ac=Duel.AnnounceCard(tp,table.unpack(getmetatable(c).announce_filter))		
		table.insert(codes,ac)
		if not Duel.SelectYesNo(tp,aux.Stringid(id, 0)) then
			break
		end
	end
	
	-- 将宣言的卡名列表和数量存入Label
	-- 结构：[1]=数量, [2...n]=卡名
	e:SetLabel(#codes, table.unpack(codes))
	Duel.SetTargetParam(#codes) -- 提示一下数量
end

function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local labs={e:GetLabel()}
	local count=labs[1]
	
	if count and count > 0 then
		local c=e:GetHandler()
		-- 注册延时效果
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
		e1:SetCountLimit(1)
		e1:SetLabel(0,table.unpack(labs))
		e1:SetCondition(s.spcon)
		e1:SetOperation(s.spop)
		e1:SetReset(RESET_PHASE+PHASE_STANDBY,count)
		Duel.RegisterEffect(e1,tp)
		Duel.Hint(HINT_SELECTMSG, tp, aux.Stringid(id, 2)) -- 提示玩家正在等待时序
	end
end

function s.spcon(e,tp,eg,ep,ev,re,r,rp)
	-- 任何玩家的准备阶段都计数
	return true
end

function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local labs={e:GetLabel()}
	local current_ct = labs[1] + 1
	local target_ct = labs[2]
	local codes = {}
	for i=3, #labs do
		table.insert(codes, labs[i])
	end
	
	if current_ct < target_ct then
		e:SetLabel(current_ct, target_ct, table.unpack(codes))
		c=e:GetOwner()
		if c then
			Duel.Hint(HINT_CARD,0,id)
		end
	else
		Duel.Hint(HINT_CARD,0,id)
		local g_to_summon = Group.CreateGroup()
		local ft = Duel.GetLocationCount(tp,LOCATION_MZONE) 
		if ft > 0 then
			for _, code in ipairs(codes) do
				if ft <= 0 then break end
				local tc = Duel.GetFirstMatchingCard(function(c) return c:IsCode(code) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end, tp, LOCATION_DECK, 0, nil)
				if tc then
					Duel.SpecialSummonStep(tc, 0, tp, tp, false, false, POS_FACEUP)
					g_to_summon:AddCard(tc)
					ft = ft - 1
				end
			end
			Duel.SpecialSummonComplete()
		end
		local mg = Duel.GetFieldGroup(tp,LOCATION_MZONE,0)
		local extra_g = Duel.GetMatchingGroup(Card.IsLinkSummonable, tp, LOCATION_EXTRA, 0, nil, nil, mg)
		if #extra_g > 0 and Duel.SelectYesNo(tp,aux.Stringid(id, 3)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_SPSUMMON)
			local sg = extra_g:Select(tp, 1, 1, nil)
			if #sg > 0 then
				Duel.LinkSummon(tp,sg:GetFirst(), nil, mg)
			end
		end
		e:Reset()
	end
end
