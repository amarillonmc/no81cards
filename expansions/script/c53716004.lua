if not pcall(function() require("expansions/script/c10199990") end) then require("script/c10199990") end
local m=53716004
local cm=_G["c"..m]
cm.name="沉默于断片的处决"
function cm.initial_effect(c)
	local e0=Effect.CreateEffect(c)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	e0:SetValue(aux.FALSE)
	c:RegisterEffect(e0)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetCountLimit(1,m)
	e1:SetCost(cm.cost)
	e1:SetTarget(cm.tg)
	e1:SetOperation(cm.op)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,1))
	e2:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e2:SetCode(EVENT_RELEASE)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e2:SetCountLimit(1,m+50)
	e2:SetCondition(cm.condition)
	e2:SetTarget(cm.target)
	e2:SetOperation(cm.operation)
	c:RegisterEffect(e2)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetRange(LOCATION_SZONE)
	e5:SetTargetRange(LOCATION_MZONE,0)
	e5:SetTarget(cm.indtg)
	e5:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e5:SetValue(1)
	c:RegisterEffect(e5)
	local e6=e5:Clone()
	e6:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	c:RegisterEffect(e6)
end
function cm.costfilter2(c)
	return bit.band(c:GetType(),0x20002)==0x20002 and c:IsSetCard(0x353b) and c:IsReleasable()
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local mg=Duel.GetMatchingGroup(Card.IsSetCard,tp,LOCATION_MZONE,0,nil,0x353b)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.costfilter2,tp,LOCATION_ONFIELD,0,1,nil) end
	Duel.ConfirmCards(1-tp,e:GetHandler())
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g=Duel.SelectMatchingCard(tp,cm.costfilter2,tp,LOCATION_ONFIELD,0,1,1,nil)
	local cg=g:Filter(Card.IsFacedown,nil)
	if #cg>0 then Duel.ConfirmCards(1-tp,cg) end 
	local tc=g:GetFirst()
	if tc:IsLocation(LOCATION_SZONE) then
		local list={}
		table.insert(list,tc:GetSequence())
		table.insert(list,5)
		e:SetLabel(table.unpack(list))
	else e:SetLabel(5) end
	Duel.Release(g,REASON_EFFECT)
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local mg=Duel.GetMatchingGroup(Card.IsSetCard,tp,LOCATION_MZONE,0,nil,0x353b)
		return Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and Duel.IsExistingMatchingCard(Card.IsSynchroSummonable,tp,LOCATION_EXTRA,0,1,nil,nil,mg)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function cm.offilter(c,list)
	return c:GetSequence()<5 and bit.band(table.unpack(list),c:GetSequence())==0
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local list={e:GetLabel()}
	local zg=Duel.GetMatchingGroup(cm.offilter,tp,LOCATION_SZONE,0,nil,list)
	if #zg>0 then
		for tc in aux.Next(zg) do
			table.insert(list,tc:GetSequence()) 
		end
	end
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and #list<6 then
		local filter=0
		for i=1,#list do
			filter=filter|1<<(list[i]+8)
		end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOZONE)
		local flag=Duel.SelectField(tp,1,LOCATION_SZONE,0,filter)
		if rsop.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,true,2^(math.log(flag,2)-8)) then
			local e1=Effect.CreateEffect(c)
			e1:SetCode(EFFECT_CHANGE_TYPE)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
			e1:SetValue(TYPE_SPELL+TYPE_CONTINUOUS)
			c:RegisterEffect(e1)
			local mg=Duel.GetMatchingGroup(Card.IsSetCard,tp,LOCATION_MZONE,0,nil,0x353b)
			local g=Duel.GetMatchingGroup(Card.IsSynchroSummonable,tp,LOCATION_EXTRA,0,nil,nil,mg)
			if g:GetCount()>0 then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
				local sg=g:Select(tp,1,1,nil)
				Duel.SynchroSummon(tp,sg:GetFirst(),nil,mg)
			end
		end
	end
end
function cm.indtg(e,c)
	local ct1=aux.GetColumn(e:GetHandler())
	local ct2=aux.GetColumn(c)
	if not ct1 or not ct2 then return false end
	return math.abs(ct1-ct2)==0 and c:GetSequence()<5
end
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end
function cm.setfilter(c)
	return c:IsSetCard(0x353b) and bit.band(c:GetType(),0x20004)==0x20004 and c:IsSSetable()
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.setfilter,tp,LOCATION_DECK,0,1,nil) end
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectMatchingCard(tp,cm.setfilter,tp,LOCATION_DECK,0,1,1,nil)
	if #g>0 then Duel.SSet(tp,g) end
end
