--绮奏战律·残响轨层
function c66620520.initial_effect(c)

    -- 作为这张卡的发动时的效果处理，可以从卡组把1只「绮奏」怪兽加入手卡
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,66620520+EFFECT_COUNT_CODE_OATH)
	e1:SetOperation(c66620520.activate)
	c:RegisterEffect(e1)
	
	-- 1回合1次，这张卡被效果破坏的场合，可以作为代替把自己墓地1张卡除外
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e5:SetRange(LOCATION_FZONE)
	e5:SetCode(EFFECT_DESTROY_REPLACE)
	e5:SetCountLimit(1)
	e5:SetTarget(c66620520.desreptg)
	c:RegisterEffect(e5)
	
	-- 对方场上的卡被战斗·效果破坏的场合才能发动，从卡组把1张「绮奏」速攻魔法卡加入手卡
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(66620520,2))
	e4:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_DESTROYED)
	e4:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_PLAYER_TARGET)
	e4:SetRange(LOCATION_FZONE)
	e4:SetCountLimit(1,66620520)
	e4:SetCondition(c66620520.thcon)
	e4:SetTarget(c66620520.thtg)
	e4:SetOperation(c66620520.thop)
	c:RegisterEffect(e4)
end

-- 作为这张卡的发动时的效果处理，可以从卡组把1只「绮奏」怪兽加入手卡
function c66620520.thfilter1(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x666a) and c:IsAbleToHand()
end

function c66620520.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c66620520.thfilter1,tp,LOCATION_DECK,0,nil)
	if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(66620520,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=g:Select(tp,1,1,nil)
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
	end
end

-- 1回合1次，这张卡被效果破坏的场合，可以作为代替把自己墓地1张卡除外
function c66620520.desreptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return not c:IsReason(REASON_REPLACE) and c:IsReason(REASON_EFFECT)
		and Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,LOCATION_GRAVE,0,1,nil) end
	if Duel.SelectEffectYesNo(tp,c,96) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local g=Duel.SelectMatchingCard(tp,Card.IsAbleToRemove,tp,LOCATION_GRAVE,0,1,1,nil)
		Duel.Remove(g,POS_FACEUP,REASON_EFFECT+REASON_REPLACE)
		return true
	else return false end
end

-- 对方场上的卡被战斗·效果破坏的场合才能发动，从卡组把1张「绮奏」速攻魔法卡加入手卡
function c66620520.drcfilter(c,tp)
	return c:IsPreviousLocation(LOCATION_ONFIELD) and c:IsPreviousControler(1-tp) and c:IsReason(REASON_BATTLE+REASON_EFFECT)
end

function c66620520.thcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c66620520.drcfilter,1,nil,tp)
end

function c66620520.thfilter2(c)
	return c:IsSetCard(0x666a) and c:IsType(TYPE_QUICKPLAY) and c:IsAbleToHand()
end

function c66620520.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c66620520.thfilter2,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end

function c66620520.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c66620520.thfilter2,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
