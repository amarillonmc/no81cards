--伪骸研究所
function c71280033.initial_effect(c)
	aux.AddCodeList(c,97403510)
	--
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	--remove
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(71280033,0))
	e2:SetCategory(CATEGORY_REMOVE+CATEGORY_RECOVER)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCountLimit(1,31280033)
	e2:SetCondition(c71280033.rmcon)
	e2:SetTarget(c71280033.rmtg)
	e2:SetOperation(c71280033.rmop)
	c:RegisterEffect(e2)
	--Recover
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(71280033,1))
	e4:SetCategory(CATEGORY_RECOVER)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_DAMAGE)
	e4:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCountLimit(1,71280033)
	e4:SetCondition(c71280033.recon)
	e4:SetOperation(c71280033.reop)
	c:RegisterEffect(e4)
end
function c71280033.spcfilter(c,tp)
	return c:IsFaceup() and c:IsType(TYPE_XYZ) and c:IsSummonPlayer(tp)
end
function c71280033.rmcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c71280033.spcfilter,1,nil,tp)
end
function c71280033.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetDecktopGroup(1-tp,3):FilterCount(Card.IsAbleToRemove,nil)==3 end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,3,1-tp,LOCATION_DECK)
end
function c71280033.rmop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetDecktopGroup(1-tp,3)
	if #g>0 then
		Duel.DisableShuffleCheck()
		if Duel.Remove(g,POS_FACEUP,REASON_EFFECT)~=0 then
			Duel.Recover(tp,1000,REASON_EFFECT)
		end
	end
end
function c71280033.recon(e,tp,eg,ep,ev,re,r,rp)
	return ep==tp and bit.band(r,REASON_BATTLE+REASON_EFFECT)~=0
end
function c71280033.reop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Recover(tp,ev,REASON_EFFECT)
	--Activate in deck
	local e0=Effect.CreateEffect(e:GetHandler())
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e0:SetCode(71280033)
	e0:SetTargetRange(1,0)
	e0:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e0,tp)
	--public
	local sg=Duel.GetMatchingGroup(c71280033.checkfilter,tp,LOCATION_DECK,0,nil)
	if sg:GetCount()>0 then Duel.ConfirmCards(tp,sg,true) end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_TO_GRAVE)
	e1:SetCondition(c71280033.con)
	e1:SetOperation(c71280033.op)
	e1:SetLabelObject(e6)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	Duel.RegisterEffect(e2,tp)
	local e3=e1:Clone()
	e3:SetCode(EVENT_TO_HAND)
	Duel.RegisterEffect(e3,tp)
	local e4=e1:Clone()
	e4:SetCode(EVENT_TO_DECK)
	Duel.RegisterEffect(e4,tp)
	local e5=e1:Clone()
	e5:SetCode(EVENT_REMOVE)
	Duel.RegisterEffect(e5,tp)
	local e6=Effect.CreateEffect(e:GetHandler())
	e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e6:SetCode(EVENT_CHAIN_SOLVED)
	e6:SetOperation(c71280033.pubop)
	e6:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e6,tp)
end
--public
function c71280033.pubcfilter(c,tp)
	return c:GetPreviousControler()==tp
		and (c:IsPreviousLocation(LOCATION_DECK) or c:GetSummonLocation()==LOCATION_DECK
			or (c:IsControler(tp) and c:IsPreviousLocation(LOCATION_DECK))
			or c:IsLocation(LOCATION_DECK)) and not c:IsReason(REASON_DRAW)
end
function c71280033.con(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c71280033.pubcfilter,1,nil,tp) and Duel.IsPlayerAffectedByEffect(tp,71280033) and Duel.GetFlagEffect(tp,71280033)==0
end
function c71280033.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.RegisterFlagEffect(tp,11280033,RESET_EVENT+RESET_CHAIN,0,1)
end
function c71280033.pubop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetFlagEffect(tp,11280033)~=0 then
		local sg=Duel.GetMatchingGroup(c71280033.checkfilter,tp,LOCATION_DECK,0,nil)
		if sg:GetCount()>0 then Duel.ConfirmCards(tp,sg,true) end
		Duel.ResetFlagEffect(tp,11280033)
	end
end
function c71280033.checkfilter(c,tp)
	return aux.IsCodeListed(c,97403510) and (c:IsType(TYPE_SPELL) or c:IsType(TYPE_TRAP)) and not c:IsCode(71280033)
end
--