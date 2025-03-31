--七仟陌
function c71000177.initial_effect(c)
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsRace,RACE_SPELLCASTER),7,3)
	c:EnableReviveLimit()
   -- spsummon condition
	
  --  cannot releaase
	aux.EnableChangeCode(c,71000100,LOCATION_MZONE)
	--atk,def
	   
	--
	local e22=Effect.CreateEffect(c)
	e22:SetCategory(CATEGORY_TODECK)
	e22:SetType(EFFECT_TYPE_IGNITION)
	e22:SetRange(LOCATION_MZONE)
	e22:SetCountLimit(1)
	e22:SetCost(c71000177.cost)
	e22:SetTarget(c71000177.tg)
	e22:SetOperation(c71000177.op)
	c:RegisterEffect(e22)
	--
	
end
function c71000177.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:CheckRemoveOverlayCard(tp,1,REASON_COST) end
	local rt=Duel.GetFieldGroupCount(tp,LOCATION_GRAVE+LOCATION_REMOVED,0)
	local ct=c:RemoveOverlayCard(tp,1,rt,REASON_COST)
	e:SetLabel(ct)
end
function c71000177.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil) end
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,e:GetLabel(),0,0)
end
function c71000177.stfilter(c)
	return c:IsSetCard(0xe73) and c:IsSSetable() 
end
function c71000177.op(e,tp,eg,ep,ev,re,r,rp)
	local ct=e:GetLabel()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,aux.TRUE,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,ct,nil)
	if g:GetCount()>0 then
		Duel.HintSelection(g)
		Duel.SendtoDeck(g,nil,CATEGORY_TODECK,REASON_EFFECT)
		local st=Duel.GetMatchingGroup(c71000177.stfilter,tp,LOCATION_DECK,0,nil)
		if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(71000177,0)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
			local sg=st:Select(tp,1,1,nil)
			Duel.SSet(tp,sg)
		end
	end
end
