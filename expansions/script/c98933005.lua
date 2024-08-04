--天外来客 异界陨星
function c98933005.initial_effect(c)
	c:EnableReviveLimit()
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c98933005.spcon)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_HAND)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetCondition(c98933005.recon1)
	e2:SetOperation(c98933005.regop)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_CHAIN_SOLVED)
	e3:SetRange(LOCATION_HAND)
	e3:SetCondition(c98933005.recon)
	e3:SetOperation(c98933005.reop)
	c:RegisterEffect(e3)
	local e6=e3:Clone()
	e6:SetCode(EVENT_CHAIN_NEGATED)
	c:RegisterEffect(e6)
	--tohand
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(98933005,0))
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	e4:SetOperation(c98933005.negop)
	c:RegisterEffect(e4)
	--to deck
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(98933005,0))
	e5:SetCategory(CATEGORY_TODECK)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e5:SetCode(EVENT_TO_GRAVE)
	e5:SetOperation(c98933005.operation)
	c:RegisterEffect(e5)
end
function c98933005.cfilter(c)
	return c:IsFacedown() or c:IsSummonableCard()
end
function c98933005.spcon(e,c)
	local tp=e:GetHandler():GetControler()
	if c==nil then return true end
	return not Duel.IsExistingMatchingCard(c98933005.cfilter,tp,LOCATION_MZONE,0,1,nil)
		and Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
end
function c98933005.recon1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(tp,98933005)==0
end
function c98933005.regop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_CHAIN_SOLVED)
	e3:SetOperation(c98933005.sop)
	e3:SetReset(RESET_CHAIN)
	Duel.RegisterEffect(e3,tp)
end
function c98933005.sop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():RegisterFlagEffect(98933005,RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET+RESET_CHAIN,0,1)
end
function c98933005.filter(c)
	return c:IsType(TYPE_MONSTER)
end
function c98933005.scfilter(c,mg)
	return mg:IsExists(c98933005.cfilter,1,nil,c)
end
function c98933005.recon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentChain()==1 and (e:GetHandler():GetFlagEffect(98933005)>0 or (e:GetCode()~=EVENT_CHAIN_NEGATED)) and Duel.GetFlagEffect(tp,98933001)==0
end
function c98933005.reop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>0 and Duel.SelectYesNo(tp,aux.Stringid(98933005,0)) then
		Duel.RegisterFlagEffect(tp,98933001,RESET_CHAIN,0,1)
		local c=e:GetHandler()
		Duel.ConfirmCards(1-tp,c)
		Duel.ShuffleHand(tp)
	  	if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)==0 then return end
		Duel.ConfirmDecktop(tp,1)
		local g=Duel.GetDecktopGroup(tp,1)
		local tc=g:GetFirst()
		if not tc:IsSummonableCard() and tc:IsType(TYPE_MONSTER) and tc:IsAbleToHand() then
		   Duel.DisableShuffleCheck()
		   Duel.SendtoHand(g,nil,REASON_EFFECT)
		   Duel.ShuffleHand(tp)
		else
		   Duel.MoveSequence(tc,SEQ_DECKBOTTOM)
		end
	end   
end
function c98933005.negop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c98933005.SSfilter,tp,LOCATION_HAND+LOCATION_GRAVE+LOCATION_DECK+LOCATION_EXTRA,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
	   local tc=g:GetFirst()
	   Duel.SpecialSummonRule(tp,tc)
	end
end
function c98933005.SSfilter(c,e,tp)
	return c:IsType(TYPE_MONSTER) and not c:IsSummonableCard() and c:IsSpecialSummonable()
end
function c98933005.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,e:GetHandler(),1,0,0)
end
function c98933005.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.SendtoDeck(e:GetHandler(),nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
end