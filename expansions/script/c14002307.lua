--共振者 哈斯塔
local m=14002307
local cm=_G["c"..m]
cm.named_with_Hastur=1
function cm.initial_effect(c)
	--SpecialSummon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e1:SetCondition(cm.spcon)
	e1:SetTarget(cm.sptg)
	e1:SetOperation(cm.spop)
	e1:SetValue(SUMMON_VALUE_SELF)
	c:RegisterEffect(e1)
	--token
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCost(cm.cost)
	e2:SetTarget(cm.sltg)
	e2:SetOperation(cm.slop)
	c:RegisterEffect(e2)
	cm.selfsummon_effect=e2 
	--rep
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EFFECT_SEND_REPLACE)
	e3:SetRange(0xff)
	e3:SetTarget(cm.reptg)
	e3:SetValue(cm.repval)
	c:RegisterEffect(e3)
end
function cm.Urara(c)
	local m_code=_G["c"..c:GetCode()]
	return m_code and m_code.named_with_Urara
end
function cm.Hastur(c)
	local m_code=_G["c"..c:GetCode()]
	return m_code and m_code.named_with_Hastur
end
function cm.get_available_field(tp,code)
	if not UraraG_fieldcheck then return nil end
	local c=nil
	if code==14002341 and UraraG_fieldcheck.release then
		c=UraraG_fieldcheck.release[tp]
	elseif code==14002342 and UraraG_fieldcheck.counter then
		c=UraraG_fieldcheck.counter[tp]
	end
	if c and type(c)=="userdata" and c:IsHasEffect(code)~=nil and c:GetFlagEffect(code)==0 then
		return c
	end
	return nil
end
function cm.chk_cost(tp)
	local ct=Duel.GetFlagEffect(tp,m)
	if ct>=3 then return false end
	if ct>=1 then
		if cm.get_available_field(tp, 14002342) ~= nil then
			return true
		end
		return Duel.IsCanRemoveCounter(tp,1,1,0x1402,1,REASON_COST)
	end
	return true
end
function cm.pay_cost(tp)
	local ct=Duel.GetFlagEffect(tp,m)
	if ct>=1 then
		local fc = cm.get_available_field(tp, 14002342)
		local has_counter = Duel.IsCanRemoveCounter(tp,1,1,0x1402,1,REASON_COST)
		if fc and (not has_counter or Duel.SelectYesNo(tp,aux.Stringid(14002341,0))) then
			fc:RegisterFlagEffect(14002342,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
		else
			Duel.RemoveCounter(tp,1,1,0x1402,1,REASON_COST)
		end
	end
	Duel.RegisterFlagEffect(tp,m,RESET_PHASE+PHASE_END,0,1)
end
function cm.relfilter(c,tp)
	return (c:IsFaceup() or c:IsControler(tp)) and cm.Urara(c) and c:IsReleasable() and Duel.GetMZoneCount(tp,c)>0
end
function cm.deck_cost_filter(c)
	return cm.Urara(c) and c:IsAbleToGraveAsCost()
end
function cm.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local b1=Duel.IsExistingMatchingCard(cm.relfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,tp)
	local b2=cm.get_available_field(tp, 14002341) ~= nil
		and Duel.IsExistingMatchingCard(cm.deck_cost_filter,tp,LOCATION_DECK,0,1,nil)
	return b1 or b2
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk,c)
	local b1=Duel.IsExistingMatchingCard(cm.relfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,tp)
	local fc=cm.get_available_field(tp, 14002341)
	local b2=(fc~=nil) and Duel.IsExistingMatchingCard(cm.deck_cost_filter,tp,LOCATION_DECK,0,1,nil)
	local op=0
	if b1 and b2 then
		op=Duel.SelectOption(tp,aux.Stringid(m,0),aux.Stringid(14002341,1))
	elseif b1 then
		op=0
	else
		op=1
	end
	if op==0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		local g=Duel.SelectMatchingCard(tp,cm.relfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,tp)
		g:KeepAlive()
		e:SetLabelObject(g)
		e:SetLabel(0)
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local g=Duel.SelectMatchingCard(tp,cm.deck_cost_filter,tp,LOCATION_DECK,0,1,1,nil)
		g:KeepAlive()
		e:SetLabelObject(g)
		e:SetLabel(1)
		fc:RegisterFlagEffect(14002341,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
	end
	return true
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=e:GetLabelObject()
	if e:GetLabel()==0 then
		Duel.Release(g,REASON_COST)
	else
		Duel.SendtoGrave(g,REASON_COST)
	end
	g:DeleteGroup()
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return cm.chk_cost(tp) end
	cm.pay_cost(tp)
end
function cm.sltg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true
		--Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsPlayerCanSpecialSummonMonster(tp,14002382,0,TYPES_TOKEN_MONSTER,2500,2500,5,RACE_FIEND,ATTRIBUTE_DARK) 
	end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,tp,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,0)
	if bit.band(e:GetHandler():GetSummonType(),SUMMON_VALUE_SELF)==SUMMON_VALUE_SELF or e:GetHandler():IsCode(14002327) then
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,0,LOCATION_ONFIELD)
	end
end
function cm.slop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsPlayerCanSpecialSummonMonster(tp,14002382,0,TYPES_TOKEN_MONSTER,2500,2500,5,RACE_FIEND,ATTRIBUTE_DARK) then
		local token=Duel.CreateToken(tp,14002382)
		Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP)
	end
	if c:IsSummonType(SUMMON_VALUE_SELF) then
		local dg=Duel.GetMatchingGroup(Card.IsAbleToHand,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
		if #dg>0 and Duel.SelectYesNo(tp,aux.Stringid(m,2)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
			local sg=dg:Select(tp,1,1,nil)
			if #sg>0 then Duel.SendtoHand(sg,nil,REASON_EFFECT) end
		end
	end
end
function cm.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then 
		return bit.band(r,REASON_COST)~=0 
			and re and re:GetLabel()==14002381 
			and eg:IsContains(c)
			and c:GetDestination()==LOCATION_DECK
			and c:GetControler()==tp
			and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
			and Duel.IsPlayerCanSpecialSummonMonster(tp,14002382,0,TYPES_TOKEN_MONSTER,2500,2500,5,RACE_FIEND,ATTRIBUTE_DARK)
			and cm.chk_cost(tp) 
	end
	if Duel.SelectYesNo(tp,aux.Stringid(m,3)) then
		cm.pay_cost(tp)
		local token=Duel.CreateToken(tp,14002382)
		Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP)
		return true
	else 
		return false 
	end
end
function cm.repval(e,c)
	return c==e:GetHandler()
end