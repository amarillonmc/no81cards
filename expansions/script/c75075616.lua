--空洞虚无之梦
function c75075616.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	-- 攻守上升
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(c75075616.adval)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e3)
    local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
    e4:SetRange(LOCATION_FZONE)
    e4:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
    e4:SetCondition(c75075616.con1)
    e4:SetTarget(c75075616.tg1)
    e4:SetLabelObject(e2)
    c:RegisterEffect(e4)
	-- 攻守下降
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(75075616,0))
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e5:SetRange(LOCATION_MZONE)
    e5:SetCountLimit(1)
	e5:SetCode(EVENT_CUSTOM+75075616)
	e5:SetTarget(c75075616.tg2)
	e5:SetOperation(c75075616.op2)
	c:RegisterEffect(e5)
    local e6=Effect.CreateEffect(c)
    e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
    e6:SetRange(LOCATION_FZONE)
    e6:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
    e6:SetCondition(c75075616.con1)
    e6:SetTarget(c75075616.tg1)
    e6:SetLabelObject(e5)
    c:RegisterEffect(e6)
	-- 遗言回收
	local e7=Effect.CreateEffect(c)
	e7:SetDescription(aux.Stringid(75075616,1))
	e7:SetCategory(CATEGORY_TOHAND)
	e7:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e7:SetCode(EVENT_TO_GRAVE)
	e7:SetProperty(EFFECT_FLAG_DELAY)
	e7:SetTarget(c75075616.tg3)
	e7:SetOperation(c75075616.op3)
	c:RegisterEffect(e7)
	if not c75075616.global_check then
		c75075616.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_SPSUMMON_SUCCESS)
		ge1:SetCondition(c75075616.con0)
		ge1:SetOperation(c75075616.op0)
		Duel.RegisterEffect(ge1,0)
	end
end
-- 0
function c75075616.filter0(c,tp)
	local code,code2=c:GetSpecialSummonInfo(SUMMON_INFO_CODE,SUMMON_INFO_CODE2)
	return c:IsFaceup() and c:IsControler(tp) and code~=75075616 and code2~=75075616
end
function c75075616.con0(e,tp,eg,ep,ev,re,r,rp)
	local sf=0
	if eg:IsExists(c75075616.filter0,1,nil,0) then
		sf=sf+1
	end
	if eg:IsExists(c75075616.filter0,1,nil,1) then
		sf=sf+2
	end
	e:SetLabel(sf)
	return sf~=0
end
function c75075616.op0(e,tp,eg,ep,ev,re,r,rp)
	Duel.RaiseEvent(eg,EVENT_CUSTOM+75075616,e,r,rp,ep,e:GetLabel())
end
-- 1
function c75075616.con1(e)
	return Duel.IsExistingMatchingCard(Card.IsSetCard,e:GetHandlerPlayer(),LOCATION_ONFIELD,0,1,nil,0x5754)
end
function c75075616.tg1(e,c)
    return c:IsSetCard(0x5754) and c:IsType(TYPE_MONSTER)
end
function c75075616.adval(e,c)
	local tp=c:GetControler()
	return Duel.GetMatchingGroupCount(Card.IsType,tp,LOCATION_GRAVE,0,nil,TYPE_FIELD)*700
end
-- 2
function c75075616.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetCard(eg)
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function c75075616.filter2(c,e)
	return c:IsLocation(LOCATION_MZONE) and c:IsRelateToEffect(e) and not c:IsImmuneToEffect(e)
end
function c75075616.op2(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(c75075616.filter2,nil,e)
	if g:GetCount()==0 then return end
	local tc=g:GetFirst()
	while tc do
		if tc:IsFaceup() then
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_SET_ATTACK_FINAL)
			e1:SetValue(math.ceil(tc:GetAttack()/2))
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e1)
		end
		tc=g:GetNext()
	end
end
-- 3
function c75075616.filter3(c)
	return c:IsSetCard(0x5754) and c:IsAbleToHand() and not c:IsCode(75075616)
end
function c75075616.tg3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c75075616.filter3,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
end
function c75075616.op3(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c75075616.filter3),tp,LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
