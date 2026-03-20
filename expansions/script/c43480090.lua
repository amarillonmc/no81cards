--被遗忘的研究 十六月的雨
function c43480090.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--special summon
	local e1=Effect.CreateEffect(c) 
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCountLimit(1,43480090)
	e1:SetCondition(c43480090.pspcon)
	e1:SetTarget(c43480090.psptg)
	e1:SetOperation(c43480090.pspop)
	c:RegisterEffect(e1)
	--des 
	local e1=Effect.CreateEffect(c) 
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F) 
	e1:SetCode(EVENT_SUMMON_SUCCESS) 
	e1:SetTarget(c43480090.destg) 
	e1:SetOperation(c43480090.desop) 
	c:RegisterEffect(e1) 
	local e2=e1:Clone() 
	e2:SetCode(EVENT_SPSUMMON_SUCCESS) 
	c:RegisterEffect(e2) 
	--SpecialSummon 
	local e2=Effect.CreateEffect(c) 
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O) 
	e2:SetCode(EVENT_TO_DECK)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,43480091)
	e2:SetCondition(c43480090.expcon)
	e2:SetTarget(c43480090.exptg)
	e2:SetOperation(c43480090.expop)
	c:RegisterEffect(e2) 
	--to hand s
	local e3=Effect.CreateEffect(c) 
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1,4348082)
	e3:SetCondition(c43480090.thscon)
	e3:SetTarget(c43480090.thstg)
	e3:SetOperation(c43480090.thsop)
	c:RegisterEffect(e3)
end
function c43480090.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x3f13)
end
function c43480090.pspcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c43480090.cfilter,tp,LOCATION_MZONE,0,1,nil) or Duel.IsEnvironment(4348070,tp) 
end
function c43480090.psptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c43480090.pspop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then 
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP) 
	end
end
function c43480090.desfil(c,tp) 
	return not (c:IsFaceup() and c:IsSetCard(0x3f13) and c:IsType(TYPE_PENDULUM)) and ((not Duel.IsPlayerAffectedByEffect(tp,43480050) and c:IsControler(tp)) or Duel.IsPlayerAffectedByEffect(tp,43480050) and c:IsControler(1-tp))
end 
function c43480090.destg(e,tp,eg,ep,ev,re,r,rp,chk) 
	local dg=Duel.GetMatchingGroup(c43480090.desfil,tp,LOCATION_MZONE,LOCATION_MZONE,nil,tp)
	if chk==0 then return true end 
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,dg,dg:GetCount(),0,0)
end
function c43480090.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()  
	local p=tp 
	if Duel.IsPlayerAffectedByEffect(tp,4348050) then p=1-tp end 
	local dg=Duel.GetMatchingGroup(c43480090.desfil,p,LOCATION_MZONE,LOCATION_MZONE,nil,tp)
	if dg:GetCount()>0 then 
		Duel.Destroy(dg,REASON_EFFECT)
	end 
end 
function c43480090.expcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsLocation(LOCATION_EXTRA) and e:GetHandler():IsFaceup()
end
function c43480090.exptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCountFromEx(tp,tp,nil,e:GetHandler())>0 and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c43480090.expop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then 
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP) 
	end
end
function c43480090.thscon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetEquipTarget()~=nil 
end
function c43480090.thfil(c) 
	return c:IsAbleToHand() and c:IsSetCard(0x3f13) and c:IsType(TYPE_MONSTER) 
end 
function c43480090.thstg(e,tp,eg,ep,ev,re,r,rp,chk,chkc) 
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c43480090.thfil(chkc) end 
	if chk==0 then return Duel.IsExistingTarget(c43480090.thfil,tp,LOCATION_GRAVE,0,1,nil) end
	local g=Duel.SelectTarget(tp,c43480090.thfil,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,g:GetCount(),0,0)
end
function c43480090.xspfil(c,e,tp) 
	return c:IsSetCard(0x3f13) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) 
end 
function c43480090.thsop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget() 
	if tc:IsRelateToEffect(e) and Duel.SendtoHand(tc,tp,REASON_EFFECT)~=0 and Duel.IsExistingMatchingCard(c43480090.xspfil,tp,LOCATION_HAND,0,1,nil,e,tp)  and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.SelectYesNo(tp,aux.Stringid(43480090,0)) then 
		Duel.BreakEffect()
		local sg=Duel.SelectMatchingCard(tp,c43480090.xspfil,tp,LOCATION_HAND,0,1,1,nil,e,tp) 
		Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP) 
	end 
end 



