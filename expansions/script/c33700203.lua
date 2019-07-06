--Heavenly Maid Duo
function c33700203.initial_effect(c)
	c:EnableReviveLimit()
	aux.EnablePendulumAttribute(c,false)
	--Materials: 2 "Heavenly Maid" Monsters
	aux.AddFusionProcFunRep(c,aux.FilterBoolFunction(Card.IsFusionSetCard,0x444),2,true)
	--You can also Special Summon this card from your Extra Deck by sending the above materials from your field to the GY. (You do not use "Polymerization")
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_SPSUMMON_PROC)
	e0:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e0:SetRange(LOCATION_EXTRA)
	e0:SetCondition(c33700203.sprcon)
	e0:SetOperation(c33700203.sprop)
	c:RegisterEffect(e0)
	--P: You cannot Pendulum Summon monsters, this effect cannot be negated.
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
	e2:SetTargetRange(1,0)
	e2:SetTarget(function(e,c,sump,sumtype,sumpos,targetp)
		return bit.band(sumtype,SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM
	end)
	c:RegisterEffect(e2)
	--P: Once per turn, you can send 1 face-up "Heavenly Maid" monster you control to your GY, and if you do, gain 1000 LP.
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCountLimit(1)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCategory(CATEGORY_RECOVER)
	e1:SetTarget(c33700203.target)
	e1:SetOperation(c33700203.operation)
	c:RegisterEffect(e1)
	--M: Once per turn, you can have your opponent apply 1 of the following effects: (below)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCategory(CATEGORY_DISABLE+CATEGORY_TOGRAVE)
	e3:SetOperation(c33700203.desop)
	c:RegisterEffect(e3)
end
function c33700203.sprcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.IsExistingMatchingCard(c33700203.sprfilter1,tp,LOCATION_MZONE,0,1,nil,tp,c)
end
function c33700203.sprfilter1(c,tp,fc)
	return c:IsFusionSetCard(0x444) and c:IsAbleToGraveAsCost() and c:IsCanBeFusionMaterial(fc)
		and Duel.IsExistingMatchingCard(c33700203.sprfilter2,tp,LOCATION_MZONE,0,1,c,tp,fc,c)
end
function c33700203.sprfilter2(c,tp,fc,mc)
	local g=Group.FromCards(c,mc)
	return c:IsFusionSetCard(0x444) and c:IsAbleToGraveAsCost() and c:IsCanBeFusionMaterial(fc)
		and Duel.GetLocationCountFromEx(tp,tp,g)>0
end
function c33700203.sprop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g1=Duel.SelectMatchingCard(tp,c33700203.sprfilter1,tp,LOCATION_MZONE,0,1,1,nil,tp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g2=Duel.SelectMatchingCard(tp,c33700203.sprfilter2,tp,LOCATION_MZONE,0,1,1,g1:GetFirst(),tp,c,g1:GetFirst())
	g1:Merge(g2)
	Duel.SendtoGrave(g1,REASON_COST)
end
function c33700203.filter(c,tp)
	return c:IsSetCard(0x444) and c:GetOwner()==tp and c:IsAbleToGrave()
end
function c33700203.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c33700203.filter,tp,LOCATION_MZONE,0,1,nil,tp) end
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,1000)
end
function c33700203.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c33700203.filter,tp,LOCATION_MZONE,0,1,1,nil,tp)
	if g:GetCount()~=0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
		if g:IsExists(Card.IsLocation,1,nil,LOCATION_GRAVE) then
			Duel.Recover(tp,1000,REASON_EFFECT)
		end
	end
end
function c33700203.disfilter(c)
	return c:IsFaceup() and (not c:IsDisabled() or c:IsType(TYPE_TRAPMONSTER)) and not (c:IsType(TYPE_NORMAL) and bit.band(c:GetOriginalType(),TYPE_NORMAL))
end
function c33700203.afilter(c)
	return c:IsSetCard(0x444) and c:IsAbleToGrave()
end
function c33700203.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g1=Duel.GetMatchingGroup(c33700203.disfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,c)
	local g2=Duel.GetMatchingGroup(c33700203.afilter,tp,LOCATION_MZONE,0,nil)
	local opt=0
	if g1:GetCount()>0 and g2:GetCount()>0 then
		opt=Duel.SelectOption(1-tp,aux.Stringid(122518919,5),aux.Stringid(122518919,6))
	elseif g1:GetCount()>0 then
		opt=Duel.SelectOption(1-tp,aux.Stringid(122518919,5))
	elseif g2:GetCount()>0 then
		opt=Duel.SelectOption(1-tp,aux.Stringid(122518919,6))+1
	else return end
	if opt==0 then
		--Negate the effects of all other face-up cards on the field.
		for nc in aux.Next(g1) do
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_DISABLE)
			e1:SetReset(RESET_EVENT+0x1fe0000)
			nc:RegisterEffect(e1)
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_DISABLE_EFFECT)
			e2:SetReset(RESET_EVENT+0x1fe0000)
			nc:RegisterEffect(e2)
			if nc:IsType(TYPE_TRAPMONSTER) then
				local e3=Effect.CreateEffect(c)
				e3:SetType(EFFECT_TYPE_SINGLE)
				e3:SetCode(EFFECT_DISABLE_TRAPMONSTER)
				e3:SetReset(RESET_EVENT+0x1fe0000)
				nc:RegisterEffect(e3)
			end
		end
	else
		--Send all "Heavenly Maid" monsters you control to the GY, this card gains 1000 ATK/DEF for each card sent to the GY by this effect.
		Duel.SendtoGrave(g2,REASON_EFFECT)
		local ct=g2:FilterCount(Card.IsLocation,LOCATION_GRAVE)
		if c:IsFaceup() and c:IsRelateToEffect(e) then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetValue(ct*1000)
			e1:SetReset(RESET_EVENT+0x1fe0000)
			c:RegisterEffect(e1)
			local e2=e1:Clone()
			e2:SetCode(EFFECT_UPDATE_DEFENSE)
			c:RegisterEffect(e2)
		end
	end
end
