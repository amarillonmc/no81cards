--漆黑噤默-安吉丽卡
function c65820005.initial_effect(c)
	--手卡特招
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c65820005.condition1)
	c:RegisterEffect(e1)
	--不能连锁
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_MZONE)
	e2:SetOperation(c65820005.chainop)
	c:RegisterEffect(e2)
	--自诉
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CAN_FORBIDDEN)
	e3:SetTargetRange(1,0)
	e3:SetTarget(c65820005.splimit)
	c:RegisterEffect(e3)
	local e7=e3:Clone()
	e7:SetCode(EFFECT_CANNOT_SUMMON)
	c:RegisterEffect(e7)
	--加攻、守
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CAN_FORBIDDEN)
	e5:SetCode(EFFECT_UPDATE_ATTACK)
	e5:SetRange(LOCATION_MZONE)
	e5:SetValue(c65820005.value)
	c:RegisterEffect(e5)
	local e6=e5:Clone()
	e6:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e6)
	--特招检索
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	e4:SetCountLimit(1,65820005)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetTarget(c65820005.target1)
	e4:SetOperation(c65820005.activate1)
	c:RegisterEffect(e4)
end



function c65820005.filter1(c)
	return not c:IsCode(65820000,65820010) 
end
function c65820005.condition1(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0 and not Duel.IsExistingMatchingCard(c65820005.filter1,c:GetControler(),LOCATION_MZONE,0,1,nil)
end


function c65820005.chainop(e,tp,eg,ep,ev,re,r,rp)
	if re:GetHandler():IsSetCard(0xa32) and ep==tp then
		Duel.SetChainLimit(c65820005.chainlm)
	end
end
function c65820005.chainlm(e,rp,tp)
	return tp==rp
end



function c65820005.splimit(e,c,sump,sumtype,sumpos,targetp)
	return not c:IsCode(65820000,65820010)
end


function c65820005.filter2(c,rc)
	return c:IsSetCard(0xa32) and c:IsFaceup()
end
function c65820005.value(e,c)
	return Duel.GetMatchingGroupCount(c65820005.filter2,c:GetControler(),LOCATION_GRAVE+LOCATION_REMOVED,0,nil)*500
end


function c65820005.thfilter(c)
	return c:IsSetCard(0xa32) and c:IsAbleToHand()
end
function c65820005.spfilter(c,e,tp)
	return c:IsCode(65820000) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and aux.NecroValleyFilter()
end
function c65820005.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=Duel.IsExistingMatchingCard(c65820005.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil)
	local b2=Duel.IsExistingMatchingCard(c65820005.spfilter,tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_HAND+LOCATION_REMOVED,0,1,nil,e,tp)
	if chk==0 then return b1 or b2 end
	local op=0
	if b1 and b2 then op=Duel.SelectOption(tp,aux.Stringid(65820005,0),aux.Stringid(65820005,1))
	elseif b1 then op=Duel.SelectOption(tp,aux.Stringid(65820005,0))
	else op=Duel.SelectOption(tp,aux.Stringid(65820005,1))+1 end
	e:SetLabel(op)
	if op==0 then
		Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(65820005,0))
		e:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND+CATEGORY_GRAVE_ACTION)
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED)
	else
		Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(65820005,1))
		e:SetCategory(CATEGORY_GRAVE_SPSUMMON+CATEGORY_SPECIAL_SUMMON+CATEGORY_DECKDES)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_HAND+LOCATION_REMOVED)
	end
end
function c65820005.activate1(e,tp,eg,ep,ev,re,r,rp)
	if e:GetLabel()==0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,c65820005.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,c65820005.spfilter,tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_HAND+LOCATION_REMOVED,0,1,1,nil,e,tp)
		if g:GetCount()>0 then
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end