--被遗忘的研究 星空的伪物
function c4348020.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--special summon
	local e1=Effect.CreateEffect(c) 
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCountLimit(1,4348020)
	e1:SetCondition(c4348020.pspcon)
	e1:SetTarget(c4348020.psptg)
	e1:SetOperation(c4348020.pspop)
	c:RegisterEffect(e1)
	--des 
	local e1=Effect.CreateEffect(c) 
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F) 
	e1:SetCode(EVENT_SUMMON_SUCCESS) 
	e1:SetTarget(c4348020.destg) 
	e1:SetOperation(c4348020.desop) 
	c:RegisterEffect(e1) 
	local e2=e1:Clone() 
	e2:SetCode(EVENT_SPSUMMON_SUCCESS) 
	c:RegisterEffect(e2) 
	--hand link
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetCode(EFFECT_EXTRA_LINK_MATERIAL)
	e2:SetRange(LOCATION_HAND)
	e2:SetCountLimit(1,4348021)
	e2:SetValue(c4348020.matval)
	c:RegisterEffect(e2)
	--SpecialSummon 
	local e3=Effect.CreateEffect(c) 
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_IGNITION)  
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1,4348022) 
	e3:SetCondition(function(e) 
	return e:GetHandler():GetEquipTarget()~=nil end)
	e3:SetTarget(c4348020.sptg)
	e3:SetOperation(c4348020.spop)
	c:RegisterEffect(e3)
end
function c4348020.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x3f13)
end
function c4348020.pspcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c4348020.cfilter,tp,LOCATION_MZONE,0,1,nil) or Duel.IsEnvironment(4348070,tp) 
end
function c4348020.psptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c4348020.pspop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then 
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)  
	end
end
function c4348020.desfil(c) 
	return not (c:IsFaceup() and c:IsSetCard(0x3f13) and c:IsType(TYPE_PENDULUM))  
end 
function c4348020.destg(e,tp,eg,ep,ev,re,r,rp,chk) 
	local dg=Duel.GetMatchingGroup(c4348020.desfil,tp,LOCATION_MZONE,0,nil)
	if chk==0 then return true end 
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,dg,dg:GetCount(),0,0)
end
function c4348020.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()  
	local p=tp 
	if Duel.IsPlayerAffectedByEffect(tp,4348050) then p=1-tp end 
	local dg=Duel.GetMatchingGroup(c4348020.desfil,p,LOCATION_MZONE,0,nil)
	if dg:GetCount()>0 then 
		Duel.Destroy(dg,REASON_EFFECT)
	end 
end
function c4348020.mfilter(c,tp)
	return c:IsLocation(LOCATION_MZONE) and c:IsSetCard(0x3f13) and c:IsControler(tp)
end
function c4348020.exmfilter(c)
	return c:IsLocation(LOCATION_HAND) and c:IsCode(4348020)
end
function c4348020.matval(e,lc,mg,c,tp)
	if not lc:IsSetCard(0x3f13) then return false,nil end
	return true,not mg or mg:IsExists(c4348020.mfilter,1,nil,tp) and not mg:IsExists(c4348020.exmfilter,1,nil)
end
function c4348020.spfil(c,e,tp) 
	return c:IsFaceup() and c:GetOriginalType()&TYPE_PENDULUM ~= 0 and c:IsSetCard(0x3f13) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE)
end 
function c4348020.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc) 
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_SZONE) and c4348020.spfil(chkc,e,tp) and chkc~=e:GetHandler() end 
	if chk==0 then return Duel.IsExistingTarget(c4348020.spfil,tp,LOCATION_SZONE+LOCATION_PZONE,0,1,e:GetHandler(),e,tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end 
	local g=Duel.SelectTarget(tp,c4348020.spfil,tp,LOCATION_SZONE+LOCATION_PZONE,0,1,1,e:GetHandler(),e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,g:GetCount(),0,0)
end
function c4348020.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then 
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
	end 
end  








