--电子镭射破坏龙
function c37440930.initial_effect(c)
	--fusion summon
	c:EnableReviveLimit()
	aux.AddFusionProcFunFun(c,aux.FilterBoolFunction(Card.IsRace,RACE_MACHINE),aux.FilterBoolFunction(Card.IsFusionSetCard,0x1093),2,true)
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(aux.fuslimit)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetCondition(c37440930.hspcon)
	e2:SetOperation(c37440930.hspop)
	c:RegisterEffect(e2)
	--destroy
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetTarget(c37440930.destg)
	e2:SetOperation(c37440930.desop)
	c:RegisterEffect(e2)
	--remove
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(37440930,0))
	e3:SetCategory(CATEGORY_REMOVE)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetTarget(c37440930.target)
	e3:SetOperation(c37440930.operation)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EVENT_SUMMON_SUCCESS)
	c:RegisterEffect(e3)
end
function c37440930.hspfilter1(c,tp,sc)
	return (c:IsFusionSetCard(0x93) or c:IsFusionSetCard(0x94)) and c:IsControler(tp) and Duel.GetLocationCountFromEx(tp,tp,c,sc)>0 and c:IsCanBeFusionMaterial(sc,SUMMON_TYPE_SPECIAL) and c:IsAbleToGraveAsCost() and (c:IsType(TYPE_SPELL) or c:IsType(TYPE_TRAP))
end
function c37440930.hspfilter2(c,tp,sc)
	return c:IsFusionSetCard(0x1093) and c:IsControler(tp) and Duel.GetLocationCountFromEx(tp,tp,c,sc)>0 and c:IsCanBeFusionMaterial(sc,SUMMON_TYPE_SPECIAL)
end
function c37440930.hspcon(e,c)
	if c==nil then return true end
	return Duel.CheckReleaseGroup(c:GetControler(),c37440930.hspfilter2,2,nil,c:GetControler(),c) and Duel.IsExistingMatchingCard(c37440930.hspfilter1,c:GetControler(),LOCATION_ONFIELD+LOCATION_HAND,0,1,nil,c:GetControler(),c)
end
function c37440930.hspop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.SelectReleaseGroup(tp,c37440930.hspfilter2,2,2,nil,tp,c)
	local g2=Duel.SelectMatchingCard(tp,c37440930.hspfilter1,tp,LOCATION_ONFIELD+LOCATION_HAND,0,1,1,nil,tp,c)
	local mg=Group.__add(g,g2)
	c:SetMaterial(mg)
	Duel.Release(g,REASON_COST)
	Duel.SendtoGrave(g2,REASON_COST)
end
function c37440930.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,e:GetHandler()) end
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c37440930.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,aux.ExceptThisCard(e))
	if g:GetCount()>0 then
		Duel.Destroy(g,REASON_EFFECT)
	end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_ATTACK)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetTarget(c37440930.ftarget)
	e1:SetLabel(e:GetHandler():GetFieldID())
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c37440930.ftarget(e,c)
	return e:GetLabel()~=c:GetFieldID()
end
function c37440930.filter(c,e,tp,atk)
	return c:IsFaceup() and c:IsControler(1-tp) and c:GetAttack()>atk and c:IsAbleToRemove() and (not e or c:IsRelateToEffect(e))
end
function c37440930.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg:IsExists(c37440930.filter,1,nil,nil,tp,e:GetHandler():GetAttack()) end
	Duel.SetTargetCard(eg)
end
function c37440930.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(c37440930.filter,nil,e,tp,e:GetHandler():GetAttack())
	if g:GetCount()>0 then
		Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
	end
end
