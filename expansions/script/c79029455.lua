--彩虹小队·近卫干员-战车
function c79029455.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep2(c,c79029455.ffilter,3,99,true)
	--th
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,79029455)
	e1:SetTarget(c79029455.thtg)
	e1:SetOperation(c79029455.thop)
	c:RegisterEffect(e1)	 
	--summon success
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_MATERIAL_CHECK)
	e2:SetValue(c79029455.matcheck)
	c:RegisterEffect(e2)   
	--
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_DISABLE+CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,09029455)
	e3:SetTarget(c79029455.seqtg)
	e3:SetOperation(c79029455.seqop)
	c:RegisterEffect(e3) 
end
function c79029455.ffilter(c,fc)
	return c:IsFusionSetCard(0xa900)
end
function c79029455.thfil(c) 
	return c:IsAbleToHand() and (c:IsSetCard(0xb90d) or c:IsSetCard(0xc90e))
end
function c79029455.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c79029455.thfil,tp,LOCATION_DECK,0,1,nil) and e:GetHandler():IsSummonType(SUMMON_TYPE_FUSION) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,tp,LOCATION_DECK)
end
function c79029455.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c79029455.thfil,tp,LOCATION_DECK,0,nil)
	if g:GetCount()<=0 then return end
	Debug.Message("部署好火力区域了。")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029455,1))
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local sg=g:Select(tp,1,1,nil)
	Duel.SendtoHand(sg,tp,REASON_EFFECT)
	Duel.ConfirmCards(1-tp,sg)
end
function c79029455.matcheck(e,c)
	local ct=c:GetMaterial():GetClassCount(Card.GetCode)
	if ct>=5 then
	Debug.Message("各位，有我在你们真是太幸运了。")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029455,2))
	--actlimit
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(79029455,0))
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT)
	e2:SetCode(EFFECT_CANNOT_ACTIVATE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(0,1)
	e2:SetValue(1)
	e2:SetCondition(c79029455.actcon)
	e2:SetReset(RESET_EVENT+RESETS_STANDARD)
	c:RegisterEffect(e2)
	end
end
function c79029455.actcon(e)
	local ph=Duel.GetCurrentPhase()
	return Duel.GetTurnPlayer()==e:GetHandlerPlayer() and (ph>=PHASE_BATTLE_START and ph<=PHASE_BATTLE)
end

function c79029455.desfilter(c)
	return not c:IsLocation(LOCATION_SZONE) or c:GetSequence()<5
end
function c79029455.seqfilter(c,seq)
	local loc=LOCATION_MZONE
	if seq>8 then
		loc=LOCATION_SZONE
		seq=seq-8
	end
	if seq>=5 and seq<=7 then return false end
	local cseq=c:GetSequence()
	local cloc=c:GetLocation()
	if cloc==LOCATION_SZONE and cseq>=5 then return false end
	if cloc==LOCATION_MZONE and cseq>=5 and loc==LOCATION_MZONE
		and (seq==1 and cseq==5 or seq==3 and cseq==6) then return true end
	return cseq==seq or cloc==loc and math.abs(cseq-seq)==1
end
function c79029455.seqtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(c79029455.desfilter,tp,0,LOCATION_ONFIELD,1,nil) end
	local filter=0
	for i=0,16 do
		if not Duel.IsExistingMatchingCard(c79029455.seqfilter,tp,0,LOCATION_ONFIELD,1,nil,i) then
			filter=filter|1<<(i+16)
		end
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local flag=Duel.SelectField(tp,1,0,LOCATION_ONFIELD,filter)
	local seq=math.log(flag>>16,2)
	e:SetLabel(seq)
	local g=Duel.GetMatchingGroup(c79029455.seqfilter,tp,0,LOCATION_ONFIELD,nil,seq)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c79029455.seqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local seq=e:GetLabel()
	local g=Duel.GetMatchingGroup(c79029455.seqfilter,tp,0,LOCATION_ONFIELD,nil,seq)
	Debug.Message("快来找战车吧，宝贝。")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029455,3))
	Duel.HintSelection(g)
	local tc=g:GetFirst()
	while tc do
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_SET_ATTACK_FINAL)
			e1:SetValue(0)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e1)
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_SET_DEFENSE_FINAL)
			e2:SetValue(0)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e2)
			local e3=Effect.CreateEffect(c)
			e3:SetType(EFFECT_TYPE_SINGLE)
			e3:SetCode(EFFECT_DISABLE)
			e3:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e3)
			local e4=Effect.CreateEffect(c)
			e4:SetType(EFFECT_TYPE_SINGLE)
			e4:SetCode(EFFECT_DISABLE_EFFECT)
			e4:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e4)
	tc=g:GetNext()
	end
end







