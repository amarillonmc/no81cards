--潮风的废都 盐风
function c29098630.initial_effect(c)
	aux.AddCodeList(c,29098631)
	aux.AddCodeList(c,22702055)
	--code
	aux.EnableChangeCode(c,22702055,LOCATION_SZONE+LOCATION_GRAVE)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--token
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(29098630,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCode(EVENT_CUSTOM+29098630)
	e2:SetTarget(c29098630.sptg)
	e2:SetOperation(c29098630.spop)
	c:RegisterEffect(e2)
	if not c29098630.global_check then
		c29098630.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_SPSUMMON_SUCCESS)
		ge1:SetCondition(c29098630.regcon)
		ge1:SetOperation(c29098630.regop)
		Duel.RegisterEffect(ge1,0)
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge2:SetCode(EVENT_SPSUMMON_SUCCESS)
		ge2:SetCondition(c29098630.regcon2)
		ge2:SetOperation(c29098630.regop2)
		Duel.RegisterEffect(ge2,0)
	end
end
function c29098630.thfilter(c)
	return (c:IsSetCard(0x87af) or (_G["c"..c:GetCode()] and  _G["c"..c:GetCode()].named_with_Arknight))
		and c:IsRace(RACE_FISH) and c:IsAbleToHand()
end
function c29098630.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c29098630.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c29098630.cfilter(c,tp)
	return c:IsFaceup() and  c:IsType(TYPE_EFFECT) and c:IsControler(tp)
end
function c29098630.regcon(e,tp,eg,ep,ev,re,r,rp)
	local sf=0
	if eg:IsExists(c29098630.cfilter,1,nil,0) then
		sf=sf+1
	end
	if eg:IsExists(c29098630.cfilter,1,nil,1) then
		sf=sf+2
	end
	e:SetLabel(sf)
	return sf~=0
end
function c29098630.regop(e,tp,eg,ep,ev,re,r,rp)
	Duel.RaiseEvent(eg,EVENT_CUSTOM+29098630,e,r,rp,ep,e:GetLabel())
end
function c29098630.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local tun=Duel.GetTurnCount()
	if chk==0 then return Duel.GetFlagEffect(tp,29098630)<tun end
	Duel.RegisterFlagEffect(tp,29098630,RESET_PHASE+PHASE_END,0,1)
	Duel.SetTargetCard(eg)
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function c29098630.spop(e,tp,eg,ep,ev,re,r,rp)
	if bit.extract(ev,tp)~=0 and Duel.GetLocationCount(1-tp,LOCATION_MZONE,tp)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,29010023,0,0x4011,1000,1000,1,RACE_AQUA,ATTRIBUTE_WATER,POS_FACEUP,1-tp) then
		local token=Duel.CreateToken(tp,29098631)
		if Duel.SpecialSummonStep(token,0,tp,1-tp,false,false,POS_FACEUP) then
			token:RegisterFlagEffect(29098630,0,0,1)
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
			e1:SetCode(EVENT_MOVE)
			e1:SetOperation(c29098630.resetop)
			token:RegisterEffect(e1,true)
		end
	end
	if bit.extract(ev,1-tp)~=0 and Duel.GetLocationCount(tp,LOCATION_MZONE,1-tp)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,29010023,0,0x4011,1000,1000,1,RACE_AQUA,ATTRIBUTE_WATER,POS_FACEUP) then
		local token=Duel.CreateToken(1-tp,29098631)
		if Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP) then
			token:RegisterFlagEffect(29098630,0,0,1)
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
			e1:SetCode(EVENT_MOVE)
			e1:SetOperation(c29098630.resetop)
			token:RegisterEffect(e1,true)
		end
	end
	Duel.SpecialSummonComplete()
end
function c29098630.resetop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local res=c:IsReason(REASON_MATERIAL) and (c:IsReason(REASON_FUSION) or c:IsReason(REASON_SYNCHRO) or c:IsReason(REASON_LINK))
	if not c:IsLocation(LOCATION_MZONE) and not res then
		c:ResetFlagEffect(29098630)
	end
end
function c29098630.cfilter2(c)
	return c:GetFlagEffect(29098630)~=0
end
function c29098630.regcon2(e,tp,eg,ep,ev,re,r,rp)
	local c=eg:GetFirst()
	local g=c:GetMaterial()
	return (c:IsSummonType(SUMMON_TYPE_FUSION) or c:IsSummonType(SUMMON_TYPE_SYNCHRO) or c:IsSummonType(SUMMON_TYPE_LINK))
		and g:IsExists(c29098630.cfilter2,1,nil)
end
function c29098630.regop2(e,tp,eg,ep,ev,re,r,rp)
	local c=eg:GetFirst()
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CHANGE_ATTRIBUTE)
	e1:SetValue(ATTRIBUTE_WATER)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	c:RegisterEffect(e1,true)
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetDescription(aux.Stringid(29098630,1))
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_CHANGE_CODE)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CLIENT_HINT)
	e2:SetValue(29098631)
	e2:SetReset(RESET_EVENT+RESETS_STANDARD)
	c:RegisterEffect(e2,true)
	local tg=c:GetMaterial():Filter(c29098630.cfilter2,nil)
	for tc in aux.Next(tg) do
		if not tc:IsLocation(LOCATION_MZONE) then tc:ResetFlagEffect(29098630) end
	end
end