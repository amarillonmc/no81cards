--血裔之城 布拉索夫
local s,id,o=GetID()
XY_VHisc=XY_VHisc or {}
function s.initial_effect(c)
	c:EnableCounterPermit(0x32b)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--Atk up
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_FZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetTarget(aux.TargetBoolFunction(Card.IsRace,RACE_ZOMBIE))
	e2:SetValue(500)
	c:RegisterEffect(e2)
	--atk change
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,0))
	e3:SetCategory(CATEGORY_COUNTER)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetRange(LOCATION_FZONE)
	e3:SetCountLimit(1)
	e3:SetTarget(s.atktg)
	e3:SetOperation(s.atkop)
	c:RegisterEffect(e3)
	--spsm
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_IGNITION) 
	e4:SetRange(LOCATION_FZONE)  
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetCountLimit(1,id)
	e4:SetTarget(s.target)
	e4:SetOperation(s.activate)
	c:RegisterEffect(e4)
end
s.VHisc_Vampire=true

--e3
function s.atkfilter(c,sp)
	return c:IsSummonPlayer(sp) and not c:IsAttack(0)
end
function s.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg:IsExists(s.atkfilter,1,nil,1-tp) end
	local g=eg:Filter(s.atkfilter,nil,1-tp)
	Duel.SetTargetCard(g)
	Duel.SetOperationInfo(0,CATEGORY_COUNTER,nil,e:GetHandler(),0,0x32b)
end
function s.atkop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	local tc=g:GetFirst()
	local atkd=0
	if not e:GetHandler():IsRelateToEffect(e) then return end
	while tc do
		local atkr=tc:GetAttack()
		if atkr>0 then
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_SET_ATTACK_FINAL)
			e1:SetValue(0)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e1)
			atkd=atkd+atkr
		end
		tc=g:GetNext()
	end
	if atkd>=500 then 
		local ct=math.floor(atkd/500)
		e:GetHandler():AddCounter(0x32b,ct)
	end
end

--e4
function s.filter(c,e,tp)
	return c.VHisc_Vampire and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and s.filter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsCanRemoveCounter(tp,LOCATION_ONFIELD,0,0x32b,1,REASON_EFFECT) and Duel.IsExistingTarget(s.filter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,s.filter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and aux.NecroValleyFilter()(tc) and Duel.IsCanRemoveCounter(tp,LOCATION_ONFIELD,0,0x32b,1,REASON_EFFECT) and Duel.RemoveCounter(tp,LOCATION_ONFIELD,0,0x32b,1,REASON_EFFECT) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end



-------Functions and Filters-------
function XY_VHisc.LPcost(tp)
	local lp=Duel.GetLP(tp)
	local m=math.floor(math.min(lp,3000)/500)
	local t={}
	for i=1,m do
		t[i]=i*500
	end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(33201050,2))
	local cost=Duel.AnnounceNumber(tp,table.unpack(t))
	Duel.PayLPCost(tp,cost,true)
	return cost/500
end


--xyz
function XY_VHisc.xyzop(e,tp,chk,code)
	if chk==0 then return Duel.GetFlagEffect(tp,code)==0 and Duel.IsCanRemoveCounter(tp,LOCATION_ONFIELD,0,0x32b,8,REASON_COST) end
	Duel.RemoveCounter(tp,LOCATION_ONFIELD,0,0x32b,8,REASON_COST)
	Duel.RegisterFlagEffect(tp,code,RESET_PHASE+PHASE_END,EFFECT_FLAG_OATH,1)
end


--remove counters and spsm
function XY_VHisc.rcsp(c,code)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e1:SetCountLimit(1,code+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(XY_VHisc.spcon)
	e1:SetOperation(XY_VHisc.spop)
	e1:SetValue(SUMMON_VALUE_SELF)
	c:RegisterEffect(e1)
end
function XY_VHisc.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.IsCanRemoveCounter(tp,LOCATION_ONFIELD,0,0x32b,2,REASON_COST) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
end
function XY_VHisc.spop(e,tp,eg,ep,ev,re,r,rp,c)
	if chk==0 then return Duel.IsCanRemoveCounter(tp,LOCATION_ONFIELD,0,0x32b,2,REASON_COST) end
	Duel.RemoveCounter(tp,LOCATION_ONFIELD,0,0x32b,2,REASON_COST)
end