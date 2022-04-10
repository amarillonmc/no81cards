--古代的战争机械
function c79229526.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcCodeFunRep(c,aux.FilterBoolFunction(Card.IsFusionSetCard,0x7),aux.FilterBoolFunction(Card.IsRace,RACE_MACHINE),2,63,true,true)
	--spsummon
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_SPSUMMON_PROC)
	e0:SetRange(LOCATION_EXTRA)
	e0:SetCondition(c79229526.hspcon)
	e0:SetOperation(c79229526.hspop)
	c:RegisterEffect(e0)
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(aux.fuslimit)
	c:RegisterEffect(e1)
	--multi
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetOperation(c79229526.atkop)
	c:RegisterEffect(e2)
	--actlimit
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetCode(EFFECT_CANNOT_ACTIVATE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(0,1)
	e3:SetValue(c79229526.aclimit)
	e3:SetCondition(c79229526.actcon)
	c:RegisterEffect(e3)
end
function c79229526.aclimit(e,re,tp)
	return re:IsHasType(EFFECT_TYPE_ACTIVATE)
end
function c79229526.actcon(e)
	return Duel.GetAttacker()==e:GetHandler()
end
function c79229526.hspfilter(c,tp,sc)
	return c:IsFusionSetCard(0x7) and c:IsControler(tp) and c:IsCanBeFusionMaterial(sc,SUMMON_TYPE_SPECIAL) and Duel.IsExistingMatchingCard(c79229526.hspfilter2,c:GetControler(),LOCATION_MZONE,LOCATION_MZONE,2,c,c:GetControler(),c,sc)
end
function c79229526.hspfilter2(c,tp,sc,scc)
	local g=Group.FromCards(c,sc)
	return c:IsRace(RACE_MACHINE) and c:IsControler(tp) and Duel.GetLocationCountFromEx(tp,tp,g,scc)>0 and c:IsCanBeFusionMaterial(scc,SUMMON_TYPE_SPECIAL)
end
function c79229526.hspcon(e,c)
	if c==nil then return true end
	return Duel.IsExistingMatchingCard(c79229526.hspfilter,c:GetControler(),LOCATION_MZONE,LOCATION_MZONE,1,nil,c:GetControler(),c)
end
function c79229526.hspop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINTMSG_FMATERIAL,tp,aux.Stringid(79229526,0))
	local g=Duel.SelectReleaseGroup(tp,c79229526.hspfilter,1,1,nil,tp,c)
	Duel.Hint(HINTMSG_FMATERIAL,tp,aux.Stringid(79229526,1))
	local g2=Duel.SelectReleaseGroup(tp,c79229526.hspfilter2,2,63,g:GetFirst(),tp,g:GetFirst(),c)
	g:Merge(g2)
	c:SetMaterial(g)
	Duel.SendtoGrave(g,REASON_COST)
end
function c79229526.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(79229526,2))
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_EXTRA_ATTACK)
	e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
	e1:SetValue(c:GetMaterialCount()-1)
	e1:SetCondition(c79229526.con2)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
	c:RegisterEffect(e1)
	--pierce
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(79229526,3))
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_PIERCE)
	e2:SetProperty(EFFECT_FLAG_CLIENT_HINT)
	e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
	e2:SetCondition(c79229526.con1)
	c:RegisterEffect(e2)
end
function c79229526.cfilter2(c,fc)
	return c:IsLevelAbove(8) and c:IsSetCard(0x7)
end
function c79229526.con1(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetHandler():GetMaterial()
	return g and g:IsExists(c79229526.cfilter2,1,nil)
end
function c79229526.con2(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetHandler():GetMaterial()
	return g and g:IsExists(Card.IsSetCard,1,nil,0x51)
end

