--预言未来
function c49966670.initial_effect(c)
 --Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DAMAGE+CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c49966670.cost)
	e1:SetTarget(c49966670.target)
	e1:SetOperation(c49966670.activate)
	c:RegisterEffect(e1)
end
function c49966670.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,2000) end
	Duel.PayLPCost(tp,2000)
end
function c49966670.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_DECK,1,nil)
		 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CODE)
	getmetatable(e:GetHandler()).announce_filter={TYPE_MONSTER,OPCODE_ISTYPE,TYPE_FUSION+TYPE_SYNCHRO+TYPE_XYZ+TYPE_LINK,OPCODE_ISTYPE,OPCODE_NOT,OPCODE_AND}
	local ac=Duel.AnnounceCard(tp,table.unpack(getmetatable(e:GetHandler()).announce_filter))
	Duel.SetTargetParam(ac)
	Duel.SetOperationInfo(0,CATEGORY_ANNOUNCE,nil,0,tp,0)
end
function c49966670.activate(e,tp,eg,ep,ev,re,r,rp)
	local ac=Duel.GetChainInfo(0,CHAININFO_TARGET_PARAM)
	local g=Duel.GetFieldGroup(tp,0,LOCATION_DECK)
	if g:GetCount()<1 then return end
	Duel.ConfirmCards(1-tp,g)
	Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_CONFIRM)
	local sg=g:FilterSelect(1-tp,Card.IsCode,1,1,nil,ac)
	local tc=sg:GetFirst()
	if tc then  
		Duel.ConfirmCards(tp,sg)
   if Duel.Remove(sg,POS_FACEUP,REASON_EFFECT)~=0 then  local dam=math.floor(sg:GetFirst():GetAttack())
			Duel.Damage(1-tp,dam,REASON_EFFECT)
end
end
	Duel.ShuffleDeck(1-tp)
end