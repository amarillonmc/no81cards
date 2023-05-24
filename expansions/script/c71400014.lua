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
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetRange(LOCATION_FZONE)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCondition(c71400014.con2)
	e2:SetCost(c71400014.cost2)
	e2:SetTarget(c71400014.tg2)
	e2:SetOperation(c71400014.op2)
	c:RegisterEffect(e2)
	--eat each other
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(71400014,2))
	e3:SetCategory(CATEGORY_DESTROY+CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_FZONE)
	e3:SetTarget(c71400014.tg3)
	e3:SetOperation(c71400014.op3)
	c:RegisterEffect(e3)
	--self to deck & activate field
	yume.AddYumeFieldGlobal(c,71400014,1)
end
function c71400014.op1(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.SelectYesNo(tp,aux.Stringid(71400014,3)) then return end
	Duel.Hint(HINT_CARD,0,71400014)
	local c=e:GetHandler()
	c:RegisterFlagEffect(71400014,RESET_PHASE+PHASE_END+RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(71400014,0))
	Duel.Hint(HINT_SELECTMSG,rp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(rp,nil,0,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,aux.ExceptThisCard(e))
	if g:GetCount()>0 then
		Duel.HintSelection(g)
		if Duel.SendtoGrave(g,REASON_EFFECT)>0 then
			Duel.BreakEffect()
			Duel.Recover(rp,1000,REASON_EFFECT)
		end
	end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetTargetRange(1,0)
	e1:SetValue(c71400014.aclimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,rp)
end
function c71400014.aclimit(e,re,tp)
	return not (re:IsActiveType(TYPE_TRAP) or re:GetHandler():IsSetCard(0x714) and re:IsActiveType(TYPE_FIELD))
end
function c71400014.con1(e,tp,eg,ep,ev,re,r,rp)
	return re:IsActiveType(TYPE_TRAP) and e:GetHandler():GetFlagEffect(1)~=0 and Duel.GetFlagEffect(tp,71400014)==0
end
function c71400014.filter2(c,e,tp)
	return c:IsSetCard(0x714) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c71400014.con2(e,tp,eg,ep,ev,re,r,rp)
	return re:IsActiveType(TYPE_TRAP) and e:GetHandler():IsStatus(STATUS_EFFECT_ENABLED)
end
function c71400014.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,2000) end
	Duel.PayLPCost(tp,2000)
end
function c71400014.filter2(c)
	return c:IsXyzSummonable(nil) and c:IsSetCard(0x714)
end
function c71400014.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c71400014.filter2,tp,LOCATION_EXTRA,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c71400014.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
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
	e1:SetValue(2000)
	e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
	e1:SetReset(RESET_EVENT+0xff0000)
	c:RegisterEffect(e1)
	e:Reset()
end
function c71400014.filter3a(c)
	return c:IsSetCard(0x714) and c:IsType(TYPE_TRAP) and c:IsAbleToHand()
end
function c71400014.filter3b(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x714) and (c:IsFaceup() or not c:IsLocation(LOCATION_MZONE))
end
function c71400014.tg3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c71400014.filter3b,tp,LOCATION_HAND+LOCATION_MZONE,0,2,nil)
		and Duel.IsExistingMatchingCard(c71400014.filter3a,tp,LOCATION_DECK,0,1,nil) end
	local g=Duel.GetMatchingGroup(c71400014.filter3b,tp,LOCATION_HAND+LOCATION_MZONE,0,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,2,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c71400014.op3(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,c71400014.filter3b,tp,LOCATION_HAND+LOCATION_MZONE,0,2,2,nil)
	if g:GetCount()==2 and Duel.Destroy(g,REASON_EFFECT)==2 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=Duel.SelectMatchingCard(tp,c71400014.filter3a,tp,LOCATION_DECK,0,1,2,nil)
		if sg:GetCount()>0 then
			Duel.SendtoHand(sg,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,sg)
		end
	end
end