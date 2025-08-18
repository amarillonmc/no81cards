--得力助手
local s,id,o=GetID()
function s.initial_effect(c)
	aux.AddCodeList(c,75646600)
	--Activate1
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCountLimit(1,id+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(s.cost)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
	--act in hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(75646610,2))
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e2:SetCondition(s.handcon)
	c:RegisterEffect(e2)
end
function s.handcon(e)
	local f=Duel.GetFlagEffect(e:GetHandlerPlayer(),75646600)
	return f and f~=0
end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil) end
	local g=Duel.GetMatchingGroup(Card.IsDiscardable,tp,LOCATION_HAND,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
	local tc=g:Select(tp,1,1,e:GetHandler()):GetFirst()
	if tc:IsCode(75646600) then e:SetLabel(1) end
	Duel.SendtoGrave(tc,REASON_COST+REASON_DISCARD)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return re:GetHandler():IsAbleToDeck() end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,eg,1,0,0)
	if (e:GetLabel()==1 or Duel.GetFlagEffect(tp,75646600)~=0) then
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	end
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	if re:GetHandler():IsRelateToEffect(re) then
		if Duel.SendtoDeck(eg,nil,2,REASON_EFFECT)>0 then
			Duel.BreakEffect()
			local op=aux.SelectFromOptions(tp,
				{true,aux.Stringid(id,2)},
				{(e:GetLabel()==1 or Duel.GetFlagEffect(tp,75646600)~=0),aux.Stringid(id,3)},
				{true,aux.Stringid(id,4)})
			if op==1 then
				local rg=Duel.GetMatchingGroup(Card.IsOriginalCodeRule,tp,0x7f,0,nil,75646600)
				if rg:GetCount()>0 then
					local rc=rg:GetFirst()
					while rc do
						if rc:GetFlagEffect(5646600)<15 then
							rc:RegisterFlagEffect(5646600,0,0,0)
						end
						rc:ResetFlagEffect(646600)
						rc:RegisterFlagEffect(646600,0,EFFECT_FLAG_CLIENT_HINT,0,0,aux.Stringid(75646600,rc:GetFlagEffect(5646600)))	
						rc=rg:GetNext()
					end
				end
			elseif op==2 then
				Duel.NegateActivation(ev)
			end
		end 
	end
end