-- 旋风斩
local s,id=GetID()

function s.initial_effect(c)
	-- 添加卡名记述
	aux.AddCodeList(c,23410101)
	
	-- ① 主要效果
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_POSITION)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,id+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(s.postg)
	e1:SetOperation(s.posop)
	c:RegisterEffect(e1)
	
	-- ② 墓地回收效果
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCountLimit(1,id+10000000)
	e2:SetCondition(s.setcon)
	e2:SetTarget(s.settg)
	e2:SetOperation(s.setop)
	c:RegisterEffect(e2)
end

-- ① 目标选择
function s.postg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(Card.IsCanTurnSet,tp,0,LOCATION_MZONE,1,nil)
	end
	Duel.SetOperationInfo(0,CATEGORY_POSITION,nil,1,1-tp,LOCATION_MZONE)
end

-- ① 效果处理
function s.posop(e,tp,eg,ep,ev,re,r,rp)
	-- 基本效果
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_POSCHANGE)
	local g=Duel.SelectMatchingCard(tp,Card.IsCanTurnSet,tp,0,LOCATION_MZONE,1,1,nil)
	if #g>0 and Duel.ChangePosition(g,POS_FACEDOWN_DEFENSE)>0 then
		-- 盖放发动的追加效果
		local c=e:GetHandler()
		if not e:GetHandler():IsStatus(STATUS_ACT_FROM_HAND) then
			local op=Duel.SelectOption(tp,aux.Stringid(id,2),aux.Stringid(id,3))
			if op==0 then
				-- 丢弃并翻转其他怪兽
				local dg=Duel.SelectMatchingCard(tp,s.disfilter,tp,LOCATION_HAND,0,1,1,nil)
				if #dg>0 and Duel.SendtoGrave(dg,REASON_EFFECT+REASON_DISCARD)>0 then
					local tg=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
					Duel.ChangePosition(tg,POS_FACEDOWN_DEFENSE)
				end
			else
				-- 盖放魔法陷阱
				local sg=Duel.SelectMatchingCard(tp,s.setfilter,tp,LOCATION_HAND,0,1,1,nil)
				if #sg>0 then
					local tc=sg:GetFirst()
					if Duel.SSet(tp,tc) then
						local e1=Effect.CreateEffect(c)
						e1:SetType(EFFECT_TYPE_SINGLE)
						e1:SetCode(EFFECT_QP_ACT_IN_SET_TURN)
						e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
						e1:SetReset(RESET_EVENT+RESETS_STANDARD)
						tc:RegisterEffect(e1)
					end
				end
			end
		end
	end
end

-- ② 条件判断
function s.setcon(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end
-- ② 目标设置
function s.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0 end
end
-- ② 效果处理
function s.setop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SSet(tp,c) then
		if Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_ONFIELD,0,1,nil,23410101)
			and Duel.IsPlayerCanDraw(tp,1) then
			Duel.Draw(tp,1,REASON_EFFECT)
		end
	end
end

-- 过滤器
function s.disfilter(c)
	return aux.IsCodeListed(c,23410101) and c:IsDiscardable()
end
function s.setfilter(c)
	return aux.IsCodeListed(c,23410101) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSSetable()
end