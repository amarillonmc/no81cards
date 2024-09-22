--梦坠
if not c71401001 then dofile("expansions/script/c71400001.lua") end
function c71400013.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(71400013,0))
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetTarget(c71400013.tg1)
	e1:SetCost(c71400013.cost)
	e1:SetOperation(c71400013.op1)
	e1:SetCountLimit(1,71400013+EFFECT_COUNT_CODE_OATH)
	c:RegisterEffect(e1)
end
function c71400013.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,500) end
	Duel.PayLPCost(tp,500)
end
function c71400013.filter2(c)
	return c:IsSetCard(0x714) and c:IsType(TYPE_MONSTER) and c:IsFaceupEx()
end

function c71400013.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=yume.YumeFieldCheck(tp,0,1)
	local tg=Duel.GetMatchingGroup(c71400013.filter2,tp,LOCATION_HAND+LOCATION_ONFIELD,0,nil)
	local b2=yume.IsYumeFieldOnField(tp) and tg:GetCount()>1 and Duel.GetFlagEffect(0,71400013)==0
	if chk==0 then return b1 or b2 end
	local op=0
	if b1 and b2 then
		op=Duel.SelectOption(tp,aux.Stringid(71400001,2),aux.Stringid(71400013,1))
	elseif b1 then
		op=Duel.SelectOption(tp,aux.Stringid(71400001,2))
	else
		op=Duel.SelectOption(tp,aux.Stringid(71400013,1))+1
	end
	if op==0 then
		if not Duel.CheckPhaseActivity() then e:SetLabel(1,op) else e:SetLabel(0,op) end
	else
		Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,tg,2,tp,LOCATION_HAND+LOCATION_ONFIELD)
	end
end
function c71400013.op1(e,tp,eg,ep,ev,re,r,rp)
	local act,op=e:GetLabel()
	if op==0 then
		local tc=yume.ActivateYumeField(e,tp,nil,1)
		local dg=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,aux.ExceptThisCard(e))
		if tc and dg:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(71400013,2)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
			local des=dg:Select(tp,1,1,nil)
			Duel.HintSelection(des)
			Duel.BreakEffect()
			Duel.SendtoGrave(des,REASON_EFFECT)
		end
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local g=Duel.SelectMatchingCard(tp,c71400013.filter2,tp,LOCATION_HAND+LOCATION_ONFIELD,0,2,2,nil)
		if g:GetCount()>0 then
			Duel.SendtoGrave(g,nil,REASON_EFFECT)
			local og=Duel.GetOperatedGroup()
			if og:GetCount()==2 and og:FilterCount(Card.IsLocation,nil,LOCATION_GRAVE)==2 then
				Duel.BreakEffect()
				local e1=Effect.CreateEffect(e:GetHandler())
				e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
				e1:SetCode(EVENT_CHAIN_SOLVING)
				e1:SetCondition(c71400013.discon)
				e1:SetOperation(c71400013.disop)
				e1:SetReset(RESET_PHASE+PHASE_END)
				Duel.RegisterEffect(e1,tp)
				Duel.RegisterFlagEffect(0,71400013,RESET_PHASE+PHASE_END,0,1)
			end
		end
	end
end
function c71400013.discon(e,tp,eg,ep,ev,re,r,rp)
	return re:IsActiveType(TYPE_MONSTER) and re:GetActivateLocation()&(LOCATION_MZONE+LOCATION_GRAVE)~=0
end
function c71400013.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateEffect(ev)
end