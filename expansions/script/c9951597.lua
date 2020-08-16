--令迦
function c9951597.initial_effect(c)
	 c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,aux.FilterBoolFunction(Card.IsFusionSetCard,0x9bd1),11,true)
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(c9951597.splimit)
	c:RegisterEffect(e1)
--cannot link material
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	--cannot release
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_UNRELEASABLE_SUM)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_UNRELEASABLE_NONSUM)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e3:SetCode(EFFECT_CANNOT_BE_FUSION_MATERIAL)
	e3:SetValue(c9951597.fuslimit)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
	e4:SetValue(1)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
	e5:SetValue(1)
	c:RegisterEffect(e5)
 --control
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_CANNOT_CHANGE_CONTROL)
	c:RegisterEffect(e1)
 --immune
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_IMMUNE_EFFECT)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetValue(c9951597.efilter)
	c:RegisterEffect(e3)
	--activate limit
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetCode(EFFECT_CANNOT_ACTIVATE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(0,1)
	e3:SetCondition(c9951597.actcon)
	e3:SetValue(c9951597.actlimit)
	c:RegisterEffect(e3)
--act limit
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(9951597,1))
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e5:SetCode(EVENT_SPSUMMON_SUCCESS)
	e5:SetProperty(EFFECT_FLAG_DELAY)
	e5:SetCondition(c9951597.limcon)
	e5:SetTarget(c9951597.limtg)
	e5:SetOperation(c9951597.limop)
	c:RegisterEffect(e5)
   local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_ADJUST)
	e4:SetRange(LOCATION_MZONE)
	e4:SetOperation(c9951597.op)
	c:RegisterEffect(e4)
	c9951597[e4]={}
 --spsummon bgm
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e8:SetCode(EVENT_SPSUMMON_SUCCESS)
	e8:SetOperation(c9951597.sumsuc)
	c:RegisterEffect(e8)
	local e9=e8:Clone()
	e9:SetCode(EVENT_SUMMON_SUCCESS)
	c:RegisterEffect(e9)
end
function c9951597.sumsuc(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_MUSIC,0,aux.Stringid(9951597,0))
end
function c9951597.splimit(e,se,sp,st)
	return not e:GetHandler():IsLocation(LOCATION_EXTRA) or bit.band(st,SUMMON_TYPE_FUSION)==SUMMON_TYPE_FUSION
end
function c9951597.fuslimit(e,c,sumtype)
	return sumtype==SUMMON_TYPE_FUSION
end
function c9951597.efilter(e,te)
	return te:GetOwner()~=e:GetOwner()
end
function c9951597.actcon(e)
	local ph=Duel.GetCurrentPhase()
	return ph>=PHASE_BATTLE_START and ph<=PHASE_BATTLE
end
function c9951597.actlimit(e,re,tp)
	return re:IsActiveType(TYPE_MONSTER)
end
function c9951597.limcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonLocation()==LOCATION_EXTRA
end
function c9951597.limtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetChainLimit(c9951597.chainlm)
end
function c9951597.chainlm(e,rp,tp)
	return tp==rp
end
function c9951597.limop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(0,1)
	e1:SetValue(c9951597.aclimit2)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c9951597.aclimit2(e,re,tp)
	return re:GetHandler():IsOnField() or re:IsHasType(EFFECT_TYPE_ACTIVATE)
end
function c9951597.copyfilter(c)
	return not c:IsSetCard(0x9bd1) and c:IsType(TYPE_EFFECT) and not c:IsType(TYPE_TRAPMONSTER)
end
function c9951597.gfilter(c,g)
	if not g then return true end
	return not g:IsContains(c)
end
function c9951597.gfilter1(c,g)
	if not g then return true end
	return not g:IsExists(c9951597.gfilter2,1,nil,c:GetOriginalCode())
end
function c9951597.gfilter2(c,code)
	return c:GetOriginalCode()==code
end
function c9951597.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local copyt=c9951597[e]
	local exg=Group.CreateGroup()
	for tc,cid in pairs(copyt) do
		if tc and cid then exg:AddCard(tc) end
	end
	local g=Duel.GetMatchingGroup(c9951597.copyfilter,tp,LOCATION_EXTRA,LOCATION_EXTRA,nil)
	local dg=exg:Filter(c9951597.gfilter,nil,g)
	for tc in aux.Next(dg) do
		c:ResetEffect(copyt[tc],RESET_COPY)
		exg:RemoveCard(tc)
		copyt[tc]=nil
	end
	local cg=g:Filter(c9951597.gfilter1,nil,exg)
	for tc in aux.Next(cg) do
		copyt[tc]=c:CopyEffect(tc:GetOriginalCode(),RESET_EVENT+RESETS_STANDARD,1)
	end
end