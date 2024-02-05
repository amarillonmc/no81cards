--白夜王子的忍者活动 神威
function c75009003.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c) 
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O) 
	e1:SetCode(EVENT_FREE_CHAIN) 
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,75009003)
	e1:SetCondition(c75009003.spcon)
	e1:SetTarget(c75009003.sptg)
	e1:SetOperation(c75009003.spop)
	c:RegisterEffect(e1) 
	--extra att
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_EXTRA_ATTACK)
	e2:SetValue(1)
	c:RegisterEffect(e2)
	--eff 
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(75009003,1)) 
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_ATTACK_ANNOUNCE)
	e3:SetCountLimit(1,15009003)
	e3:SetTarget(c75009003.efftg)
	e3:SetOperation(c75009003.effop)
	c:RegisterEffect(e3) 
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(75009003,1)) 
	e4:SetType(EFFECT_TYPE_QUICK_O) 
	e4:SetCode(EVENT_CHAINING) 
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1,15009003)
	e4:SetCondition(c75009003.effcon)
	e4:SetTarget(c75009003.efftg)
	e4:SetOperation(c75009003.effop)
	c:RegisterEffect(e4)
end 
function c75009003.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)<Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE) 
end
function c75009003.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c75009003.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c75009003.effcon(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp and re:IsActiveType(TYPE_MONSTER)
end 
function c75009003.ctfil(c) 
	return c:IsSetCard(0x75e,0x750) and c:IsType(TYPE_MONSTER) and c:IsLevelAbove(1) and c:IsAbleToGraveAsCost() 
end  
function c75009003.efftg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
	if chk==0 then return Duel.IsExistingMatchingCard(c75009003.ctfil,tp,LOCATION_DECK,0,1,nil) and g:GetCount()>0 end 
	local tc=Duel.SelectMatchingCard(tp,c75009003.ctfil,tp,LOCATION_DECK,0,1,1,nil):GetFirst()
	e:SetLabel(tc:GetLevel()) 
	Duel.SendtoGrave(tc,REASON_COST)  
end  
function c75009003.effop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	local lv=e:GetLabel() 
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil) 
	if g:GetCount()>0 and lv and lv>0 then 
		local tc=g:GetFirst() 
		while tc do 
		local e1=Effect.CreateEffect(c) 
		e1:SetType(EFFECT_TYPE_SINGLE) 
		e1:SetCode(EFFECT_UPDATE_ATTACK) 
		e1:SetRange(LOCATION_MZONE) 
		e1:SetValue(-lv*200) 
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END) 
		tc:RegisterEffect(e1)
		local e1=Effect.CreateEffect(c) 
		e1:SetType(EFFECT_TYPE_SINGLE) 
		e1:SetCode(EFFECT_UPDATE_DEFENSE) 
		e1:SetRange(LOCATION_MZONE) 
		e1:SetValue(-lv*200) 
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END) 
		tc:RegisterEffect(e1)
		tc=g:GetNext() 
		end 
	end 
end 







