local m=82206040
local cm=_G["c"..m]
cm.name="植占师20-深渊"
function cm.initial_effect(c)
	--xyz summon  
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsRace,RACE_PLANT),3,2)  
	c:EnableReviveLimit()
	--attack all  
	local e1=Effect.CreateEffect(c)  
	e1:SetType(EFFECT_TYPE_SINGLE)  
	e1:SetCode(EFFECT_ATTACK_ALL)  
	e1:SetValue(cm.atkfilter)  
	c:RegisterEffect(e1)
	--destroy replace  
	local e2=Effect.CreateEffect(c)  
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)  
	e2:SetCode(EFFECT_DESTROY_REPLACE)  
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)  
	e2:SetRange(LOCATION_MZONE)  
	e2:SetTarget(cm.reptg)  
	c:RegisterEffect(e2)  
	--remove  
	local e4=Effect.CreateEffect(c)  
	e4:SetDescription(aux.Stringid(m,0))  
	e4:SetCategory(CATEGORY_REMOVE)  
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)  
	e4:SetCode(EVENT_BATTLE_START)  
	e4:SetCondition(cm.rmcon)  
	e4:SetTarget(cm.rmtg)  
	e4:SetOperation(cm.rmop)  
	c:RegisterEffect(e4)
end
function cm.atkfilter(e,c)  
	return c:IsSummonType(SUMMON_TYPE_SPECIAL)  
end 
function cm.reptg(e,tp,eg,ep,ev,re,r,rp,chk)  
	local c=e:GetHandler()  
	if chk==0 then return c:IsReason(REASON_BATTLE+REASON_EFFECT) and not c:IsReason(REASON_REPLACE)  
		and c:CheckRemoveOverlayCard(tp,1,REASON_EFFECT) end  
	if Duel.SelectEffectYesNo(tp,c,96) then  
		c:RemoveOverlayCard(tp,1,1,REASON_EFFECT)  
		return true  
	else return false end  
end  
function cm.rmcon(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler()  
	local bc=c:GetBattleTarget()  
	return bc and bc:IsSummonType(SUMMON_TYPE_SPECIAL)  
end  
function cm.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return true end  
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,e:GetHandler():GetBattleTarget(),1,0,0)  
end  
function cm.rmop(e,tp,eg,ep,ev,re,r,rp)  
	local bc=e:GetHandler():GetBattleTarget()  
	if bc:IsRelateToBattle() then  
		Duel.Remove(bc,POS_FACEUP,REASON_EFFECT)  
	end  
end