--妖刀-卡通不知火
function c40008420.initial_effect(c)
	--cannot attack
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetOperation(c40008420.atklimit)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	c:RegisterEffect(e2)
	local e3=e1:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
	--direct attack
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_DIRECT_ATTACK)
	e4:SetCondition(c40008420.dircon)
	c:RegisterEffect(e4)
	--spsummon
	local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e5:SetType(EFFECT_TYPE_QUICK_O)
	e5:SetCode(EVENT_FREE_CHAIN)
	e5:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e5:SetRange(LOCATION_GRAVE)
	e5:SetTarget(c40008420.target)
	e5:SetOperation(c40008420.operation)
	c:RegisterEffect(e5)
	--special summon
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD)
	e6:SetCode(EFFECT_SPSUMMON_PROC)
	e6:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e6:SetRange(LOCATION_HAND)
	e6:SetCondition(c40008420.spcon)
	c:RegisterEffect(e6)	
end
function c40008420.filter(c)
	return c:IsFaceup() and c:IsCode(15259703)
end
function c40008420.spcon(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0 and
		Duel.IsExistingMatchingCard(c40008420.filter,c:GetControler(),LOCATION_SZONE,0,1,nil)
end
function c40008420.atklimit(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CANNOT_ATTACK)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	e:GetHandler():RegisterEffect(e1)
end
function c40008420.cfilter1(c)
	return c:IsFaceup() and c:IsCode(15259703)
end
function c40008420.cfilter2(c)
	return c:IsFaceup() and c:IsType(TYPE_TOON)
end
function c40008420.dircon(e)
	local tp=e:GetHandlerPlayer()
	return Duel.IsExistingMatchingCard(c40008420.cfilter1,tp,LOCATION_ONFIELD,0,1,nil)
		and not Duel.IsExistingMatchingCard(c40008420.cfilter2,tp,0,LOCATION_MZONE,1,nil)
end
function c40008420.filter1(c,e,tp,lv)
	local clv=c:GetLevel()
	return clv>0 and not c:IsType(TYPE_TUNER) and c:IsAbleToRemove()
		and Duel.IsExistingMatchingCard(c40008420.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,lv+clv)
end
function c40008420.filter2(c,e,tp,lv)
	return c:IsLevel(lv) and c:IsSetCard(0x62) and c:IsType(TYPE_SYNCHRO) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_SYNCHRO,tp,false,false)
end
function c40008420.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE) and c40008420.filter1(chkc,e,tp,e:GetHandler():GetLevel()) end
	if chk==0 then return Duel.GetLocationCountFromEx(tp)>0 and e:GetHandler():IsAbleToRemove()
		and Duel.IsExistingTarget(c40008420.filter1,tp,LOCATION_GRAVE,0,1,nil,e,tp,e:GetHandler():GetLevel()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,c40008420.filter1,tp,LOCATION_GRAVE,0,1,1,nil,e,tp,e:GetHandler():GetLevel())
	g:AddCard(e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,2,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c40008420.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if not c:IsRelateToEffect(e) or not tc:IsRelateToEffect(e) then return end
	local lv=c:GetLevel()+tc:GetLevel()
	local g=Group.FromCards(c,tc)
	if Duel.Remove(g,POS_FACEUP,REASON_EFFECT)==2 then
		if Duel.GetLocationCountFromEx(tp)<=0 then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=Duel.SelectMatchingCard(tp,c40008420.filter2,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,lv)
		if sg:GetCount()>0 then
			Duel.SpecialSummon(sg,SUMMON_TYPE_SYNCHRO,tp,tp,false,false,POS_FACEUP)
		end
	end
end