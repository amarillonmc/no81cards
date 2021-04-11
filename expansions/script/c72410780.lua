--命运之神意-7『暴走』战车·奥辂昂
function c72410780.initial_effect(c)
	aux.AddCodeList(c,72410770)
		--xyz summon
	c:EnableReviveLimit()
	aux.AddXyzProcedure(c,nil,7,2,c72410780.ovfilter,aux.Stringid(72410780,0),99,nil)
	--immune
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	c:RegisterEffect(e2)
	local e3=e1:Clone()
	e3:SetCode(EFFECT_CANNOT_ATTACK)
	c:RegisterEffect(e3)
		--dice
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_DAMAGE+CATEGORY_DICE)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e4:SetCode(EVENT_PHASE+PHASE_END)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1)
	e4:SetCondition(c72410770.con)
	e4:SetCost(c72410780.discost)
	e4:SetTarget(c72410770.target)
	e4:SetOperation(c72410770.operation)
	c:RegisterEffect(e4)
end
c72410780.toss_dice=true
function c72410780.ovfilter(c)
	return c:IsFaceup() and c:IsCode(72410770)
end
function c72410780.discost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c72410770.con(e,tp,eg,ep,ev,re,r,rp)
	return tp==Duel.GetTurnPlayer()
end
function c72410770.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DICE,nil,0,tp,1)
end
function c72410770.operation(e,tp,eg,ep,ev,re,r,rp)
	local d=Duel.TossDice(tp,1)
	if d==1 or d==2 then
		Duel.Damage(1-tp,3000,REASON_EFFECT)
	elseif d==3 or d==4 then
		local g=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_MZONE,LOCATION_MZONE,aux.ExceptThisCard(e))
		if g:GetCount()>0 then
			Duel.Destroy(g,REASON_EFFECT)
		end
	elseif d==5 or d==6 then	
		Duel.Damage(tp,3000,REASON_EFFECT)
	end
	local d=Duel.TossDice(tp,1)
	if d==1 or d==2 then
		Duel.Damage(1-tp,3000,REASON_EFFECT)
	elseif d==3 or d==4 then
		local g=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_MZONE,LOCATION_MZONE,aux.ExceptThisCard(e))
		if g:GetCount()>0 then
			Duel.Destroy(g,REASON_EFFECT)
		end
	elseif d==5 or d==6 then	
		Duel.Damage(tp,3000,REASON_EFFECT)
	end
end