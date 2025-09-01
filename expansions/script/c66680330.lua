--堕福的禁曲・终幕歌
local s,id,o=GetID()
function s.initial_effect(c)
	
	-- 自己场上有「堕福」超量怪兽存在，怪兽的效果·魔法·陷阱卡发动时才能发动，那个发动无效并除外
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCountLimit(1,id)
	e1:SetCondition(s.condition)
	e1:SetCost(s.cost)
	e1:SetTarget(aux.nbtg)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
	
	-- 这张卡被效果送去墓地的场合才能发动，把自己墓地的「堕福」卡种类数量的卡从自己卡组上面送去墓地
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_DECKDES)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCountLimit(1,id)
	e2:SetCondition(s.tgcon)
	e2:SetTarget(s.tgtg)
	e2:SetOperation(s.tgop)
	c:RegisterEffect(e2)
	
	-- 这些效果发动的回合，自己不能把场上的怪兽的效果发动
	Duel.AddCustomActivityCounter(id,ACTIVITY_CHAIN,s.chainfilter)
end

-- 这些效果发动的回合，自己不能把场上的怪兽的效果发动
function s.chainfilter(re,tp,cid)
	local rc=re:GetHandler()
	local loc=Duel.GetChainInfo(cid,CHAININFO_TRIGGERING_LOCATION)
	return not (re:IsActiveType(TYPE_MONSTER) and loc==LOCATION_MZONE)
end

function s.aclimit(e,re,tp)
	local rc=re:GetHandler()
	return re:IsActiveType(TYPE_MONSTER) and rc:IsLocation(LOCATION_MZONE)
end

-- 自己场上有「堕福」超量怪兽存在，怪兽的效果·魔法·陷阱卡发动时才能发动，那个发动无效并除外
function s.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x666c) and c:IsType(TYPE_XYZ)
end

function s.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(s.cfilter,tp,LOCATION_MZONE,0,1,nil)
		and Duel.IsChainNegatable(ev) and (re:IsActiveType(TYPE_MONSTER) or re:IsHasType(EFFECT_TYPE_ACTIVATE))
end

function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetCustomActivityCount(id,tp,ACTIVITY_CHAIN)==0 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetTargetRange(1,0)
	e1:SetValue(s.aclimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end

function s.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Remove(eg,POS_FACEUP,REASON_EFFECT)
	end
end

-- 这张卡被效果送去墓地的场合才能发动，把自己墓地的「堕福」卡种类数量的卡从自己卡组上面送去墓地
function s.tgcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsReason(REASON_EFFECT)
end

function s.tgfilter(c)
	return c:IsSetCard(0x666c)
end

function s.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=Duel.GetMatchingGroup(s.tgfilter,tp,LOCATION_GRAVE,0,nil):GetClassCount(Card.GetCode)
	if chk==0 then return ct>0 and Duel.IsPlayerCanDiscardDeck(tp,ct) end
	Duel.SetOperationInfo(0,CATEGORY_DECKDES,nil,0,tp,ct)
end

function s.tgop(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.GetMatchingGroup(s.tgfilter,tp,LOCATION_GRAVE,0,nil):GetClassCount(Card.GetCode)
	if ct>0 then
		Duel.DiscardDeck(tp,ct,REASON_EFFECT)
	end
end
