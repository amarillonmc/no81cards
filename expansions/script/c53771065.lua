--永续陷阱
if not require and dofile then function require(str) return dofile(str..".lua") end end
if not pcall(function() require("expansions/script/c53702500") end) then require("script/c53702500") end
function c53771065.initial_effect(c)
	SNNM.Sarcoveil_Sort(c)
	--act in set turn
	local se1=Effect.CreateEffect(c)
	se1:SetDescription(aux.Stringid(53771065,1))
	se1:SetType(EFFECT_TYPE_SINGLE)
	se1:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
	se1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	se1:SetCondition(c53771065.actcon)
	c:RegisterEffect(se1)
	--Activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	e0:SetCountLimit(1,53771065+EFFECT_COUNT_CODE_OATH)
	c:RegisterEffect(e0)
	--accumulate
	local se2=Effect.CreateEffect(c)
	se2:SetType(EFFECT_TYPE_FIELD)
	se2:SetCode(EFFECT_FLAG_EFFECT+53771065)
	se2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	se2:SetRange(LOCATION_SZONE)
	se2:SetTargetRange(0,1)
	c:RegisterEffect(se2)
	--summon cost
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SUMMON_COST)
	e1:SetRange(LOCATION_SZONE)
	e1:SetTargetRange(0,0xff)
	e1:SetTarget(c53771065.costtg)
	e1:SetCost(c53771065.costchk)
	e1:SetOperation(c53771065.costop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_MSET_COST)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_FLIPSUMMON_COST)
	e3:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e3:SetRange(LOCATION_SZONE)
	e3:SetLabel(1)
	e3:SetTargetRange(0,0xff)
	e3:SetTarget(c53771065.fstg)
	e3:SetCost(SNNM.Sarcoveil_fscost)
	e3:SetOperation(SNNM.Sarcoveil_fsop)
	c:RegisterEffect(e3)
	--activate limit
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_CANNOT_ACTIVATE)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetRange(LOCATION_SZONE)
	e4:SetTargetRange(0,1)
	e4:SetCondition(c53771065.actcon)
	e4:SetValue(1)
	c:RegisterEffect(e4)
	--spsummon limit
	local e5=e4:Clone()
	e5:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e5:SetTarget(aux.TargetBoolFunction(Card.IsLocation,LOCATION_EXTRA))
	c:RegisterEffect(e5)
	--to hand
	local e6=Effect.CreateEffect(c)
	e6:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e6:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	e6:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e6:SetRange(LOCATION_SZONE)
	e6:SetCountLimit(1)
	e6:SetTarget(c53771065.thtg)
	e6:SetOperation(c53771065.thop)
	c:RegisterEffect(e6)
	if not c53771065.global_check then
		c53771065.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_SSET)
		ge1:SetOperation(c53771065.checkop)
		Duel.RegisterEffect(ge1,0)
	end
end
function c53771065.checkop(e,tp,eg,ep,ev,re,r,rp)
	if not re or not re:GetHandler():IsSetCard(0xa53b) then return end
	for tc in aux.Next(eg) do
		tc:RegisterFlagEffect(53771065,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
	end
end
function c53771065.actcon(e)
	return e:GetHandler():GetFlagEffect(53771065)>0
end
function c53771065.costtg(e,c,tp)
	e:SetLabelObject(c)
	return true
end
function c53771065.costchk(e,te_or_c,tp)
	local ct=Duel.GetFlagEffect(tp,53771065)
	return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,ct,te_or_c)
end
function c53771065.costop(e,tp,eg,ep,ev,re,r,rp)
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD,e:GetLabelObject())
end
function c53771065.fstg(e,c,tp)
	Sarcoveil_Fsing=c
	return true
end
function c53771065.actcon(e)
	return Duel.IsExistingMatchingCard(Card.IsSummonType,Duel.GetTurnPlayer(),LOCATION_MZONE,0,1,nil,SUMMON_TYPE_FLIP)
end
function c53771065.thfilter(c,chk)
	return c:IsSetCard(0xa53b) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand() and (chk==0 or aux.NecroValleyFilter()(c))
end
function c53771065.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) end
	if chk==0 then return Duel.IsExistingMatchingCard(c53771065.thfilter,tp,LOCATION_DECK,0,1,nil,0) and Duel.IsExistingTarget(Card.IsAbleToHand,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local sg=Duel.SelectTarget(tp,Card.IsAbleToHand,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,sg,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c53771065.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToChain() or Duel.SendtoHand(tc,nil,REASON_EFFECT)==0 or not tc:IsLocation(LOCATION_HAND) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local tg=Duel.SelectMatchingCard(tp,c53771065.thfilter,tp,LOCATION_DECK,0,1,1,nil,1)
	if #tg>0 then
		Duel.SendtoHand(tg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tg)
	end
end
