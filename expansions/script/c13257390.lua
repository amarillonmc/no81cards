--梦超时空战斗机-铃仙（后略）
local s,id,o=GetID()
if not tama then xpcall(function() dofile("expansions/script/tama.lua") end,function() dofile("script/tama.lua") end) end
function s.initial_effect(c)
	c:EnableCounterPermit(TAMA_COMSIC_FIGHTERS_COUNTER_BOMB)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_EQUIP+CATEGORY_COUNTER)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,id)
	e1:SetCondition(s.spcon)
	e1:SetTarget(s.sptg)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_EQUIP)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetTarget(s.eqtg)
	e2:SetOperation(s.eqop)
	c:RegisterEffect(e2)
	--Power Capsule
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,0))
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_DESTROYED)
	e3:SetRange(LOCATION_MZONE)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e3:SetCondition(s.pccon)
	e3:SetTarget(s.pctg)
	e3:SetOperation(s.pcop)
	c:RegisterEffect(e3)
	--bomb
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(id,6))
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetCountLimit(1,EFFECT_COUNT_CODE_CHAIN)
	e4:SetCost(s.bombcost)
	e4:SetOperation(s.bombop)
	c:RegisterEffect(e4)
	eflist={{"power_capsule",e3},{"bomb",e4}}
	s[c]=eflist
	
	if not s.global_check then
		s.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_BECOME_TARGET)
		ge1:SetOperation(s.checkop)
		Duel.RegisterEffect(ge1,0)
	end
end
function s.checkop(e,tp,eg,ep,ev,re,r,rp)
	for tc in aux.Next(eg) do
		if tc:IsLocation(LOCATION_MZONE) and Duel.GetFlagEffect(tc:GetControler(),id)==0 then
			Duel.RegisterFlagEffect(tc:GetControler(),id,RESET_PHASE+PHASE_END,0,1)
		end
	end
end
function s.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(tp,id)~=0
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
end
function s.eqtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingMatchingCard(s.eqfilter,tp,LOCATION_EXTRA,0,1,nil,e:GetHandler()) end
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,nil,1,tp,LOCATION_EXTRA)
end
function s.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 or c:IsFacedown() or not c:IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local g=Duel.SelectMatchingCard(tp,s.eqfilter,tp,LOCATION_EXTRA,0,1,1,nil,c)
	local tc=g:GetFirst()
	if tc then
		Duel.Equip(tp,tc,c)
	end
end
function s.eqfilter(c,ec)
	return c:IsSetCard(0x352) and c:IsType(TYPE_MONSTER) and c:CheckEquipTarget(ec)
end
function s.pcfilter(c,tp)
	return c:IsReason(REASON_BATTLE+REASON_EFFECT) and c:IsPreviousLocation(LOCATION_MZONE) and c:GetPreviousControler()==tp
end
function s.pccon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(s.pcfilter,1,nil,1-tp)
end
function s.pctg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local t1=e:GetHandler():IsCanAddCounter(TAMA_COMSIC_FIGHTERS_COUNTER_BOMB,1)
	local t2=true
	if chk==0 then return t1 or t2 end
	local op=0
	if t1 or t2 then
		local m1={}
		local n1={}
		local ct=1
		if t1 then m1[ct]=aux.Stringid(id,2) n1[ct]=1 ct=ct+1 end
		m1[ct]=aux.Stringid(id,3) n1[ct]=2 ct=ct+1
		local sp=Duel.SelectOption(tp,table.unpack(m1))
		op=n1[sp+1]
	end
	e:SetLabel(op)
	if op==1 then
		e:SetCategory(CATEGORY_COUNTER)
	else
		e:SetCategory(CATEGORY_ATKCHANGE)
	end
end
function s.pcop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if e:GetLabel()==1 and c:IsRelateToEffect(e) then
		c:AddCounter(TAMA_COMSIC_FIGHTERS_COUNTER_BOMB,1)
	elseif e:GetLabel()==2 then
		if c:IsRelateToEffect(e) and c:IsFaceup() then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetValue(400)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
			c:RegisterEffect(e1)
		end
	end
end
function s.bombcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanRemoveCounter(tp,TAMA_COMSIC_FIGHTERS_COUNTER_BOMB,1,REASON_COST) end
	e:GetHandler():RemoveCounter(tp,TAMA_COMSIC_FIGHTERS_COUNTER_BOMB,1,REASON_COST)
end
function s.efilter(e,te)
	return e:GetHandler()~=te:GetOwner() and not te:GetOwner():IsType(TYPE_EQUIP)
end
function s.eqfilter1(c,ec)
	return c:IsSetCard(0x5352) and c:IsType(TYPE_MONSTER) and c:CheckEquipTarget(ec)
end
function s.bombtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingMatchingCard(s.eqfilter1,tp,LOCATION_EXTRA,0,1,nil,e:GetHandler()) end
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,nil,1,tp,LOCATION_EXTRA)
end
function s.bombop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		local e4=Effect.CreateEffect(e:GetHandler())
		e4:SetDescription(aux.Stringid(id,6))
		e4:SetType(EFFECT_TYPE_SINGLE)
		e4:SetProperty(EFFECT_FLAG_CLIENT_HINT+EFFECT_FLAG_SINGLE_RANGE)
		e4:SetRange(LOCATION_MZONE)
		e4:SetCode(EFFECT_IMMUNE_EFFECT)
		e4:SetValue(s.efilter)
		e4:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_CHAIN)
		c:RegisterEffect(e4)
		if Duel.GetLocationCount(tp,LOCATION_SZONE)>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
			local g=Duel.SelectMatchingCard(tp,s.eqfilter1,tp,LOCATION_EXTRA,0,1,1,nil,c)
			local tc=g:GetFirst()
			if tc then
				Duel.Equip(tp,tc,c)
			end
		end
	end
end
