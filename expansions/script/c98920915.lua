--巨神马达
--马达
local s,id,o=GetID()
function s.initial_effect(c)
	aux.AddCodeList(c,82556059)
	--①：特殊召唤
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,id,EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(s.spcon)
	e1:SetTarget(s.sptg)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)
	--②：特殊召唤衍生物
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,{id,1})
	e2:SetCost(s.tkcost)
	e2:SetTarget(s.tktg)
	e2:SetOperation(s.tkop)
	c:RegisterEffect(e2)
	--③：破坏相同纵列的卡
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,2))
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetTarget(s.destg)
	e3:SetOperation(s.desop)
	c:RegisterEffect(e3)
end

--①的效果实现
function s.spfilter(c,tp)
	return (c:IsCode(82556059) or aux.IsCodeListed(c,82556059))
		and c:IsReleasable() and Duel.GetMZoneCount(tp,c)>0
end
function s.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.CheckReleaseGroup(tp,s.spfilter,1,nil,c,tp)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.SelectReleaseGroup(tp,s.spfilter,1,1,nil,c,tp)
	if g then
		g:KeepAlive()
		e:SetLabelObject(g)
		return true
	end
	return false
end
function s.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=e:GetLabelObject()
	if not g then return end
	Duel.Release(g,REASON_COST)
	g:DeleteGroup()
end

--②的效果实现
function s.tkcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end
function s.tktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,82556059,0,TYPES_TOKEN,200,200,1,RACE_MACHINE,ATTRIBUTE_EARTH) end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,0)
end
function s.tkop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 
		and Duel.IsPlayerCanSpecialSummonMonster(tp,82556059,0,TYPES_TOKEN,200,200,1,RACE_MACHINE,ATTRIBUTE_EARTH) then
		local token=Duel.CreateToken(tp,82556059)
		Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP_ATTACK)
	end
end

--③的效果实现
function s.cfilter(c)
	return c:IsFaceup() and c:IsCode(82556059)
end
function s.desfilter(c,cg)
	return cg:IsExists(function(tc) return c:GetColumnGroup():IsContains(tc) end,1,nil)
end
function s.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then 
		local cg=Duel.GetMatchingGroup(s.cfilter,tp,LOCATION_MZONE,0,nil)
		return #cg>0 and Duel.IsExistingMatchingCard(s.desfilter,tp,0,LOCATION_ONFIELD,1,nil,cg)
	end
	local cg=Duel.GetMatchingGroup(s.cfilter,tp,LOCATION_MZONE,0,nil)
	local g=Duel.GetMatchingGroup(s.desfilter,tp,0,LOCATION_ONFIELD,nil,cg)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,#g,0,0)
end
function s.desop(e,tp,eg,ep,ev,re,r,rp)
	local cg=Duel.GetMatchingGroup(s.cfilter,tp,LOCATION_MZONE,0,nil)
	if #cg==0 then return end
	local g=Duel.GetMatchingGroup(s.desfilter,tp,0,LOCATION_ONFIELD,nil,cg)
	if #g>0 then
		Duel.Destroy(g,REASON_EFFECT)
	end
end
