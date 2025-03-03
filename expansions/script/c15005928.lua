local m=15005928
local cm=_G["c"..m]
cm.name="龙芯残机-制动螭玦"
function cm.initial_effect(c)
	c:EnableReviveLimit()
	--material
	aux.AddFusionProcFunFunRep(c,cm.matfilter1,cm.matfilter2,1,63,true)
	--spsummon condition
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	e0:SetValue(aux.fuslimit)
	c:RegisterEffect(e0)
	--immune
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(cm.econ)
	e1:SetValue(cm.efilter)
	c:RegisterEffect(e1)
	--des
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,1))
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_BE_BATTLE_TARGET)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(cm.descon1)
	e2:SetTarget(cm.destg)
	e2:SetOperation(cm.desop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_BECOME_TARGET)
	e3:SetCondition(cm.descon2)
	c:RegisterEffect(e3)
	--disable
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(m,2))
	e4:SetCategory(CATEGORY_DISABLE)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_CHAINING)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1)
	e4:SetCondition(cm.discon)
	e4:SetTarget(cm.distg)
	e4:SetOperation(cm.disop)
	c:RegisterEffect(e4)
	if not cm.global_check then
		cm.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_CHAINING)
		ge1:SetOperation(cm.regop)
		Duel.RegisterEffect(ge1,0)
	end
end
function cm.regop(e,tp,eg,ep,ev,re,r,rp)
	Duel.RegisterFlagEffect(rp,m,RESET_CHAIN,0,1)
end
function cm.matfilter1(c)
	return c:IsSetCard(0x9f43) and c:IsType(TYPE_FUSION+TYPE_XYZ)
end
function cm.matfilter2(c)
	return c:IsType(TYPE_EFFECT)
end
function cm.cfilter2(c)
	return c:IsType(TYPE_XYZ) and c:IsFaceup()
end
function cm.econ(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return Duel.IsExistingMatchingCard(cm.cfilter2,tp,LOCATION_MZONE,0,1,nil) and c:IsSummonType(SUMMON_TYPE_FUSION) and c:GetMaterialCount()>=3
end
function cm.efilter(e,re)
	return e:GetHandlerPlayer()~=re:GetOwnerPlayer()
end
function cm.descon1(e,tp,eg,ep,ev,re,r,rp)
	local bc=eg:GetFirst()
	return bc:IsSetCard(0x9f43) and bc:IsControler(tp)
end
function cm.cfilter3(c,tp)
	return c:IsFaceup() and c:IsControler(tp) and c:IsLocation(LOCATION_MZONE) and c:IsSetCard(0x9f43)
end
function cm.descon2(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp and eg:IsExists(cm.cfilter3,1,nil,tp)
end
function cm.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(nil,tp,0,LOCATION_MZONE,nil)
	if chk==0 then return #g>0 end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function cm.desop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,nil,tp,0,LOCATION_MZONE,1,1,nil)
	if g:GetCount()>0 then
		Duel.HintSelection(g)
		Duel.Destroy(g,REASON_EFFECT)
	end
end
function cm.discon(e,tp,eg,ep,ev,re,r,rp)
	for i=1,ev do
		if ((not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED)) and Duel.IsChainDisablable(i)) and Duel.GetFlagEffect(tp,m)>0 then
			return true
		end
	end
	return false
end
function cm.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local ng=Group.CreateGroup()
	for i=1,ev do
		local te,tgp=Duel.GetChainInfo(i,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_PLAYER)
		if ((not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED)) and Duel.IsChainDisablable(i)) and Duel.GetFlagEffect(tp,m)>0 then
			local tc=te:GetHandler()
			ng:AddCard(tc)
		end
	end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,ng,ng:GetCount(),0,0)
end
function cm.disop(e,tp,eg,ep,ev,re,r,rp)
	local dg=Group.CreateGroup()
	for i=1,ev do
		Duel.NegateEffect(i)
	end
end