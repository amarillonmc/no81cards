--恶星层
local s,id,o=GetID()
function s.initial_effect(c)
	aux.AddCodeList(c,56099748)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e2:SetRange(LOCATION_SZONE)
	e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(s.immtg)
	e2:SetValue(aux.tgoval)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e3:SetValue(aux.indoval)
	c:RegisterEffect(e3)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetCode(EFFECT_CANNOT_ACTIVATE)
	e3:SetRange(LOCATION_SZONE)
	e3:SetTargetRange(0,1)
	e3:SetValue(s.aclimit)
	c:RegisterEffect(e3)
	local custom_code=aux.RegisterMergedDelayedEvent_ToSingleCard(c,id,EVENT_DESTROYED)
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DAMAGE)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(custom_code)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_PLAYER_TARGET)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1,id)
	e2:SetCondition(s.damcon)
	e2:SetTarget(s.damtg)
	e2:SetOperation(s.damop)
	c:RegisterEffect(e2)
	if not s.global_check then
		s.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD)
		ge1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_IGNORE_RANGE)
		ge1:SetCode(EFFECT_MATERIAL_CHECK)
		ge1:SetValue(s.valcheck)
		Duel.RegisterEffect(ge1,0)
		local ge2=ge1:Clone()
		ge2:SetValue(s.matcheck)
		Duel.RegisterEffect(ge2,0)
	end
end
function s.valcheck(e,c)
	if c:GetMaterial():IsExists(Card.IsCode,1,nil,56099748) then c:RegisterFlagEffect(id,RESET_EVENT+0x4fe0000,0,1) end
end
function s.immtg(e,c)
	return c:IsFaceup() and c:GetFlagEffect(id)>0 and c:IsSummonType(SUMMON_TYPE_FUSION)
end
function s.matcheck(e,c)
	local g=c:GetMaterial()
	local att=0
	for tc in aux.Next(g) do
		att=att|tc:GetFusionAttribute()
	end
	c:RegisterFlagEffect(id+1000,RESET_EVENT+0x4fe0000,0,1,att)
end
function s.lfilter(c)
	return c:IsOriginalCodeRule(89490260) and c:IsSummonType(SUMMON_TYPE_FUSION) and c:IsFaceup()
end
function s.aclimit(e,re,tp)
	local g=Duel.GetMatchingGroup(s.lfilter,tp,LOCATION_MZONE,0,nil)
	local att=0
	for tc in aux.Next(g) do
		att=att|tc:GetFlagEffectLabel(id+1000)
	end
	return re:IsActiveType(TYPE_MONSTER) and re:GetHandler():IsAttribute(att)
end
function s.cfilter(c,tp)
	return c:IsPreviousControler(1-tp) and c:IsType(TYPE_MONSTER) and c:IsPreviousLocation(LOCATION_MZONE) and c:IsReason(REASON_EFFECT) and c:IsFaceup()
end
function s.damcon(e,tp,eg,ep,ev,re,r,rp)
	if not re then return end
	local rc=re:GetHandler()
	return rc:IsAttribute(ATTRIBUTE_DARK) and rc:IsRace(RACE_WARRIOR+RACE_FAIRY) and eg:IsExists(s.cfilter,1,nil,tp)
end
function s.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(1-tp)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,0)
end
function s.damop(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	local sg=eg:Filter(s.cfilter,nil,tp):Select(tp,1,1,nil)
	Duel.HintSelection(sg)
	Duel.Damage(p,sg:GetFirst():GetBaseAttack(),REASON_EFFECT)
end
