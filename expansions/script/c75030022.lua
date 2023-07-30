--苍炎圣骑将 迪亚玛特
function c75030022.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsRace,RACE_PYRO),aux.NonTuner(Card.IsRace,RACE_PYRO),1,1)
	c:EnableReviveLimit()   
	--SpecialSummon
	local e1=Effect.CreateEffect(c) 
	e1:SetType(EFFECT_TYPE_QUICK_O) 
	e1:SetCode(EVENT_FREE_CHAIN) 
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_MZONE) 
	e1:SetCountLimit(1,75030022) 
	e1:SetTarget(c75030022.sptg) 
	e1:SetOperation(c75030022.spop) 
	c:RegisterEffect(e1) 
	--xx
	local e2=Effect.CreateEffect(c) 
	e2:SetType(EFFECT_TYPE_IGNITION) 
	e2:SetRange(LOCATION_MZONE) 
	e2:SetCountLimit(1,15030022+EFFECT_COUNT_CODE_DUEL)
	e2:SetCondition(function(e,tp,eg,ep,ev,re,r,rp) 
	return Duel.GetFlagEffect(tp,75030022)>=6 end)  
	e2:SetTarget(c75030022.xxtg) 
	e2:SetOperation(c75030022.xxop) 
	c:RegisterEffect(e2) 
	if not c75030022.global_check then
		c75030022.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_ATTACK_ANNOUNCE)
		ge1:SetOperation(c75030022.checkop)
		Duel.RegisterEffect(ge1,0) 
	end
end
function c75030022.checkop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetAttacker() 
	if tc:IsSetCard(0x753) then 
		Duel.RegisterFlagEffect(tc:GetControler(),75030022,0,0,1) 
	end
end
function c75030022.spfil(c,e,tp) 
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_ATTACK) and c:IsSetCard(0x753) and Duel.IsExistingMatchingCard(c75030022.espfil,tp,LOCATION_EXTRA,0,1,nil,e,tp,c)  
end 
function c75030022.espfil(c,e,tp,sc) 
	return sc:IsCanBeXyzMaterial(c) and c:IsType(TYPE_XYZ) and c:IsSetCard(0x753) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false) and Duel.GetLocationCountFromEx(tp,tp,mc,c)>0 
end 
function c75030022.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingTarget(c75030022.spfil,tp,LOCATION_GRAVE,0,1,nil,e,tp) end 
	local g=Duel.SelectTarget(tp,c75030022.spfil,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,2,tp,LOCATION_EXTRA)  
end 
function c75030022.spop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) or tc:IsImmuneToEffect(e) then return end
	if Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)==0 then return end
	if not aux.MustMaterialCheck(tc,tp,EFFECT_MUST_BE_XMATERIAL) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sc=Duel.SelectMatchingCard(tp,c75030022.espfil,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,tc):GetFirst()  
	if sc then
		Duel.BreakEffect()
		sc:SetMaterial(Group.FromCards(tc))
		Duel.Overlay(sc,Group.FromCards(tc))
		Duel.SpecialSummon(sc,SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP)
		sc:CompleteProcedure()
	end
end
function c75030022.xxtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end   
	Duel.SetChainLimit(aux.FALSE) 
end 
function c75030022.xxop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	local e1=Effect.CreateEffect(c) 
	e1:SetDescription(aux.Stringid(75030022,1))
	e1:SetType(EFFECT_TYPE_FIELD) 
	e1:SetCode(75030022) 
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT)
	e1:SetTargetRange(1,0) 
	Duel.RegisterEffect(e1,tp) 
	--damage 
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS) 
	e2:SetCode(EVENT_DAMAGE) 
	e2:SetCondition(function(e,tp,eg,ep,ev,re,r,rp) 
	return ep==tp and bit.band(r,REASON_EFFECT)~=0 end) 
	e2:SetOperation(c75030022.xdaop) 
	Duel.RegisterEffect(e2,tp) 
end  
function c75030022.xdaop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,75030022) 
	Duel.Damage(1-tp,ev,REASON_EFFECT) 
end 
  











