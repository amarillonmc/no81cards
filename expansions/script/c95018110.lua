-- 场地魔法卡：炽魂领域
local s, id = GetID()

-- 定义炽魂字段常量
s.soul_setcode = 0xa96c

-- 卡名常量
s.block_name = 95018060
s.impact_name = 95018080
s.escape_name = 95018070

function s.initial_effect(c)
	c:EnableCounterPermit(s.soul_setcode)
	
	-- 效果①：发动时放置2个炽魂指示物
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_COUNTER)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetOperation(s.activate_op)
	c:RegisterEffect(e1)
	
	-- 效果②：去除2个指示物检索
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCountLimit(1,id+1) -- 效果②一回合一次
	e2:SetCost(s.thcost)
	e2:SetTarget(s.thtg)
	e2:SetOperation(s.thop)
	c:RegisterEffect(e2)
	
	-- 效果③：炽魂怪兽连接召唤时触发
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,2))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DESTROY+CATEGORY_DRAW+CATEGORY_DECKDES)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetRange(LOCATION_FZONE)
	e3:SetCountLimit(1,id+2) -- 效果③一回合一次
	e3:SetCondition(s.lkcon)
	e3:SetTarget(s.lktg)
	e3:SetOperation(s.lkop)
	c:RegisterEffect(e3)
end

-- 效果①：发动时操作
function s.activate_op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		c:AddCounter(s.soul_setcode,2)
	end
end

-- 效果②：去除2个指示物作为代价
function s.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsCanRemoveCounter(tp,1,0,s.soul_setcode,2,REASON_COST) end
	Duel.RemoveCounter(tp,1,0,s.soul_setcode,2,REASON_COST)
end

-- 效果②：检索目标设定
function s.thfilter(c)
	return c:IsSetCard(s.soul_setcode) and c:IsAbleToHand() and c:IsType(TYPE_MONSTER)
end

function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end

function s.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end

-- 效果③：连接召唤条件
function s.lkcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(s.lkfilter,1,nil)
end

function s.lkfilter(c)
	return c:IsSetCard(s.soul_setcode) and c:IsType(TYPE_LINK) and c:IsSummonType(SUMMON_TYPE_LINK) and  (c:IsAttribute(ATTRIBUTE_DARK) or c:IsAttribute(ATTRIBUTE_LIGHT))
end

-- 效果③：目标设定
function s.lktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	
	local g=eg:Filter(s.lkfilter,nil)
	if #g>0 then
		-- 根据连接怪兽的属性设置不同的操作信息
		for tc in aux.Next(g) do
			local attr=tc:GetAttribute()
			local name=tc:GetCode()
			
			if attr==ATTRIBUTE_DARK and (name==s.block_name or string.find(name,s.block_name)) then
				Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
			elseif attr==ATTRIBUTE_LIGHT and (name==s.impact_name or string.find(name,s.impact_name)) then
				local dg=Duel.GetMatchingGroup(nil,tp,0,LOCATION_ONFIELD,nil)
				Duel.SetOperationInfo(0,CATEGORY_DESTROY,dg,1,0,0)
			elseif attr==ATTRIBUTE_DARK and (name==s.escape_name or string.find(name,s.escape_name)) then
				Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,1,tp,0)
			elseif attr==ATTRIBUTE_LIGHT and (name==s.escape_name or string.find(name,s.escape_name)) then
				Duel.SetOperationInfo(0,CATEGORY_DECKDES,nil,0,tp,2)
			end
		end
	end
end

-- 效果③：操作处理
function s.lkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=eg:Filter(s.lkfilter,nil)
	
	if #g>0 then
		-- 只处理第一只符合条件的连接怪兽
		local lc=g:GetFirst()
		local attr=lc:GetAttribute()
		local name=lc:GetCode()
		-- 暗属性「炽魂之格挡」：从墓地把1只炽魂怪兽守备表示特殊召唤
		if attr==ATTRIBUTE_DARK and (name==s.block_name or string.find(name,s.block_name)) then
			local g2=Duel.GetMatchingGroup(s.spfilter,tp,LOCATION_GRAVE,0,nil,e,tp)
			if #g2>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
				local sg=g2:Select(tp,1,1,nil)
				if #sg>0 then
					Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
				end
			end
			
		-- 光属性「炽魂之冲击」：对方场上1张卡破坏
		elseif attr==ATTRIBUTE_LIGHT and (name==s.impact_name or string.find(name,s.impact_name)) then
			local dg=Duel.GetMatchingGroup(nil,tp,0,LOCATION_ONFIELD,nil)
			if #dg>0 then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
				local sg=dg:Select(tp,1,1,nil)
				if #sg>0 then
					Duel.Destroy(sg,REASON_EFFECT)
				end
			end
			
		-- 暗属性「炽魂之遁形」：自己从卡组抽1张卡
		elseif attr==ATTRIBUTE_DARK and (name==s.escape_name or string.find(name,s.escape_name)) then
			Duel.Draw(tp,1,REASON_EFFECT)
			
		-- 光属性「炽魂之遁形」：从自己卡组上面把2张卡送去墓地
		elseif attr==ATTRIBUTE_LIGHT and (name==s.escape_name or string.find(name,s.escape_name)) then
			local g2=Duel.GetDecktopGroup(tp,2)
			if #g2>0 then
				Duel.SendtoGrave(g2,REASON_EFFECT)
			end
		end
	end
end

function s.spfilter(c,e,tp)
	return c:IsSetCard(s.soul_setcode) and c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE)
end