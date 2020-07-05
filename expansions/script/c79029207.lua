--罗德岛·狙击干员-W
function c79029207.initial_effect(c)
	--xyz summon
	c:EnableReviveLimit()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetValue(SUMMON_TYPE_XYZ)
	e1:SetCondition(c79029207.sprcon)
	e1:SetOperation(c79029207.sprop)
	c:RegisterEffect(e1)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e1)
	--dark xyz
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_CHANGE_RANK)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetValue(-8)
	c:RegisterEffect(e1) 
	--dark xyz
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CHANGE_TYPE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetValue(TYPE_XYZ+TYPE_EFFECT)
	c:RegisterEffect(e1)  
	--surprise
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCategory(CATEGORY_TODECK)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCost(c79029207.dcost)
	e2:SetTarget(c79029207.dtg)
	e2:SetOperation(c79029207.dop)
	c:RegisterEffect(e2) 
	--cannot be target
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_CANNOT_BE_BATTLE_TARGET)
	e3:SetValue(aux.imval1)
	e3:SetCondition(c79029207.ctcon)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	c:RegisterEffect(e4)  
	--d12
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e5:SetCode(EVENT_SPSUMMON_SUCCESS)
	e5:SetCondition(c79029207.d12con)
	e5:SetOperation(c79029207.d12op)
	c:RegisterEffect(e5)
end
function c79029207.sprfilter1(c,tp,g,sc)
	local lv=c:GetLevel()
	return not c:IsType(TYPE_MONSTER) and c:GetOriginalLevel()==8
end
function c79029207.sprfilter2(c,tp,g,sc)
	local lv=c:GetLevel()
	return not c:IsType(TYPE_MONSTER) and c:GetOriginalLevel()==8
end
function c79029207.sprcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local g=Duel.GetMatchingGroup(c79029207.sprfilter,tp,LOCATION_MZONE,0,nil)
	return g:IsExists(c79029207.sprfilter1,1,nil,tp,g,c)
end
function c79029207.sprop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.GetMatchingGroup(c79029207.sprfilter,tp,LOCATION_MZONE,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
	local g1=g:FilterSelect(tp,c79029207.sprfilter1,1,1,nil,tp,g,c)
	local mc=g1:GetFirst()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
	local g2=g:FilterSelect(tp,c79029207.sprfilter2,1,1,mc,tp,mc,c,mc:GetLink())
	g1:Merge(g2)
	e:GetHandler():SetMaterial(g1)
	Duel.Overlay(e:GetHandler(),g1)
	Duel.MoveToField(e:GetHandler(),tp,tp,LOCATION_MZONE,POS_FACEUP,true)
	Debug.Message("说不定我会偷偷溜到其他地方去呢。")
end
function c79029207.dcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c79029207.dtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,0,LOCATION_ONFIELD+LOCATION_HAND,1,nil) end
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToDeck,tp,0,LOCATION_ONFIELD+LOCATION_HAND,1,1,nil)
	Duel.SetTargetCard(g)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,tp,0)
end
function c79029207.dop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	Debug.Message("遍地惊喜，任君自取~")
	if Duel.SendtoDeck(tc,nil,3,REASON_EFFECT)~=0 then
	tc:ReverseInDeck()
	local e1=Effect.CreateEffect(tc)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCategory(CATEGORY_DAMAGE)
	e1:SetCode(EVENT_TO_HAND)
	e1:SetOperation(c79029207.daop)
	tc:RegisterEffect(e1)
	tc:RegisterFlagEffect(79029207,RESET_EVENT+RESET_TOHAND,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(79029207,0))
end
end
function c79029207.daop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ConfirmCards(tp+1-tp,e:GetHandler())
	Duel.Damage(tp,4000,REASON_EFFECT)
	Duel.ShuffleHand(e:GetHandler():GetControler())
	e:Reset()
	Debug.Message("砰！哈哈哈——")
end
function c79029207.ctcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return Duel.IsExistingMatchingCard(aux.TRUE,c:GetControler(),LOCATION_MZONE,0,1,c)
end
function c79029207.d12con(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ) and Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_DECK,1,nil)
end
function c79029207.d12op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetFieldGroup(tp,0,LOCATION_DECK)
	local tc=g:RandomSelect(tp,1):GetFirst()
	Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_ONFIELD+LOCATION_EXTRA+LOCATION_GRAVE+LOCATION_REMOVED)
	e2:SetTargetRange(0,LOCATION_ONFIELD)
	e2:SetTarget(c79029207.disable)
	e2:SetCode(EFFECT_DISABLE)
	e2:SetLabel(tc:GetOriginalType())
	c:RegisterEffect(e2)
	Debug.Message("是谁会抽中大奖呢？")
end
function c79029207.disable(e,c)
	return c:IsType(e:GetLabel())
end






