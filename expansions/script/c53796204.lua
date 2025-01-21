local s,id=GetID()
function s.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetTarget(s.eqtg)
	e1:SetOperation(s.eqop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,EFFECT_COUNT_CODE_CHAIN)
	e2:SetCondition(s.atkcon)
	e2:SetOperation(s.atkop)
	c:RegisterEffect(e2)
end
function s.filter(c,tp)
	return c:IsRace(RACE_FISH) and c:IsLevel(2) and not c:IsForbidden() and c:CheckUniqueOnField(tp) and Duel.IsExistingMatchingCard(s.filter2,tp,LOCATION_DECK+LOCATION_HAND,0,1,c,c:GetCode())
end
function s.filter2(c,code)
	return c:IsType(TYPE_MONSTER) and c:IsCode(code) and not c:IsForbidden() and c:CheckUniqueOnField(tp)
end
function s.eqtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsRelateToEffect(e) and Duel.GetLocationCount(tp,LOCATION_SZONE)>1 and Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_DECK+LOCATION_HAND,0,1,nil,tp) end
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,nil,1,tp,LOCATION_DECK+LOCATION_HAND)
end
function s.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<2 or c:IsFacedown() or not c:IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local g1=Duel.SelectMatchingCard(tp,s.filter,tp,LOCATION_DECK+LOCATION_HAND,0,1,1,nil,tp)
	if g1:GetCount()<=0 then return end
	local ft=Duel.GetLocationCount(tp,LOCATION_SZONE)-1
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local g2=Duel.SelectMatchingCard(tp,s.filter2,tp,LOCATION_DECK+LOCATION_HAND,0,1,math.min(2,ft),g1,g1:GetFirst():GetCode())
	g1:Merge(g2)
	for tc in aux.Next(g1) do
		if Duel.Equip(tp,tc,c,true,true) then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_EQUIP_LIMIT)
			e1:SetProperty(EFFECT_FLAG_OWNER_RELATE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			e1:SetValue(s.eqlimit)
			tc:RegisterEffect(e1)
		end
	end
	Duel.EquipComplete()
	local cg=g1:Filter(Card.GetEquipTarget,nil)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_DIRECT_ATTACK)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	c:RegisterEffect(e1)
	local cp={}
	local f=Card.RegisterEffect
	Card.RegisterEffect=function(tc,te,bool)
		local pro1,pro2=te:GetProperty()
		if not te:IsActivated() and pro1&EFFECT_FLAG_UNCOPYABLE==0 then table.insert(cp,te:Clone()) end
		return f(tc,te,bool)
	end
	for tc in aux.Next(cg) do
		Duel.CreateToken(tp,tc:GetOriginalCode())
		for _,v in pairs(cp) do
			local pro1,pro2=v:GetProperty()
			local e1=Effect.CreateEffect(c)
			e1:SetType(v:GetType())
			e1:SetCode(v:GetCode())
			e1:SetProperty(pro1,pro2)
			if v:GetRange() and v:GetRange()~=0 then e1:SetRange(v:GetRange()) end
			if v:GetCondition() then e1:SetCondition(v:GetCondition()) end
			if v:GetCost() then e1:SetCost(v:GetCost()) end
			if v:GetTarget() then e1:SetTarget(v:GetTarget()) end
			if v:GetOperation() then e1:SetOperation(v:GetOperation()) end
			if v:GetValue() then e1:SetValue(v:GetValue()) end
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			f(c,e1,true)
		end
		cp={}
	end
	Card.RegisterEffect=f
end
function s.eqlimit(e,c)
	return e:GetOwner()==c
end
function s.atkcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local erv={Duel.IsPlayerAffectedByEffect(1-tp,EFFECT_REVERSE_DAMAGE)}
	local enbd={c:IsHasEffect(EFFECT_NO_BATTLE_DAMAGE)}
	local erd={Duel.IsPlayerAffectedByEffect(1-tp,EFFECT_REPLACE_DAMAGE)}
	local le1={c:IsHasEffect(EFFECT_CHANGE_BATTLE_DAMAGE)}
	local le2={c:IsHasEffect(EFFECT_CHANGE_INVOLVING_BATTLE_DAMAGE)}
	local le3={Duel.IsPlayerAffectedByEffect(1-tp,EFFECT_CHANGE_DAMAGE)}
	local le4={Duel.IsPlayerAffectedByEffect(1-tp,EFFECT_CHANGE_BATTLE_DAMAGE)}
	return (c==Duel.GetAttacker() or c==Duel.GetAttackTarget()) and #erv+#enbd+#erd+#le1+#le2+#le3+#le4~=0
end
function s.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local erv={Duel.IsPlayerAffectedByEffect(1-tp,EFFECT_REVERSE_DAMAGE)}
	local enbd={c:IsHasEffect(EFFECT_NO_BATTLE_DAMAGE)}
	local erd={Duel.IsPlayerAffectedByEffect(1-tp,EFFECT_REPLACE_DAMAGE)}
	local le1={c:IsHasEffect(EFFECT_CHANGE_BATTLE_DAMAGE)}
	local le2={c:IsHasEffect(EFFECT_CHANGE_INVOLVING_BATTLE_DAMAGE)}
	local le3={Duel.IsPlayerAffectedByEffect(1-tp,EFFECT_CHANGE_DAMAGE)}
	local le4={Duel.IsPlayerAffectedByEffect(1-tp,EFFECT_CHANGE_BATTLE_DAMAGE)}
	if #erv+#enbd+#erd+#le1+#le2+#le3+#le4==0 then return end
	local t,ret1,ret2={},{},{},{}
	for k,v in pairs(erv) do
		table.insert(ret1,v)
		local con=v:GetCondition() or aux.TRUE
		table.insert(ret2,con)
		v:SetCondition(aux.FALSE)
	end
	for k,v in pairs(enbd) do
		table.insert(ret1,v)
		local con=v:GetCondition() or aux.TRUE
		table.insert(ret2,con)
		v:SetCondition(aux.FALSE)
	end
	for k,v in pairs(erd) do
		table.insert(ret1,v)
		local con=v:GetCondition() or aux.TRUE
		table.insert(ret2,con)
		v:SetCondition(aux.FALSE)
	end
	for k,v in pairs(le1) do
		local val=v:GetValue()
		table.insert(t,val(v,1-tp))
		table.insert(ret1,v)
		local con=v:GetCondition() or aux.TRUE
		table.insert(ret2,con)
		v:SetCondition(aux.FALSE)
	end
	for k,v in pairs(le2) do
		local val=v:GetValue()
		table.insert(t,val(v,1-tp))
		table.insert(ret1,v)
		local con=v:GetCondition() or aux.TRUE
		table.insert(ret2,con)
		v:SetCondition(aux.FALSE)
	end
	for k,v in pairs(le3) do
		table.insert(t,v)
		table.insert(ret1,v)
		local con=v:GetCondition() or aux.TRUE
		table.insert(ret2,con)
		v:SetCondition(aux.FALSE)
	end
	for k,v in pairs(le4) do
		table.insert(t,v)
		table.insert(ret1,v)
		local con=v:GetCondition() or aux.TRUE
		table.insert(ret2,con)
		v:SetCondition(aux.FALSE)
	end
	local operations={}
	local atk=c:GetAttack()
	for k,v in pairs(t) do
		if aux.GetValueType(v)=="Effect" then
			local val=v:GetValue()
			local op=function(num)return val(v,Effect.CreateEffect(c),num,REASON_BATTLE,tp,c)end
			if op(atk)>atk then table.insert(operations,op) end
		elseif aux.GetValueType(v)=="number" then
			if v==DOUBLE_DAMAGE then
				local op=function(num)return num*2 end
				table.insert(operations,op)
			elseif v>atk then
				local op=function(num)return v end
				table.insert(operations,op)
			end
		end
	end
	local max_result = atk
	local function permute(list, n, current_result)
		if n == 0 then
			if current_result > max_result then
				max_result = current_result
			end
		else
			for i = 1, n do
				list[n], list[i] = list[i], list[n]
				permute(list, n - 1, operations[list[n]](current_result))
				list[n], list[i] = list[i], list[n]
			end
		end
	end
	local nct={}
	for i=1,#operations do table.insert(nct,i) end
	permute(nct,#nct,atk)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SET_ATTACK_FINAL)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_DAMAGE_CAL)
	e1:SetValue(max_result)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_ADJUST)
	e2:SetOperation(s.reset(ret1,ret2))
	Duel.RegisterEffect(e2,tp)
end
function s.reset(ret1,ret2)
	return  function(e,tp,eg,ep,ev,re,r,rp)
				local ph=Duel.GetCurrentPhase()
				if Duel.IsDamageCalculated() or (ph~=PHASE_DAMAGE and ph~=PHASE_DAMAGE_CAL) then
					e:Reset()
					for i=1,#ret1 do ret1[i]:SetCondition(ret2[i]) end
				end
			end
end
