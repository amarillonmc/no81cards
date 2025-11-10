-- 超量怪兽：永火恶魔骑士
local s, id = GetID()

function s.initial_effect(c)
	-- 超量召唤条件
	c:EnableReviveLimit()
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsAttribute,ATTRIBUTE_DARK),3,2)
	
	-- 效果①：取除超量素材，从卡组送墓永火怪兽，手卡0张时可破坏对方卡
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_TOGRAVE+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCost(s.cost)
	e1:SetTarget(s.target)
	e1:SetOperation(s.operation)
	c:RegisterEffect(e1,false,REGISTER_FLAG_DETACH_XMAT)
	
	-- 效果②：手卡0张时解放自己，特殊召唤墓地4星以下永火怪兽
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(s.spcon)
	e2:SetCost(s.spcost)
	e2:SetTarget(s.sptg)
	e2:SetOperation(s.spop)
	c:RegisterEffect(e2)
end

-- 定义永火字段常量
s.infernity_setcode = 0xb
function s.costfilter(c)
	return c:IsAbleToGraveAsCost()
end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end

-- 效果①：目标设定
function s.tgfilter(c)
	return c:IsSetCard(s.infernity_setcode) and c:IsType(TYPE_MONSTER) and c:IsAbleToGrave()
end

function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.tgfilter,tp,LOCATION_DECK,0,2,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end

-- 效果①：操作处理
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,s.tgfilter,tp,LOCATION_DECK,0,2,2,nil)
	if #g>0 and Duel.SendtoGrave(g,REASON_EFFECT)~=0 then
		-- 手卡0张时，可以再破坏对方场上1张卡
		if Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)==0 then
			-- 检查对方场上是否有卡
			local dg=Duel.GetFieldGroup(tp,0,LOCATION_ONFIELD)
			if #dg>0 then
				-- 让玩家选择是否破坏
				if Duel.SelectYesNo(tp,aux.Stringid(id,2)) then
					Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
					local sg=dg:Select(tp,1,1,nil)
					if #sg>0 then
						Duel.Destroy(sg,REASON_EFFECT)
					end
				end
			end
		end
	end
end

function s.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)==0
end

function s.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,2,REASON_COST) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	e:GetHandler():RemoveOverlayCard(tp,2,2,REASON_COST) 
end

function s.spfilter(c,e,tp)
	return c:IsSetCard(s.infernity_setcode) and c:IsLevelBelow(4) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end

function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1
			and Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.spfilter),tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	if #g>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end