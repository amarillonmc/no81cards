--大原满美食汇 - 美食之梦
local s,id,o=GetID()
function s.initial_effect(c)
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)

	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,0))
	e3:SetCategory(CATEGORY_RECOVER)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1,id)
	e3:SetTarget(s.target)
	e3:SetOperation(s.prop)
	c:RegisterEffect(e3)

	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_RECOVER)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCondition(s.con)
	e2:SetTarget(s.target2)
	e2:SetOperation(s.prop2)
	c:RegisterEffect(e2)
end

function s.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x607)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local ct=Duel.GetMatchingGroupCount(s.filter,tp,LOCATION_ONFIELD,0,nil)
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(ct*500)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,ct*500)
end
function s.filter2(c,tp)
	return c:IsSetCard(0x605) and c:GetType()==0x20004
		and c:GetActivateEffect():IsActivatable(tp)
end
function s.filter3(c,tp)
	return c:GetType()==0x20004 and c:IsSSetable()
end
function s.filter4(c)
	return c:IsReleasableByEffect() and c:IsLocation(LOCATION_ONFIELD) and c:IsFaceup()
end
function s.prop(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.GetMatchingGroupCount(s.filter,tp,LOCATION_ONFIELD,0,nil)
	Duel.Recover(tp,ct*500,REASON_EFFECT)
	
	Duel.BreakEffect()
	if Duel.GetLP(tp)-Duel.GetLP(1-tp)>=2000 and Duel.IsExistingMatchingCard(s.filter2,tp,LOCATION_DECK,0,1,nil,tp) and Duel.IsExistingMatchingCard(s.filter4,tp,LOCATION_ONFIELD,0,1,nil)  and Duel.SelectYesNo(tp,aux.Stringid(id,2)) then
		local g = Duel.SelectMatchingCard(tp,s.filter4,tp,LOCATION_ONFIELD,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.Release(g,REASON_EFFECT)
		end
		if Duel.GetLP(tp)-Duel.GetLP(1-tp)>=4000 and Duel.SelectYesNo(tp,aux.Stringid(id,3)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
			local g2 = Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.filter3),tp,LOCATION_GRAVE+LOCATION_DECK,0,1,1,nil,tp)
			local tc2 = g2:GetFirst()
			if tc2 then
				Duel.SSet(tp,tc2)
			end
		else
			local g2 = Duel.SelectMatchingCard(tp,s.filter2,tp,LOCATION_DECK,0,1,1,nil,tp)
			local tc2 = g2:GetFirst()
			if tc2 and tc2:GetActivateEffect():IsActivatable(tp) then
				Duel.MoveToField(tc2,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
				local te=tc2:GetActivateEffect()
				local tep=tc2:GetControler()
				local cost=te:GetCost()
				if cost then cost(te,tep,eg,ep,ev,re,r,rp,1) end
			end
		end
	end
end


function s.con(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD) and e:GetHandler():IsPreviousPosition(POS_FACEUP)
end
function s.target2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return true end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1000)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,1000)
end
function s.prop2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Recover(tp,1000,REASON_EFFECT)
end