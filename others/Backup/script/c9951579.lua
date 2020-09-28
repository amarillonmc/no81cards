--呼唤我的名字吧
function c9951579.initial_effect(c)
	 --Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,9951579+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c9951579.cost)
	e1:SetTarget(c9951579.target)
	e1:SetOperation(c9951579.activate)
	c:RegisterEffect(e1)
end
function c9951579.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,2000) end
	Duel.PayLPCost(tp,2000)
	if not e:IsHasType(EFFECT_TYPE_ACTIVATE) then return end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetReset(RESET_SELF_TURN+RESET_PHASE+PHASE_END,2)
	e1:SetTargetRange(1,0)
	Duel.RegisterEffect(e1,tp)
end
function c9951579.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToHand,tp,LOCATION_DECK,0,1,nil)
		or Duel.IsPlayerCanSpecialSummon(tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CODE)
	getmetatable(e:GetHandler()).announce_filter={TYPE_MONSTER,OPCODE_ISTYPE,TYPE_FUSION+TYPE_SYNCHRO+TYPE_XYZ+TYPE_LINK,OPCODE_ISTYPE,OPCODE_NOT,OPCODE_AND}
	local ac=Duel.AnnounceCard(tp,table.unpack(getmetatable(e:GetHandler()).announce_filter))
	Duel.SetTargetParam(ac)
	Duel.SetOperationInfo(0,CATEGORY_ANNOUNCE,nil,0,tp,0)
end
function c9951579.activate(e,tp,eg,ep,ev,re,r,rp)
	local ac=Duel.GetChainInfo(0,CHAININFO_TARGET_PARAM)
	local g=Duel.GetFieldGroup(tp,LOCATION_DECK,0)
	if g:GetCount()<1 then return end
	Duel.ConfirmCards(1-tp,g)
	Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_CONFIRM)
	local sg=g:FilterSelect(1-tp,Card.IsCode,1,1,nil,ac)
	local tc=sg:GetFirst()
	if tc then
		Duel.ConfirmCards(tp,sg)
		local b1=tc:IsAbleToHand()
		local b2=Duel.GetLocationCount(tp,LOCATION_MZONE)>0
			and tc:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_ATTACK,tp)
		local sel=0
		if b1 and b2 then
			Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_OPTION)
			sel=Duel.SelectOption(1-tp,aux.Stringid(9951579,0),aux.Stringid(9951579,1))+1
		elseif b1 then
			Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_OPTION)
			sel=Duel.SelectOption(1-tp,aux.Stringid(9951579,0))+1
		elseif b2 then
			Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_OPTION)
			sel=Duel.SelectOption(1-tp,aux.Stringid(9951579,1))+2
		end
		if sel==1 then
			Duel.SendtoHand(sg,tp,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,sg)
		elseif sel==2 then
			Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP_ATTACK)
		end
	end
	Duel.ShuffleDeck(1-tp)
end

