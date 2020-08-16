--炽天使兽
function c9951588.initial_effect(c)
	  --fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,c9951588.ffilter,3,true)
 --spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(aux.fuslimit)
	c:RegisterEffect(e1)
 --indes
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e2:SetValue(c9951588.indval)
	c:RegisterEffect(e2)
	--immune
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_IMMUNE_EFFECT)
	e3:SetValue(c9951588.efilter)
	c:RegisterEffect(e3)
   --destroy drawn
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(9951588,0))
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_TO_HAND)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(c9951588.ddcon)
	e3:SetTarget(c9951588.ddtg)
	e3:SetOperation(c9951588.ddop)
	c:RegisterEffect(e3)
	--destroy all
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(9951588,1))
	e4:SetCategory(CATEGORY_DESTROY)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	e4:SetTarget(c9951588.destg)
	e4:SetOperation(c9951588.desop)
	c:RegisterEffect(e4)
--spsummon bgm
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e8:SetCode(EVENT_SPSUMMON_SUCCESS)
	e8:SetOperation(c9951588.sumsuc)
	c:RegisterEffect(e8)
	local e9=e8:Clone()
	e9:SetCode(EVENT_SUMMON_SUCCESS)
	c:RegisterEffect(e9)
end
function c9951588.sumsuc(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_MUSIC,0,aux.Stringid(9951588,0))
end
function c9951588.indval(e,c)
	return not c:IsType(TYPE_NORMAL)
end
function c9951588.efilter(e,te)
	return te:IsActiveType(TYPE_MONSTER) and te:GetOwner()~=e:GetOwner()
end
function c9951588.ffilter(c)
	return c:IsFusionAttribute(ATTRIBUTE_LIGHT) and c:IsRace(RACE_FAIRY)
end
function c9951588.ddcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()~=PHASE_DRAW
end
function c9951588.ddfilter(c,tp)
	return c:IsControler(1-tp) and c:IsPreviousLocation(LOCATION_DECK+LOCATION_GRAVE)
end
function c9951588.ddtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=eg:Filter(c9951588.ddfilter,nil,tp)
	if chk==0 then return g:GetCount()>0 end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c9951588.ddop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local g=eg:Filter(c9951588.ddfilter,nil,tp)
	if g:GetCount()>0 then
		Duel.Destroy(g,REASON_EFFECT)
	end
end
function c9951588.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=Duel.GetFieldGroup(tp,0,LOCATION_ONFIELD)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c9951588.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(tp,0,LOCATION_ONFIELD)
	if g:GetCount()>0 then
		Duel.Destroy(g,REASON_EFFECT)
	end
end