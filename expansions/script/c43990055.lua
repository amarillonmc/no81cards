--N公司 准执锤者 辛克莱
local m=43990055
local cm=_G["c"..m]
function cm.initial_effect(c)
	--summon with 3 tribute
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(43990055,0))
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SUMMON_PROC)
	e1:SetCondition(c43990055.ttcon)
	e1:SetOperation(c43990055.ttop)
	e1:SetValue(SUMMON_TYPE_ADVANCE+SUMMON_VALUE_SELF)
	c:RegisterEffect(e1)
	--race
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(0,LOCATION_MZONE)
	e2:SetCode(EFFECT_CHANGE_RACE)
	e2:SetValue(RACE_MACHINE)
	e2:SetCondition(c43990055.sumcon)
	c:RegisterEffect(e2)
	--immune
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetCode(EFFECT_IMMUNE_EFFECT)
	e3:SetRange(LOCATION_MZONE)
	e3:SetValue(c43990055.efilter)
	c:RegisterEffect(e3)
	--negate
 --   local e4=Effect.CreateEffect(c)
 --   e4:SetCategory(CATEGORY_DISABLE+CATEGORY_DESTROY)
--  e4:SetType(EFFECT_TYPE_QUICK_O)
 --   e4:SetCode(EVENT_CHAINING)
 --   e4:SetRange(LOCATION_MZONE)
 --   e4:SetCountLimit(1,43990055)
 --   e4:SetCondition(c43990055.discon)
--  e4:SetTarget(c43990055.distg)
--  e4:SetOperation(c43990055.disop)
--  c:RegisterEffect(e4)

	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e5:SetCode(EVENT_SUMMON_SUCCESS)
	e5:SetProperty(EFFECT_FLAG_DELAY)
	e5:SetOperation(c43990055.spop)
	c:RegisterEffect(e5)
	local e6=e5:Clone()
	e6:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e6)
	--double
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e7:SetCode(EVENT_PRE_BATTLE_DAMAGE)
	e7:SetCondition(c43990055.damcon)
	e7:SetOperation(c43990055.damop)
	c:RegisterEffect(e7)
	
end

function c43990055.damcon(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp and e:GetHandler():GetBattleTarget()~=nil 
		and e:GetHandler():GetBattleTarget():IsRace(RACE_MACHINE)
end
function c43990055.damop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ChangeBattleDamage(ep,ev*2)
end
function c43990055.ctfilter(c)
	return c:IsRace(RACE_MACHINE) and c:IsFaceup()
end
function c43990055.ttcon(e,c,minc)
	if c==nil then return true end
	local tp=c:GetControler()
	local mg=Duel.GetMatchingGroup(c43990055.ctfilter,tp,0,LOCATION_MZONE,nil)
	return minc<=3 and Duel.CheckTribute(c,3,3,mg,1-tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
end
function c43990055.ttop(e,tp,eg,ep,ev,re,r,rp,c)
	local mg=Duel.GetMatchingGroup(c43990055.ctfilter,tp,0,LOCATION_MZONE,nil)
	local g=Duel.SelectTribute(tp,c,3,3 ,mg,1-tp)
	c:SetMaterial(g)
	Duel.Release(g,REASON_SUMMON+REASON_MATERIAL)
end
function c43990055.sumcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_ADVANCE)
end
function c43990055.efilter(e,te)
	return te:IsActiveType(TYPE_TRAP+TYPE_SPELL)
end
function c43990055.discon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=re:GetHandler()
	return not c:IsStatus(STATUS_BATTLE_DESTROYED) and Duel.IsChainDisablable(ev) and ep==1-tp
		and (re:IsActiveType(TYPE_SPELL+TYPE_TRAP) or (rc:IsRace(RACE_MACHINE) and re:IsActiveType(TYPE_MONSTER)))
end
function c43990055.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c43990055.disop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateEffect(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end
function c43990055.spop(e,tp,eg,ep,ev,re,r,rp)
	Debug.Message("全部,都烧掉......") 
	Debug.Message("连同我那令人作呕的一生。") 
end