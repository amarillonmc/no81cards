--灼祟化胧 灼祟鬼
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
	--接触特召：把自己怪兽区域1张炎属性化胧陷阱怪兽送去墓地
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
	--① 自己场上的化胧怪兽的原本攻守变成2倍
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_SET_BASE_ATTACK)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetTarget(s.atkfilter)
	e3:SetValue(s.atkval)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EFFECT_SET_BASE_DEFENSE)
	e4:SetValue(s.defval)
	c:RegisterEffect(e4)
	--② 效果变成
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(id,0))
	e5:SetType(EFFECT_TYPE_QUICK_O)
	e5:SetCode(EVENT_CHAINING)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCountLimit(1,id)
	e5:SetCondition(s.chcon)
	e5:SetTarget(s.chtg)
	e5:SetOperation(s.chop)
	c:RegisterEffect(e5)
end
function s.matf1(c)
	return c:IsSetCard(0x894)
end
function s.matf2(c)
	return c:IsAttribute(ATTRIBUTE_FIRE)
end
function s.spfilter(c)
	return c:IsType(TYPE_TRAPMONSTER) and c:IsSetCard(0x894) and c:IsAttribute(ATTRIBUTE_FIRE)
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
function s.atkfilter(e,c)
	return c:IsSetCard(0x894)
end
function s.atkval(e,c)
	return c:GetBaseAttack()*2
end
function s.defval(e,c)
	return c:GetBaseDefense()*2
end
function s.chcon(e,tp,eg,ep,ev,re,r,rp)
	local ec=re:GetHandler()
	return rp==tp and re:IsActiveType(TYPE_TRAP) and ec:IsSetCard(0x894) and ec:IsType(TYPE_CONTINUOUS)
		and ec:IsLocation(LOCATION_SZONE)
end
function s.chtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(Card.IsType,1-tp,LOCATION_GRAVE,0,1,nil,TYPE_MONSTER)
			or Duel.IsExistingMatchingCard(Card.IsType,1-tp,LOCATION_GRAVE,0,1,nil,TYPE_SPELL+TYPE_TRAP)
	end
end
function s.chop(e,tp,eg,ep,ev,re,r,rp)
	local g=Group.CreateGroup()
	Duel.ChangeTargetCard(ev,g)
	Duel.ChangeChainOperation(ev,s.repop)
end
function s.repop(e,tp,eg,ep,ev,re,r,rp)
	local rc=e:GetHandler()
	Duel.SendtoGrave(rc,REASON_EFFECT)
	local g=Group.CreateGroup()
	local mg=Duel.GetMatchingGroup(Card.IsType,1-tp,LOCATION_GRAVE,0,nil,TYPE_MONSTER)
	if #mg>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local sg=mg:Select(tp,0,1,nil)
		g:Merge(sg)
	end
	local stg=Duel.GetMatchingGroup(Card.IsType,1-tp,LOCATION_GRAVE,0,nil,TYPE_SPELL+TYPE_TRAP)
	if #stg>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local sg2=stg:Select(tp,0,1,nil)
		g:Merge(sg2)
	end
	if #g>0 then
		Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
	end
end
