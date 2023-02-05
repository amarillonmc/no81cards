--魔键召龙-歌赛亚
function c98920033.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFun2(c,c98920033.mtfilter,c98920033.mtfilter2,true)
  --Attribute
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_ADD_ATTRIBUTE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(c98920033.attval)
	c:RegisterEffect(e1)
--destroy
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(98920033,1))
	e4:SetCategory(CATEGORY_DESTROY)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e4:SetCode(EVENT_BATTLE_START)
	e4:SetCondition(c98920033.descon)
	e4:SetTarget(c98920033.destg)
	e4:SetOperation(c98920033.desop)
	c:RegisterEffect(e4)
--negate activate
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(98920033,0))
	e2:SetCategory(CATEGORY_NEGATE+CATEGORY_TOGRAVE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)return rp~=tp and not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and Duel.IsChainNegatable(ev)end)
	e2:SetTarget(c98920033.alctg1)
	e2:SetOperation(c98920033.alcop1)
	c:RegisterEffect(e2)
end
function c98920033.mtfilter(c)
	return c:IsFusionSetCard(0x165) and c:IsFusionType(TYPE_EFFECT)
end
function c98920033.mtfilter2(c)
	return c:IsFusionType(TYPE_NORMAL) and not c:IsType(TYPE_TOKEN)
end
function c98920033.rafilter(c)
	return c:IsType(TYPE_MONSTER) and (c:IsSetCard(0x165) or c:IsType(TYPE_NORMAL))
end
function c98920033.attval(e,c)
	local c=e:GetHandler()
	local og=Duel.GetOperatedGroup():Filter(c98920033.rafilter,nil)
	local ct=og:GetClassCount(Card.GetAttribute)
	local g1=Duel.GetMatchingGroup(c98920033.rafilter,tp,LOCATION_GRAVE,LOCATION_GRAVE,nil)
	local wbc=g1:GetFirst()
	local att=0
	while wbc do
		att=att|wbc:GetAttribute()
		wbc=g1:GetNext()
	end
	return att
end
function c98920033.descon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	return bc and bc:IsAttribute(e:GetHandler():GetAttribute())
end
function c98920033.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,e:GetHandler():GetBattleTarget(),1,0,0)
end
function c98920033.desop(e,tp,eg,ep,ev,re,r,rp)
	local bc=e:GetHandler():GetBattleTarget()
	if bc:IsRelateToBattle() then
		Duel.Destroy(bc,REASON_EFFECT)
	end
end
function c98920033.setfilter1(c,att)
	return c:IsAttribute(att)
end
function c98920033.alctg1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(c98920033.setfilter1,tp,LOCATION_GRAVE,0,1,nil,eg:GetFirst():GetAttribute()) end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,1-tp,LOCATION_GRAVE)
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function c98920033.alcop1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local sc=Duel.SelectMatchingCard(tp,c98920033.setfilter1,tp,LOCATION_GRAVE,0,1,1,nil,eg:GetFirst():GetAttribute()):GetFirst()
	if not sc then return end
	Duel.HintSelection(Group.FromCards(sc))
	if Duel.SendtoDeck(sc,nil,2,REASON_EFFECT) then
	   Duel.NegateActivation(ev)
	   Duel.Destroy(eg,REASON_EFFECT)
	end
end