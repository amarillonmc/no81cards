--指引前路的苍蓝之星·大锤
function c11579805.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsRace,RACE_WARRIOR),4,2,nil,nil,99)
	c:EnableReviveLimit()   
	--xx 
	local e1=Effect.CreateEffect(c) 
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O) 
	e1:SetCode(EVENT_SPSUMMON_SUCCESS) 
	e1:SetProperty(EFFECT_FLAG_DELAY) 
	e1:SetCondition(function(e) 
	return e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ) end)
	e1:SetTarget(c11579805.xxtg) 
	e1:SetOperation(c11579805.xxop) 
	c:RegisterEffect(e1) 
	--pierce
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_PIERCE)
	e2:SetValue(DOUBLE_DAMAGE)
	c:RegisterEffect(e2) 
	--actlimit
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetCode(EFFECT_CANNOT_ACTIVATE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(0,1)
	e3:SetValue(1)
	e3:SetCondition(function(e)
	return Duel.GetAttacker()==e:GetHandler() or Duel.GetAttackTarget()==e:GetHandler() end)
	c:RegisterEffect(e3)
end
c11579805.SetCard_ZH_Bluestar=true  
function c11579805.xxtg(e,tp,eg,ep,ev,re,r,rp,chk) 
	local x=e:GetHandler():GetOverlayCount()
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,x,REASON_EFFECT) end 
end 
function c11579805.xxop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	local x=e:GetHandler():GetOverlayCount()
	if c:IsRelateToEffect(e) and c:RemoveOverlayCard(tp,x,x,REASON_EFFECT)==x then 
		local e1=Effect.CreateEffect(c) 
		e1:SetDescription(aux.Stringid(11579805,1))
		e1:SetCategory(CATEGORY_POSITION) 
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O) 
		e1:SetCode(EVENT_SUMMON_SUCCESS) 
		e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CLIENT_HINT)  
		e1:SetRange(LOCATION_MZONE)
		e1:SetTarget(c11579805.pstg) 
		e1:SetOperation(c11579805.psop)  
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,x) 
		c:RegisterEffect(e1) 
		local e2=e1:Clone() 
		e2:SetCode(EVENT_SPSUMMON_SUCCESS) 
		c:RegisterEffect(e2) 
		local e3=e1:Clone() 
		e2:SetCode(EVENT_FLIP_SUMMON_SUCCESS) 
		c:RegisterEffect(e3) 
	end 
end 
function c11579805.psckfil(c,tp) 
	return c:IsSummonPlayer(1-tp) and c:IsCanChangePosition() and not c:IsPosition(POS_FACEDOWN_DEFENSE) 
end 
function c11579805.pstg(e,tp,eg,ep,ev,re,r,rp,chk) 
	local g=eg:Filter(c11579805.psckfil,nil,tp)
	if chk==0 then return g:GetCount()>0 and e:GetHandler():GetFlagEffect(11579805)==0 end 
	e:GetHandler():RegisterFlagEffect(11579805,RESET_EVENT+RESETS_STANDARD,0,1) 
	Duel.SetTargetCard(g)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,g,g:GetCount(),0,0) 
end 
function c11579805.psop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e) 
	if g:GetCount()>0 then 
		Duel.ChangePosition(g,POS_FACEDOWN_DEFENSE)
	end 
end 


















