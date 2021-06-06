--不灭的奇迹
function c33405100.initial_effect(c)
	--search
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetTarget(c33405100.settg)
	e2:SetOperation(c33405100.setop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
	local e1=e2:Clone()
	e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e1:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_FIELD)
	e1:SetCountLimit(1)
	e1:SetRange(LOCATION_MZONE)
	c:RegisterEffect(e1)
	if not c33405100.global_check then
		c33405100.global_check=true
		im_miracle={}
		im_miracle[1]=0 
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_LEAVE_FIELD)
		ge1:SetOperation(c33405100.checkop)
		Duel.RegisterEffect(ge1,0)
	end
	--removed
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_LEAVE_FIELD)
	e1:SetOperation(c33405100.rmop)
	c:RegisterEffect(e1)
end
function c33405100.checkop(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	while tc do
	   if tc:GetOriginalCode()==33405100  then
		  if tc:IsReason(REASON_BATTLE+REASON_EFFECT)  then
			 if tc:IsReason(REASON_BATTLE) then
				local bt=tc:GetReasonCard()
				im_miracle[#im_miracle+1]=bt:GetOriginalCode()
			 end
			 if tc:IsReason(REASON_EFFECT) then
				local ec=tc:GetReasonEffect()
				local ef=ec:GetHandler()
				if aux.GetValueType(ef)=="Card" and ef:GetOriginalType()&TYPE_MONSTER~=0 then
				   im_miracle[#im_miracle+1]=ef:GetOriginalCode()
				end 
			 end
		  end
	   end
	   tc=eg:GetNext()
	end
end
function c33405100.get_announce(t)
	local rt={t[1],OPCODE_ISCODE}
	for i=2,#t do
		table.insert(rt,t[i])
		table.insert(rt,OPCODE_ISCODE)
		table.insert(rt,OPCODE_OR)
	end
	--table.insert(rt,TYPE_MONSTER)
	--table.insert(rt,OPCODE_ISTYPE)
	--table.insert(rt,OPCODE_AND)
	return table.unpack(rt)
end
function c33405100.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return #im_miracle>1 end
	Duel.Hint(HINT_CARD,0,e:GetHandler():GetOriginalCode())
	local rcode=Duel.AnnounceCard(tp,c33405100.get_announce(im_miracle))
	Duel.SetTargetParam(rcode)
end
function c33405100.setop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local code=Duel.GetChainInfo(0,CHAININFO_TARGET_PARAM)
	local f=Card.RegisterEffect
	Card.RegisterEffect=function(tc,e,forced)
		 e:SetCondition(c33405100.rcon2_2(e:GetCondition()))
		 e:SetCost(c33405100.rcost2_2(e:GetCost()))
		 f(tc,e,forced)
	end
	c:CopyEffect(code,RESET_EVENT+0x1fe0000,1)
	Card.RegisterEffect=f
	local ra=Duel.ReadCard(code,4)
	local lv=0
	if ra&TYPE_XYZ~=0 or ra&TYPE_LINK~=0 then
	   lv=1
	else
	   lv=Duel.ReadCard(code,5)
	end
	local atk=Duel.ReadCard(code,8)
	local def=Duel.ReadCard(code,9)
	local race=Duel.ReadCard(code,7)
	local att=Duel.ReadCard(code,6)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SET_BASE_ATTACK)
	e1:SetValue(atk)
	e1:SetReset(RESET_EVENT+0x1fe0000)
	c:RegisterEffect(e1,true)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_SET_BASE_DEFENSE)
	e2:SetValue(def)
	c:RegisterEffect(e2,true)
	local e4=e1:Clone()
	e4:SetCode(EFFECT_CHANGE_RACE)
	e4:SetValue(race)
	c:RegisterEffect(e4,true)
	local e5=e1:Clone()
	e5:SetCode(EFFECT_CHANGE_ATTRIBUTE)
	e5:SetValue(att)
	c:RegisterEffect(e5,true)
	local e6=e1:Clone()
	e6:SetCode(EFFECT_CHANGE_LEVEL)
	e6:SetValue(lv)
	c:RegisterEffect(e6,true)
	local e7=e1:Clone()
	e7:SetType(EFFECT_TYPE_SINGLE)
	e7:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e7:SetCode(EFFECT_CHANGE_CODE)
	e7:SetValue(code)
	c:RegisterEffect(e7,true)
	c:RegisterFlagEffect(33405100,RESET_EVENT+0x1fe0000,EFFECT_FLAG_CLIENT_HINT,0,1,aux.Stringid(33405100,1))
end
function c33405100.rcon2_2(con)
	return 
	function(e,tp,eg,ep,ev,re,r,rp)
		return not con or con(e,tp,eg,ep,ev,re,r,rp) or e:IsHasType(0x7e0)
	end
end
--
function c33405100.rcost2_2(cost)
	return 
	function(e,tp,eg,ep,ev,re,r,rp,chk)
		if chk==0 then return not cost or cost(e,tp,eg,ep,ev,re,r,rp,0) or e:IsHasType(0x7e0) end
		return not cost or e:IsHasType(0x7e0) or cost(e,tp,eg,ep,ev,re,r,rp,1)
	end
end
function c33405100.rmop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if e:GetHandler():IsFacedown() then return end
	local tr=Duel.GetTurnCount()
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e2:SetReset(RESET_PHASE+PHASE_STANDBY,2)
	e2:SetCountLimit(1)
	e2:SetLabel(tr)
	e2:SetCondition(c33405100.condition)
	e2:SetOperation(c33405100.operation)
	Duel.RegisterEffect(e2,tp)
end
function c33405100.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnCount()>e:GetLabel()
end
function c33405100.tgfilter(c)
	return c:IsCode(33405100)
end
function c33405100.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return e:Reset() end
	Duel.Hint(HINT_CARD,0,33405100)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c33405100.tgfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil)
	if g:GetCount()>0 then
	   Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
	e:Reset()
end