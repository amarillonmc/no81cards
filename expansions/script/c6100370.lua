--绚烂之阳华姬 赫利安瑟
local s,id=GetID()
function s.initial_effect(c)
	--超量召唤手续
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsRace,RACE_PLANT),8,2)
	c:EnableReviveLimit()
	--允许放置魔力指示物
	c:EnableCounterPermit(0x1)
	c:SetCounterLimit(0x1,5)

	--①：超量召唤成功时，展示额外，垫素材
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,id)
	e1:SetCondition(s.matcon)
	e1:SetCost(s.matcost) --此处修正
	e1:SetTarget(s.mattg)
	e1:SetOperation(s.matop)
	c:RegisterEffect(e1)

	--②：植物族效果发动给自身置1个指示物
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetCondition(s.ctcon)
	e2:SetOperation(s.ctop)
	c:RegisterEffect(e2)

	--②：攻击力上升
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetValue(s.atkval)
	c:RegisterEffect(e3)

	--③：解放卡片 & (可选)无效
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(id,1))
	e4:SetCategory(CATEGORY_RELEASE)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_CHAINING)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1,id+1)
	e4:SetCondition(s.relcon)
	e4:SetCost(s.relcost)
	e4:SetTarget(s.reltg)
	e4:SetOperation(s.relop)
	c:RegisterEffect(e4)
end

--①：Condition
function s.matcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ)
end

function s.matfilter(c,att)
	return c:IsRace(RACE_PLANT) and c:IsAttribute(att)
end

function s.rvfilter(c,tp)
	return c:IsRace(RACE_PLANT) and Duel.IsExistingMatchingCard(s.matfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,c:GetAttribute())
end

--①：Cost
function s.matcost(e,tp,eg,ep,ev,re,r,rp,chk)
	--chk==0时，传入tp给filter进行嵌套检查
	if chk==0 then return Duel.IsExistingMatchingCard(s.rvfilter,tp,LOCATION_EXTRA,0,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g=Duel.SelectMatchingCard(tp,s.rvfilter,tp,LOCATION_EXTRA,0,1,1,nil,tp)
	Duel.ConfirmCards(1-tp,g)
	e:SetLabel(g:GetFirst():GetAttribute())
end

--①：Target
function s.mattg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsFaceup() end
	--这是一个不取对象的效果，且不涉及移动到手卡/场上，通常不需要SetOperationInfo
end

--①：Operation
function s.matop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local att=e:GetLabel() --获取Cost阶段记录的属性
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
	local g=Duel.SelectMatchingCard(tp,s.matfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,att)
	if #g>0 then
		Duel.Overlay(c,g)
	end
end

--②：放置指示物
function s.ctcon(e,tp,eg,ep,ev,re,r,rp)
	return rp==tp and re:IsActiveType(TYPE_MONSTER) and re:GetHandler():IsRace(RACE_PLANT) and re:GetHandler()~=e:GetHandler()
end
function s.ctop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():AddCounter(0x1,1)
end

--②：攻击力
function s.atkval(e,c)
	return c:GetCounter(0x1)*300
end

function s.relcon(e,tp,eg,ep,ev,re,r,rp)
	return re:GetHandler()~=e:GetHandler()
end

--③：Cost (必须取除素材，可选追加取除指示物)
function s.relcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	--基本要求：取除1个素材
	local b1=c:CheckRemoveOverlayCard(tp,1,REASON_COST)
	--强化要求：取除1个素材 + 取除3个指示物
	local b2=b1 and c:IsCanRemoveCounter(tp,0x1,3,REASON_COST)
	
	if chk==0 then return b1 end
	
	--如果同时满足，让玩家选择是否追加指示物
	if b2 and Duel.SelectYesNo(tp,aux.Stringid(id,2)) then --"是否同时取除3个指示物？"
		c:RemoveOverlayCard(tp,1,1,REASON_COST)
		c:RemoveCounter(tp,0x1,3,REASON_COST)
		e:SetLabel(1) --标记：支付了强化Cost
	else
		c:RemoveOverlayCard(tp,1,1,REASON_COST)
		e:SetLabel(0) --标记：只支付了基本Cost
	end
end

--③：Target
function s.reltg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return re:GetHandler():IsRelateToEffect(re) end
	Duel.SetOperationInfo(0,CATEGORY_RELEASE,re:GetHandler(),1,0,0)
	if e:GetLabel()==1 then
		Duel.SetOperationInfo(0,CATEGORY_DISABLE,eg,1,0,0)
	end
end

--③：Operation
function s.relop(e,tp,eg,ep,ev,re,r,rp)
	local tc=re:GetHandler()
	if tc:IsRelateToEffect(re) and Duel.Release(tc,REASON_EFFECT)>0 then
		if e:GetLabel()==1 then
			Duel.NegateEffect(ev)
		end
	end
end