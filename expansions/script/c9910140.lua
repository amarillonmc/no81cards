--战车道装甲·追猎者
dofile("expansions/script/c9910100.lua")
function c9910140.initial_effect(c)
	--xyz summon
	QutryZcd.AddXyzProcedure(c,nil,3,2,c9910140.xyzfilter,99)
	c:EnableReviveLimit()
	--remove & to hand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(9910140,1))
	e1:SetCategory(CATEGORY_REMOVE+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCost(c9910140.cost)
	e1:SetTarget(c9910140.target)
	e1:SetOperation(c9910140.operation)
	c:RegisterEffect(e1)
end
function c9910140.xyzfilter(c)
	return (c:IsType(TYPE_MONSTER) or (c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSetCard(0x9958) and c:IsFaceup()))
end
function c9910140.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c9910140.thfilter(c)
	return c:IsSetCard(0x9958) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToHand()
end
function c9910140.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE,tp,LOCATION_REASON_CONTROL)>0
		and (Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_GRAVE,1,nil)
		or Duel.IsExistingMatchingCard(c9910140.thfilter,tp,LOCATION_GRAVE,0,1,nil)) end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function c9910140.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or c:IsControler(1-tp) or c:IsImmuneToEffect(e) or Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOZONE)
	local s=Duel.SelectDisableField(tp,1,LOCATION_MZONE,0,0)
	local nseq=math.log(s,2)
	Duel.MoveSequence(c,nseq)
	Duel.BreakEffect()
	local off=1
	local ops={}
	local opval={}
	local g1=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_GRAVE,nil)
	local g2=Duel.GetMatchingGroup(aux.NecroValleyFilter(c9910140.thfilter),tp,LOCATION_GRAVE,0,nil)
	if g1:GetCount()>0 then
		ops[off]=aux.Stringid(9910140,2)
		opval[off-1]=1
		off=off+1
	end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and g2:GetCount()>0 then
		ops[off]=aux.Stringid(9910140,3)
		opval[off-1]=2
		off=off+1
	end
	if off==1 then return end
	local op=Duel.SelectOption(tp,table.unpack(ops))
	if opval[op]==1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local sg1=g1:Select(tp,1,2,nil)
		if sg1:GetCount()>0 then
			Duel.HintSelection(sg1)
			Duel.Remove(sg1,POS_FACEUP,REASON_EFFECT)
		end
	elseif opval[op]==2 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg2=g2:Select(tp,1,1,nil)
		if sg2:GetCount()>0 then
			Duel.SendtoHand(sg2,nil,REASON_EFFECT)
		end
	end
end
