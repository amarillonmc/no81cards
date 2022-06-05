--虚妄之心罪·格雷特
function c29010401.initial_effect(c) 
	--sp 
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(29010401,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_BATTLE_DAMAGE)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCondition(c29010401.spcon)
	e1:SetTarget(c29010401.sptg)
	e1:SetOperation(c29010401.spop)
	c:RegisterEffect(e1) 
	--sp 2 
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_LEAVE_FIELD)
	e2:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e2:SetCountLimit(1,29010401)
	e2:SetCondition(c29010401.xspcon)
	e2:SetTarget(c29010401.xsptg)
	e2:SetOperation(c29010401.xspop)
	c:RegisterEffect(e2)
end
function c29010401.spcon(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp
end
function c29010401.spfil(c,e,tp) 
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsSetCard(0x7a1) and not c:IsCode(29010401) 
end 
function c29010401.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c29010401.spfil,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)  
end
function c29010401.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	local g=Duel.GetMatchingGroup(c29010401.spfil,tp,LOCATION_DECK,0,nil,e,tp)
	if g:GetCount()>0 then 
	local sg=g:Select(tp,1,1,nil) 
	Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
	end 
end 
function c29010401.cfilter(c,tp,rp)
	return c:IsPreviousControler(tp) and bit.band(c:GetPreviousTypeOnField(),TYPE_MONSTER)~=0
		and c:IsPreviousSetCard(0x7a1) and not c:IsPreviousSetCard(0x17a1) and (c:IsReason(REASON_BATTLE) or (rp==1-tp and c:IsReason(REASON_EFFECT)))
end
function c29010401.xspcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c29010401.cfilter,1,nil,tp,rp) and not eg:IsContains(e:GetHandler())
end
function c29010401.xsptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_ATTACK) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c29010401.xspop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
	Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP_ATTACK)
	end
end











