--绮奏·冥裁归谕 缇亚兹缇蕾
local s,id,o=GetID()
function s.initial_effect(c)
	c:EnableReviveLimit()
	
	-- 这张卡不能通常召唤
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	c:RegisterEffect(e1)
	
	-- 把自己的墓地·除外状态的3张「绮奏」魔法·陷阱卡回到卡组场合才能从手卡·墓地特殊召唤
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetRange(LOCATION_GRAVE+LOCATION_HAND)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetCondition(s.spscon)
	e2:SetTarget(s.spstg)
	e2:SetOperation(s.spsop)
	c:RegisterEffect(e2)
	
	-- 对方不能把自己场上的7星以下的「绮奏」怪兽作为效果的对象
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e3:SetRange(LOCATION_MZONE)
	e3:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetTarget(s.ctfilter)
	e3:SetValue(aux.tgoval)
	c:RegisterEffect(e3)
	
	-- 自己在对方回合把「绮奏」速攻魔法卡的效果发动的场合才能发动，自己抽1张
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(id,0))
	e4:SetCategory(CATEGORY_DRAW)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EVENT_CHAINING)
	e4:SetCountLimit(1,id)
	e4:SetCondition(s.drcon)
	e4:SetTarget(s.drtg)
	e4:SetOperation(s.drop)
	c:RegisterEffect(e4)
	
	-- 这张卡从手卡·场上送去墓地的场合才能发动，同名卡不在自己墓地存在的1张「绮奏」魔法·陷阱卡从卡组加入手卡
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(id,1))
	e5:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e5:SetProperty(EFFECT_FLAG_DELAY)
	e5:SetCode(EVENT_TO_GRAVE)
	e5:SetCountLimit(1,id+1)
	e5:SetCondition(s.thcon)
	e5:SetTarget(s.thtg)
	e5:SetOperation(s.thop)
	c:RegisterEffect(e5)
end

-- 把自己的墓地·除外状态的3张「绮奏」魔法·陷阱卡回到卡组场合才能从手卡·墓地特殊召唤
function s.cfilter(c)
	return c:IsSetCard(0x666a) and (c:IsType(TYPE_SPELL) or c:IsType(TYPE_TRAP))
		and (c:IsLocation(LOCATION_GRAVE) or c:IsFaceup())
		and c:IsAbleToDeckAsCost()
end

function s.spscon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local g=Duel.GetMatchingGroup(s.cfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,c)
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and #g>=3
end

function s.spstg(e,tp,eg,ep,ev,re,r,rp,chk,c)
	if chk==0 then
		local g=Duel.GetMatchingGroup(s.cfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,c)
		return g:GetClassCount(Card.GetCode)>=1 and #g>=3
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,s.cfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,3,3,nil)
	if #g>0 then
		g:KeepAlive()
		e:SetLabelObject(g)
		return true
	end
	return false
end

function s.spsop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=e:GetLabelObject()
	if g then
		Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_SPSUMMON)
	    g:DeleteGroup()
    end
end

-- 对方不能把自己场上的7星以下的「绮奏」怪兽作为效果的对象
function s.ctfilter(e,c)
	return c:IsFaceup() and c:IsSetCard(0x666a) and c:IsLevelBelow(7)
end

-- 自己在对方回合把「绮奏」速攻魔法卡的效果发动的场合才能发动，自己抽1张
function s.drcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp and rp==tp
		and re:IsActiveType(TYPE_QUICKPLAY)
		and re:GetHandler():IsSetCard(0x666a)
end

function s.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end

function s.drop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end

-- 这张卡从手卡·场上送去墓地的场合才能发动，同名卡不在自己墓地存在的1张「绮奏」魔法·陷阱卡从卡组加入手卡
function s.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_HAND+LOCATION_ONFIELD)
end

function s.thfilter(c,tp)
	return c:IsSetCard(0x666a) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToHand()
		and not Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_GRAVE,0,1,nil,c:GetCode())
end

function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK,0,1,nil,tp) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end

function s.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_DECK,0,1,1,nil,tp)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
