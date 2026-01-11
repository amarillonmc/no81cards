--绮奏斥律·梦骸返跃
function c66620615.initial_effect(c)

	-- 可以从自己的手卡·场上·墓地把1只「绮奏」怪兽除外，从以下效果选择1个发动
	
	-- 自己场上的「绮奏」怪兽为对象的效果由对方发动时才能发动，那个效果无效并破坏
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(66620615,0))
	e1:SetCategory(CATEGORY_DISABLE+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCountLimit(1,66620615)
	e1:SetCondition(c66620615.discon)
	e1:SetCost(c66620615.cost)
	e1:SetTarget(c66620615.distg)
	e1:SetOperation(c66620615.disop)
	c:RegisterEffect(e1)
	
	-- 对方把怪兽召唤·反转召唤·特殊召唤之际才能发动，那个无效，那些怪兽回到手卡
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(66620615,1))
	e2:SetCategory(CATEGORY_DISABLE_SUMMON+CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_SUMMON)
	e2:SetCountLimit(1,66620615)
	e2:SetCondition(c66620615.condition)
	e2:SetCost(c66620615.cost)
	e2:SetTarget(c66620615.target)
	e2:SetOperation(c66620615.operation)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_FLIP_SUMMON)
	c:RegisterEffect(e3)
	local e4=e2:Clone()
	e4:SetCode(EVENT_SPSUMMON)
	c:RegisterEffect(e4)
	
	-- 自己·对方的准备阶段，自己场上有机械族融合怪兽存在的场合才能发动，墓地的这张卡在自己场上盖放，这个效果盖放的这张卡从场上离开的场合除外
	local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_SSET)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e5:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e5:SetRange(LOCATION_GRAVE)
	e5:SetCountLimit(1,66620616)
	e5:SetCondition(c66620615.setcon)
	e5:SetTarget(c66620615.settg)
	e5:SetOperation(c66620615.setop)
	c:RegisterEffect(e5)
end

-- 可以从自己的手卡·场上·墓地把1只「绮奏」怪兽除外，从以下效果选择1个发动
function c66620615.thfilter(c)
	return c:IsSetCard(0x666a) and c:IsType(TYPE_MONSTER) and c:IsAbleToRemoveAsCost()
end

function c66620615.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c66620615.thfilter,tp,LOCATION_HAND+LOCATION_MZONE+LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c66620615.thfilter,tp,LOCATION_HAND+LOCATION_MZONE+LOCATION_GRAVE,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end

-- 对方把怪兽召唤·反转召唤·特殊召唤之际才能发动，那个无效，那些怪兽回到手卡
function c66620615.condition(e,tp,eg,ep,ev,re,r,rp)
	return tp~=ep and Duel.GetCurrentChain()==0
end

function c66620615.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE_SUMMON,eg,eg:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,eg,eg:GetCount(),0,0)
end

function c66620615.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateSummon(eg)
	Duel.SendtoHand(eg,nil,REASON_EFFECT)
end

-- 自己场上的「绮奏」怪兽为对象的效果由对方发动时才能发动，那个效果无效并破坏
function c66620615.discfilter(c,tp)
	return c:IsControler(tp) and c:IsSetCard(0x666a) and c:IsType(TYPE_MONSTER) and c:IsFaceup() and c:IsLocation(LOCATION_MZONE)
end

function c66620615.discon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsStatus(STATUS_BATTLE_DESTROYED) then return false end
	if rp~=1-tp or not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return false end
	local tg=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	return tg and tg:IsExists(c66620615.discfilter,1,nil,tp) and Duel.IsChainDisablable(ev)
end

function c66620615.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end

function c66620615.disop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateEffect(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end

-- 自己·对方的准备阶段，自己场上有机械族融合怪兽存在的场合才能发动，墓地的这张卡在自己场上盖放，这个效果盖放的这张卡从场上离开的场合除外
function c66620615.rccfilter(c)
	return c:IsFaceup() and c:IsRace(RACE_MACHINE) and c:IsType(TYPE_FUSION)
end

function c66620615.setcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c66620615.rccfilter,tp,LOCATION_MZONE,0,1,nil)
end

function c66620615.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsSSetable() end
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,e:GetHandler(),1,0,0)
end

function c66620615.setop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and aux.NecroValleyFilter()(c) and Duel.SSet(tp,c)~=0 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_REDIRECT)
		e1:SetValue(LOCATION_REMOVED)
		c:RegisterEffect(e1)
	end
end
