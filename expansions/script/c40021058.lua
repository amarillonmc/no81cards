--壳骑的急袭
local s,id=GetID()
s.named_with_Shellman=1

function s.Shellman(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_Shellman
end

function s.initial_effect(c)
	aux.AddCodeList(c,40021036)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_DISABLE_SUMMON+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_SUMMON)
	e1:SetCountLimit(1,id)
	e1:SetCondition(s.discon)
	e1:SetTarget(s.distg)
	e1:SetOperation(s.disop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_FLIP_SUMMON)
	c:RegisterEffect(e2)
	local e3=e1:Clone()
	e3:SetCode(EVENT_SPSUMMON)
	c:RegisterEffect(e3)

	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EFFECT_DESTROY_REPLACE)
	e4:SetRange(LOCATION_GRAVE)
	e4:SetCountLimit(1,id+1)
	e4:SetTarget(s.reptg)
	e4:SetValue(s.repval)
	e4:SetOperation(s.repop)
	c:RegisterEffect(e4)
end

function s.discon(e,tp,eg,ep,ev,re,r,rp)
	local b1=Duel.IsExistingMatchingCard(function(c) return c:IsCode(40021036) and c:IsLocation(LOCATION_PZONE) end,tp,LOCATION_PZONE,0,1,nil)
	local b2=Duel.IsExistingMatchingCard(function(c) return s.Shellman(c) and c:IsType(TYPE_LINK) and c:IsFaceup() end,tp,LOCATION_MZONE,0,1,nil)
	return (b1 or b2) and Duel.GetCurrentChain()==0
end

function s.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE_SUMMON,eg,#eg,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,#eg,0,0)
end

function s.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateSummon(eg)
	Duel.Destroy(eg,REASON_EFFECT)
end

function s.repfilter(c,tp)
	if not (c:IsControler(tp) and c:IsLocation(LOCATION_ONFIELD) and c:IsFaceup()) then return false end
	local is_ares = c:IsCode(40021036) and c:IsLocation(LOCATION_PZONE)
	local is_shellman_mon = s.Shellman(c) and c:IsType(TYPE_MONSTER) and c:IsLocation(LOCATION_MZONE)
	return (is_ares or is_shellman_mon) and not c:IsReason(REASON_REPLACE) and c:IsDestructable(e)
end

function s.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToRemove() and eg:IsExists(s.repfilter,1,nil,tp) end
	return Duel.SelectEffectYesNo(tp,c,aux.Stringid(id,1))
end

function s.repval(e,c)
	return s.repfilter(c,e:GetHandlerPlayer())
end

function s.repop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_EFFECT+REASON_REPLACE)
end
