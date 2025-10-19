--失控磁盘 斯特拉
function c95101224.initial_effect(c)
	--position
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(95101224,0))
	e1:SetCategory(CATEGORY_COIN+CATEGORY_POSITION)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetTarget(c95101224.postg)
	e1:SetOperation(c95101224.posop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	--attack effect:draw
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(95101224,1))
	e3:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCondition(c95101224.atkcon)
	e3:SetTarget(c95101224.atktg)
	e3:SetOperation(c95101224.atkop)
	c:RegisterEffect(e3)
	--defense effect:deckdes
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(95101224,1))
	e4:SetCategory(CATEGORY_DICE+CATEGORY_TOGRAVE+CATEGORY_DECKDES)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1)
	e4:SetCondition(c95101224.defcon)
	e4:SetTarget(c95101224.deftg)
	e4:SetOperation(c95101224.defop)
	c:RegisterEffect(e4)
end
function c95101224.postg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_COIN,nil,0,tp,1)
end
function c95101224.posop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local res=Duel.TossCoin(tp,1)
	if res==1 then Duel.ChangePosition(c,POS_FACEUP_ATTACK)
	else Duel.ChangePosition(c,POS_FACEUP_DEFENSE) end
end
function c95101224.atkcon(e)
	return e:GetHandler():IsAttackPos()
end
function c95101224.tdfilter(c)
	return c:IsSetCard(0x6bb0) and c:IsFaceupEx() and c:IsAbleToDeck()
end
function c95101224.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c95101224.tdfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,3,nil) and Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,3,tp,LOCATION_GRAVE+LOCATION_REMOVED)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c95101224.atkop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c95101224.tdfilter),tp,LOCATION_GRAVE+LOCATION_REMOVED,0,3,3,nil)
	if g:GetCount()~=3 or Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)==0 or g:FilterCount(Card.IsLocation,nil,LOCATION_DECK+LOCATION_EXTRA)==0 then return end
	Duel.Draw(tp,1,REASON_EFFECT)
end
function c95101224.defcon(e)
	return e:GetHandler():IsDefensePos()
end
function c95101224.deftg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>0 end
	Duel.SetOperationInfo(0,CATEGORY_DICE,nil,0,tp,1)
end
function c95101224.tgfilter(c)
	return c:IsSetCard(0x6bb0) and c:IsAbleToGrave()
end
function c95101224.defop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)==0 then return end
	local dc=Duel.TossDice(tp,1)
	Duel.ConfirmDecktop(tp,dc)
	local dg=Duel.GetDecktopGroup(tp,dc)
	local g=dg:Filter(c95101224.tgfilter,nil)
	if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(95101224,2)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local sg=g:Select(tp,1,1,nil)
		Duel.SendtoGrave(sg,REASON_EFFECT)
	end
	Duel.ShuffleDeck(tp)
end
