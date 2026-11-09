--Yearning
function c33741107.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetHintTiming(TIMING_DAMAGE_STEP)
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(c33741107.target)
	e1:SetOperation(c33741107.activate)
	c:RegisterEffect(e1)
end
function c33741107.tfilter(c)
	return c:IsFaceup()
end
function c33741107.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c33741107.tfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c33741107.tfilter,tp,LOCATION_MZONE,0,1,nil) and (Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>0 or e:GetHandler():IsLocation(LOCATION_HAND) and Duel.GetFieldGroupCount(tp,0,LOCATION_DECK)>0) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,c33741107.tfilter,tp,LOCATION_MZONE,0,1,1,nil)
	--
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CODE)
	getmetatable(e:GetHandler()).announce_filter={TYPE_MONSTER,OPCODE_ISTYPE,TYPE_FUSION+TYPE_SYNCHRO+TYPE_XYZ+TYPE_LINK,OPCODE_ISTYPE,OPCODE_NOT,OPCODE_AND}
	local ac=Duel.AnnounceCard(tp,table.unpack(getmetatable(e:GetHandler()).announce_filter))
	Duel.SetTargetParam(ac)
	Duel.SetOperationInfo(0,CATEGORY_ANNOUNCE,nil,0,tp,0)
end
function c33741107.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToChain() or tc:IsFacedown() then return end
	local g=Duel.GetFieldGroup(tp,LOCATION_DECK,0)
	if e:GetHandler():IsStatus(STATUS_ACT_FROM_HAND) and Duel.SelectOption(tp,aux.Stringid(33741107,0),aux.Stringid(33741107,1))==1 then g=Duel.GetFieldGroup(tp,0,LOCATION_DECK) end
	Duel.ConfirmCards(0,g)
	Duel.ConfirmCards(1,g)
	local ac=Duel.GetChainInfo(0,CHAININFO_TARGET_PARAM)
	if g:IsExists(Card.IsCode,1,nil,ac) then
		local atk=g:Filter(Card.IsCode,nil,ac):GetFirst():GetAttack()
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_SET_ATTACK_FINAL)
		e2:SetValue(atk)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e2)
	end
end
