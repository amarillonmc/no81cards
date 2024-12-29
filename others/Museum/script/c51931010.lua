--魔棋战场
function c51931010.initial_effect(c)
	--Activate
	local e0=Effect.CreateEffect(c)
	e0:SetCategory(CATEGORY_REMOVE)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	e0:SetOperation(c51931010.activate)
	c:RegisterEffect(e0)
	--atk up
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetRange(LOCATION_FZONE)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetCondition(c51931010.effcon)
	e1:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x6258))
	e1:SetValue(500)
	e1:SetLabel(1)
	c:RegisterEffect(e1)
	--cannot be target
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_SET_AVAILABLE)
	e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e2:SetRange(LOCATION_FZONE)
	e2:SetTargetRange(LOCATION_ONFIELD,0)
	e2:SetCondition(c51931010.effcon)
	e2:SetTarget(c51931010.tglimit)
	e2:SetLabel(2)
	e2:SetValue(aux.tgoval)
	c:RegisterEffect(e2)
	--negate
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_CHAINING)
	e3:SetRange(LOCATION_FZONE)
	e3:SetCountLimit(1)
	e3:SetCondition(c51931010.effcon)
	e3:SetOperation(c51931010.disop)
	e3:SetLabel(3)
	c:RegisterEffect(e3)
	--act negate
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_CHAIN_SOLVING)
	e4:SetRange(LOCATION_FZONE)
	e4:SetCondition(c51931010.effcon)
	e4:SetOperation(c51931010.adop)
	e4:SetLabel(4)
	c:RegisterEffect(e4)
	--inactivatable
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetCode(EFFECT_CANNOT_DISEFFECT)
	e5:SetRange(LOCATION_FZONE)
	e5:SetCondition(c51931010.effcon)
	e5:SetValue(c51931010.effectfilter)
	e5:SetLabel(5)
	c:RegisterEffect(e5)
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD)
	e6:SetCode(EFFECT_CANNOT_INACTIVATE)
	e6:SetRange(LOCATION_FZONE)
	e6:SetCondition(c51931010.effcon)
	e6:SetValue(c51931010.effectfilter)
	e6:SetLabel(5)
	c:RegisterEffect(e6)
end
function c51931010.rmfilter(c)
	return c:IsSetCard(0x6258) and c:IsType(TYPE_MONSTER) and c:IsAbleToRemove()
end
function c51931010.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c51931010.rmfilter,tp,LOCATION_DECK,0,nil)
	if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(51931010,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=g:Select(tp,1,1,nil)
		Duel.Remove(sg,POS_FACEUP,REASON_EFFECT)
	end
end
function c51931010.chkfilter(c)
	return c:IsSetCard(0x6258) and c:IsType(TYPE_CONTINUOUS) and c:IsFaceup()
end
function c51931010.effcon(e)
	local g=Duel.GetMatchingGroup(c51931010.chkfilter,e:GetHandlerPlayer(),LOCATION_ONFIELD,0,nil)
	return g:GetClassCount(Card.GetCode)>=e:GetLabel()
end
function c51931010.tglimit(e,c)
	return c:IsSetCard(0x6258) and c:IsType(TYPE_CONTINUOUS) and c:IsFaceup()
end
function c51931010.disfilter(c)
	return c:IsSetCard(0x6258) and c:IsType(TYPE_CONTINUOUS) and c:IsAbleToGraveAsCost()-- and c:IsFaceup()
end
function c51931010.disop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not rp==1-tp and Duel.IsChainDisablable(ev) and c:GetFlagEffect(51931010)==0
		and Duel.IsExistingMatchingCard(c51931010.disfilter,tp,LOCATION_ONFIELD,0,1,nil)
	then return end
	if not Duel.SelectYesNo(tp,aux.Stringid(51931010,1)) then return end
	Duel.Hint(HINT_CARD,0,51931010)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local sg=Duel.SelectMatchingCard(tp,c51931010.disfilter,tp,LOCATION_ONFIELD,0,1,1,nil)
	Duel.SendtoGrave(sg,REASON_COST)
	Duel.NegateEffect(ev)
	c:RegisterFlagEffect(51931010,RESET_PHASE+PHASE_END,0,0)
end
function c51931010.seqfilter(seq2)
	local seq1=aux.MZoneSequence(c:GetSequence())
	return c:IsSetCard(0x6258) and c:IsFaceup() and seq1==4-seq2
end
function c51931010.adop(e,tp,eg,ep,ev,re,r,rp)
	local loc,seq=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION,CHAININFO_TRIGGERING_SEQUENCE)
	seq=aux.MZoneSequence(seq)
	if not (rp==1-tp and re:IsActiveType(TYPE_MONSTER) and loc==LOCATION_MZONE
		and Duel.IsExistingMatchingCard(c51931010.seqfilter,tp,LOCATION_MZONE,0,1,nil,seq)) then return end
	Duel.Hint(HINT_CARD,0,51931010)
	Duel.NegateEffect(ev)
end
function c51931010.effectfilter(e,ct)
	local p=e:GetHandler():GetControler()
	local te,tp=Duel.GetChainInfo(ct,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_PLAYER)
	return p==tp and te:GetHandler():IsSetCard(0x6258)
end
