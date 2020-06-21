--企鹅物流·术士干员-莫斯提马
function c79029054.initial_effect(c)
   --link summon
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,nil,3,6,c79029054.lcheck) 
	--spsummon condition
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	e0:SetValue(c79029054.splimit)
	c:RegisterEffect(e0)
	--disable spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(79864860,0))
	e1:SetCategory(CATEGORY_DISABLE_SUMMON+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_SPSUMMON)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,79029054)
	e1:SetCondition(c79029054.condition)
	e1:SetTarget(c79029054.target)
	e1:SetOperation(c79029054.operation)
	c:RegisterEffect(e1)
	--cannot target
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e2:SetValue(aux.tgoval)
	c:RegisterEffect(e2)
	--indes
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetValue(1)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	c:RegisterEffect(e4)
	--cannot release
	local e5=e3:Clone()
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCode(EFFECT_UNRELEASABLE_SUM)
	c:RegisterEffect(e5)
	local e6=e3:Clone()
	e6:SetCode(EFFECT_UNRELEASABLE_NONSUM)
	c:RegisterEffect(e6)  
	--remove
	local e7=Effect.CreateEffect(c)
	e7:SetCategory(CATEGORY_NEGATE)
	e7:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e7:SetCode(EVENT_CHAINING)
	e7:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e7:SetRange(LOCATION_MZONE)
	e7:SetCondition(c79029054.discon)
	e7:SetTarget(c79029054.distg)
	e7:SetOperation(c79029054.disop)
	c:RegisterEffect(e7) 
	--damage conversion
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_FIELD)
	e8:SetCode(EFFECT_REVERSE_DAMAGE)
	e8:SetRange(LOCATION_MZONE)
	e8:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e8:SetTargetRange(1,0)
	e8:SetValue(c79029054.rev)
	c:RegisterEffect(e8)
	--Remove and draw
	local e9=Effect.CreateEffect(c)
	e9:SetCategory(CATEGORY_RECOVER)
	e9:SetCode(EVENT_FREE_CHAIN)
	e9:SetType(EFFECT_TYPE_IGNITION)
	e9:SetRange(LOCATION_MZONE)
	e9:SetTarget(c79029054.drtg)
	e9:SetOperation(c79029054.drop)
	e9:SetCountLimit(1,79029054999999)
	c:RegisterEffect(e9)
end
function c79029054.splimit(e,se,sp,st)
	return bit.band(st,SUMMON_TYPE_LINK)==SUMMON_TYPE_LINK 
end
function c79029054.lcheck(g)
	return g:GetClassCount(Card.GetLinkAttribute)==g:GetCount()
end
function c79029054.cfilter(c,tp)
	return c:GetSummonPlayer()==tp and c:IsPreviousLocation(LOCATION_EXTRA)
end
function c79029054.condition(e,tp,eg,ep,ev,re,r,rp)
	return tp~=ep and eg:IsExists(c79029054.cfilter,1,nil,1-tp) and Duel.GetCurrentChain()==0
end
function c79029054.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE_SUMMON,eg,eg:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,eg,eg:GetCount(),0,0)
end
function c79029054.operation(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(c79029054.thfilter,1-tp,LOCATION_DECK,0,nil)
	Duel.NegateSummon(eg)
	Duel.Remove(eg,POS_FACEUP,REASON_EFFECT)
end
function c79029054.discon(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp and not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED)
end
function c79029054.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,eg,1,0,0)
end
function c79029054.disop(e,tp,eg,ep,ev,re,r,rp)
	g=Duel.GetDecktopGroup(1-tp,1)
	Duel.Remove(g,POS_FACEDOWN,REASON_EFFECT)
end
function c79029054.rev(e,re,r,rp,rc)
	local c=e:GetHandler()
	if bit.band(r,REASON_EFFECT+REASON_BATTLE)~=0 and c:GetFlagEffect(79029054)==0 then c:RegisterFlagEffect(79029054,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
		return 0
	end
	return val
end
function c79029054.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetLinkedGroupCount()>0 end
	local gc=e:GetHandler():GetLinkedGroup():FilterCount(aux.TRUE,nil)
	Duel.SetTargetPlayer(tp)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,gc)
end
function c79029054.drop(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	local gc=e:GetHandler():GetLinkedGroup():FilterCount(aux.TRUE,nil)
	local g=Duel.GetDecktopGroup(1-tp,gc)
	if gc>0 then
		Duel.Draw(p,gc,REASON_EFFECT)
		Duel.Remove(g,POS_FACEDOWN,REASON_EFFECT)
	end
end
