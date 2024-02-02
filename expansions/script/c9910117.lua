--战车道装甲·三号突击炮
dofile("expansions/script/c9910100.lua")
function c9910117.initial_effect(c)
	--xyz summon
	QutryZcd.AddXyzProcedure(c,nil,5,2,c9910117.xyzfilter,99)
	c:EnableReviveLimit()
	--destroy
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(9910117,1))
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(2)
	e1:SetCost(c9910117.cost)
	e1:SetTarget(c9910117.target)
	e1:SetOperation(c9910117.operation)
	c:RegisterEffect(e1)
end
function c9910117.xyzfilter(c)
	return (c:IsType(TYPE_MONSTER) or (c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSetCard(0x9958) and c:IsFaceup()))
end
function c9910117.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c9910117.cfilter(c,tp)
	local seq=c:GetSequence()
	if c:IsLocation(LOCATION_MZONE) then
		seq=Auxiliary.MZoneSequence(seq)
	end
	if c:IsLocation(LOCATION_PZONE) then
		if seq==6 then seq=0 end
		if seq==7 then seq=4 end
	end
	return (not c:IsLocation(LOCATION_FZONE)) and Duel.CheckLocation(tp,LOCATION_MZONE,4-seq)
end
function c9910117.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE,tp,LOCATION_REASON_CONTROL)>0
		and Duel.IsExistingMatchingCard(c9910117.cfilter,tp,0,LOCATION_ONFIELD,1,nil,tp) end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function c9910117.gyfilter(c,g)
	return g:IsContains(c)
end
function c9910117.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or c:IsControler(1-tp) or c:IsImmuneToEffect(e) or Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local g=Duel.GetMatchingGroup(c9910117.cfilter,tp,0,LOCATION_ONFIELD,nil,tp)
	local tc=g:GetFirst()
	local zone=0
	while tc do
		local seq=tc:GetSequence()
		if tc:IsLocation(LOCATION_MZONE) then
			seq=Auxiliary.MZoneSequence(seq)
		end
		if tc:IsLocation(LOCATION_PZONE) then
			if seq==6 then seq=0 end
			if seq==7 then seq=4 end
		end
		zone=bit.replace(zone,0x1,4-seq)
		tc=g:GetNext()
	end
	zone=bit.bxor(zone,0xff)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOZONE)
	local s=Duel.SelectDisableField(tp,1,LOCATION_MZONE,0,zone)
	local nseq=math.log(s,2)
	Duel.MoveSequence(c,nseq)
	local tg=Duel.GetMatchingGroup(c9910117.gyfilter,tp,0,LOCATION_ONFIELD,nil,c:GetColumnGroup())
	if tg:GetCount()>0 then
		Duel.BreakEffect()
		Duel.Destroy(tg,REASON_EFFECT)
	end
end
