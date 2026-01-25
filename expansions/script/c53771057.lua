--通常魔法1
if not require and dofile then function require(str) return dofile(str..".lua") end end
if not pcall(function() require("expansions/script/c53702500") end) then require("script/c53702500") end
function c53771057.initial_effect(c)
	SNNM.Sarcoveil_Sort(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c53771057.cost)
	e1:SetOperation(c53771057.activate)
	c:RegisterEffect(e1)
	--draw
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DRAW)
	e2:SetDescription(aux.Stringid(53771057,1))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,53771057)
	e2:SetCost(c53771057.drcost)
	e2:SetTarget(c53771057.drtg)
	e2:SetOperation(c53771057.drop)
	c:RegisterEffect(e2)
	if not c53771057.global_check then
		c53771057.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
		ge1:SetOperation(c53771057.checkop)
		Duel.RegisterEffect(ge1,0)
	end
end
function c53771057.checkop(e,tp,eg,ep,ev,re,r,rp)
	for tc in aux.Next(eg) do
		tc:RegisterFlagEffect(53771057,RESET_EVENT+0x1fc0000,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(53771057,0))
	end
end
function c53771057.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,Card.IsSetCard,2,nil,0xa53b) and Duel.GetFlagEffect(tp,53771057)==0 end
	local g=Duel.SelectReleaseGroup(tp,Card.IsSetCard,2,2,nil,0xa53b)
	Duel.Release(g,REASON_COST)
end
function c53771057.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.RegisterFlagEffect(tp,53771057,RESET_PHASE+PHASE_END,0,2)
	--pos
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SET_POSITION)
	e1:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e1:SetTarget(c53771057.postg)
	e1:SetValue(POS_FACEDOWN_DEFENSE)
	e1:SetReset(RESET_PHASE+PHASE_END,2)
	Duel.RegisterEffect(e1,tp)
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_ADJUST)
	e2:SetOperation(c53771057.adjustop)
	e2:SetReset(RESET_PHASE+PHASE_END,2)
	Duel.RegisterEffect(e2,tp)
	--cost
	local e3=Effect.CreateEffect(e:GetHandler())
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_FLIPSUMMON_COST)
	e3:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e3:SetLabel(1)
	e3:SetLabelObject(tc)
	e3:SetTargetRange(0xff,0xff)
	e3:SetTarget(c53771057.fstg)
	e3:SetCost(SNNM.Sarcoveil_fscost)
	e3:SetOperation(SNNM.Sarcoveil_fsop)
	e3:SetReset(RESET_PHASE+PHASE_END,2)
	Duel.RegisterEffect(e3,tp)
end
function c53771057.fstg(e,c,tp)
	if c:GetFlagEffect(53771058)==0 then return false end
	Sarcoveil_Fsing=c
	return true
end
function c53771057.postg(e,c)
	return c:IsSummonableCard() and c:GetFlagEffect(53771057)==0
end
function c53771057.adjustop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsStatus,0,LOCATION_MZONE,LOCATION_MZONE,nil,STATUS_SUMMON_TURN+STATUS_SPSUMMON_TURN)
	for tc in aux.Next(g) do
		if tc:GetFlagEffect(53771058)==0 then tc:RegisterFlagEffect(53771058,RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET+RESET_PHASE+PHASE_END,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(53771057,1)) end
		if tc:IsFacedown() then tc:SetStatus(0x0100,false) else tc:SetStatus(0x0100,true) end
	end
end
function c53771057.tdfilter(c)
	return c:IsSetCard(0xa53b) and c:IsAbleToDeckAsCost()
end
function c53771057.drcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c53771057.tdfilter,tp,LOCATION_GRAVE,0,5,e:GetHandler()) and aux.bfgcost(e,tp,eg,ep,ev,re,r,rp,0) end
	aux.bfgcost(e,tp,eg,ep,ev,re,r,rp,1)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,c53771057.tdfilter,tp,LOCATION_GRAVE,0,5,5,nil)
	Duel.HintSelection(g)
	Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_COST)
end
function c53771057.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c53771057.drop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)--Duel.Draw(tp,1,REASON_EFFECT)
end
