--被 呼 唤 者
local m=22348079
local cm=_G["c"..m]
function cm.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,nil,1,1)
	c:EnableReviveLimit()
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_SPSUMMON_PROC)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_SPSUM_PARAM+EFFECT_FLAG_SET_AVAILABLE)
	e0:SetTargetRange(POS_FACEUP,1)
	e0:SetRange(LOCATION_EXTRA)
	e0:SetCondition(c22348079.con)
	e0:SetTarget(c22348079.tg)
	e0:SetOperation(c22348079.op)
	c:RegisterEffect(e0)
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(c22348079.splimit)
	c:RegisterEffect(e1)
	--immune
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_IMMUNE_EFFECT)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(c22348079.efilter)
	c:RegisterEffect(e2)
	--cannot target
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e3:SetCondition(c22348079.tgcon)
	e3:SetValue(aux.tgoval)
	c:RegisterEffect(e3)
	--indes
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_MZONE)
	e3:SetCondition(c22348079.tgcon)
	e4:SetValue(aux.indoval)
	c:RegisterEffect(e4)
	--negate
	local e9=Effect.CreateEffect(c)
	e9:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e9:SetCode(EVENT_CHAINING)
	e9:SetProperty(EFFECT_FLAG_DELAY)
	e9:SetRange(LOCATION_MZONE)
	e9:SetCondition(c22348079.negcon)
	e9:SetOperation(c22348079.negop)
	c:RegisterEffect(e9)
	--Damage
	local e10=Effect.CreateEffect(c)
	e10:SetDescription(aux.Stringid(22348079,1))
	e10:SetCategory(CATEGORY_DAMAGE)
	e10:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e10:SetCode(EVENT_CHAINING)
	e10:SetProperty(EFFECT_FLAG_DELAY)
	e10:SetRange(LOCATION_MZONE)
	e10:SetCondition(c22348079.ddcon)
	e10:SetOperation(c22348079.ddop)
	c:RegisterEffect(e10)
	local e11=Effect.CreateEffect(c)
	e11:SetType(EFFECT_TYPE_SINGLE)
	e11:SetCode(EFFECT_MUST_USE_MZONE)
	e11:SetValue(c22348079.frcval)
	c:RegisterEffect(e11)
end
function c22348079.tgcon(e)
	return e:GetHandler():IsSummonLocation(LOCATION_EXTRA)
end
function c22348079.splimit(e,se,sp,st)
	return not e:GetHandler():IsLocation(LOCATION_EXTRA)
end
function c22348079.frcval(e,c,fp,rp,r)
	return 0x1f001f
end
function c22348079.linkfilter(c,tp)
	return Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0
end
function c22348079.con(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local rg=Duel.GetMatchingGroup(Card.IsReleasable,tp,LOCATION_MZONE,0,nil)
	return rg:CheckSubGroup(c22348079.linkfilter,1,1,tp)
end
function c22348079.tg(e,tp,eg,ep,ev,re,r,rp,chk,c)
	  local rg=Duel.GetMatchingGroup(Card.IsReleasable,tp,LOCATION_MZONE,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local sg=rg:Select(tp,1,1,nil)
	if sg then
		sg:KeepAlive()
		e:SetLabelObject(sg)
		return true
	else return false end
end
function c22348079.op(e,tp,eg,ep,ev,re,r,rp,c)
	local g=e:GetLabelObject()
	Duel.SendtoGrave(g,REASON_COST)
	g:DeleteGroup()
end
function c22348079.efilter(e,te)
	return te:GetOwner()~=e:GetOwner()
end
function c22348079.fuslimit(e,c,sumtype)
	return sumtype==SUMMON_TYPE_FUSION
end
function c22348079.negcon(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp and Duel.GetFlagEffect(tp,22348079)<1
end
function c22348079.filter(c,code)
	return c:IsAbleToRemove() and c:IsCode(code) and c:IsFaceup()
end
function c22348079.negop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.SelectYesNo(tp,aux.Stringid(22348079,0)) then
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CODE)
	Duel.RegisterFlagEffect(tp,22348079,RESET_PHASE+PHASE_END,0,1)
	local nc=Duel.AnnounceCard(tp)
	local g=Duel.GetMatchingGroup(c22348079.filter,tp,0,LOCATION_ONFIELD+LOCATION_GRAVE,nil,nc)
	local c=e:GetHandler()
	local tc=g:GetFirst()
	if tc and Duel.Remove(g,POS_FACEDOWN,REASON_EFFECT)~=0 and tc:IsLocation(LOCATION_REMOVED) then
		Duel.NegateRelatedChain(tc,RESET_CHAIN)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetTargetRange(LOCATION_ONFIELD+LOCATION_REMOVED,LOCATION_ONFIELD+LOCATION_REMOVED)
		e1:SetTarget(c22348079.distg1)
		e1:SetLabelObject(tc)
		Duel.RegisterEffect(e1,tp)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e2:SetCode(EVENT_CHAIN_SOLVING)
		e2:SetCondition(c22348079.discon)
		e2:SetOperation(c22348079.disop)
		e2:SetLabelObject(tc)
		Duel.RegisterEffect(e2,tp)
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_FIELD)
		e3:SetCode(EFFECT_DISABLE_TRAPMONSTER)
		e3:SetTargetRange(LOCATION_MZONE+LOCATION_REMOVED,LOCATION_MZONE+LOCATION_REMOVED)
		e3:SetTarget(c22348079.distg2)
		e3:SetLabelObject(tc)
		Duel.RegisterEffect(e3,tp)
end
end
end
function c22348079.distg1(e,c)
	local tc=e:GetLabelObject()
	if c:IsType(TYPE_SPELL+TYPE_TRAP) then
		return c:IsOriginalCodeRule(tc:GetOriginalCodeRule())
	else
		return c:IsOriginalCodeRule(tc:GetOriginalCodeRule()) and (c:IsType(TYPE_EFFECT) or c:GetOriginalType()&TYPE_EFFECT~=0)
	end
end
function c22348079.distg2(e,c)
	local tc=e:GetLabelObject()
	return c:IsOriginalCodeRule(tc:GetOriginalCodeRule())
end
function c22348079.discon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	return re:GetHandler():IsOriginalCodeRule(tc:GetOriginalCodeRule())
end
function c22348079.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateEffect(ev)
end
function c22348079.ddcon(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp
end
function c22348079.ddop(e,tp,eg,ep,ev,re,r,rp)
		Duel.SetLP(1-tp,math.ceil(Duel.GetLP(1-tp)-500))
end












