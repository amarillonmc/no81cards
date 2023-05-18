--霸王白龙 异色眼辉白龙
function c98940018.initial_effect(c)
	c:SetSPSummonOnce(98940018)
	aux.EnablePendulumAttribute(c,false)
	  --Synchro summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(nil),1)
	c:EnableReviveLimit() 
	--special summon
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_SPSUMMON_PROC)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e3:SetRange(LOCATION_EXTRA) 
	e3:SetValue(SUMMON_TYPE_SYNCHRO)
	e3:SetCondition(c98940018.spcon)
	e3:SetOperation(c98940018.spop)
	c:RegisterEffect(e3)
	--check
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e0:SetCode(EVENT_SPSUMMON_SUCCESS)
	e0:SetCondition(c98940018.regcon)
	e0:SetOperation(c98940018.regop)
	c:RegisterEffect(e0)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_MATERIAL_CHECK)
	e1:SetValue(c98940018.valcheck)
	e1:SetLabelObject(e0)
	c:RegisterEffect(e1)
	--disable
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTargetRange(0,LOCATION_MZONE)
	e4:SetCode(EFFECT_DISABLE)
	e4:SetCondition(c98940018.condition)
	c:RegisterEffect(e4)
	--to pzone
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(98940018,2))
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e5:SetCode(EVENT_DESTROYED)
	e5:SetProperty(EFFECT_FLAG_DELAY)
	e5:SetCondition(c98940018.pencon)
	e5:SetTarget(c98940018.pentg)
	e5:SetOperation(c98940018.penop)
	c:RegisterEffect(e5) 
   --spsummon
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(98940018,0))
	e6:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DESTROY)
	e6:SetType(EFFECT_TYPE_IGNITION)
	e6:SetRange(LOCATION_PZONE)
	e6:SetCountLimit(1)
	e6:SetTarget(c98940018.sptg1)
	e6:SetOperation(c98940018.spop1)
	c:RegisterEffect(e6)
end
function c98940018.rfilter(c,tp)  
	return c:IsSetCard(0x2017) and Duel.CheckReleaseGroup(tp,Card.IsType,1,c,TYPE_TUNER)  
end  
function c98940018.syfilter(c,e)
	return c:IsLevel(8) and c:IsType(TYPE_SYNCHRO)
end
function c98940018.spcon(e,c)  
	if c==nil then return true end  
	local tp=c:GetControler()  
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>-2  
		and Duel.CheckReleaseGroup(tp,c98940018.rfilter,1,nil,tp)  
end  

function c98940018.spop(e,tp,eg,ep,ev,re,r,rp,c)  
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)  
	local g1=Duel.SelectReleaseGroup(tp,c98940018.rfilter,1,1,nil,tp)  
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)  
	local g2=Duel.SelectReleaseGroup(tp,Card.IsType,1,1,g1:GetFirst(),TYPE_TUNER)  
	g1:Merge(g2)  
	e:GetHandler():SetMaterial(g1)
	Duel.SendtoGrave(g1,REASON_MATERIAL+REASON_SYNCHRO)  
end  
function c98940018.regcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_SYNCHRO) and e:GetLabel()==1
end
function c98940018.regop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():RegisterFlagEffect(98940018,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(98940018,2))
end
function c98940018.valcheck(e,c)
	local g=c:GetMaterial()
	if g:IsExists(c98940018.syfilter,1,nil) then
		e:GetLabelObject():SetLabel(1)
	else
		e:GetLabelObject():SetLabel(0)
	end
end
function c98940018.condition(e)
	return e:GetHandler():GetFlagEffect(98940018)>0
end
function c98940018.pencon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(LOCATION_MZONE) and c:IsFaceup()
end
function c98940018.pentg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1) end
end
function c98940018.penop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.MoveToField(c,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
	end
end
function c98940018.spfilter(c,e,tp)
	return c:IsSetCard(0xff,0x2016) and c:IsType(TYPE_SYNCHRO) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_SYNCHRO,tp,false,false)
end
function c98940018.sptg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c98940018.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c98940018.spop1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c98940018.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
	if Duel.Destroy(e:GetHandler(),REASON_EFFECT) and g:GetCount()>0 then
		Duel.SpecialSummon(g,SUMMON_TYPE_SYNCHRO,tp,tp,false,false,POS_FACEUP)
	end
end