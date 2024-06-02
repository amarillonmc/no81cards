--厨师汇聚之处《81号餐厅》
local s,id,o=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCountLimit(1,id)
	e2:SetCondition(s.setcon)
	e2:SetTarget(s.settg)
	e2:SetOperation(s.setop)
	c:RegisterEffect(e2)
	--add summon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,2))
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_EXTRA_SUMMON_COUNT)
	e3:SetRange(LOCATION_FZONE)
	e3:SetTargetRange(LOCATION_HAND+LOCATION_MZONE,0)
	e3:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x9221))
	c:RegisterEffect(e3)
	--
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(id,3))
	e4:SetCategory(CATEGORY_RECOVER)
	e4:SetType(EFFECT_TYPE_TRIGGER_F+EFFECT_TYPE_FIELD)
	e4:SetCode(EVENT_BATTLE_DESTROYED)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_CAL+EFFECT_FLAG_DAMAGE_STEP)
	e4:SetRange(LOCATION_FZONE)
	e4:SetCondition(s.paycon)
	e4:SetTarget(s.paytg)
	e4:SetOperation(s.payop)
	c:RegisterEffect(e4)
end

function s.setfilter(c,tp,codes)
	return c:IsSetCard(0xa221) and c:CheckUniqueOnField(tp) and not c:IsCode(table.unpack(codes))
end
function s.setcon(e,tp,eg,ep,ev,re,r,rp)
	return re:GetHandler():IsSetCard(0xa221)
end
function s.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local codes={}
	for i=1,ev do
		local code=Duel.GetChainInfo(i,CHAININFO_TRIGGERING_CODE)
		table.insert(codes,code)
	end
	if chk==0 then return Duel.IsExistingMatchingCard(s.setfilter,tp,LOCATION_GRAVE,0,1,nil,tp,codes) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 end
end
function s.setop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	local codes={}
	for i=1,ev do
		local code=Duel.GetChainInfo(i,CHAININFO_TRIGGERING_CODE)
		table.insert(codes,code)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local tc=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.setfilter),tp,LOCATION_GRAVE,0,1,1,nil,tp,codes):GetFirst()
	if not tc then return end
	Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_CHAIN_END)
	e1:SetOperation(s.tgop)
	e1:SetLabelObject(tc)
	Duel.RegisterEffect(e1,tp)
	tc:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD,0,1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_CHANGE_TYPE)
	e2:SetReset(RESET_EVENT+RESETS_STANDARD)
	e2:SetValue(TYPE_SPELL+TYPE_CONTINUOUS)
	tc:RegisterEffect(e2)
end
function s.tgop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	if tc:GetFlagEffect(id)~=0 then
		Duel.SendtoGrave(tc,nil,REASON_EFFECT)
	end
	e:Reset()
end

function s.payfilter(c,tp)
	return c:IsSetCard(0x9221) and c:IsPreviousControler(tp) and bit.band(c:GetPreviousTypeOnField(),TYPE_FUSION+TYPE_MONSTER)==TYPE_FUSION+TYPE_MONSTER
end
function s.paycon(e,tp,eg,ep,ev,re,r,rp)
	return eg:FilterCount(s.payfilter,nil,tp)==1
end
function s.paytg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local tc=eg:Filter(s.payfilter,nil,tp):GetFirst()
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,tp,tc:GetPreviousDefenseOnField())
end
function s.payop(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:Filter(s.payfilter,nil,tp):GetFirst()
	Duel.PayLPCost(1-tp,tc:GetPreviousDefenseOnField())
	Duel.Recover(tp,tc:GetPreviousDefenseOnField(),REASON_EFFECT)
end