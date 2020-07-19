--创星的机壳集成 卡巴拉
local m=14090042
local cm=_G["c"..m]
function cm.initial_effect(c)
	--link summon
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkSetCard,0xaa),2,3)
	--extra material
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCondition(cm.linkcon)
	e1:SetOperation(cm.linkop)
	e1:SetValue(SUMMON_TYPE_LINK)
	c:RegisterEffect(e1)
	--immune
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_IMMUNE_EFFECT)
	e2:SetCondition(cm.immcon)
	e2:SetValue(cm.efilter)
	c:RegisterEffect(e2)
	--CopyEffect
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,1))
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e3:SetCost(cm.copycost)
	e3:SetTarget(cm.copytg)
	e3:SetOperation(cm.copyop)
	c:RegisterEffect(e3)
	--destroy replace
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_DESTROY_REPLACE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTarget(cm.desreptg)
	e4:SetValue(cm.desrepval)
	e4:SetOperation(cm.desrepop)
	c:RegisterEffect(e4)
end
function cm.lkfilter(c)
	return not c:IsSetCard(0xaa) or c:IsFacedown()
end
function cm.lmfilter(c,lc,tp,og,lmat)
	return c:IsFaceup() and c:IsCanBeLinkMaterial(lc) and (c:IsLinkCode(20447641) or c:IsSummonType(SUMMON_TYPE_ADVANCE)) and c:IsLinkSetCard(0xaa)
		and Duel.GetLocationCountFromEx(tp,tp,c,lc)>0 and aux.MustMaterialCheck(c,tp,EFFECT_MUST_BE_LMATERIAL)
		and (not og or og:IsContains(c)) and (not lmat or lmat==c)
end
function cm.linkcon(e,c,og,lmat,min,max)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.IsExistingMatchingCard(cm.lmfilter,tp,LOCATION_MZONE,0,1,nil,c,tp,og,lmat)
		and not Duel.IsExistingMatchingCard(cm.lkfilter,tp,LOCATION_MZONE,0,1,nil)
end
function cm.linkop(e,tp,eg,ep,ev,re,r,rp,c,og,lmat,min,max)
	local mg=Duel.SelectMatchingCard(tp,cm.lmfilter,tp,LOCATION_MZONE,0,1,1,nil,c,tp,og,lmat)
	c:SetMaterial(mg)
	Duel.SendtoGrave(mg,REASON_MATERIAL+REASON_LINK)
end
function cm.immcon(e)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function cm.efilter(e,te)
	if te:IsActiveType(TYPE_SPELL+TYPE_TRAP) then return true
	else return te:GetHandler():IsSummonType(SUMMON_TYPE_SPECIAL) and te:IsActiveType(TYPE_EFFECT) and te:IsActivated() and te:GetOwner()~=e:GetOwner() end
end
function cm.copycost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsReleasable,tp,LOCATION_MZONE,LOCATION_MZONE,1,e:GetHandler()) and Duel.IsExistingMatchingCard(cm.copyfilter,tp,LOCATION_DECK,0,1,nil) end
	local cg=Group.CreateGroup()
	local g=Duel.SelectMatchingCard(tp,Card.IsReleasable,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,e:GetHandler())
	local rc=g:GetFirst()
	Duel.Release(rc,REASON_COST)
	if rc and rc:IsLocation(LOCATION_GRAVE) then
		cg:AddCard(rc)
	end
	local g1=Duel.SelectMatchingCard(tp,cm.copyfilter,tp,LOCATION_DECK,0,1,1,nil)
	local tc=g1:GetFirst()
	Duel.SendtoGrave(tc,REASON_COST)
	if tc and tc:IsLocation(LOCATION_GRAVE) then
		cg:AddCard(tc)
	end
	e:SetLabelObject(cg)
	cg:KeepAlive()
end
function cm.copyfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0xaa) and c:IsAbleToGraveAsCost()
end
function cm.copytg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsLocation(LOCATION_MZONE) end
end
function cm.copyop(e,tp,eg,ep,ev,re,r,rp)
	local c,cg=e:GetHandler(),e:GetLabelObject()
	local tc=cg:GetFirst()
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		while tc do
			local code=tc:GetOriginalCodeRule()
			c:CopyEffect(code,RESET_EVENT+RESETS_STANDARD,1)
			tc=cg:GetNext()
		end
	end
end
function cm.repfilter(c,tp)
	return c:IsControler(tp) and c:IsLocation(LOCATION_ONFIELD)
		and c:IsReason(REASON_BATTLE+REASON_EFFECT) and not c:IsReason(REASON_REPLACE)
end
function cm.desreptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return eg:IsExists(cm.repfilter,1,nil,tp)
		and Duel.CheckLPCost(tp,800) end
	return Duel.SelectEffectYesNo(tp,c,96)
end
function cm.desrepval(e,c)
	return cm.repfilter(c,e:GetHandlerPlayer())
end
function cm.desrepop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,1-tp,m)
	Duel.PayLPCost(tp,800)
end