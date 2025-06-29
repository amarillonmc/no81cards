--翼冠龙·爆块之塔拉特库托拉
function c11570010.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e1:SetCountLimit(1,11570010+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c11570010.sprcon)
	e1:SetOperation(c11570010.sprop)
	c:RegisterEffect(e1)
	--destroy
	local e2=Effect.CreateEffect(c)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER)
	e2:SetDescription(aux.Stringid(11570010,1))
	e2:SetCategory(CATEGORY_DESTROY+CATEGORY_DAMAGE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_HAND+LOCATION_REMOVED)
	e2:SetCountLimit(1,11570010)
	e2:SetCost(c11570010.descost)
	e2:SetTarget(c11570010.destg)
	e2:SetOperation(c11570010.desop)
	c:RegisterEffect(e2)
	--cannot material
	local le1=Effect.CreateEffect(c)
	le1:SetType(EFFECT_TYPE_SINGLE)
	le1:SetCode(EFFECT_CANNOT_BE_FUSION_MATERIAL)
	le1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	le1:SetCondition(c11570010.matcon)
	le1:SetValue(c11570010.fuslimit)
	c:RegisterEffect(le1)
	local le2=le1:Clone()
	le2:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
	le2:SetValue(1)
	c:RegisterEffect(le2)
	local le3=le2:Clone()
	le3:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
	c:RegisterEffect(le3)
	local le4=le2:Clone()
	le4:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
	c:RegisterEffect(le4)
end
function c11570010.sprfilter(c)
	return c:IsSetCard(0x810) and c:IsAbleToRemoveAsCost()
end
function c11570010.sprcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c11570010.sprfilter,tp,LOCATION_GRAVE+LOCATION_HAND,0,2,c)
end
function c11570010.sprop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c11570010.sprfilter,tp,LOCATION_GRAVE+LOCATION_HAND,0,2,2,c)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c11570010.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToGraveAsCost() or c:IsLocation(LOCATION_REMOVED) end
	if c:IsLocation(LOCATION_REMOVED) then Duel.SendtoGrave(c,REASON_COST+REASON_RETURN) else Duel.SendtoGrave(c,REASON_COST) end
end
function c11570010.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsSetCard,tp,LOCATION_HAND,0,1,e:GetHandler(),0x810) and (Duel.IsExistingMatchingCard(nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) and Duel.GetTurnPlayer()~=tp or Duel.IsExistingMatchingCard(Card.IsSetCard,tp,LOCATION_DECK,0,1,nil,0x810) and Duel.GetTurnPlayer()==tp) end
end
function c11570010.desop(e,tp,eg,ep,ev,re,r,rp)
	local dg=Group.CreateGroup()
	if Duel.IsExistingMatchingCard(Card.IsSetCard,tp,LOCATION_HAND,0,1,nil,0x810) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local g1=Duel.SelectMatchingCard(tp,Card.IsSetCard,tp,LOCATION_HAND,0,1,1,nil,0x810)
		dg:Merge(g1)
	end
	if Duel.IsExistingMatchingCard(Card.IsSetCard,tp,LOCATION_DECK,0,1,nil,0x810) and Duel.GetTurnPlayer()==tp then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local g2=Duel.SelectMatchingCard(tp,Card.IsSetCard,tp,LOCATION_DECK,0,1,1,nil,0x810)
		dg:Merge(g2)
	end
	if Duel.IsExistingMatchingCard(nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) and Duel.GetTurnPlayer()~=tp then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local g3=Duel.SelectMatchingCard(tp,nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
		Duel.HintSelection(g3)
		dg:Merge(g3)
	end
	if dg:GetCount()~=2 or Duel.Destroy(dg,REASON_EFFECT)==0 then return end
	local og=Duel.GetOperatedGroup()
	local tg,ct=og:GetMaxGroup(Card.GetLevel)
	if not tg then return end
	Duel.Damage(1-tp,ct*100,REASON_EFFECT)
end
function c11570010.chkfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x3810)
end
function c11570010.matcon(e)
	return not Duel.IsExistingMatchingCard(c11570010.chkfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)
end
function c11570010.fuslimit(e,c,sumtype)
	return sumtype==SUMMON_TYPE_FUSION
end
