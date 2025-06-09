--欧提努斯
local s,id,o=GetID()
s.MoJin=true
function s.initial_effect(c)
	aux.AddCodeList(c,5012604)
	--synchro summon
	aux.AddSynchroProcedure(c,nil,aux.FilterBoolFunction(Card.IsCode,5012604),1,1)
	c:EnableReviveLimit()
	--cannot special summon
	local e0=Effect.CreateEffect(c)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	e0:SetValue(aux.synlimit)
	c:RegisterEffect(e0)
	--change lp
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(1191)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetCondition(s.tgcon)
	--e1:SetTarget(s.tgtg)
	e1:SetOperation(s.tgop)
	c:RegisterEffect(e1)
	--acn't be attacked
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_CANNOT_BE_BATTLE_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetCondition(s.atkcon)
	e2:SetValue(aux.imval1)
	c:RegisterEffect(e2)
	--immune
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_IMMUNE_EFFECT)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetValue(s.efilter)
	c:RegisterEffect(e3)
	--control
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCode(EFFECT_CANNOT_CHANGE_CONTROL)
	c:RegisterEffect(e5)
	--disable
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD)
	e6:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e6:SetCode(EFFECT_DISABLE)
	e6:SetRange(LOCATION_MZONE)
	e6:SetTargetRange(LOCATION_SZONE,LOCATION_SZONE)
	e6:SetTarget(s.distg)
	c:RegisterEffect(e6)
	--disable
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e7:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e7:SetCode(EVENT_CHAIN_SOLVING)
	e7:SetRange(LOCATION_MZONE)
	e7:SetCondition(s.discon)
	e7:SetOperation(s.disop)
	c:RegisterEffect(e7)
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_FIELD)
	e8:SetCode(EFFECT_CANNOT_ACTIVATE)
	e8:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE)
	e8:SetRange(LOCATION_MZONE)
	e8:SetTargetRange(1,1)
	e8:SetValue(s.elimit)
	c:RegisterEffect(e8)
	--atk/def
	local e9=Effect.CreateEffect(c)
	e9:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e9:SetType(EFFECT_TYPE_SINGLE)
	e9:SetCode(EFFECT_SET_ATTACK_FINAL)
	e9:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e9:SetRange(LOCATION_MZONE)
	e9:SetCondition(s.ndcon)
	e9:SetValue(0)
	c:RegisterEffect(e9)
	local e10=e9:Clone()
	e10:SetCode(EFFECT_SET_DEFENSE_FINAL)
	c:RegisterEffect(e10)
	--CancelToGrave
	local e11=Effect.CreateEffect(c)
	e11:SetDescription(aux.Stringid(id,0))
	e11:SetCategory(CATEGORY_DESTROY+CATEGORY_DAMAGE)
	e11:SetType(EFFECT_TYPE_QUICK_O)
	e11:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e11:SetCode(EVENT_FREE_CHAIN)
	e11:SetRange(LOCATION_MZONE)
	e11:SetCountLimit(1)
	e11:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e11:SetTarget(s.tgetg)
	e11:SetOperation(s.tgeop)
	c:RegisterEffect(e11)
	--
	local e20=Effect.CreateEffect(c)
	e20:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e20:SetType(EFFECT_TYPE_FIELD)
	e20:SetCode(EFFECT_CANNOT_DISEFFECT)
	e20:SetValue(s.effectfilter)
	c:RegisterEffect(e20)
	
	--不能当召唤用素材--
	local e21=Effect.CreateEffect(c)
	e21:SetType(EFFECT_TYPE_SINGLE)
	e21:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE)
	e21:SetRange(LOCATION_MZONE)
	e21:SetCode(EFFECT_UNRELEASABLE_SUM)
	e21:SetValue(1)
	c:RegisterEffect(e21)
	local e12=e21:Clone()
	e12:SetCode(EFFECT_UNRELEASABLE_NONSUM)
	c:RegisterEffect(e12)
	local e13=Effect.CreateEffect(c)
	e13:SetType(EFFECT_TYPE_SINGLE)
	e13:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e13:SetCode(EFFECT_CANNOT_BE_FUSION_MATERIAL)
	e13:SetValue(1)
	c:RegisterEffect(e13)
	local e14=e13:Clone()
	e14:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
	e14:SetValue(1)
	c:RegisterEffect(e14)
	local e15=e14:Clone()
	e15:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
	c:RegisterEffect(e15)
	local e16=e14:Clone()
	e16:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
	c:RegisterEffect(e16)
	--做超量素材时送去墓地
	local e4=Effect.CreateEffect(c)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e4:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e4:SetCode(EVENT_ADJUST)
	e14:SetCountLimit(13,id)
	e4:SetOperation(s.rmop)
	Duel.RegisterEffect(e4,0)
	
	--maintain
	local e17=Effect.CreateEffect(c)
	e17:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e17:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e17:SetCode(EVENT_PHASE+PHASE_END)
	--e17:SetRange(LOCATION_MZONE)
	e17:SetCountLimit(1)
	e17:SetCondition(s.mtcon)
	e17:SetOperation(s.mtop)
	c:RegisterEffect(e17)
end

function s.rmop(e)
	local g=Duel.GetOverlayGroup(0,LOCATION_MZONE,LOCATION_MZONE)
	local tgg=g:Filter(Card.IsCode,nil,id)
	if tgg and #tgg>0 then

		Duel.SendtoGrave(tgg,REASON_EFFECT)
	end
end

function s.ndsfilter(c)
	return c:IsFaceup() and c:IsCode(5012604)
end
function s.mtcon(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsExistingMatchingCard(s.ndsfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) 
end
function s.mtop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not (c:IsAbleToExtra() or c:IsExtraDeckMonster()) then return end
	Duel.SendtoDeck(c,nil,SEQ_DECKTOP,REASON_EFFECT)
end
function s.effectfilter(e,ct)
	local p=e:GetHandler():GetControler()
	local te,tp,loc=Duel.GetChainInfo(ct,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_PLAYER,CHAININFO_TRIGGERING_LOCATION)
	return p==tp and te:GetHandler()==e:GetHandler()
end
function s.tgcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_SYNCHRO)
end
function s.tgfilter(c)
	return c:IsAbleToGrave() and (c:IsFacedown() or not c:IsCode(5012613))
end
function s.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.tgfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	local sg=Duel.GetMatchingGroup(s.tgfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,sg,sg:GetCount(),0,0)
end
function s.tgop(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetMatchingGroup(s.tgfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	if #sg>0 then
		Duel.SendtoGrave(sg,REASON_RULE)
	end
end
function s.cfliter(c)
	return c:IsFaceup() and c:IsCode(5012604)
end
function s.atkcon(e)
	return Duel.IsExistingMatchingCard(s.cfliter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil,POS_FACEDOWN_DEFENSE)
end
function s.efilter(e,te)
	return te:GetOwner()~=e:GetOwner()
end
function s.distg(e,c)
	return c:IsType(TYPE_SPELL)
end
function s.cfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_SPELL)
end
function s.discon(e,tp,eg,ep,ev,re,r,rp)
	local loc=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION)
	local rc=re:GetHandler()
	return rc:IsType(TYPE_SPELL) and loc~=LOCATION_SZONE and loc~=LOCATION_MZONE
end
function s.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateEffect(ev)
end
function s.elimit(e,re,tp)
	local rc=re:GetHandler()
	return rc:IsFacedown() and rc:IsLocation(LOCATION_ONFIELD)
end
function s.tgetg(e,tp,eg,ep,ev,re,r,rp,chk)
	local loc=LOCATION_HAND+LOCATION_ONFIELD+LOCATION_EXTRA+LOCATION_DECK
	if chk==0 then return Duel.GetLP(tp)<=1
		and Duel.IsExistingMatchingCard(aux.TRUE,tp,loc,loc,1,e:GetHandler()) end
	local sg=Duel.GetMatchingGroup(aux.TRUE,tp,loc,loc,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,sg,sg:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,PLAYER_ALL,5000000)
end
function s.tgeop(e,tp,eg,ep,ev,re,r,rp)
	local loc=LOCATION_HAND+LOCATION_ONFIELD+LOCATION_EXTRA+LOCATION_DECK
	local sg=Duel.GetMatchingGroup(aux.TRUE,tp,loc,loc,e:GetHandler())
	if Duel.Destroy(sg,REASON_EFFECT)~=0 then
		Duel.Damage(tp,5000000,REASON_EFFECT,true)
		Duel.Damage(1-tp,5000000,REASON_EFFECT,true)
		Duel.RDComplete()
	end
end
function s.ndcon(e)
	return Duel.GetLP(e:GetHandlerPlayer())>1
end