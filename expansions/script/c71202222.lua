--妖醒化胧 妖醒鬼
local s,id,o=GetID()
function s.initial_effect(c)
	--融合素材
	aux.AddFusionProcFun2(c,s.matf1,s.matf2,true)
	--不能作为融合素材
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_CANNOT_BE_FUSION_MATERIAL)
	e0:SetValue(1)
	c:RegisterEffect(e0)
	--接触特召：把自己怪兽区域1张暗属性化胧陷阱怪兽送去墓地
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_SPSUM_PARAM)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetTargetRange(POS_FACEUP,0)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetCondition(s.spcon)
	e2:SetTarget(s.sptg)
	e2:SetOperation(s.spop)
	c:RegisterEffect(e2)
	--① 从墓地把2张化胧永续陷阱盖放
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,0))
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetCountLimit(1,id)
	e3:SetTarget(s.settg)
	e3:SetOperation(s.setop)
	c:RegisterEffect(e3)
	--② 效果变成
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(id,1))
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_CHAINING)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1,id+100)
	e4:SetCondition(s.chcon)
	e4:SetTarget(s.chtg)
	e4:SetOperation(s.chop)
	c:RegisterEffect(e4)
end
function s.matf1(c)
	return c:IsSetCard(0x894)
end
function s.matf2(c)
	return c:IsAttribute(ATTRIBUTE_DARK)
end
function s.spfilter(c)
	return c:IsType(TYPE_TRAPMONSTER) and c:IsSetCard(0x894) and c:IsAttribute(ATTRIBUTE_DARK)
		and c:IsAbleToGraveAsCost()
end
function s.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local g=Duel.GetMatchingGroup(s.spfilter,tp,LOCATION_MZONE,0,nil)
	return #g>0 and Duel.GetLocationCountFromEx(tp,tp,g,c)>0
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk,c)
	local g=Duel.SelectMatchingCard(tp,s.spfilter,tp,LOCATION_MZONE,0,1,1,nil)
	if #g>0 then
		g:KeepAlive()
		e:SetLabelObject(g)
		return true
	end
	return false
end
function s.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=e:GetLabelObject()
	Duel.SendtoGrave(g,REASON_COST)
	g:DeleteGroup()
end
function s.setfilter(c)
	return c:IsSetCard(0x894) and c:IsType(TYPE_TRAP) and c:IsType(TYPE_CONTINUOUS)
		and c:IsSSetable()
end
function s.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>=2
		and Duel.IsExistingMatchingCard(s.setfilter,tp,LOCATION_GRAVE,0,2,nil) end
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,nil,2,tp,LOCATION_GRAVE)
end
function s.setop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<2 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local sg=Duel.SelectMatchingCard(tp,s.setfilter,tp,LOCATION_GRAVE,0,2,2,nil)
	if #sg==2 then
		Duel.SSet(tp,sg)
	end
end
function s.chcon(e,tp,eg,ep,ev,re,r,rp)
	local ec=re:GetHandler()
	return rp==tp and re:IsActiveType(TYPE_TRAP) and ec:IsSetCard(0x894) and ec:IsType(TYPE_CONTINUOUS)
		and ec:IsLocation(LOCATION_SZONE)
end
function s.chtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.OR(Card.IsAbleToHand,Card.IsAbleToExtra),tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
end
function s.chop(e,tp,eg,ep,ev,re,r,rp)
	local g=Group.CreateGroup()
	Duel.ChangeTargetCard(ev,g)
	Duel.ChangeChainOperation(ev,s.repop)
end
function s.repop(e,tp,eg,ep,ev,re,r,rp)
	local rc=e:GetHandler()
	Duel.SendtoGrave(rc,REASON_EFFECT)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectMatchingCard(tp,aux.OR(Card.IsAbleToHand,Card.IsAbleToExtra),tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	if #g>0 then
		Duel.HintSelection(g)
		Duel.SendtoHand(g,nil,REASON_EFFECT)
	end
end
