--Protoss·不朽者
function c65870080.initial_effect(c)
	--特招
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,65870080+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c65870080.spcon)
	e1:SetTarget(c65870080.sptg)
	e1:SetOperation(c65870080.spop)
	c:RegisterEffect(e1)
	--destroy
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(65870080,0))
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_BATTLE_START)
	e1:SetCondition(c65870080.descon)
	e1:SetTarget(c65870080.destg)
	e1:SetOperation(c65870080.desop)
	c:RegisterEffect(e1)
	--
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e4:SetValue(1)
	c:RegisterEffect(e4)
end

function c65870080.filter(c)
	return c:IsRace(RACE_MACHINE) and Duel.GetMZoneCount(tp,c,tp)>0 and c:IsAbleToDeckOrExtraAsCost() and c:IsFaceupEx()
end
function c65870080.spcon(e,c)
	if c==nil then return true end
	return Duel.IsExistingMatchingCard(c65870080.filter,c:GetControler(),LOCATION_REMOVED+LOCATION_MZONE+LOCATION_GRAVE,0,1,nil)
end
function c65870080.sptg(e,tp,eg,ep,ev,re,r,rp,chk,c)
	local g=Duel.GetMatchingGroup(c65870080.filter,tp,LOCATION_REMOVED+LOCATION_MZONE+LOCATION_GRAVE,0,nil,tp,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local tc=g:SelectUnselect(tc,tp,false,true,1,1)
	if tc then
		e:SetLabelObject(tc)
		return true
	else return false end
end
function c65870080.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=e:GetLabelObject()
	Duel.SendtoDeck(g,nil,2,REASON_SPSUMMON)
end

function c65870080.descon(e,tp,eg,ep,ev,re,r,rp)
	local d=Duel.GetAttackTarget()
	return e:GetHandler()==Duel.GetAttacker() and d and d:IsFaceup() and d:GetAttack()>e:GetHandler():GetAttack()
end
function c65870080.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,Duel.GetAttackTarget(),1,0,0)
end
function c65870080.desop(e,tp,eg,ep,ev,re,r,rp)
	local d=Duel.GetAttackTarget()
	if d:IsRelateToBattle() and d:GetAttack()>e:GetHandler():GetAttack() then
		Duel.Destroy(d,REASON_EFFECT)
	end
end