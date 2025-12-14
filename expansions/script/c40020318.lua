--觉龙的神托
local s,id=GetID()

local CODE_MITRA=40020256

s.named_with_AwakenedDragon=1
function s.AwakenedDragon(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_AwakenedDragon
end

function s.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,id)  
	e1:SetTarget(s.tg1)
	e1:SetOperation(s.op1)
	c:RegisterEffect(e1)

	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))  
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,id+1)
	e2:SetCost(s.spcost2)
	e2:SetTarget(s.sptg2)
	e2:SetOperation(s.spop2)
	c:RegisterEffect(e2)
end

function s.topfilter(c)
	return c:IsCode(CODE_MITRA) or s.AwakenedDragon(c)
end
function s.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>=3
	end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,0,tp,LOCATION_EXTRA)
end
-- 把组 g 当作灵摆卡使用加入额外卡组
function s.SendGroupToExtraAsPendulum(g,tp,reason,e)
	local handler = e and e:GetHandler() or nil
	local tc=g:GetFirst()
	while tc do
		if not tc:IsType(TYPE_PENDULUM) then
			local e1=Effect.CreateEffect(handler)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_ADD_TYPE)
			e1:SetValue(TYPE_PENDULUM)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e1,true)
		end
		tc=g:GetNext()
	end
	Duel.SendtoExtraP(g,tp,reason)
end
function s.op1(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)<3 then return end
	Duel.ConfirmDecktop(tp,3)
	local g=Duel.GetDecktopGroup(tp,3)
	if #g==0 then return end
	local cand=g:Filter(s.topfilter,nil)
	local send_ct=0
	local chosen=Group.CreateGroup()
	if #cand>0 then
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(id,2)) 
		chosen=cand:Select(tp,0,#cand,nil)
		send_ct=#chosen
		if send_ct>0 then
			s.SendGroupToExtraAsPendulum(chosen,tp,REASON_EFFECT,e)
		end
	end
	local rest=g:Filter(function(c) return not chosen:IsContains(c) end,nil)
	if #rest>0 then
		Duel.SendtoDeck(rest,nil,SEQ_DECKBOTTOM,REASON_EFFECT)
	end
	if send_ct<=0 then return end
	local eg2=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_EXTRA,0,nil)
	if #eg2==0 then return end
	local num=math.min(send_ct,#eg2)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local sg=eg2:Select(tp,num,num,nil)
	if #sg>0 then
		Duel.SendtoDeck(sg,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
	end
end

function s.exfilter(c,e,tp)
	if not (c:IsFaceup() and c:IsLocation(LOCATION_EXTRA)) then
		return false
	end
	if not (c:IsCode(40020256) or s.AwakenedDragon(c)) then
		return false
	end
	if not (c:IsType(TYPE_PENDULUM) and c:IsType(TYPE_MONSTER)) then
		return false
	end
	local can_ss = Duel.GetLocationCountFromEx(tp,tp,nil,c)>0
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
	local can_pzone = (Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1))
		and not c:IsForbidden()
	return can_ss or can_pzone
end

function s.spcost2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return c:IsLocation(LOCATION_GRAVE) and c:IsAbleToRemoveAsCost()
	end
	Duel.Remove(c,POS_FACEUP,REASON_COST)
end
function s.sptg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(s.exfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function s.spop2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
	local g=Duel.SelectMatchingCard(tp,s.exfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	if not tc then return end
	local can_ss = Duel.GetLocationCountFromEx(tp,tp,nil,tc)>0
		and tc:IsCanBeSpecialSummoned(e,0,tp,false,false)
	local can_pzone = Duel.CheckPendulumZones(tp)
	if not (can_ss or can_pzone) then return end
	local op
	if can_ss and can_pzone then
		op = Duel.SelectOption(tp,aux.Stringid(id,3),aux.Stringid(id,4))
	elseif can_ss then
		op = 0
	else
		op = 1
	end
	if op==0 then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	else
		Duel.MoveToField(tc,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
	end
end
