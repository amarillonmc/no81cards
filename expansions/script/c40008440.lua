--秘旋谍-双卡通特工
function c40008440.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,nil,2,2,c40008440.lcheck)
	c:EnableReviveLimit()
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(40008440,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCondition(c40008440.con)
	e1:SetOperation(c40008440.spcop)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(40008440,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,40008440)
	e2:SetTarget(c40008440.sptg)
	e2:SetOperation(c40008440.spop)
	c:RegisterEffect(e2)
	--cannot attack
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetCondition(c40008440.regcon)
	e3:SetOperation(c40008440.atklimit)
	c:RegisterEffect(e3)
	--direct attack
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetCode(EFFECT_DIRECT_ATTACK)
	e5:SetCondition(c40008440.dircon)
	c:RegisterEffect(e5)	
end
function c40008440.regcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function c40008440.lcheck(g,lc)
	return g:IsExists(Card.IsSetCard,1,nil,0x62)
end
function c40008440.atklimit(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CANNOT_ATTACK)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	e:GetHandler():RegisterEffect(e1)
end
function c40008440.cfilter1(c)
	return c:IsFaceup() and c:IsCode(15259703)
end
function c40008440.cfilter2(c)
	return c:IsFaceup() and c:IsType(TYPE_TOON)
end
function c40008440.dircon(e)
	local tp=e:GetHandlerPlayer()
	return Duel.IsExistingMatchingCard(c40008440.cfilter1,tp,LOCATION_ONFIELD,0,1,nil)
		and not Duel.IsExistingMatchingCard(c40008440.cfilter2,tp,0,LOCATION_MZONE,1,nil)
end
function c40008440.con(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(Card.IsCode,e:GetHandlerPlayer(),LOCATION_ONFIELD,0,1,nil,15259703)
end
function c40008440.spcop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFieldGroupCount(tp,0,LOCATION_DECK)==0 then return end
	Duel.ConfirmDecktop(1-tp,1)
	Duel.GetDecktopGroup(1-tp,1)
end
function c40008440.spfilter(c,e,tp,zone)
	return c:IsSetCard(0x62) and c:IsType(TYPE_MONSTER) and (c:IsAbleToHand() or (zone~=0 and c:IsCanBeSpecialSummoned(e,0,tp,true,false,POS_FACEUP,tp,zone)))
end
function c40008440.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local zone=e:GetHandler():GetLinkedZone()
	if chk==0 then return Duel.GetFieldGroupCount(tp,0,LOCATION_DECK)>0
		and Duel.IsExistingMatchingCard(c40008440.spfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,e,tp,zone) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CARDTYPE)
	e:SetLabel(Duel.AnnounceType(tp))
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c40008440.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFieldGroupCount(tp,0,LOCATION_DECK)==0 then return end
	Duel.ConfirmDecktop(1-tp,1)
	local g=Duel.GetDecktopGroup(1-tp,1)
	local tc=g:GetFirst()
	local opt=e:GetLabel()
	if (opt==0 and tc:IsType(TYPE_MONSTER)) or (opt==1 and tc:IsType(TYPE_SPELL)) or (opt==2 and tc:IsType(TYPE_TRAP)) then
		local zone=e:GetHandler():GetLinkedZone()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c40008440.spfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,e,tp,zone)
		local sc=sg:GetFirst()
		if sc then
			if zone~=0 and sc:IsCanBeSpecialSummoned(e,0,tp,true,false,POS_FACEUP,tp,zone)
				and (not sc:IsAbleToHand() or Duel.SelectOption(tp,1190,1152)==1) then
				Duel.SpecialSummon(sc,0,tp,tp,true,false,POS_FACEUP,zone)
			else
				Duel.SendtoHand(sc,nil,REASON_EFFECT)
				Duel.ConfirmCards(1-tp,sc)
			end
		end
	end
end
