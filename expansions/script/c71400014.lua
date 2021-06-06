--幻异梦境-梦幻图书馆
xpcall(function() require("expansions/script/c71400001") end,function() require("script/c71400001") end)
function c71400014.initial_effect(c)
	--red remedy
	local e1a=Effect.CreateEffect(c)
	e1a:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e1a:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1a:SetCode(EVENT_CHAINING)
	e1a:SetRange(LOCATION_FZONE)
	e1a:SetOperation(aux.chainreg)
	c:RegisterEffect(e1a)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetRange(LOCATION_FZONE)
	e1:SetCode(EVENT_CHAIN_SOLVING)
	e1:SetOperation(c71400014.op1)
	e1:SetCondition(c71400014.con1)
	c:RegisterEffect(e1)
	--heart
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(71400014,1))
	e2:SetCategory(CATEGORY_TOGRAVE)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCountLimit(1)
	e2:SetCost(c71400014.cost2)
	e2:SetTarget(c71400014.tg2)
	e2:SetOperation(c71400014.op2)
	c:RegisterEffect(e2)
	--self to deck & activate field
	yume.AddYumeFieldGlobal(c,71400014,1)
end
function c71400014.op1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,71400014)
	Duel.Hint(HINT_SELECTMSG,rp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(rp,nil,rp,LOCATION_ONFIELD,0,1,1,aux.ExceptThisCard(re))
	if g:GetCount()>0 then
		Duel.HintSelection(g)
		if Duel.SendtoGrave(g,REASON_EFFECT)>0 then
			Duel.BreakEffect()
			Duel.Recover(rp,1000,REASON_EFFECT)
		end
	end
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetTargetRange(1,0)
	e1:SetValue(c71400014.aclimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,rp)
	c:RegisterFlagEffect(0,RESET_PHASE+PHASE_END+RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(71400014,0))
end
function c71400014.aclimit(e,re,tp)
	return not re:IsActiveType(TYPE_TRAP)
end
function c71400014.con1(e,tp,eg,ep,ev,re,r,rp)
	return re:IsActiveType(TYPE_TRAP) and e:GetHandler():GetFlagEffect(1)~=0
end
function c71400014.filter2(c,e,tp)
	return c:IsSetCard(0x714) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c71400014.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c71400014.filter2,tp,LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,0,tp,LOCATION_HAND)
end
function c71400014.cost2(e,tp,eg,ep,ev,re,r,rp)
	if chk==0 then return Duel.CheckLPCost(tp,1000) end
	Duel.PayLPCost(tp,1000)
end
function c71400014.filter2(c)
	return c:IsXyzSummonable(nil) and c:IsSetCard(0x715)
end
function c71400014.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c71400014.filter2,tp,LOCATION_EXTRA,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c71400014.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local g=Duel.GetMatchingGroup(c71400014.filter2,tp,LOCATION_EXTRA,0,nil)
	if g:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tg=g:Select(tp,1,1,nil)
		local tc=tg:GetFirst()
		Duel.XyzSummon(tp,tc,nil)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SPSUMMON_COST)
		e1:SetLabelObject(c)
		e1:SetOperation(c71400014.regop)
		tc:RegisterEffect(e1)
	end
end
function c71400014.regop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(e:GetLabelObject())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetDescription(aux.Stringid(71400014,1))
	e1:SetValue(1000)
	e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
	e1:SetReset(RESET_EVENT+0xff0000)
	c:RegisterEffect(e1)
	e:Reset()
end