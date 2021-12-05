local m=53799136
local cm=_G["c"..m]
cm.name="腕角力"
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_DESTROY)
	e4:SetDescription(aux.Stringid(m,2))
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e4:SetRange(LOCATION_SZONE)
	e4:SetProperty(EFFECT_FLAG_EVENT_PLAYER)
	e4:SetCode(EVENT_CUSTOM+m)
	e4:SetTarget(cm.target)
	e4:SetOperation(cm.operation)
	c:RegisterEffect(e4)
	if not cm.global_check then
		cm.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_SUMMON_SUCCESS)
		ge1:SetOperation(cm.check)
		Duel.RegisterEffect(ge1,0)
		local ge2=ge1:Clone()
		ge2:SetCode(EVENT_SPSUMMON_SUCCESS)
		Duel.RegisterEffect(ge2,0)
		local ge3=ge1:Clone()
		ge3:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
		Duel.RegisterEffect(ge3,0)
	end
end
function cm.check(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g1=Group.CreateGroup()
	local g2=Group.CreateGroup()
	for tc in aux.Next(eg) do
		if tc:IsControler(0) then g1:AddCard(tc) else g2:AddCard(tc) end
	end
	if #g1>0 then Duel.RaiseEvent(g1,EVENT_CUSTOM+m,re,r,rp,0,0) end
	if #g2>0 then Duel.RaiseEvent(g2,EVENT_CUSTOM+m,re,r,rp,1,0) end
end
function cm.filter1(c)
	return c:IsLocation(LOCATION_MZONE) and c:IsFaceup()
end
function cm.filter2(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local b1=eg:IsExists(cm.filter1,1,nil)
	local b2=eg:IsExists(Card.IsLocation,1,nil,LOCATION_MZONE) and Duel.IsExistingMatchingCard(cm.filter2,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil)
	if chk==0 then return b1 or b2 end
	local s=0
	if b1 and not b2 then
		s=Duel.SelectOption(tp,aux.Stringid(m,0))
	elseif not b1 and b2 then
		s=Duel.SelectOption(tp,aux.Stringid(m,1))+1
	elseif b1 and b2 then
		s=Duel.SelectOption(tp,aux.Stringid(m,0),aux.Stringid(m,1))
	end
	e:SetLabel(s)
	if s==0 then
		e:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
	else
		e:SetCategory(CATEGORY_DESTROY)
		local sg=Duel.GetMatchingGroup(cm.filter2,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,sg,1,0,0)
	end
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if e:GetLabel()==0 then
		local fg=eg:Filter(cm.filter1,nil)
		if #fg>0 then
			local tc=fg:GetFirst()
			if #fg>1 then tc=fg:Select(tp,1,1,nil):GetFirst() end
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetValue(-1000)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e1)
			local e2=e1:Clone()
			e2:SetCode(EFFECT_UPDATE_DEFENSE)
			tc:RegisterEffect(e2)
		end
	end
	if e:GetLabel()==1 then
		local sg=Duel.GetMatchingGroup(cm.filter2,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
		local fg=eg:Filter(Card.IsLocation,nil,LOCATION_MZONE)
		if #fg>0 and #sg>0 then
			if #fg>1 then fg=fg:Select(tp,1,1,nil) end
			if Duel.SendtoGrave(fg,REASON_EFFECT)==1 then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
				local g=sg:Select(tp,1,1,nil)
				if g:GetCount()>0 then
					Duel.HintSelection(g)
					Duel.Destroy(g,REASON_EFFECT)
				end
			end
		end
	end
end
