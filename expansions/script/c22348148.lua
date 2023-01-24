--地 狱 恶 魔 罪 业 博 士 阿 撒 兹 勒
local m=22348148
local cm=_G["c"..m]
function cm.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(c22348148.splimit)
	c:RegisterEffect(e1)
	--special summon rule
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetCountLimit(1,22348148+EFFECT_COUNT_CODE_OATH)
	e2:SetCondition(c22348148.spcon)
	e2:SetOperation(c22348148.spop)
	c:RegisterEffect(e2)
	--negate
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(22348148,0))
	e3:SetCategory(CATEGORY_DISABLE+CATEGORY_ATKCHANGE)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetTarget(c22348148.ngtg)
	e3:SetOperation(c22348148.ngop)
	c:RegisterEffect(e3)
	if not c22348148.global_flag then
		c22348148.global_flag=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_REMOVE)
		ge1:SetCondition(c22348148.recon)
		ge1:SetOperation(c22348148.regop)
		Duel.RegisterEffect(ge1,0)
	end
	c22348148.onfield_effect=e3
	c22348148.SetCard_diyuemo=true
end
function c22348148.recfilter(c,tp)
	return c:IsControler(tp) and c:IsFaceup() and c:IsSetCard(0x45) and c:IsPreviousControler(tp)
end
function c22348148.recon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tp=c:GetControler()
	return eg:IsExists(c22348148.recfilter,1,e:GetHandler(),tp) and e:GetHandler():IsStatus(STATUS_EFFECT_ENABLED)
end
function c22348148.regop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tp=c:GetControler()
	Duel.RegisterFlagEffect(tp,22348148,0,0,0)
end
function c22348148.splimit(e,se,sp,st)
	return not e:GetHandler():IsLocation(LOCATION_EXTRA)
end
function c22348148.sprfilter(c)
	return c.SetCard_diyuemo and c:IsAbleToRemoveAsCost() and c:IsType(TYPE_MONSTER)
end
function c22348148.sprfilter1(c)
	return c:IsCode(22348147) and c:IsAbleToRemoveAsCost() and c:IsType(TYPE_MONSTER)
end
function c22348148.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local aaa=Duel.GetFlagEffect(tp,22348148)
	if aaa>12 then aaa=12 end
	return 
	(
	(Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(c22348148.sprfilter,tp,LOCATION_GRAVE+LOCATION_MZONE,0,13-aaa,nil) and Duel.IsExistingMatchingCard(c22348148.sprfilter1,tp,LOCATION_GRAVE+LOCATION_MZONE,0,1,nil)) 
	or 
	(Duel.GetLocationCount(tp,LOCATION_MZONE)<1 and Duel.IsExistingMatchingCard(c22348148.sprfilter,tp,LOCATION_MZONE,0,1,nil) and Duel.IsExistingMatchingCard(c22348148.sprfilter,tp,LOCATION_GRAVE+LOCATION_MZONE,0,13-aaa,nil) and Duel.IsExistingMatchingCard(c22348148.sprfilter1,tp,LOCATION_GRAVE+LOCATION_MZONE,0,1,nil))
	or
	(Duel.GetLocationCount(tp,LOCATION_MZONE)<1 and Duel.IsExistingMatchingCard(c22348148.sprfilter1,tp,LOCATION_MZONE,0,1,nil) and Duel.IsExistingMatchingCard(c22348148.sprfilter,tp,LOCATION_GRAVE+LOCATION_MZONE,0,13-aaa,nil)) 
	)
end
function c22348148.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local aaa=Duel.GetFlagEffect(tp,22348148)
	if aaa>12 then aaa=12 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
	local g1=Duel.SelectMatchingCard(tp,c22348148.sprfilter1,tp,LOCATION_GRAVE+LOCATION_MZONE,0,1,1,nil)
	local g2=Duel.SelectMatchingCard(tp,c22348148.sprfilter,tp,LOCATION_GRAVE+LOCATION_MZONE,0,13-aaa,13-aaa,g1)
	local g=Group.__add(g1,g2)
	Duel.Remove(g,POS_FACEUP,REASON_COST) 
	elseif Duel.IsExistingMatchingCard(c22348148.sprfilter1,tp,LOCATION_MZONE,0,1,nil) then
	local g1=Duel.SelectMatchingCard(tp,c22348148.sprfilter1,tp,LOCATION_MZONE,0,1,1,nil)
	local g2=Duel.SelectMatchingCard(tp,c22348148.sprfilter,tp,LOCATION_GRAVE+LOCATION_MZONE,0,13-aaa,13-aaa,g1)
	local g=Group.__add(g1,g2)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
	elseif Duel.IsExistingMatchingCard(c22348148.sprfilter,tp,LOCATION_MZONE,0,1,nil) then
	local g1=Duel.SelectMatchingCard(tp,c22348148.sprfilter1,tp,LOCATION_GRAVE+LOCATION_MZONE,0,1,1,nil)
	local g2=Duel.SelectMatchingCard(tp,c22348148.sprfilter,tp,LOCATION_MZONE,0,1,1,g1)
	local g3=Group.__add(g1,g2)
	local g4=Duel.SelectMatchingCard(tp,c22348148.sprfilter,tp,LOCATION_GRAVE+LOCATION_MZONE,0,12-aaa,12-aaa,g3)
	local g=Group.__add(g3,g4)
	Duel.Remove(g,POS_FACEUP,REASON_COST) end
end
function c22348148.filter(c)
	return c:IsFaceup()
end
function c22348148.ngtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(c22348148.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
end
function c22348148.ngop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectMatchingCard(tp,c22348148.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	local tc=g:GetFirst()
	if tc:IsFaceup() then
		Duel.NegateRelatedChain(tc,RESET_TURN_SET)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetValue(RESET_TURN_SET)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e2)
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE)
		e3:SetRange(LOCATION_MZONE)
		e3:SetCode(EFFECT_IMMUNE_EFFECT)
		e3:SetValue(c22348148.efilter)
		e3:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e3)
		local e4=Effect.CreateEffect(c)
		e4:SetType(EFFECT_TYPE_SINGLE)
		e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e4:SetCode(EFFECT_UPDATE_ATTACK)
		e4:SetValue(2300)
		e4:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e4)
		local e5=Effect.CreateEffect(c)
		e5:SetType(EFFECT_TYPE_SINGLE)
		e5:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e5:SetCode(EFFECT_CANNOT_ATTACK_ANNOUNCE)
		e5:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e5)
		if tc then
		Duel.BreakEffect()
		local rg=Duel.GetDecktopGroup(tp,3)
		Duel.Remove(rg,POS_FACEUP,REASON_EFFECT)
		end
	end
end
function c22348148.efilter(e,te)
	return te:GetOwner()~=e:GetOwner()
end



