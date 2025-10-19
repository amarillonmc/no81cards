-- 怪兽卡：魂铸守护者
local s, id = GetID()

function s.initial_effect(c)
	-- 不能特殊召唤
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	e0:SetValue(aux.FALSE)
	c:RegisterEffect(e0)
	
	-- 效果①：对方场上没有通常召唤的怪兽时，对方不能发动魔法卡
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(0,1)
	e1:SetCondition(s.actcon)
	e1:SetValue(s.actlimit)
	c:RegisterEffect(e1)
	
	-- 效果②：解放自己场上另一只怪兽，检索并可能破坏魔法·陷阱卡
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,id)
	e2:SetCost(s.thcost)
	e2:SetTarget(s.thtg)
	e2:SetOperation(s.thop)
	c:RegisterEffect(e2)
end

-- 定义魂铸意志字段
s.soul_setcode = 0x396c

-- 效果①：条件检查（对方场上没有通常召唤的怪兽）
function s.actfilter(c)
	return c:IsSummonType(SUMMON_TYPE_NORMAL)
end

function s.actcon(e)
	local tp=e:GetHandlerPlayer()
	return not Duel.IsExistingMatchingCard(s.actfilter,1-tp,LOCATION_MZONE,0,1,nil)
end

-- 效果①：限制值（不能发动魔法卡）
function s.actlimit(e,re,tp)
	return re:IsHasType(EFFECT_TYPE_ACTIVATE) and re:IsActiveType(TYPE_SPELL)
end

-- 效果②：代价（解放自己场上另一只怪兽）
function s.costfilter(c,tp)
	return c:IsReleasable() and not c:IsCode(id)
end

function s.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,s.costfilter,1,e:GetHandler(),tp) end
	local g=Duel.SelectReleaseGroup(tp,s.costfilter,1,1,e:GetHandler(),tp)
	Duel.Release(g,REASON_COST)
end

-- 效果②：目标设定
function s.thfilter(c)
	return c:IsSetCard(s.soul_setcode) and c:IsAbleToHand()
end

function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK,0,1,nil)
	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,1-tp,LOCATION_SZONE)
end

-- 效果②：操作处理
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	-- 从卡组把1张「魂铸意志」卡加入手卡
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if #g>0 then
		if Duel.SendtoHand(g,nil,REASON_EFFECT)~=0 then
			Duel.ConfirmCards(1-tp,g)
			
			-- 可以把对方场上1张魔法·陷阱卡破坏
			local dg=Duel.GetMatchingGroup(Card.IsType,1-tp,LOCATION_SZONE,0,nil,TYPE_SPELL+TYPE_TRAP)
			if #dg>0 and Duel.SelectYesNo(tp,aux.Stringid(id,1)) then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
				local sg=dg:Select(tp,1,1,nil)
				if #sg>0 then
					Duel.HintSelection(sg)
					Duel.Destroy(sg,REASON_EFFECT)
				end
			end
		end
	end
end