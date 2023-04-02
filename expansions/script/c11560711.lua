--星海航线 圣光灵神
function c11560711.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,5,3) 
	c:EnableReviveLimit()  
	--atk up
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EVENT_PRE_DAMAGE_CALCULATE) 
	e1:SetCountLimit(1,11560711) 
	e1:SetCondition(c11560711.atkcon)
	e1:SetCost(c11560711.atkcost)
	e1:SetOperation(c11560711.atkop)
	c:RegisterEffect(e1) 
	--Destroy
	local e2=Effect.CreateEffect(c) 
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_BATTLED)
	e2:SetCountLimit(1,21560711) 
	e2:SetCondition(c11560711.descon)
	e2:SetTarget(c11560711.destg)
	e2:SetOperation(c11560711.desop)
	c:RegisterEffect(e2) 
	--SpecialSummon 
	local e3=Effect.CreateEffect(c) 
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)  
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F) 
	e3:SetCode(EVENT_LEAVE_FIELD) 
	e3:SetCountLimit(1,31560711)  
	e3:SetLabel(0)
	e3:SetTarget(c11560711.sptg) 
	e3:SetOperation(c11560711.spop) 
	c:RegisterEffect(e3) 
	local e4=Effect.CreateEffect(c) 
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS) 
	e4:SetCode(EVENT_LEAVE_FIELD_P)  
	e4:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e4:SetLabelObject(e3) 
	e4:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler() 
	local te=e:GetLabelObject() 
	if te==nil then return end 
	if c:GetOverlayCount()>0 then 
	te:SetLabel(1)
	else
	te:SetLabel(0) 
	end end)  
	c:RegisterEffect(e4) 
end
c11560711.SetCard_SR_Saier=true 
function c11560711.atkcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	return bc 
end
function c11560711.atkcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:CheckRemoveOverlayCard(tp,1,REASON_COST) end
	c:RemoveOverlayCard(tp,1,1,REASON_COST) 
end
function c11560711.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_ATTACK_FINAL) 
		e1:SetRange(LOCATION_MZONE)
		e1:SetValue(c:GetAttack()*2)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)  
		c:RegisterEffect(e1)
	end 
end
function c11560711.descon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	return bc and bc:IsStatus(STATUS_OPPO_BATTLE) and bc:IsRelateToBattle()
end 
function c11560711.destg(e,tp,eg,ep,ev,re,r,rp,chk) 
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	if chk==0 then return true end 
	local g=Group.FromCards(c,bc) 
	Duel.SetTargetCard(g)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c11560711.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	local dg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e) 
	if dg:GetCount()>0 then 
	Duel.Destroy(dg,REASON_EFFECT) 
	end 
end 
function c11560711.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetLabel()~=0 end 
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0) 
end 
function c11560711.spop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 then  
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_SET_ATTACK_FINAL) 
		e2:SetRange(LOCATION_MZONE)
		e2:SetValue(c:GetBaseAttack()*2) 
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		c:RegisterEffect(e2)
	end 
end 















