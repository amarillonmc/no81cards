local s,id,o=GetID()
function s.initial_effect(c)
Duel.EnableGlobalFlag(GLOBALFLAG_DETACH_EVENT)
c:EnableReviveLimit()
	--Xyz Summon / 超量召唤
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(1165) --系统内置文本“超量召唤”
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_SPSUMMON_PROC)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetRange(LOCATION_EXTRA)
	e0:SetValue(SUMMON_TYPE_XYZ)
	e0:SetCountLimit(1,id+EFFECT_COUNT_CODE_OATH)
	e0:SetCondition(s.xyzcon)
	e0:SetTarget(s.xyztg)
	e0:SetOperation(s.xyzop)
	c:RegisterEffect(e0)
--remove
local e1=Effect.CreateEffect(c)
e1:SetType(EFFECT_TYPE_FIELD)
e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_IGNORE_RANGE+EFFECT_FLAG_IGNORE_IMMUNE)
e1:SetCode(EFFECT_TO_GRAVE_REDIRECT)
e1:SetRange(LOCATION_MZONE)
e1:SetTarget(s.rmtg)
e1:SetTargetRange(0xff,0xff)
e1:SetValue(LOCATION_REMOVED)
c:RegisterEffect(e1)
--negate activated effect
local e2=Effect.CreateEffect(c)
e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
e2:SetCode(EVENT_CHAIN_SOLVING)
e2:SetRange(LOCATION_MZONE)
e2:SetCondition(s.negcon)
e2:SetOperation(s.negop)
c:RegisterEffect(e2)
--attach
local e3=Effect.CreateEffect(c)
e3:SetDescription(aux.Stringid(id,0))
e3:SetType(EFFECT_TYPE_QUICK_O)
e3:SetCode(EVENT_CHAINING)
e3:SetRange(LOCATION_MZONE)
e3:SetCondition(s.atchcon)
e3:SetCost(s.atchcost)
e3:SetTarget(s.atchtg)
e3:SetOperation(s.atchop)
c:RegisterEffect(e3)
end

--素材过滤器：己方场上的3星怪兽
function s.mfilter(c,xyzc)
	return c:IsFaceup() and c:IsLevel(3) and c:IsCanBeXyzMaterial(xyzc)
end

--素材过滤器：对方墓地的魔法陷阱（视为3星怪兽）
function s.gfilter(c,xyzc)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and not c:IsHasEffect(EFFECT_CANNOT_BE_XYZ_MATERIAL) and c:GetTurnID()==Duel.GetTurnCount() and not c:IsReason(REASON_RETURN)
end

--子集目标检查：检查选中的素材组是否符合要求
function s.xyzcheck(g,tp,xyzc)
	--限制对方墓地的卡最多5张
	if g:FilterCount(Card.IsLocation,nil,LOCATION_GRAVE)>5 then return false end
	--检查是否有足够的额外怪兽区位置（包含将场上怪兽叠放腾出位置的情况）
	return Duel.GetLocationCountFromEx(tp,tp,g,xyzc)>0
end

--超量召唤 Condition
function s.xyzcon(e,c,og,min,max)
	if c==nil then return true end
	if c:IsType(TYPE_PENDULUM) and c:IsFaceup() then return false end
	local tp=c:GetControler()
	local minc=2 --最低素材要求：2只
	local maxc=99 --最高素材要求：无限（受限于场上和墓地数量）
	if min then
		if min>minc then minc=min end
		if max<maxc then maxc=max end
	end
	if maxc<minc then return false end

	local mg=nil
	if og then
		--如果是通过其他卡的效果指定了素材(og)，则只使用og
		mg=og:Filter(s.mfilter,nil,c)
	else
		--通常超量召唤：己方场上3星 + 对方墓地魔陷
		mg=Duel.GetMatchingGroup(s.mfilter,tp,LOCATION_MZONE,0,nil,c)
		local gg=Duel.GetMatchingGroup(s.gfilter,tp,0,LOCATION_GRAVE,nil,c)
		mg:Merge(gg)
	end

	--检查是否有必须作为素材的卡(EFFECT_MUST_BE_XMATERIAL)
	local sg=Duel.GetMustMaterial(tp,EFFECT_MUST_BE_XMATERIAL)
	if sg:IsExists(aux.MustMaterialCounterFilter,1,nil,mg) then return false end
	Duel.SetSelectedCard(sg)
	
	--检查是否存在满足条件的子集
	return mg:CheckSubGroup(s.xyzcheck,minc,maxc,tp,c)
end

--超量召唤 Target
function s.xyztg(e,tp,eg,ep,ev,re,r,rp,chk,c,og,min,max)
	if og and not min then return true end
	local minc=2
	local maxc=99
	if min then
		if min>minc then minc=min end
		if max<maxc then maxc=max end
	end
	
	local mg=nil
	if og then
		mg=og:Filter(s.mfilter,nil,c)
	else
		mg=Duel.GetMatchingGroup(s.mfilter,tp,LOCATION_MZONE,0,nil,c)
		local gg=Duel.GetMatchingGroup(s.gfilter,tp,0,LOCATION_GRAVE,nil,c)
		mg:Merge(gg)
	end

	local sg=Duel.GetMustMaterial(tp,EFFECT_MUST_BE_XMATERIAL)
	Duel.SetSelectedCard(sg)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
	local cancel=Duel.IsSummonCancelable()
	
	--选择素材
	local g=mg:SelectSubGroup(tp,s.xyzcheck,cancel,minc,maxc,tp,c)
	
	if g and g:GetCount()>0 then
		g:KeepAlive()
		e:SetLabelObject(g)
		return true
	else return false end
end

--超量召唤 Operation
function s.xyzop(e,tp,eg,ep,ev,re,r,rp,c,og,min,max)
	if og and not min then
		--处理通过其他效果进行的超量召唤
		local sg=Group.CreateGroup()
		local tc=og:GetFirst()
		while tc do
			local sg1=tc:GetOverlayGroup()
			sg:Merge(sg1)
			tc=og:GetNext()
		end
		Duel.SendtoGrave(sg,REASON_RULE)
		c:SetMaterial(og)
		Duel.Overlay(c,og)
	else
		--处理通常超量召唤
		local mg=e:GetLabelObject()
		local sg=Group.CreateGroup()
		local tc=mg:GetFirst()
		while tc do
			local sg1=tc:GetOverlayGroup()
			sg:Merge(sg1)
			tc=mg:GetNext()
		end
		Duel.SendtoGrave(sg,REASON_RULE)
		c:SetMaterial(mg)
		Duel.Overlay(c,mg)
		mg:DeleteGroup()
	end
end
function s.rmtg(e,c)
return (c:IsLocation(LOCATION_OVERLAY) or c:IsPreviousLocation(LOCATION_OVERLAY))
and c:GetOverlayTarget()==e:GetHandler()
and c:IsType(TYPE_SPELL+TYPE_TRAP)
and c:IsReason(REASON_COST+REASON_SPSUMMON+REASON_EFFECT)
end
function s.negfilter(c,code)
return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsCode(code)
end
function s.negcon(e,tp,eg,ep,ev,re,r,rp)
local c=e:GetHandler()
local rc=re:GetHandler()
return re:IsActiveType(TYPE_SPELL+TYPE_TRAP)
and c:GetOverlayGroup():IsExists(s.negfilter,1,nil,rc:GetCode())
end
function s.negop(e,tp,eg,ep,ev,re,r,rp)
Duel.NegateEffect(ev)
end
function s.atchcon(e,tp,eg,ep,ev,re,r,rp)
return rp==1-tp and re:IsHasType(EFFECT_TYPE_ACTIVATE) and re:IsActiveType(TYPE_SPELL+TYPE_TRAP)
end
function s.atchcost(e,tp,eg,ep,ev,re,r,rp,chk)
if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,3,REASON_COST) end
e:GetHandler():RemoveOverlayCard(tp,3,3,REASON_COST)
end
function s.atchtg(e,tp,eg,ep,ev,re,r,rp,chk)
if chk==0 then return re:GetHandler():IsCanOverlay() and e:GetHandler():IsType(TYPE_XYZ) end
re:GetHandler():CreateEffectRelation(e)
end
function s.atchop(e,tp,eg,ep,ev,re,r,rp)
local c=e:GetHandler()
local tc=re:GetHandler()
if c:IsFaceup() and c:IsRelateToChain()
and tc:IsRelateToChain() and tc:IsCanOverlay() then
tc:CancelToGrave()
Duel.Overlay(c,tc)
end
end