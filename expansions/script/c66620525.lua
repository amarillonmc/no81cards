--绮奏崩律·断绝连奏
function c66620525.initial_effect(c)

	-- 以自己场上1只「绮奏」怪兽为对象才能发动，和那只怪兽相同纵列的对方的卡全部破坏
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(66620525,0))
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_MAIN_END+TIMING_END_PHASE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,66620525)
	e1:SetTarget(c66620525.target)
	e1:SetOperation(c66620525.activate)
	c:RegisterEffect(e1)
	
	-- 自己主要阶段把墓地的这张卡除外，以「绮奏崩律·断绝连奏」以外的自己的墓地·除外状态的1张「绮奏」魔法·陷阱卡为对象才能发动，那张卡回到卡组最下面，那之后，自己抽1张
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(66620525,1))
	e2:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,66620526)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c66620525.drtg)
	e2:SetOperation(c66620525.drop)
	c:RegisterEffect(e2)
end

-- 以自己场上1只「绮奏」怪兽为对象才能发动，和那只怪兽相同纵列的对方的卡全部破坏
function c66620525.filter(c,tp)
	if not (c:IsFaceup() and c:IsSetCard(0x666a)) then return false end
	local col=c:GetColumnGroup():Filter(Card.IsControler,nil,1-tp)
	return #col>0
end

function c66620525.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c66620525.filter(chkc,tp)
	end
	if chk==0 then return Duel.IsExistingTarget(c66620525.filter,tp,LOCATION_MZONE,0,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local tc=Duel.SelectTarget(tp,c66620525.filter,tp,LOCATION_MZONE,0,1,1,nil,tp):GetFirst()
	local col=tc:GetColumnGroup():Filter(Card.IsControler,nil,1-tp)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,col,#col,1-tp,0)
end

function c66620525.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not tc or not tc:IsRelateToEffect(e) or tc:IsFacedown() then return end
	local g=tc:GetColumnGroup():Filter(Card.IsControler,nil,1-tp)
	if #g>0 then
		Duel.Destroy(g,REASON_EFFECT)
	end
end

-- 自己主要阶段把墓地的这张卡除外，以「绮奏崩律·断绝连奏」以外的自己的墓地·除外状态的1张「绮奏」魔法·陷阱卡为对象才能发动，那张卡回到卡组最下面，那之后，自己抽1张
function c66620525.cfilter(c)
	return c:IsFaceupEx() and c:IsSetCard(0x666a) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToDeck()
		and not c:IsCode(66620525)
end

function c66620525.drtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE+LOCATION_REMOVED) and chkc:IsControler(tp) and s.cfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c66620525.cfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil)
		and Duel.IsPlayerCanDraw(tp,1) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,c66620525.cfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end

function c66620525.drop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.SendtoDeck(tc,nil,SEQ_DECKBOTTOM,REASON_EFFECT)>0
		and tc:IsLocation(LOCATION_DECK) then
		Duel.BreakEffect()
		Duel.Draw(tp,1,REASON_EFFECT)
	end
end
