--真红眼极炎龙皇
function c79029558.initial_effect(c) 
	--link summon
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkRace,RACE_DRAGON),3,99,c79029558.lcheck)
	c:EnableReviveLimit()
	--rec 
	local e1=Effect.CreateEffect(c) 
	e1:SetCategory(CATEGORY_RECOVER)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCountLimit(1,79029558)
	e1:SetCondition(function(e) 
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK) end)  
	e1:SetTarget(c79029558.rectg)
	e1:SetOperation(c79029558.recop)
	c:RegisterEffect(e1)
	--cannot target
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e2:SetValue(aux.tgoval)
	c:RegisterEffect(e2)
	--indes
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetValue(aux.indoval)
	c:RegisterEffect(e3) 
	--negate
	local e2=Effect.CreateEffect(c) 
	e2:SetCategory(CATEGORY_DISABLE+CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL+EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,19029558)
	e2:SetCondition(c79029558.discon) 
	e2:SetTarget(c79029558.distg)
	e2:SetOperation(c79029558.disop)
	c:RegisterEffect(e2)
end
function c79029558.lcheck(g)
	return g:IsExists(Card.IsLinkSetCard,1,nil,0x3b)
end  
function c79029558.tgfil(c) 
	return c:IsSetCard(0x3b) and c:IsType(TYPE_MONSTER) and c:GetAttack()>0 and c:IsAbleToGraveAsCost() 
end 
function c79029558.rectg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c79029558.tgfil,tp,LOCATION_DECK,0,1,nil) end 
	local tc=Duel.SelectMatchingCard(tp,c79029558.tgfil,tp,LOCATION_DECK,0,1,1,nil):GetFirst() 
	Duel.SendtoGrave(tc,REASON_COST) 
	local atk=tc:GetAttack() 
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(atk) 
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,atk)
end
function c79029558.recop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM) 
	Duel.Recover(p,d,REASON_EFFECT)  
end  
function c79029558.discon(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp and not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and Duel.IsChainDisablable(ev)
end 
function c79029558.dspfil(c,e,tp) 
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsSetCard(0x3b)  
end 
function c79029558.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingTarget(c79029558.dspfil,tp,LOCATION_GRAVE,0,1,nil,e,tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end 
	local g=Duel.SelectTarget(tp,c79029558.dspfil,tp,LOCATION_GRAVE,0,1,1,nil,e,tp) 
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,g:GetCount(),0,0) 
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,eg,1,0,0)
end
function c79029558.disop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	local tc=Duel.GetFirstTarget()
	if Duel.NegateEffect(ev) and tc:IsRelateToEffect(e) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then 
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end 
end





