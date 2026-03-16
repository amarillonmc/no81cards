--闪烁初星 ～缤纷偶像储物箱～
function c71201233.initial_effect(c)
	--
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	--draw
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCountLimit(1,71201233)
	e1:SetCost(c71201233.drcost)
	e1:SetTarget(c71201233.drtg)
	e1:SetOperation(c71201233.drop)
	c:RegisterEffect(e1)
	--at limit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_SELECT_BATTLE_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(0,LOCATION_MZONE)
	e2:SetValue(c71201233.atlimit)
	c:RegisterEffect(e2)
	--special summon
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(71201233,2))
	e5:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOGRAVE+CATEGORY_RECOVER)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e5:SetCode(EVENT_REMOVE)
	e5:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e5:SetCountLimit(1,11201233)
	e5:SetTarget(c71201233.sptg)
	e5:SetOperation(c71201233.spop)
	c:RegisterEffect(e5)
end
function c71201233.drfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsDiscardable(REASON_COST) and c:IsSetCard(0x7121)
end
function c71201233.drcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c71201233.drfilter,tp,LOCATION_HAND,0,1,nil) end
	local ct=1
	if Duel.IsPlayerCanDraw(tp,2) then ct=2 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
	local ct=Duel.DiscardHand(tp,c71201233.drfilter,1,ct,REASON_DISCARD+REASON_COST)
	e:SetLabel(ct)
end
function c71201233.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	local ct=e:GetLabel()
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(ct)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,ct)
end
function c71201233.drop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
function c71201233.atlimit(e,c)
	return c:IsFaceup() and c:IsSetCard(0x7121) and c:IsPosition(POS_DEFENSE)
end
function c71201233.filter(c,e,tp)
	if not c:IsLevelAbove(1) then return end
	return c:IsFaceup() and c:IsSetCard(0x7121) and c:IsAbleToGrave() and Duel.GetMZoneCount(tp,c)>0
		and Duel.IsExistingMatchingCard(c71201233.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp,c:GetLevel())
end
function c71201233.spfilter(c,e,tp,lv)
	return c:IsSetCard(0x7121) and not c:IsLevel(lv) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c71201233.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c71201233.filter(chkc,e,tp) end
	if chk==0 then return Duel.IsExistingTarget(c71201233.filter,tp,LOCATION_MZONE,0,1,nil,e,tp) 
		and e:GetHandler():IsAbleToGrave() end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectTarget(tp,c71201233.filter,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,e:GetHandler(),1,tp,LOCATION_REMOVED)
end
function c71201233.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or Duel.SendtoGrave(c,REASON_EFFECT)==0 then return end
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) or Duel.SendtoGrave(tc,REASON_EFFECT)==0 then return end
	if not tc:IsLocation(LOCATION_GRAVE) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c71201233.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp,tc:GetLevel())
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		Duel.Recover(tp,500,REASON_EFFECT)
	end
end