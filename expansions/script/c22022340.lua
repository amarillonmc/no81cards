--人理之基 燕青
function c22022340.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,aux.FilterBoolFunction(Card.IsFusionSetCard,0xff1),2,true)
	--name change
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(22022340,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetTarget(c22022340.nametg)
	e1:SetOperation(c22022340.nameop)
	c:RegisterEffect(e1)
	--spsummon (DM)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(22022340,1))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,22022340)
	e2:SetCondition(c22022340.condition2)
	e2:SetTarget(c22022340.target)
	e2:SetOperation(c22022340.operation)
	c:RegisterEffect(e2)
end
function c22022340.nametg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local code=e:GetHandler():GetCode()
	--c:IsSetCard(0x51) and not c:IsCode(code)
	getmetatable(e:GetHandler()).announce_filter={0xff1,OPCODE_ISSETCARD,code,OPCODE_ISCODE,OPCODE_NOT,OPCODE_AND}
	local ac=Duel.AnnounceCard(tp,table.unpack(getmetatable(e:GetHandler()).announce_filter))
	Duel.SetTargetParam(ac)
	Duel.SetOperationInfo(0,CATEGORY_ANNOUNCE,nil,0,tp,0)
end
function c22022340.nameop(e,tp,eg,ep,ev,re,r,rp)
	local ac=Duel.GetChainInfo(0,CHAININFO_TARGET_PARAM)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_CHANGE_CODE)
		e1:SetValue(ac)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e1)
	end
end
function c22022340.condition2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=re:GetHandler()
	return re:IsActiveType(TYPE_SPELL+TYPE_TRAP) and rc:IsSetCard(0x3ff1) and rc:IsControler(tp)
end
function c22022340.thfilter(c,code)
	return c:IsCode(code) and c:IsAbleToHand()
end
function c22022340.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local tc=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(c22022340.thfilter,tp,LOCATION_DECK,0,1,nil,tc:GetCode()) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c22022340.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c22022340.thfilter,tp,LOCATION_DECK,0,1,1,nil,tc:GetCode())
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end