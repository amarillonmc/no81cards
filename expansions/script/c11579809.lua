--指引前路的苍蓝之星·操虫棍
function c11579809.initial_effect(c)
	--link summon
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,function(c) return c:IsLinkRace(RACE_WARRIOR) or c.SetCard_ZH_Bluestar end,2,2) 
	--direct attack
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_DIRECT_ATTACK)
	c:RegisterEffect(e1) 
	--actlimit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(EFFECT_CANNOT_ACTIVATE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(0,1)
	e2:SetValue(1)
	e2:SetCondition(function(e)
	return Duel.GetAttacker()==e:GetHandler() or Duel.GetAttackTarget()==e:GetHandler() end) 
	c:RegisterEffect(e2) 
	--control 
	local e3=Effect.CreateEffect(c) 
	e3:SetCategory(CATEGORY_CONTROL)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_BATTLE_DAMAGE)
	e3:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp end)
	e3:SetTarget(c11579809.contg)
	e3:SetOperation(c11579809.conop)
	c:RegisterEffect(e3)
end
c11579809.SetCard_ZH_Bluestar=true	
function c11579809.contg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsControlerCanBeChanged,tp,0,LOCATION_MZONE,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_CONTROL,nil,1,1-tp,LOCATION_MZONE)
end
function c11579809.conop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	if Duel.IsExistingMatchingCard(Card.IsControlerCanBeChanged,tp,0,LOCATION_MZONE,1,nil) then 
		local sg=Duel.SelectMatchingCard(tp,Card.IsControlerCanBeChanged,tp,0,LOCATION_MZONE,1,1,nil) 
		Duel.GetControl(sg,tp)
	end 
end





