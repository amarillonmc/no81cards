--塔露拉·不死的黑蛇
function c29065573.initial_effect(c)
	c:EnableCounterPermit(0x11ae)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFunFunRep(c,c29065573.fusfilter1,aux.FilterBoolFunction(Card.IsRace,RACE_FIEND),2,99,true) 
	--Damage
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DAMAGE)
	e1:SetType(EFFECT_TYPE_QUICK_F)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,29065573)
	e1:SetCondition(c29065573.discon)
	e1:SetTarget(c29065573.distg)
	e1:SetOperation(c29065573.disop)
	c:RegisterEffect(e1) 
	--
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_CUSTOM+29065573)
	e2:SetCountLimit(1,29000005)
	e2:SetTarget(c29065573.detg)
	e2:SetOperation(c29065573.deop)
	c:RegisterEffect(e2)
	--destroy replace
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EFFECT_DESTROY_REPLACE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetTarget(c29065573.reptg)
	e3:SetOperation(c29065573.repop)
	c:RegisterEffect(e3)
end
function c29065573.fusfilter1(c)
	return c:IsSetCard(0x87af) and c:IsRace(RACE_DRAGON)
end
function c29065573.discon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(Card.IsControler,1,nil,1-tp)
end
function c29065573.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local atk=eg:GetSum(Card.GetBaseAttack)
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(atk)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,atk)
end
function c29065573.disop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Damage(p,d,REASON_EFFECT)
end
function c29065573.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	return true
end
function c29065573.repop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,29065573)
	Duel.RaiseEvent(e:GetHandler(),EVENT_CUSTOM+29065573,e,0,0,tp,0)
end
function c29065573.detg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_MZONE,1,nil) end
	local sg=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,sg,sg:GetCount(),0,0)
end
function c29065573.deop(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_MZONE,nil)
	Duel.Destroy(sg,REASON_EFFECT)
end