local s,id,o=GetID()
function s.initial_effect(c)
    aux.AddCodeList(c,51397770)
    c:SetSPSummonOnce(id)
    --fusion material
    c:EnableReviveLimit()
	aux.AddFusionProcMix(c,false,true,s.fusfilter1,s.fusfilter2,s.fusfilter3)
    --spsummon condition
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
    e0:SetRange(0x40)
	e0:SetValue(aux.fuslimit)
	c:RegisterEffect(e0)
    --special summon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetValue(aux.fuslimit)
	c:RegisterEffect(e1)
    --special summon rule
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetCondition(s.spcon)
    e2:SetTarget(s.sptg)
	e2:SetOperation(s.spop)
	c:RegisterEffect(e2)
end
function s.fusfilter1(c)
	return c:IsAttribute(ATTRIBUTE_LIGHT)
end
function s.fusfilter2(c)
	return c:IsAttribute(ATTRIBUTE_DARK)
end
function s.fusfilter3(c)
	return c:IsCode(51397770)
end
function s.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.IsExistingMatchingCard(s.spfi1ter,tp,0x04,0x04,1,nil,tp)
end
function s.spfi1ter(c)
	return c:GetEquipGroup():FilterCount(Card.IsCode,nil,51397770)>0
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk,c)
	local g=Duel.GetMatchingGroup(s.spfi1ter,tp,0x04,0x04,nil)
	Duel.Hint(3,tp,500)
	local tc=g:SelectUnselect(nil,tp,false,true,1,1)
	if tc then
		e:SetLabelObject(tc)
		return true
	else return false end
end
function s.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=e:GetLabelObject()
    if g:IsControler(1-tp) then
        local e1=Effect.CreateEffect(c)
	    e1:SetType(EFFECT_TYPE_FIELD)
	    e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	    e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	    e1:SetTargetRange(1,0)
	    e1:SetTarget(s.splimit)
	    Duel.RegisterEffect(e1,tp)
    end
	Duel.Release(g,REASON_SPSUMMON)
end
function s.splimit(e,c)
	return c:IsCode(id)
end