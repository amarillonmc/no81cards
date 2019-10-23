--战车道装甲·四号坦克
require("expansions/script/c9910106")
function c9910105.initial_effect(c)
	--xyz summon
	Zcd.AddXyzProcedure(c,nil,4,2,c9910105.xyzfilter,aux.Stringid(9910105,0),99)
	c:EnableReviveLimit()
	--destroy & spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(9910105,1))
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,9910105)
	e1:SetCost(c9910105.cost)
	e1:SetTarget(c9910105.target)
	e1:SetOperation(c9910105.operation)
	c:RegisterEffect(e1)
end
function c9910105.xyzfilter(c)
	return (c:IsType(TYPE_MONSTER) or (c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSetCard(0x952) and c:IsFaceup()))
end
function c9910105.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c9910105.spfilter(c,e,tp)
	return c:IsSetCard(0x952) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c9910105.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE,tp,LOCATION_REASON_CONTROL)>0
		and (Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_ONFIELD,1,nil)
		or (Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c9910105.spfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp))) end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function c9910105.operation(e,tp,eg,ep,ev,re,r,rp)
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
	if Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_ONFIELD,1,nil) then
		ops[off]=aux.Stringid(9910105,2)
		opval[off-1]=1
		off=off+1
	end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c9910105.spfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp) then
		ops[off]=aux.Stringid(9910105,3)
		opval[off-1]=2
		off=off+1
	end
	if off==1 then return end
	local op=Duel.SelectOption(tp,table.unpack(ops))
	if opval[op]==1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local g=Duel.SelectMatchingCard(tp,aux.TRUE,tp,0,LOCATION_ONFIELD,1,1,nil)
		if g:GetCount()>0 then
			Duel.HintSelection(g)
			Duel.Destroy(g,REASON_EFFECT)
		end
	elseif opval[op]==2 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,c9910105.spfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,e,tp)
		if g:GetCount()>0 then
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end
