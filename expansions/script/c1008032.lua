--罪恶王冠 守墓人
function c1008032.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFun2(c,aux.FilterBoolFunction(Card.IsSetCard,0x320e),aux.FilterBoolFunction(Card.IsSetCard,0x520e),true)
	--spsummon condition
	local e11=Effect.CreateEffect(c)
	e11:SetType(EFFECT_TYPE_SINGLE)
	e11:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e11:SetCode(EFFECT_SPSUMMON_CONDITION)
	e11:SetValue(c1008032.splimit2)
	c:RegisterEffect(e11)
	--special summon rule
	local e22=Effect.CreateEffect(c)
	e22:SetType(EFFECT_TYPE_FIELD)
	e22:SetCode(EFFECT_SPSUMMON_PROC)
	e22:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e22:SetRange(LOCATION_EXTRA)
	e22:SetCondition(c1008032.sprcon)
	e22:SetOperation(c1008032.sprop)
	c:RegisterEffect(e22)
	local g=Group.CreateGroup()
	g:KeepAlive()
	--Negate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_INDESTRUCTABLE_COUNT)
	e1:SetCountLimit(1)
	e1:SetValue(c1008032.effcon1)
	e1:SetLabel(1)
	c:RegisterEffect(e1)
	--draw
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(1008032,3))
	e2:SetCategory(CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetLabel(2)
	e2:SetCountLimit(1)
	e2:SetCondition(c1008032.effcon2)
	e2:SetCost(c1008032.cost2)
	e2:SetTarget(c1008032.drtg)
	e2:SetOperation(c1008032.drop)
	c:RegisterEffect(e2)
	--disable field
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(1008032,4))
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetLabel(3)
	e3:SetCountLimit(1)
	e3:SetCondition(c1008032.effcon3)
	e3:SetOperation(c1008032.disop1)
	c:RegisterEffect(e3)
	--activate limit
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e3:SetCode(EVENT_CHAINING)
	e3:SetRange(LOCATION_MZONE)
	e3:SetLabel(4)
	e3:SetCondition(c1008032.effcon4)
	e3:SetOperation(c1008032.aclimit1)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e4:SetCode(EVENT_CHAIN_NEGATED)
	e4:SetRange(LOCATION_MZONE)
	e4:SetLabel(4)
	e4:SetCondition(c1008032.effcon4)
	e4:SetOperation(c1008032.aclimit2)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetCode(EFFECT_CANNOT_ACTIVATE)
	e5:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e5:SetRange(LOCATION_MZONE)
	e5:SetTargetRange(0,1)
	e5:SetCondition(c1008032.econ)
	e5:SetValue(c1008032.elimit)
	c:RegisterEffect(e5)
	--creat void
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(1008032,1))
	e6:SetCategory(CATEGORY_EQUIP)
	e6:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e6:SetType(EFFECT_TYPE_QUICK_O+EFFECT_TYPE_SINGLE)
	e6:SetCode(1008001)
	e6:SetRange(LOCATION_MZONE)
	e6:SetTarget(c1008032.voidtg)
	e6:SetOperation(c1008032.voidop)
	c:RegisterEffect(e6)
end
function c1008032.splimit2(e,se,sp,st)
	return e:GetHandler():GetLocation()~=LOCATION_EXTRA
end
function c1008032.spfilter1(c,tp)
	return c:IsSetCard(0x320e) and c:IsCanBeFusionMaterial()
		and (Duel.IsExistingMatchingCard(Card.IsSetCard,tp,LOCATION_MZONE,0,1,c,0x520e)
		or Duel.IsExistingMatchingCard(c1008032.spfilter3,tp,LOCATION_SZONE,0,1,c,tp))
end
function c1008032.spfilter3(c,tp)
	return c:IsSetCard(0x520e) and Duel.GetLocationCount(tp,LOCATION_MZONE)>-2
end
function c1008032.sprcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1
		and Duel.IsExistingMatchingCard(c1008032.spfilter1,tp,LOCATION_MZONE,0,1,nil,tp)
end
function c1008032.sprop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g1=Duel.SelectMatchingCard(tp,c1008032.spfilter1,tp,LOCATION_MZONE,0,1,1,nil,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<-1 then
		g2=Duel.SelectMatchingCard(tp,Card.IsSetCard,tp,LOCATION_SZONE,0,1,1,g1:GetFirst(),0x520e)
	else
		g2=Duel.SelectMatchingCard(tp,c1008032.spfilter3,tp,LOCATION_ONFIELD,0,1,1,g1:GetFirst(),tp)
	end
	g1:Merge(g2)
	c:SetMaterial(g1)
	Duel.SendtoGrave(g1,REASON_COST)
end
function c1008032.filtereff1(c,e,tp)
	return c:IsSetCard(0x520e) and c:IsControler(tp)
end
function c1008032.effcon1(e,tp,eg,ep,ev,re,r,rp)
   local g=Duel.GetMatchingGroup(c1008032.filtereff1,e:GetHandlerPlayer(),LOCATION_SZONE,0,nil,e,tp)
	local ct=g:GetClassCount(Card.GetCode)
	return ct>=1
end
function c1008032.effcon2(e,tp,eg,ep,ev,re,r,rp)
   local g=Duel.GetMatchingGroup(c1008032.filtereff1,e:GetHandlerPlayer(),LOCATION_SZONE,0,nil,e,tp)
	local ct=g:GetClassCount(Card.GetCode)
	return ct>=2
end
function c1008032.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,Card.IsSetCard,1,e:GetHandler(),0x320e) end
	local sg=Duel.SelectReleaseGroup(tp,Card.IsSetCard,1,1,e:GetHandler(),0x320e)
	Duel.Release(sg,REASON_COST)
end
function c1008032.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c1008032.drop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
function c1008032.effcon3(e,tp,eg,ep,ev,re,r,rp)
   local g=Duel.GetMatchingGroup(c1008032.filtereff1,e:GetHandlerPlayer(),LOCATION_SZONE,0,nil,e,tp)
	local ct=g:GetClassCount(Card.GetCode)
	return ct>=3
end
function c1008032.disop1(e,tp)
	local ct=Duel.GetLocationCount(1-tp,LOCATION_MZONE)
	if ct==0 then return end
	local c=e:GetHandler()
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_DISABLE_FIELD)
	e3:SetReset(RESET_EVENT+0x1fe0000)
	e3:SetOperation(c1008032.disop)
	c:RegisterEffect(e3,tp)
end
function c1008032.effcon4(e,tp,eg,ep,ev,re,r,rp)
   local g=Duel.GetMatchingGroup(c1008032.filtereff1,e:GetHandlerPlayer(),LOCATION_SZONE,0,nil,e,tp)
	local ct=g:GetClassCount(Card.GetCode)
	return ct>=4
end
function c1008032.disop(e,tp)
	local dis1=Duel.SelectDisableField(tp,1,0,LOCATION_MZONE,0)
	return dis1
end
function c1008032.aclimit1(e,tp,eg,ep,ev,re,r,rp)
	if ep==tp or not re:IsActiveType(TYPE_MONSTER) then return end
	e:GetHandler():RegisterFlagEffect(10080321,RESET_EVENT+0x3ff0000+RESET_PHASE+PHASE_END,0,1)
end
function c1008032.aclimit2(e,tp,eg,ep,ev,re,r,rp)
	if ep==tp or not re:IsActiveType(TYPE_MONSTER) then return end
	e:GetHandler():ResetFlagEffect(10080321)
end
function c1008032.econ(e)
	return e:GetHandler():GetFlagEffect(10080321)~=0
end
function c1008032.elimit(e,te,tp)
	return te:IsActiveType(TYPE_MONSTER)
end
function c1008032.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetHandler():GetFirstCardTarget()
	if tc and tc:IsLocation(LOCATION_ONFIELD) then
		Duel.Destroy(tc,REASON_RULE)
	end
end
function c1008032.descon2(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetHandler():GetFirstCardTarget()
	return tc and eg:IsContains(tc) and re and not re:GetHandler():IsSetCard(0x320e)
end
function c1008032.desop2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Destroy(e:GetHandler(),REASON_RULE)
end
function c1008032.voidfilter(c)
	return c:IsSetCard(0x320e) and c:IsFaceup()
end
function c1008032.voidtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingTarget(c1008032.voidfilter,tp,LOCATION_MZONE,0,1,nil)
		and Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and e:GetHandler():IsLocation(LOCATION_MZONE) and e:GetHandler():IsFaceup() end
	Duel.Hint(8,tp,1008034)
	local g=Duel.SelectTarget(tp,c1008032.voidfilter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c1008032.voidop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<1 or not c:IsRelateToEffect(e) then return end
	if not c:IsLocation(LOCATION_MZONE) or not c:IsFaceup() then return end
	local eqc=Duel.GetFirstTarget()
	if eqc:IsRelateToEffect(e) then
		c:RegisterFlagEffect(10080011,RESET_EVENT+0x1fe0000,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(1008001,4))
		local os=require "os"
		math.randomseed( tonumber(tostring(os.time()):reverse():sub(1,6)) )
		local code = math.random(1008034,1008034)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SELF)
		local g=Group.FromCards(Duel.CreateToken(tp,code))
		local tc=g:GetFirst()
		Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
		Duel.BreakEffect()
		Duel.Equip(tp,tc,eqc,true)
		c:SetCardTarget(tc)
		--Destroy
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
		e2:SetCode(EVENT_LEAVE_FIELD)
		e2:SetOperation(c1008032.desop)
		c:RegisterEffect(e2,true)
		--Destroy2
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
		e3:SetRange(LOCATION_MZONE)
		e3:SetCode(EVENT_LEAVE_FIELD)
		e3:SetCondition(c1008032.descon2)
		e3:SetOperation(c1008032.desop2)
		c:RegisterEffect(e3,true)
	end
end