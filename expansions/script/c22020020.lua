--人理之基 阿尔托莉雅
function c22020020.initial_effect(c)
	--summon success
	local e100=Effect.CreateEffect(c)
	e100:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e100:SetCode(EVENT_SUMMON_SUCCESS)
	e100:SetOperation(c22020020.sumsuc)
	e100:SetCountLimit(1,22020020+EFFECT_COUNT_CODE_DUEL)
	c:RegisterEffect(e100)
	local e101=e100:Clone()
	e101:SetCode(EVENT_SPSUMMON_SUCCESS)
	e101:SetCountLimit(1,22020020+EFFECT_COUNT_CODE_DUEL)
	c:RegisterEffect(e101)
	local e102=e100:Clone()
	e102:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	e102:SetCountLimit(1,22020020+EFFECT_COUNT_CODE_DUEL)
	c:RegisterEffect(e102)
	--attack cost
	local e103=Effect.CreateEffect(c)
	e103:SetType(EFFECT_TYPE_SINGLE)
	e103:SetCode(EFFECT_ATTACK_COST)
	e103:SetOperation(c22020020.atop)
	c:RegisterEffect(e103)
	--search
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(22020020,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetTarget(c22020020.target)
	e1:SetOperation(c22020020.operation)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(22020020,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCountLimit(1,22020021)
	e2:SetCondition(c22020020.spcon)
	e2:SetTarget(c22020020.sptg)
	e2:SetOperation(c22020020.spop)
	c:RegisterEffect(e2)
end
function c22020020.sumsuc(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	Debug.Message("开始吧，Master！")
	Duel.RegisterEffect(e1,tp)
end
function c22020020.atop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	Debug.Message("风啊，飞舞吧！")
	Duel.RegisterEffect(e1,tp)
end
function c22020020.filter(c)
	return c:IsCode(22020090) and c:IsAbleToHand()
end
function c22020020.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c22020020.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c22020020.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c22020020.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
		Debug.Message("梅林，快过来")
	end
end
function c22020020.spcon(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	return tc:IsControler(tp) and tc:IsSetCard(0xff1) and tc:IsSummonType(SUMMON_TYPE_SYNCHRO)
end
function c22020020.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c22020020.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP_ATTACK)
	end
end