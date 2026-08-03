--爱 舔 小 苏 打 的 天 才 女 童 星
local m=43990020
local cm=_G["c"..m]
function cm.initial_effect(c)
	aux.AddCodeList(c,43990016)
	--draw
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DRAW+CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,43990020)
	e1:SetCost(c43990020.drcost)
	e1:SetTarget(c43990020.drtg)
	e1:SetOperation(c43990020.drop)
	c:RegisterEffect(e1)

--  local e2=Effect.CreateEffect(c)
--  e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
--  e2:SetProperty(EFFECT_FLAG_DELAY)
--  e2:SetCode(EVENT_SPSUMMON_SUCCESS)
--  e2:SetRange(LOCATION_MZONE)
--  e2:SetCondition(c43990020.lpcon1)
--  e2:SetOperation(c43990020.lpop1)
--  c:RegisterEffect(e2)
--  --sp_summon effect
--  local e3=Effect.CreateEffect(c)
--  e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
--  e3:SetCode(EVENT_SPSUMMON_SUCCESS)
--  e3:SetRange(LOCATION_MZONE)
--  e3:SetCondition(c43990020.regcon)
--  e3:SetOperation(c43990020.regop)
--  c:RegisterEffect(e3)
--  local e31=Effect.CreateEffect(c)
--  e31:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
--  e31:SetCode(EVENT_CHAIN_SOLVED)
--  e31:SetRange(LOCATION_MZONE)
--  e31:SetCondition(c43990020.lpcon2)
--  e31:SetOperation(c43990020.lpop2)
--  e31:SetLabelObject(e3)
--  c:RegisterEffect(e31)
	--spsummon
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_GRAVE)
	e4:SetCountLimit(1,43991020)
	e4:SetCondition(c43990020.spcon)
	e4:SetTarget(c43990020.sptg)
	e4:SetOperation(c43990020.spop)
	c:RegisterEffect(e4)
	
end
function c43990020.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c43990020.cccfilter,tp,LOCATION_ONFIELD,0,1,nil)
end
function c43990020.spcfilter(c)
	return c:IsFaceup() and c:IsCode(43990018)
end
function c43990020.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c43990020.spcfilter,tp,LOCATION_ONFIELD,0,1,nil)
end
function c43990020.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c43990020.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c43990020.drcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local b2=Duel.IsExistingMatchingCard(Card.IsAbleToGraveAsCost,tp,LOCATION_HAND,0,1,c)
	if chk==0 then return c:IsAbleToGraveAsCost() and b2 end
	if b2 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local g=Duel.SelectMatchingCard(tp,Card.IsAbleToGraveAsCost,tp,LOCATION_HAND,0,1,1,c)
		local gc=g:GetFirst()
		e:SetLabel(gc:GetCode())
		g:AddCard(c)
		Duel.SendtoGrave(g,REASON_COST)
	end
end
function c43990020.tgfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsCode(43990016) and c:IsAbleToGrave()
end
function c43990020.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c43990020.tgfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function c43990020.setfilter(c)
	return aux.IsCodeListed(c,43990016) and c:IsType(TYPE_TRAP) and c:IsSSetable()
end
function c43990020.drop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c43990020.tgfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 and Duel.SendtoGrave(g,REASON_EFFECT)~=0 and  Duel.IsExistingMatchingCard(c43990020.setfilter,tp,LOCATION_DECK,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(43990020,1)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
		Duel.BreakEffect()
		local sg=Duel.SelectMatchingCard(tp,c43990020.setfilter,tp,LOCATION_DECK,0,1,1,nil)
		if Duel.SSet(tp,sg:GetFirst())~=0 and e:GetLabel()==43990016 and Duel.IsPlayerCanDraw(tp,1) and Duel.SelectYesNo(tp,aux.Stringid(43990020,0)) then
		Duel.BreakEffect()
		Duel.Draw(tp,1,REASON_EFFECT)
		end
	end
end



function c43990020.cccfilter(c)
	return c:IsFaceup() and c:IsCode(43990016)
end
function c43990020.cfilter(c,sp)
	return c:IsType(TYPE_EFFECT)
		and c:IsSummonPlayer(sp) and c:IsFaceup()
end
function c43990020.lpcon1(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return Duel.IsExistingMatchingCard(c43990020.cccfilter,tp,LOCATION_ONFIELD,0,1,nil) and eg:IsExists(c43990020.cfilter,1,nil,1-tp)
		and (ph==PHASE_MAIN1 or ph==PHASE_MAIN2 or (ph>=PHASE_BATTLE_START and ph<=PHASE_BATTLE))
		and (not re:IsHasType(EFFECT_TYPE_ACTIONS) or re:IsHasType(EFFECT_TYPE_CONTINUOUS))
end
function c43990020.lpop1(e,tp,eg,ep,ev,re,r,rp)
	local lg=eg:Filter(c43990020.cfilter,nil,1-tp)
	local rnum=lg:GetSum(Card.GetAttack)
	if Duel.Recover(tp,rnum,REASON_EFFECT)<1 then return end
	Duel.RegisterFlagEffect(tp,43990020,RESET_PHASE+PHASE_END,0,1)
end
function c43990020.regcon(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return eg:IsExists(c43990020.cfilter,1,nil,1-tp)
		and (ph==PHASE_MAIN1 or ph==PHASE_MAIN2 or (ph>=PHASE_BATTLE_START and ph<=PHASE_BATTLE))
		and re:IsHasType(EFFECT_TYPE_ACTIONS) and not re:IsHasType(EFFECT_TYPE_CONTINUOUS)
end
function c43990020.regop(e,tp,eg,ep,ev,re,r,rp)
	local lg=eg:Filter(c43990020.cfilter,nil,1-tp)
	local g=e:GetLabelObject()
	if g==nil or #g==0 then
		lg:KeepAlive()
		e:SetLabelObject(lg)
	else
		g:Merge(lg)
	end
	Duel.RegisterFlagEffect(tp,60643554,RESET_CHAIN,0,1)
end
function c43990020.lpcon2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c43990020.cccfilter,tp,LOCATION_ONFIELD,0,1,nil) and Duel.GetFlagEffect(tp,60643554)>0
end
function c43990020.lpop2(e,tp,eg,ep,ev,re,r,rp)
	Duel.ResetFlagEffect(tp,60643554)
	local lg=e:GetLabelObject():GetLabelObject()
	local rnum=lg:GetSum(Card.GetAttack)
	local g=Group.CreateGroup()
	g:KeepAlive()
	e:GetLabelObject():SetLabelObject(g)
	lg:DeleteGroup()
	if Duel.Recover(tp,rnum,REASON_EFFECT)<1 then return end
	Duel.RegisterFlagEffect(tp,43990020,RESET_PHASE+PHASE_END,0,1)
end

