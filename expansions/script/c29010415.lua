--虚妄之心罪·智神之法典
function c29010415.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,nil,2,99,c29010415.lcheck)
	c:EnableReviveLimit() 
	--xyz 
	local e0=Effect.CreateEffect(c) 
	e0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS) 
	e0:SetCode(EVENT_CHAINING) 
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetRange(LOCATION_EXTRA) 
	e0:SetCondition(c29010415.lkcon) 
	e0:SetOperation(c29010415.lkop) 
	c:RegisterEffect(e0)
	--down and sp 
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(29010415,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_BATTLE_DAMAGE)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCondition(c29010415.dpcon)
	e1:SetTarget(c29010415.dptg)
	e1:SetOperation(c29010415.dpop)
	c:RegisterEffect(e1)  
	c29010415.battle_effect=e1
	--  
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_TRIGGER)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(0,LOCATION_MZONE)
	e2:SetTarget(c29010415.actg)
	e2:SetValue(1)
	c:RegisterEffect(e2) 
	if not c29010415.global_check then
		c29010415.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_BATTLE_CONFIRM)
		ge1:SetOperation(c29010415.checkop)
		Duel.RegisterEffect(ge1,0)
	end 
end
function c29010415.checkop(e,tp,eg,ep,ev,re,r,rp)
	local a,b=Duel.GetBattleMonster(tp) 
	if a then a:RegisterFlagEffect(29010415,RESET_EVENT+RESETS_STANDARD,0,1) end 
	if b then b:RegisterFlagEffect(29010415,RESET_EVENT+RESETS_STANDARD,0,1) end 
end
function c29010415.lkcon(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler()
	local rc=re:GetOwner() 
	local ph=Duel.GetCurrentPhase() 
	return (ph>=PHASE_BATTLE_START and ph<=PHASE_BATTLE) and Duel.GetFlagEffect(tp,29010415)==0 and rc:IsSetCard(0x7a1) and rp==tp and g:GetCount()>=2 and c:IsLinkSummonable(nil) 
end 
function c29010415.lkop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	if Duel.GetFlagEffect(tp,29010415)==0 and Duel.SelectYesNo(tp,aux.Stringid(29010415,0)) then 
	Duel.RegisterFlagEffect(tp,29010415,RESET_PHASE+PHASE_END,0,1)
	Duel.LinkSummon(tp,c,nil) 
	end 
end 
function c29010415.lcheck(g)
	return g:IsExists(Card.IsLinkSetCard,1,nil,0x7a1)
end
function c29010415.dpcon(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp
end 
function c29010415.dptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsFaceup,tp,0,LOCATION_MZONE,1,nil) end
end 
function c29010415.spfil(c,e,tp) 
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsSetCard(0x7a1)
end 
function c29010415.dpop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()  
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,1,nil)
	if g:GetCount()>0 then 
	local tc=g:GetFirst() 
	while tc do 
	local e1=Effect.CreateEffect(c) 
	e1:SetType(EFFECT_TYPE_SINGLE)  
	e1:SetCode(EFFECT_UPDATE_ATTACK) 
	e1:SetRange(LOCATION_MZONE) 
	e1:SetValue(c:GetAttack())
	e1:SetReset(RESET_EVENT+RESETS_STANDARD) 
	tc:RegisterEffect(e1) 
	local e2=e1:Clone() 
	e2:SetCode(EFFECT_UPDATE_DEFENSE) 
	tc:RegisterEffect(e2) 
	tc=g:GetNext()
	end  
	if Duel.IsExistingMatchingCard(c29010415.spfil,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.SelectYesNo(tp,aux.Stringid(29010415,1)) then 
	local sg=Duel.SelectMatchingCard(tp,c29010415.spfil,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil) 
	Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
	end 
	end 
end 
function c29010415.actg(e,c)
	return c:GetFlagEffect(29010415)==0 
end








