--白垩纪 暴龙兽
local m=91010013
local cm=c91010013
function c91010013.initial_effect(c)
c:SetUniqueOnField(1,0,m)
  --xyz summon
c:EnableReviveLimit()
aux.AddXyzProcedureLevelFree(c,cm.xyzfilter,cm.xyzcheck,2,2,cm.xzfilter,aux.Stringid(m,0),cm.xyzop)
--atk def
local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(cm.atkval)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_UPDATE_DEFENSE)
	e2:SetValue(cm.defval)
	c:RegisterEffect(e2)
--Overlay 
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_LEAVE_FIELD)
	e2:SetProperty(EFFECT_FLAG_DELAY) 
	e2:SetOperation(cm.oper)
	c:RegisterEffect(e2)
--grave summon_special
  local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetCondition(cm.spcon)
	e3:SetTarget(cm.sptg)
	e3:SetCountLimit(1,m)
	e3:SetOperation(cm.spop)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EVENT_REMOVE)
	c:RegisterEffect(e4)
--set label
 local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e5:SetCode(EVENT_LEAVE_FIELD_P)
	e5:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e5:SetOperation(cm.regop)
	e5:SetLabelObject(e3)
	c:RegisterEffect(e5)
end
--xyz Summon
function cm.xyzfilter(c)
return c:IsFaceup() and c:IsRace(RACE_DINOSAUR)
end
function cm.xyzcheck(g)
	return g:GetClassCount(Card.GetLevel)==1
end
function cm.xzfilter(c)
	return c:IsFaceup() and c:IsSummonLocation(LOCATION_GRAVE) and c:IsRace(RACE_DINOSAUR)
end
function cm.xyzop(e,tp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,m)==0 end
	Duel.RegisterFlagEffect(tp,m,RESET_PHASE+PHASE_END,EFFECT_FLAG_OATH,1)
end
--e1
function cm.atkfilter(c)
	return  c:GetAttack()>=0
end
function cm.atkval(e,c)
	local g=e:GetHandler():GetOverlayGroup():Filter(cm.atkfilter,nil)
	return g:GetSum(Card.GetAttack)
end
function cm.deffilter(c)
	return c:GetDefense()>=0
end
function cm.defval(e,c)
	local g=e:GetHandler():GetOverlayGroup():Filter(cm.deffilter,nil)
	return g:GetSum(Card.GetDefense)
end
--e2
function cm.cfilter(c)
return not c:IsType(TYPE_TOKEN) and c:IsCanOverlay() 
end
function cm.oper(e,tp,eg,ep,ev,re,r,rp)
local c=e:GetHandler()
local g=eg:Filter(cm.cfilter,nil,tp)
Duel.Overlay(c,g)
end
--e3
function cm.xyzfilter(c,e)
	return c:IsRace(RACE_DINOSAUR)
end
function cm.regop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ce=c:GetOverlayGroup():Filter(cm.xyzfilter,nil)
	local ct=#ce
	e:GetLabelObject():SetLabel(ct)
end
function cm.spcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsReason(REASON_EFFECT)  and c:IsPreviousControler(tp)
		and c:IsPreviousLocation(LOCATION_ONFIELD) 
end
function cm.spfilter(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and c:IsLocation(LOCATION_GRAVE) and Duel.GetMZoneCount(tp)>0 and c:IsRace(RACE_DINOSAUR)		   
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return  cm.spfilter(chkc) end
	local ct=e:GetLabel()
	if chk==0 then return ct>0 and Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	sg=Duel.SelectTarget(tp,cm.spfilter,tp,LOCATION_GRAVE,0,1,ct,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,sg,sg:GetCount(),tp,LOCATION_GRAVE)
end
function cm.splimit(e,c)
    return  not c:IsRace(RACE_DINOSAUR)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local sg=g:Filter(Card.IsRelateToEffect,nil,e)
	if sg:GetCount()>0 then
		Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
	end
	local e3=Effect.CreateEffect(e:GetHandler())
    e3:SetType(EFFECT_TYPE_FIELD)
    e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e3:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
    e3:SetTargetRange(1,0)
    e3:SetTarget(cm.splimit)
    e3:SetReset(RESET_PHASE+PHASE_END)
    Duel.RegisterEffect(e3,tp)
end

  