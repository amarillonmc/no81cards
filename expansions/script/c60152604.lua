--皇家骑士 浅井
function c60152604.initial_effect(c)
	--yd
	local e01=Effect.CreateEffect(c)
	e01:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e01:SetCode(EVENT_CHAINING)
	e01:SetRange(LOCATION_MZONE)
	e01:SetCondition(c60152604.e01con)
	e01:SetOperation(c60152604.e01op)
	c:RegisterEffect(e01)
	local e02=e01:Clone()
	e02:SetCode(EVENT_ATTACK_ANNOUNCE)
	c:RegisterEffect(e02)
	local e03=e01:Clone()
	e03:SetCode(EVENT_SUMMON_SUCCESS)
	c:RegisterEffect(e03)
	local e04=e01:Clone()
	e04:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e04)
	local e05=e01:Clone()
	e05:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	c:RegisterEffect(e05)
	--tograve
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(60152604,0))
    e1:SetCategory(CATEGORY_TOGRAVE)
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e1:SetCode(EVENT_SUMMON_SUCCESS)
    e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
    e1:SetCountLimit(1,60152604)
    e1:SetTarget(c60152604.e1tar)
    e1:SetOperation(c60152604.e1op)
    c:RegisterEffect(e1)
    local e2=e1:Clone()
    e2:SetCode(EVENT_SPSUMMON_SUCCESS)
    e2:SetCountLimit(1,6012604)
	e2:SetCondition(c60152604.e2con)
    c:RegisterEffect(e2)
end
function c60152604.e01con(e,tp,eg,ep,ev,re,r,rp)
	local tp=e:GetHandlerPlayer()
	local c=e:GetHandler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1
end
function c60152604.e01op(e,tp,eg,ep,ev,re,r,rp)
	local tp=e:GetHandlerPlayer()
	local c=e:GetHandler()
	local seq=c:GetSequence()
	local g=Duel.GetFieldGroup(tp,0xff,0)
    local seed=g:RandomSelect(tp,1)
	local nseq=seed:GetFirst():GetSequence()
	while nseq>4 do nseq=nseq-5 end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)==0 and Duel.GetFieldGroupCount(e:GetHandlerPlayer(),LOCATION_MZONE,0)==1 then
		return false
	else
		if nseq==seq then
			if seq>=2 then 
				if Duel.CheckLocation(e:GetHandlerPlayer(),LOCATION_MZONE,nseq-1) then
					Duel.MoveSequence(c,nseq-1)
				else
					local c2=Duel.GetFieldCard(e:GetHandlerPlayer(),LOCATION_MZONE,nseq-1)
					Duel.SwapSequence(c,c2)
				end
			else
				if Duel.CheckLocation(e:GetHandlerPlayer(),LOCATION_MZONE,nseq+1) then
					Duel.MoveSequence(c,nseq+1)
				else
					local c2=Duel.GetFieldCard(e:GetHandlerPlayer(),LOCATION_MZONE,nseq+1)
					Duel.SwapSequence(c,c2)
				end
			end
		else
			if Duel.CheckLocation(e:GetHandlerPlayer(),LOCATION_MZONE,nseq) then
				Duel.MoveSequence(c,nseq)
			else
				local c2=Duel.GetFieldCard(e:GetHandlerPlayer(),LOCATION_MZONE,nseq)
				Duel.SwapSequence(c,c2)
			end
		end
	end
end
function c60152604.e1tarfilter(c)
    return c:IsSetCard(0x6b27) and not c:IsCode(60152604) and c:IsAbleToGrave()
end
function c60152604.e1tar(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c60152604.e1tarfilter,tp,LOCATION_DECK,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function c60152604.e1opfilter(c,e,tp)
	return c:IsSetCard(0x6b27) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c60152604.e1op(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
    local g=Duel.SelectMatchingCard(tp,c60152604.e1tarfilter,tp,LOCATION_DECK,0,1,1,nil)
    if g:GetCount()>0 then
        Duel.SendtoGrave(g,REASON_EFFECT)
		if e:GetHandler():GetColumnGroupCount()==0 then
			if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
			local g=Duel.GetMatchingGroup(c60152604.e1opfilter,tp,LOCATION_HAND,0,nil,e,tp)
			if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(60152604,1)) then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
				local sg=g:Select(tp,1,1,nil)
				Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
			end
		end
    end
end
function c60152604.e2confilter(c)
	return c:IsFaceup() and c:IsSetCard(0x6b27) and c:IsType(TYPE_XYZ)
end
function c60152604.e2con(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c60152604.e2confilter,tp,LOCATION_MZONE,0,1,nil)
end