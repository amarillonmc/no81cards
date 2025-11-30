--魔契的禁忌封缄
local s,id,o=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_POSITION)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetCountLimit(1,id)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
	--set
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,4))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,id)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCost(aux.bfgcost)
	e2:SetCountLimit(1,id)
	e2:SetTarget(s.thtg)
	e2:SetOperation(s.thop)
	c:RegisterEffect(e2)
end
function s.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x3cf0) and c:IsCanChangePosition()
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and s.cfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(s.cfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEDOWN)
	local g=Duel.SelectTarget(tp,s.cfilter,tp,LOCATION_MZONE,0,1,2,nil)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,g,g:GetCount(),0,0)
end
function s.filter(c,e)
	return c:IsRelateToEffect(e) and c:IsLocation(LOCATION_MZONE) and c:IsFaceup()
end
function s.filter1(c)
	return c:IsFaceup() and c:IsCanChangePosition()
end
function s.filter2(c)
	return c:IsFacedown() and c:IsCanChangePosition()
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local sg=g:Filter(s.filter,nil,e)
	local ct=sg:GetCount()
	if ct>0 and Duel.ChangePosition(sg,POS_FACEDOWN_DEFENSE)~=0 then
		local b1=Duel.IsExistingMatchingCard(s.filter1,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil)
		local b2=Duel.IsExistingMatchingCard(s.filter2,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil)
		if (b1 or b2) and Duel.SelectYesNo(tp,aux.Stringid(id,1)) then
			local op=0
			if b1 and b2 then
				op=Duel.SelectOption(tp,aux.Stringid(id,2),aux.Stringid(id,3))
			elseif b1 then
				op=Duel.SelectOption(tp,aux.Stringid(id,2))
			else
				op=Duel.SelectOption(tp,aux.Stringid(id,3))+1
			end
				if op==0 then
					local tg=Duel.SelectMatchingCard(tp,s.filter1,tp,LOCATION_MZONE,LOCATION_MZONE,1,ct,nil)
					if tg:GetCount()>0 then
						Duel.ChangePosition(tg,POS_FACEDOWN_DEFENSE)
					end
				else
					local tg=Duel.SelectMatchingCard(tp,s.filter2,tp,LOCATION_MZONE,LOCATION_MZONE,1,ct,nil)
					if tg:GetCount()>0 then
						Duel.ChangePosition(tg,POS_FACEUP_ATTACK)
				end
			end
		end
	end
end
function s.setfilter(c)
	return not c:IsCode(id) and c:IsSetCard(0x3cf0) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsFaceup() and c:IsSSetable()
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE+LOCATION_REMOVED) and chkc:IsControler(tp) and s.setfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(s.setfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectTarget(tp,s.setfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,g,1,0,0)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and aux.NecroValleyFilter()(tc) then
		Duel.SSet(tp,tc)
	end
end
