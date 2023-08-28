--动物朋友 地狱三头犬
--Anifriends Cerberus
--Animamici Cerbero
--Original Script by: scl
--Rescripted by: XGlitchy30

local s,id=GetID()
function s.initial_effect(c)
	--xyz summon
	c:EnableReviveLimit()
	aux.AddXyzProcedureLevelFree(c,s.matfilter,s.xyzcheck,3,3,s.ovfilter,aux.Stringid(id,2),s.xyzop)
	--[[Once per turn: You can detach all materials from this card; this card gains 1 additional attack during each Battle Phase this turn for each material detached.]]
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCost(aux.LabelCost)
	e1:SetTarget(s.atktg)
	e1:SetOperation(s.atkop)
	c:RegisterEffect(e1)
	--[[If this card destroys a monster(s) by battle while you have no cards with the same name in your GY: You can attach it to this card as material.]]
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE|EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_BATTLE_DESTROYING)
	e2:SetCondition(s.atcon)
	e2:SetTarget(s.attg)
	e2:SetOperation(s.atop)
	c:RegisterEffect(e2)
end
function s.matfilter(c,xyzc)
	return c:IsXyzLevel(xyzc,5)
end
function s.xyzcheck(g)
	return g:GetClassCount(Card.GetCode)==3
end
function s.ovfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_XYZ) and c:IsSetCard(0x442) and not c:IsCode(id)
end
function s.xyzop(e,tp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,id)==0 end
	Duel.RegisterFlagEffect(tp,id,RESET_PHASE|PHASE_END,EFFECT_FLAG_OATH,1)
end

function s.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local ct=c:GetOverlayCount()
	if chk==0 then
		if e:GetLabel()~=1 then return false end
		e:SetLabel(0)
		return Duel.IsAbleToEnterBP() and c:IsCapableOfAttacking() and c:CheckRemoveOverlayCard(tp,ct,REASON_COST)
	end
	e:SetLabel(0)
	if c:RemoveOverlayCard(tp,ct,ct,REASON_COST) then
		Duel.SetTargetParam(#Duel.GetOperatedGroup())
	end
end
function s.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ct=Duel.GetTargetParam()
	if ct and ct>0 and c:IsRelateToChain() then
		local e1=Effect.CreateEffect(c)
		e1:SetDescription(STRING_GAINED_ADDITIONAL_ATTACK)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
		e1:SetCode(EFFECT_EXTRA_ATTACK)
		e1:SetValue(ct)
		e1:SetReset(RESET_EVENT|RESETS_STANDARD|RESET_PHASE|PHASE_END)
		c:RegisterEffect(e1)
	end
end

function s.atcon(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetGY(tp)
	return aux.bdocon(e,tp,eg,ep,ev,re,r,rp) and g:GetClassCount(Card.GetCode)==#g
end
function s.attg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	if chk==0 then return c:IsType(TYPE_XYZ) and bc:IsCanOverlay(tp) and (bc:IsLocation(LOCATION_GRAVE) or (bc:IsFaceup() and bc:IsLocation(LOCATION_EXTRA|LOCATION_REMOVED))) end
	Duel.SetTargetCard(bc)
	if bc:IsLocation(LOCATION_GRAVE) then
		Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,bc,1,0,0)
	end
end
function s.atop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToChain() and c:IsType(TYPE_XYZ) and tc:IsRelateToChain() then
		Duel.Attach(tc,c)
	end
end