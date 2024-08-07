--璞玉雕琢之月神
function c9910070.initial_effect(c)
	--fusion material
	aux.AddFusionProcFun2(c,aux.FilterBoolFunction(Card.IsFusionAttribute,ATTRIBUTE_LIGHT),aux.FilterBoolFunction(Card.IsFusionAttribute,ATTRIBUTE_DARK),true)
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(c9910070.splimit)
	c:RegisterEffect(e1)
	--special summon rule
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetCondition(c9910070.sprcon)
	e2:SetOperation(c9910070.sprop)
	c:RegisterEffect(e2)
	--effect gain
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(9910070,0))
	e3:SetCategory(CATEGORY_POSITION)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetRange(LOCATION_HAND)
	e3:SetCondition(c9910070.setcon)
	e3:SetCost(c9910070.setcost)
	e3:SetTarget(c9910070.settg)
	e3:SetOperation(c9910070.setop)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTargetRange(LOCATION_HAND,0)
	e4:SetTarget(c9910070.eftg)
	e4:SetLabelObject(e3)
	c:RegisterEffect(e4)
	Duel.AddCustomActivityCounter(9910070,ACTIVITY_CHAIN,c9910070.chainfilter)
end
function c9910070.chainfilter(re,tp,cid)
	return not (re:GetHandler():IsRace(RACE_FAIRY) and re:IsActiveType(TYPE_MONSTER)
		and Duel.GetChainInfo(cid,CHAININFO_TRIGGERING_LOCATION)==LOCATION_HAND)
end
function c9910070.splimit(e,se,sp,st)
	return se:IsHasType(EFFECT_TYPE_ACTIONS)
end
function c9910070.sprfilter1(c,sc)
	return c:IsReleasable(REASON_SPSUMMON) and c:IsCanBeFusionMaterial(sc,SUMMON_TYPE_SPECIAL)
		and c:IsFusionAttribute(ATTRIBUTE_LIGHT+ATTRIBUTE_DARK)
end
function c9910070.sprfilter2(g,tp,sc)
	return Duel.GetLocationCountFromEx(tp,tp,g,sc)>0
		and g:IsExists(Card.IsFusionAttribute,1,nil,ATTRIBUTE_LIGHT) and g:IsExists(Card.IsFusionAttribute,1,nil,ATTRIBUTE_DARK)
end
function c9910070.sprcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local g=Duel.GetMatchingGroup(c9910070.sprfilter1,tp,LOCATION_MZONE,0,nil,c)
	return (Duel.GetCustomActivityCount(9910070,tp,ACTIVITY_CHAIN)~=0 or Duel.GetCustomActivityCount(9910070,1-tp,ACTIVITY_CHAIN)~=0)
		and g:CheckSubGroup(c9910070.sprfilter2,2,2,tp,c)
end
function c9910070.sprop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.GetMatchingGroup(c9910070.sprfilter1,tp,LOCATION_MZONE,0,nil,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local sg=g:SelectSubGroup(tp,c9910070.sprfilter2,false,2,2,tp,c)
	c:SetMaterial(sg)
	Duel.Release(sg,REASON_SPSUMMON+REASON_MATERIAL)
end
function c9910070.cfilter(c)
	return c:IsFaceup() and (c:IsLevelAbove(6) or c:IsRankAbove(6))
end
function c9910070.setcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c9910070.cfilter,1,nil)
end
function c9910070.setcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsDiscardable() end
	Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)
end
function c9910070.setfilter(c)
	return c:IsFaceup() and c:IsDefenseAbove(0)
end
function c9910070.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(c9910070.setfilter,tp,0,LOCATION_MZONE,nil)
	local tg=Group.CreateGroup()
	if #g>0 then tg=g:GetMaxGroup(Card.GetDefense):Filter(Card.IsCanTurnSet,nil) end
	if chk==0 then return #tg>0 end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.SetOperationInfo(0,CATEGORY_POSITION,tg,1,0,0)
end
function c9910070.setop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c9910070.setfilter,tp,0,LOCATION_MZONE,nil)
	local tg=Group.CreateGroup()
	if #g>0 then tg=g:GetMaxGroup(Card.GetDefense):Filter(Card.IsCanTurnSet,nil) end
	if #tg>0 then
		if #tg>1 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_POSCHANGE)
			local sg=tg:Select(tp,1,1,nil)
			Duel.HintSelection(sg)
			Duel.ChangePosition(sg,POS_FACEDOWN_DEFENSE)
		else Duel.ChangePosition(tg,POS_FACEDOWN_DEFENSE) end
	end
end
function c9910070.eftg(e,c)
	return c:IsSetCard(0x9951) and c:IsType(TYPE_MONSTER)
end
