--R.X-剑士 索萨
function c49811252.initial_effect(c)
	--special summon
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_SPSUMMON_PROC)
	e0:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_SPSUM_PARAM)
	e0:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e0:SetTargetRange(POS_FACEUP_ATTACK,1)
	e0:SetCountLimit(1,49811252+EFFECT_COUNT_CODE_OATH)
	e0:SetCondition(c49811252.spcon)
	e0:SetOperation(c49811252.spop)
	c:RegisterEffect(e0)
	--cannot special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	c:RegisterEffect(e1)
	--immune
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_IMMUNE_EFFECT)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e2:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0xd))
	e2:SetValue(c49811252.efilter)
	c:RegisterEffect(e2)
	--matlimit
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e4:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0xd))
	e4:SetValue(c49811252.matlimit)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)	
	c:RegisterEffect(e5)
	local e6=e4:Clone()
	e6:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)	
	c:RegisterEffect(e6)
	--draw or spsummon
	local e7=Effect.CreateEffect(c)
	e7:SetDescription(aux.Stringid(49811252,0))
	e7:SetCategory(CATEGORY_DRAW+CATEGORY_SPECIAL_SUMMON)
	e7:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e7:SetCode(EVENT_SPSUMMON_SUCCESS)
	e7:SetProperty(EFFECT_FLAG_DELAY)
	e7:SetRange(LOCATION_MZONE)
	e7:SetCondition(c49811252.chkcon)
	e7:SetTarget(c49811252.chktg)
	e7:SetOperation(c49811252.chkop)
	c:RegisterEffect(e7)
end
function c49811252.spcfilter(c)
	return c:IsSetCard(0x100d) and c:IsType(TYPE_MONSTER) and not c:IsPublic()
end
function c49811252.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c49811252.spcfilter,tp,LOCATION_HAND,0,1,c)
end
function c49811252.spop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g=Duel.SelectMatchingCard(tp,c49811252.spcfilter,tp,LOCATION_HAND,0,1,1,c)
	Duel.ConfirmCards(1-tp,g)
	Duel.ShuffleHand(tp)
end
function c49811252.efilter(e,te,c)
	local tc=te:GetOwner()
	return not tc:IsSetCard(0x100d) and tc:IsOnField() and te:IsActiveType(TYPE_MONSTER) and te:IsActivated()
end
function c49811252.matlimit(e,c)
	if not c then return false end
	return not c:IsSetCard(0xd)
end
function c49811252.cfilter(c,p)
	return c:IsSummonLocation(LOCATION_EXTRA) and c:IsSummonPlayer(p)
end
function c49811252.chkcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c49811252.cfilter,1,nil,1-tp)
end
function c49811252.chktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,0,LOCATION_EXTRA)>0 end
end
function c49811252.spfilter(c,e,tp)
	return c:IsSetCard(0xd) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c49811252.chkop(e,tp,eg,ep,ev,re,r,rp)
	local cg=Duel.GetFieldGroup(tp,0,LOCATION_EXTRA)
	if #cg==0 then return end
	Duel.ConfirmCards(tp,cg)
	if cg:IsExists(Card.IsSetCard,1,nil,0xd) then
		local g=cg:Filter(c49811252.spfilter,nil,e,tp)
		if #g>0 and Duel.GetLocationCountFromEx(tp)>0 and Duel.SelectYesNo(tp,aux.Stringid(49811252,1)) then
			local sg=g:GetMinGroup(Card.GetAttack)
			if #sg>1 then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
				sg=sg:Select(tp,1,1,nil)
			end
			Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
		end
	else
		if Duel.IsPlayerCanDraw(tp,1) and Duel.SelectYesNo(tp,aux.Stringid(49811252,2)) then
			Duel.Draw(tp,1,REASON_EFFECT)
		end
	end
end
