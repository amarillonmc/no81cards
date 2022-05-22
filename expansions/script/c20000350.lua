--奉神天使 
local cm,m,o=GetID()
fu_god = fu_god or {}
function fu_god.Summon(c,code,f,op)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,code)
	e1:SetTarget(fu_god.Summon_Draw_tg)
	e1:SetOperation(fu_god.Summon_Draw_op)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,1))
	e2:SetCategory(CATEGORY_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_ONFIELD)
	e2:SetCountLimit(1,code+100)
	e2:SetCost(fu_god.Summon_Sum_cos)
	e2:SetTarget(fu_god.Summon_Sum_tg)
	e2:SetOperation(fu_god.Summon_Sum_op)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_CHAINING)
	e3:SetRange(LOCATION_ONFIELD)
	e3:SetCondition(fu_god.Summon_Ex_con)
	e3:SetOperation(fu_god.Summon_Ex_op(code,f,op))
	c:RegisterEffect(e3)
	return e1,e2,e3
end
function fu_god.Counter(c,cat,cod,pro,con,tg,op,cod2)
	local e=Effect.CreateEffect(c)
	e:SetCategory(cat)
	e:SetType(EFFECT_TYPE_ACTIVATE)
	e:SetCode(cod)
	e:SetProperty(pro)
	e:SetCondition(fu_god.Counter_con(con))
	e:SetCost(fu_god.Counter_cos)
	e:SetTarget(tg)
	e:SetOperation(op)
	c:RegisterEffect(e)
	if cod2 then
		local e2=e:Clone()
		e2:SetCode(cod2)
		c:RegisterEffect(e2)
		return e,e2
	end
	return e
end
function fu_god.Reg(e,m,tp)
	if not Duel.IsPlayerAffectedByEffect(tp,m) then
		Duel.RegisterFlagEffect(tp,m+19,0,0,1)
		local e=Effect.CreateEffect(e:GetHandler())
		e:SetType(EFFECT_TYPE_FIELD)
		e:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT)
		e:SetCode(m)
		e:SetTargetRange(1,0)
		e:SetDescription(aux.Stringid(m,0))
		Duel.RegisterEffect(e,tp)
	end
end
--------------------------------------------------------------
function fu_god.Summon_Draw_tg(e,tp,eg,ep,ev,re,r,rp,chk)
		if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
		Duel.SetTargetPlayer(tp)
		Duel.SetTargetParam(1)
		Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function fu_god.Summon_Draw_op(e,tp,eg,ep,ev,re,r,rp)
		local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
		if Duel.Draw(p,d,REASON_EFFECT)~=0 then
			local tc=Duel.GetOperatedGroup():GetFirst()
			Duel.ConfirmCards(1-tp,tc)
			Duel.BreakEffect()
			if not (tc:IsSetCard(0x5fd2) or tc:GetType()==0x100004) then
				Duel.SendtoDeck(tc,nil,2,REASON_EFFECT)
			end
			Duel.ShuffleHand(tp)
		end
end
function fu_god.Summon_Sum_cos(e,tp,eg,ep,ev,re,r,rp,chk)
		if chk==0 then return e:GetHandler():IsFaceup() and e:GetHandler():IsAbleToHandAsCost() end
		Duel.SendtoHand(e:GetHandler(),nil,REASON_EFFECT)
end
function fu_god.Summon_Sum_tg(e,tp,eg,ep,ev,re,r,rp,chk)
		if chk==0 then return Duel.GetFieldGroup(tp,LOCATION_DECK,0) end
		Duel.SetOperationInfo(0,CATEGORY_SUMMON,nil,1,tp,0)
end
function fu_god.Summon_Sum_op(e,tp,eg,ep,ev,re,r,rp)
		Duel.ShuffleDeck(tp)
		local g=Duel.GetMatchingGroup(function(c)return c:IsSetCard(0x5fd2) and c:IsSummonable(true,nil)end,tp,LOCATION_HAND,0,nil)
		if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(m,1)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
			local tc=g:Select(tp,1,1,nil):GetFirst()
			Duel.Summon(tp,tc,true,nil)
		end
end
function fu_god.Summon_Ex_con(e,tp,eg,ep,ev,re,r,rp)
		return re:GetHandler():IsSetCard(0x5fd2) and re:GetHandler():GetType()==0x100004 and re:IsHasType(EFFECT_TYPE_ACTIVATE)
end
function fu_god.Summon_Ex_op(code,f,op)
	return function(e,tp,eg,ep,ev,re,r,rp)
				if Duel.IsExistingMatchingCard(f,tp,LOCATION_ONFIELD+LOCATION_GRAVE,LOCATION_ONFIELD+LOCATION_GRAVE,1,nil)
				and e:GetHandler():GetFlagEffect(m)==0 and Duel.SelectYesNo(tp,aux.Stringid(code,0)) then
					e:GetHandler():RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(m,2))
					local g=Duel.SelectMatchingCard(tp,f,tp,LOCATION_ONFIELD+LOCATION_GRAVE,LOCATION_ONFIELD+LOCATION_GRAVE,1,1,nil)
					local fc=g:GetFirst()
					if #g>0 then
						op(e,tp,eg,ep,ev,re,r,rp,g,fc)
					end
				end
			end
end
function fu_god.Counter_con(con)
	return function(e,tp,eg,ep,ev,re,r,rp)
				return Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,0,nil):FilterCount(Card.IsRace,nil,RACE_FAIRY) and con(e,tp,eg,ep,ev,re,r,rp)
			end
end
function fu_god.Counter_cos(e,tp,eg,ep,ev,re,r,rp,chk)
		if chk==0 then return Duel.GetLP(tp)>=1000  end
		Duel.PayLPCost(tp,1000)
end