--天外来客 末日颂歌
function c98933009.initial_effect(c)
	c:SetUniqueOnField(1,0,98933009)
	--link summon
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsType,TYPE_SPSUMMON+TYPE_FUSION+TYPE_RITUAL+TYPE_SYNCHRO+TYPE_XYZ+TYPE_LINK),4)
	c:EnableReviveLimit()
	--special summon rule
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(98933009,0))
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetCondition(c98933009.sprcon)
	e2:SetOperation(c98933009.sprop)
	c:RegisterEffect(e2)
	--tohand
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(98933009,0))
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	e4:SetOperation(c98933009.negop)
	c:RegisterEffect(e4)
		--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetCondition(c98933009.recon)
	e2:SetOperation(c98933009.regop)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_CHAIN_SOLVED)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(c98933009.recon)
	e3:SetOperation(c98933009.reop)
	c:RegisterEffect(e3)
	local e6=e3:Clone()
	e6:SetCode(EVENT_CHAIN_NEGATED)
	c:RegisterEffect(e6)
end
function c98933009.sprcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	return ft>0 and Duel.IsExistingMatchingCard(c98933009.pfilter,tp,LOCATION_DECK+LOCATION_HAND,0,1,nil,tp) and Duel.GetFieldCard(tp,LOCATION_FZONE,0)==nil
end
function c98933009.sprop(e,tp,eg,ep,ev,re,r,rp,c)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local tc=Duel.SelectMatchingCard(tp,c98933009.pfilter,tp,LOCATION_DECK+LOCATION_HAND,0,1,1,nil,tp):GetFirst()
	if tc then Duel.MoveToField(tc,tp,tp,LOCATION_FZONE,POS_FACEUP,true) end
end
function c98933009.pfilter(c,tp)
	return c:IsCode(98933011) and not c:IsForbidden() and c:CheckUniqueOnField(tp)
end
function c98933009.negop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ConfirmDecktop(tp,3)
	local g=Duel.GetDecktopGroup(tp,3)
	if g:GetCount()>0 then
		if g:IsExists(c98933009.thfilter,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(98933009,2)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local sg=g:FilterSelect(tp,c98933009.thfilter,1,1,nil)
			Duel.SendtoHand(sg,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,sg)
			Duel.ShuffleHand(tp)
		end
		Duel.ShuffleDeck(tp)
	end
end
function c98933009.thfilter(c)
	return not c:IsSummonableCard() and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c98933009.recon1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(tp,98933009)==0
end
function c98933009.regop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_CHAIN_SOLVED)
	e3:SetOperation(c98933009.sop)
	e3:SetReset(RESET_CHAIN)
	Duel.RegisterEffect(e3,tp)
end
function c98933009.sop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():RegisterFlagEffect(98933009,RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET+RESET_CHAIN,0,1)
end
function c98933009.filter(c)
	return c:IsType(TYPE_MONSTER)
end
function c98933009.scfilter(c,mg)
	return mg:IsExists(c98933009.cfilter,1,nil,c)
end
function c98933009.recon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentChain()==1 and (e:GetHandler():GetFlagEffect(98933009)>0 or (e:GetCode()~=EVENT_CHAIN_NEGATED)) and Duel.GetFlagEffect(tp,98933001)==0
end
function c98933009.reop(e,tp,eg,ep,ev,re,r,rp)
	local tp=e:GetHandler():GetControler()
	if e:GetHandler():IsExtraLinkState() then
		local lp=Duel.GetLP(1-tp)
		Duel.SetLP(1-tp,lp/2)
	end   
end