--逆元构造 蚀暗
function c79029801.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c79029801.spcon)
	c:RegisterEffect(e1)
	--t g
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,79029801)
	e2:SetCondition(c79029801.tgcon)
	e2:SetTarget(c79029801.tdtg)
	e2:SetOperation(c79029801.tdop)
	c:RegisterEffect(e2)
	--ww
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_RECOVER)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCost(aux.bfgcost)
	e3:SetCountLimit(1,19029801)
	e3:SetTarget(c79029801.rctg)
	e3:SetOperation(c79029801.rcop)
	c:RegisterEffect(e3)
end
function c79029801.xxfilter(c)
	return not c:IsLevel(3) and not c:IsRank(3) and not c:IsLink(3)
end
function c79029801.spcon(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0 and
	  not  Duel.IsExistingMatchingCard(c79029801.xxfilter,c:GetControler(),LOCATION_MZONE,0,1,nil) and not Duel.IsExistingMatchingCard(Card.IsFacedown,c:GetControler(),LOCATION_MZONE,0,1,nil) and Duel.GetFieldGroupCount(c:GetControler(),LOCATION_MZONE,0)>0
end
function c79029801.filter(c)
	return c:IsAbleToDeck() and c:IsSetCard(0xa991) and (c:IsLocation(LOCATION_GRAVE) or c:IsFaceup())
end
function c79029801.tgcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end
function c79029801.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c79029801.filter,tp,LOCATION_REMOVED+LOCATION_GRAVE,0,3,nil,tp) and Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,3,tp,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,1,tp,0,0)  
end
function c79029801.sfilter(c,tp)
	return c:IsLocation(LOCATION_DECK) and c:IsControler(tp)
end
function c79029801.tdop(e,tp,eg,ep,ev,re,r,rp)
	local a1=Duel.IsExistingMatchingCard(c79029801.filter,tp,LOCATION_REMOVED+LOCATION_GRAVE,0,3,nil,tp) and Duel.IsPlayerCanDraw(tp,1) 
	local a2=Duel.IsExistingMatchingCard(c79029801.filter,tp,LOCATION_REMOVED+LOCATION_GRAVE,0,6,nil,tp) and Duel.IsPlayerCanDraw(tp,2) 
	local op=2
	if a1 and a2 then
		op=Duel.SelectOption(tp,aux.Stringid(79029801,0),aux.Stringid(79029801,1))
	elseif a1 then
		op=Duel.SelectOption(tp,aux.Stringid(79029801,0))
	elseif a2 then
		op=Duel.SelectOption(tp,aux.Stringid(79029801,1))+1
	else
		return
	end 
	local tg=Group.CreateGroup()
	if op==0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		tg=Duel.SelectMatchingCard(tp,c79029801.filter,tp,LOCATION_REMOVED+LOCATION_GRAVE,0,3,3,nil)
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		tg=Duel.SelectMatchingCard(tp,c79029801.filter,tp,LOCATION_REMOVED+LOCATION_GRAVE,0,6,6,nil)
	end
	Duel.SendtoDeck(tg,nil,0,REASON_EFFECT)
	local g=Duel.GetOperatedGroup()
	if g:IsExists(c79029801.sfilter,1,nil,tp) then Duel.ShuffleDeck(tp) end
	local ct=g:FilterCount(Card.IsLocation,nil,LOCATION_DECK+LOCATION_EXTRA)
	if ct>=3 then
		Duel.BreakEffect()
		local num=math.floor(ct/3)
		Duel.Draw(tp,num,REASON_EFFECT)
	end
end
function c79029801.rcfilter(c)
	return c:IsFaceup() and (c:IsAttackAbove(0) or c:IsDefenseAbove(0))
end
function c79029801.rctg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return c:IsLocation(LOCATION_MZONE) and c79029801.rcfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c79029801.rcfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	g=Duel.SelectTarget(tp,c79029801.rcfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	local tc=g:GetFirst()
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,math.max(tc:GetAttack(),tc:GetDefense()),tp,0,0)
end
function c79029801.rcop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		Duel.Recover(tp,math.max(tc:GetAttack(),tc:GetDefense()),REASON_EFFECT)
	end
end