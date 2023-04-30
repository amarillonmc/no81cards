--星海航线 重生之翼
function c11560710.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,6,3) 
	c:EnableReviveLimit()   
	--battle indes
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e1:SetValue(1) 
	e1:SetLabel(1) 
	e1:SetCondition(c11560710.effcon)
	c:RegisterEffect(e1) 
	--atk up 
	local e2=Effect.CreateEffect(c) 
	e2:SetType(EFFECT_TYPE_SINGLE) 
	e2:SetCode(EFFECT_UPDATE_ATTACK) 
	e2:SetRange(LOCATION_MZONE) 
	e2:SetValue(function(e) 
	return e:GetHandler():GetOverlayCount()*500 end) 
	e2:SetLabel(2) 
	e2:SetCondition(c11560710.effcon)
	c:RegisterEffect(e2) 
	--
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(4550066,0))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_BATTLE_DESTROYING) 
	e3:SetCountLimit(1,11560710)
	e3:SetLabel(3) 
	e3:SetCondition(c11560710.excon)
	e3:SetCost(c11560710.excost)
	e3:SetTarget(c11560710.extg)
	e3:SetOperation(c11560710.exop)
	c:RegisterEffect(e3) 
	--double damage
	--local e5=Effect.CreateEffect(c)
	--e5:SetType(EFFECT_TYPE_SINGLE)
	--e5:SetCode(EFFECT_CHANGE_BATTLE_DAMAGE)
	--e5:SetLabel(4)
	--e5:SetCondition(c11560710.effcon)
	--e5:SetValue(aux.ChangeBattleDamage(1,DOUBLE_DAMAGE))
	--c:RegisterEffect(e5)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetCode(EFFECT_PIERCE) 
	e5:SetLabel(4)
	e5:SetCondition(c11560710.effcon)
	c:RegisterEffect(e5) 
	--disable
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD)
	e6:SetRange(LOCATION_MZONE)
	e6:SetTargetRange(0,LOCATION_MZONE) 
	e6:SetTarget(function(e,c) 
	return c:IsAttackBelow(e:GetHandler():GetAttack()) end)
	e6:SetCode(EFFECT_DISABLE) 
	e6:SetLabel(5)
	e6:SetCondition(c11560710.effcon)
	c:RegisterEffect(e6)
	--cannot target
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_SINGLE)
	e7:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e7:SetRange(LOCATION_MZONE)
	e7:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e7:SetLabel(6)
	e7:SetValue(aux.tgoval)
	e7:SetCondition(c11560710.effcon)
	c:RegisterEffect(e7)
	--indes
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_SINGLE)
	e7:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e7:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e7:SetRange(LOCATION_MZONE)
	e7:SetLabel(6)
	e7:SetValue(1)
	e7:SetCondition(c11560710.effcon)
	c:RegisterEffect(e7)
	--immuse 
	--local e7=Effect.CreateEffect(c)
	--e7:SetType(EFFECT_TYPE_SINGLE)
	--e7:SetCode(EFFECT_IMMUNE_EFFECT)
	--e7:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	--e7:SetRange(LOCATION_MZONE)
	--e7:SetLabel(6)
	--e7:SetCondition(c11560710.effcon)
	--e7:SetValue(function(e,te)
	--return te:GetOwnerPlayer()~=e:GetOwnerPlayer() end)
	--c:RegisterEffect(e7) 
	--ov 
	local e8=Effect.CreateEffect(c)  
	e8:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e8:SetCode(EVENT_ATTACK_ANNOUNCE)
	e8:SetCountLimit(2,21560710)
	e8:SetTarget(c11560710.ovtg)
	e8:SetOperation(c11560710.ovop)
	c:RegisterEffect(e8) 
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e8:SetCode(EVENT_BATTLED) 
	e8:SetCountLimit(2,21560710)
	e8:SetTarget(c11560710.ovtg)
	e8:SetOperation(c11560710.ovop)
	c:RegisterEffect(e8)   
	--SpecialSummon 
	local e9=Effect.CreateEffect(c) 
	e9:SetCategory(CATEGORY_SPECIAL_SUMMON) 
	e9:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F) 
	e9:SetCode(EVENT_LEAVE_FIELD) 
	e9:SetProperty(EFFECT_FLAG_DELAY) 
	e9:SetTarget(c11560710.sptg) 
	e9:SetOperation(c11560710.spop) 
	c:RegisterEffect(e9)
end
c11560710.SetCard_SR_Saier=true 
function c11560710.effcon(e) 
	return e:GetHandler():GetOverlayCount()>=e:GetLabel()  
end 
function c11560710.excon(e,tp,eg,ep,ev,re,r,rp) 
	return aux.bdocon(e,tp,eg,ep,ev,re,r,rp) and c11560710.effcon(e)  
end  
function c11560710.excost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,1,REASON_COST) end 
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST) 
end 
function c11560710.extg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end 
end 
function c11560710.exop(e,tp,eg,ep,ev,re,r,rp)  
	Duel.ChainAttack()  
end 
function c11560710.ovtg(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsCanOverlay,tp,LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil) and e:GetHandler():GetFlagEffect(11560710)==0 end 
	e:GetHandler():RegisterFlagEffect(11560710,RESET_CHAIN,0,1)  
end 
function c11560710.ovop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	local g=Duel.GetMatchingGroup(Card.IsCanOverlay,tp,LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_REMOVED,0,nil) 
	if c:IsRelateToEffect(e) and g:GetCount()>0 then 
	local og=g:Select(tp,1,1,nil) 
	Duel.Overlay(c,og) 
	end 
end 
function c11560710.spfil(c,e,tp) 
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and not c:IsCode(11560710) 
end 
function c11560710.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end 
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end 
function c11560710.spop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	local g=Duel.GetMatchingGroup(c11560710.spfil,tp,LOCATION_GRAVE,0,nil,e,tp) 
	if g:GetCount()>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then 
	local sg=g:Select(tp,1,1,nil) 
	Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP) 
	end 
end 










