--整合运动·宿主领袖·梅菲斯特
function c79020034.initial_effect(c)
	--synchro summon
	aux.AddSynchroMixProcedure(c,aux.Tuner(nil),aux.Tuner(nil),aux.Tuner(nil),aux.NonTuner(nil),1,99)
	c:EnableReviveLimit()
	--special summon rule
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetValue(SUMMON_TYPE_SYNCHRO)
	e1:SetCondition(c79020034.sprcon)
	e1:SetOperation(c79020034.sprop)
	c:RegisterEffect(e1)
	--extra material
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(79020034,0))
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetCondition(c79020034.linkcon)
	e2:SetOperation(c79020034.linkop)
	e2:SetValue(SUMMON_TYPE_XYZ)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e3:SetRange(LOCATION_MZONE+LOCATION_EXTRA)
	e3:SetTargetRange(LOCATION_EXTRA,0)
	e3:SetTarget(c79020034.mattg)
	e3:SetLabelObject(e2)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(79020034,0))
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e4:SetCode(EFFECT_SPSUMMON_PROC)
	e4:SetRange(LOCATION_EXTRA)
	e4:SetCondition(c79020034.linkcon1)
	e4:SetOperation(c79020034.linkop1)
	e4:SetValue(SUMMON_TYPE_XYZ)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e5:SetRange(LOCATION_MZONE+LOCATION_EXTRA)
	e5:SetTargetRange(LOCATION_EXTRA,0)
	e5:SetTarget(c79020034.mattg1)
	e5:SetLabelObject(e4)
	c:RegisterEffect(e5)
	--indes
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD)
	e6:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e6:SetValue(1)
	e6:SetRange(LOCATION_MZONE+LOCATION_EXTRA)
	e6:SetTargetRange(LOCATION_MZONE,0)
	e6:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x3904))
	c:RegisterEffect(e6)
	local e7=e6:Clone()
	e7:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e7:SetValue(aux.tgoval)
	c:RegisterEffect(e7)
	--Recover
	local e8=Effect.CreateEffect(c)
	e8:SetCategory(CATEGORY_RECOVER)
	e8:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e8:SetCode(EVENT_PHASE+PHASE_END)
	e8:SetRange(LOCATION_MZONE+LOCATION_EXTRA)
	e8:SetCountLimit(1)
	e8:SetTarget(c79020034.retg)
	e8:SetOperation(c79020034.reop)
	c:RegisterEffect(e8)
	--spsummon
	local e9=Effect.CreateEffect(c)
	e9:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e9:SetType(EFFECT_TYPE_IGNITION)
	e9:SetRange(LOCATION_MZONE)
	e9:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e9:SetTarget(c79020034.target)
	e9:SetOperation(c79020034.activate)
	c:RegisterEffect(e9)
	--overlay
	local e10=Effect.CreateEffect(c)
	e10:SetType(EFFECT_TYPE_IGNITION)
	e10:SetRange(LOCATION_EXTRA+LOCATION_MZONE)
	e10:SetTarget(c79020034.ovtg)
	e10:SetOperation(c79020034.ovop)
	c:RegisterEffect(e10)
end
function c79020034.lmfilter(c,lc,tp,og,lmat)
	return c:IsFaceup() and c:IsSetCard(0x3900) 
end
function c79020034.linkcon(e,c,og,lmat,min,max)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.IsExistingMatchingCard(c79020034.lmfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c79020034.linkop(e,tp,eg,ep,ev,re,r,rp,c,og,lmat,min,max)
	local mg=Duel.SelectMatchingCard(tp,c79020034.lmfilter,tp,LOCATION_MZONE,0,1,1,nil)
	c:SetMaterial(mg)
		local lg=mg:GetFirst():GetOverlayGroup()
		if lg:GetCount()~=0 then
			Duel.Overlay(c,lg)
		end
	Duel.Overlay(c,mg)
end
function c79020034.mattg(e,c)
	return c:IsCode(79020028)
end
function c79020034.lmfilter1(c,lc,tp,og,lmat)
	return c:IsFaceup() and c:IsSetCard(0x3900) and c:IsType(TYPE_XYZ)
end
function c79020034.linkcon1(e,c,og,lmat,min,max)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.IsExistingMatchingCard(c79020034.lmfilter1,tp,LOCATION_MZONE,0,1,nil)
end
function c79020034.linkop1(e,tp,eg,ep,ev,re,r,rp,c,og,lmat,min,max)
	local mg=Duel.SelectMatchingCard(tp,c79020034.lmfilter1,tp,LOCATION_MZONE,0,1,1,nil)
	c:SetMaterial(mg)
		local lg=mg:GetFirst():GetOverlayGroup()
		if lg:GetCount()~=0 then
			Duel.Overlay(c,lg)
		end
	Duel.Overlay(c,mg)
end
function c79020034.mattg1(e,c)
	return c:IsSetCard(0x3904) and c:IsType(TYPE_XYZ) and not c:IsCode(79020028)
end
function c79020034.sprfilter(c,tp,g,sc)
	return c:IsSetCard(0x3904) and c:GetOverlayCount()>=12
end
function c79020034.sprcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local g=Duel.GetMatchingGroup(c79020034.sprfilter,tp,LOCATION_MZONE,0,nil)
	return Duel.IsExistingMatchingCard(c79020034.sprfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c79020034.sprop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.GetMatchingGroup(c79020034.sprfilter,tp,LOCATION_MZONE,0,nil)
	local tg=g:Select(tp,1,1,nil)
	Duel.SendtoGrave(tg,REASON_MATERIAL+REASON_SYNCHRO)
end
function c79020034.retg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsSetCard,tp,LOCATION_MZONE,0,1,1,nil,0x3904) end
	local g=Duel.GetMatchingGroup(Card.IsSetCard,tp,LOCATION_MZONE,0,1,nil,0x3904)
	local atk=g:GetSum(Card.GetAttack)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,0,0,tp,atk)
end
function c79020034.reop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsSetCard,tp,LOCATION_MZONE,0,1,nil,0x3904)
	local atk=g:GetSum(Card.GetAttack)
	Duel.Recover(tp,atk/2,REASON_EFFECT) 
end
function c79020034.filter(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c79020034.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and c79020034.filter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c79020034.filter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c79020034.filter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c79020034.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
			Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_ADD_SETCODE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetValue(0x3904)
	tc:RegisterEffect(e1)
	tc:RegisterFlagEffect(79020033,0,EFFECT_FLAG_CLIENT_HINT,0,0,aux.Stringid(79020033,4))
	end
end
function c79020034.ovfilter(c,e,tp)
	return c:IsSetCard(0x3904) and c:IsType(TYPE_XYZ)
end
function c79020034.ovfilter2(c,e,tp)
	return c:IsSetCard(0x3904)
end
function c79020034.ovtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and c79020034.ovfilter(chkc,e,tp) end
	if chk==0 then return Duel.IsExistingTarget(c79020034.ovfilter,tp,LOCATION_MZONE,0,1,nil,e,tp) and Duel.IsExistingTarget(c79020034.ovfilter2,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,c79020034.ovfilter,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
end
function c79020034.ovop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
	local g=Duel.SelectMatchingCard(tp,c79020034.ovfilter2,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,5,nil)
	Duel.Overlay(tc,g)
	end
end



