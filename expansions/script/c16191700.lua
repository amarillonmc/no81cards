-- 光·暗属性4星魔法师族怪兽×2
local s,id=GetID()
function s.initial_effect(c)
	-- 超量召唤手续
	aux.AddXyzProcedure(c,s.matfilter,4,2)
	c:EnableReviveLimit()

	-- ①：检索光·暗属性特定数值魔法师族，那之后可以立刻召唤1只魔法师族
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,id)
	e1:SetCost(s.cost)
	e1:SetTarget(s.thtg)
	e1:SetOperation(s.thop)
	c:RegisterEffect(e1)

	-- ②：双方结束阶段，展示并随机挑选盖放
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,id+1)
	e2:SetCost(s.cost)
	e2:SetTarget(s.settg)
	e2:SetOperation(s.setop)
	c:RegisterEffect(e2)
end

-- 超量素材过滤：光·暗属性 的 魔法师族
function s.matfilter(c,xyz,sumtype,tp)
	return c:IsRace(RACE_SPELLCASTER) 
		and (c:IsAttribute(ATTRIBUTE_LIGHT) or c:IsAttribute(ATTRIBUTE_DARK))
end

-- 拔除素材Cost（共用）
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end

-------------------------------------------------------------------------
-- 【①效果：检索并立刻召唤】
-------------------------------------------------------------------------
function s.thfilter(c)
	return c:IsLevel(4) and c:IsRace(RACE_SPELLCASTER)
		and (c:IsAttribute(ATTRIBUTE_LIGHT) or c:IsAttribute(ATTRIBUTE_DARK))
		and c:IsAttack(1500) and c:IsDefense(2000) and c:IsAbleToHand()
end
-- 立刻召唤的判定过滤（必须是魔法师族，且符合常规召唤条件）
function s.sumfilter(c)
	return c:IsRace(RACE_SPELLCASTER) and c:IsSummonable(true,nil)
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	-- 注意：因为召唤是“可以”发动的选发效果，所以在 Target 阶段不强制要求手卡必定有能召唤的怪兽
	Duel.SetOperationInfo(0,CATEGORY_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_MZONE)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
		
		-- 判断“那之后”是否可以进行召唤
		local sg=Duel.GetMatchingGroup(s.sumfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,nil)
		-- 使用 aux.Stringid(id,2) 作为提示语（例如："是否召唤1只魔法师族怪兽？"）
		if sg:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(id,2)) then
			Duel.BreakEffect() -- 插入“那之后”的时点分割
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
			local sc=sg:Select(tp,1,1,nil):GetFirst()
			if sc then
				-- 第三个参数填 true，代表这次召唤不占用每回合1次的通常召唤规则次数
				Duel.Summon(tp,sc,true,nil)
			end
		end
	end
end

-------------------------------------------------------------------------
-- 【②效果：从牌库/手卡/墓地展示并随机盖放】
-------------------------------------------------------------------------
function s.setfilter(c)
	return (c:IsType(TYPE_SPELL) and c:IsType(TYPE_QUICKPLAY)) 
		or (c:GetType()==TYPE_TRAP)
end
function s.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(s.setfilter,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,nil)
	if chk==0 then 
		return Duel.GetLocationCount(tp,LOCATION_SZONE)>0 
			and g:GetClassCount(Card.GetCode)>=6 
	end
end
function s.setop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(s.setfilter,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,nil)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 or g:GetClassCount(Card.GetCode)<6 then return end
	
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local cg=g:SelectSubGroup(tp,aux.dncheck,false,6,6)
	if not cg or cg:GetCount()<6 then return end
	
	Duel.ConfirmCards(1-tp,cg)
	local rg=cg:RandomSelect(1-tp,2)
	
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local sg=rg:Select(tp,1,1,nil)
	local tc=sg:GetFirst()
	if tc and Duel.SSet(tp,tc)>0 then
		rg:RemoveCard(tc)
		Duel.SendtoDeck(rg,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
	end
end