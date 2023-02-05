--极星兽 哈提
function c98920001.initial_effect(c) 
   Duel.EnableGlobalFlag(GLOBALFLAG_BRAINWASHING_CHECK)
 --to hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(98920001,1))
	e2:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetCountLimit(1,98920001)
	e2:SetTarget(c98920001.thtg)
	e2:SetOperation(c98920001.thop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetCondition(c98920001.thcon)
	c:RegisterEffect(e3)
	--coin effect
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,98930001)
	e3:SetCost(c98920001.spcost)
	e3:SetTarget(c98920001.sptg)
	e3:SetOperation(c98920001.spop)
	c:RegisterEffect(e3)	
--change position
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(98920001,0)) 
	e4:SetCategory(CATEGORY_POSITION)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_GRAVE)
	e4:SetCountLimit(1,98931001)
	e4:SetCost(aux.bfgcost)
	e4:SetTarget(c98920001.postg)
	e4:SetOperation(c98920001.posop)
	c:RegisterEffect(e4)	 
 --return control
	local e5=Effect.CreateEffect(c)
	e5:SetRange(LOCATION_GRAVE)
	e5:SetDescription(aux.Stringid(98920001,1))
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetCost(aux.bfgcost)
	e5:SetCountLimit(1,98931001)
	e5:SetCondition(c98920001.ctcon)
	e5:SetTarget(c98920001.cttg)
	e5:SetOperation(c98920001.ctop)
	c:RegisterEffect(e5) 
end
function c98920001.thfilter(c)
	return (c:IsSetCard(0x6042) and c:IsType(TYPE_MONSTER) and not c:IsCode(98920001)) or c:IsCode(91697229) and c:IsAbleToHand()
end
function c98920001.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c98920001.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c98920001.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c98920001.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c98920001.thcon(e,tp,eg,ep,ev,re,r,rp)
	return re and re:GetHandler():IsSetCard(0x42)
end
function c98920001.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,1000) end
	Duel.PayLPCost(tp,1000)
end
function c98920001.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,15394084,0,TYPES_TOKEN_MONSTER,0,0,1,RACE_PLANT,ATTRIBUTE_EARTH) end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function c98920001.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	if not Duel.IsPlayerCanSpecialSummonMonster(tp,15394084,0,TYPES_TOKEN_MONSTER,0,0,1,RACE_PLANT,ATTRIBUTE_EARTH) then return end
	local token=Duel.CreateToken(tp,15394084)
	Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP)
end
function c98920001.posfilter(c)
	return c:IsDefensePos() or c:IsFacedown()
end
function c98920001.postg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c98920001.posfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
end
function c98920001.posop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c98920001.posfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	if g:GetCount()==0 then return end
	Duel.ChangePosition(g,POS_FACEUP_ATTACK)
end
function c98920001.ctcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousPosition(POS_FACEUP)
end
function c98920001.ctfilter(c)
	return c:GetControler()~=c:GetOwner()
end
function c98920001.cttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c98920001.ctfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
end
function c98920001.ctop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(tp,LOCATION_MZONE,LOCATION_MZONE)
	local tc=g:GetFirst()
	local tg=Group.CreateGroup()
	local tc=g:GetFirst()
	while tc do
		if not tc:IsImmuneToEffect(e) and tc:GetFlagEffect(98920001)==0 then
			tc:RegisterFlagEffect(98920001,RESET_EVENT+RESETS_STANDARD,0,1)
			tg:AddCard(tc)
		end
		tc=g:GetNext()
	end
	tg:KeepAlive()
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_REMOVE_BRAINWASHING)
	e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e1:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e1:SetTarget(aux.TargetEqualFunction(Card.GetFlagEffect,1,98920001))
	e1:SetLabelObject(tg)
	Duel.RegisterEffect(e1,tp)
	--force adjust
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_CHAIN_SOLVED)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetLabelObject(e1)
	Duel.RegisterEffect(e2,tp)
	--reset
	local e3=Effect.CreateEffect(e:GetHandler())
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_CHAIN_SOLVED)
	e3:SetLabelObject(e2)
	e3:SetLabel(Duel.GetChainInfo(0,CHAININFO_CHAIN_ID))
	e3:SetOperation(c98920001.reset)
	Duel.RegisterEffect(e3,tp)
end
function c98920001.reset(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetChainInfo(ev,CHAININFO_CHAIN_ID)==e:GetLabel() then
		local e2=e:GetLabelObject()
		local e1=e2:GetLabelObject()
		local tg=e1:GetLabelObject()
		for tc in aux.Next(tg) do
			tc:ResetFlagEffect(98920001)
		end
		tg:DeleteGroup()
		e1:Reset()
		e2:Reset()
		e:Reset()
	end
end