--炼狱骑士团 战极颂歌龙 
if not pcall(function() require("expansions/script/c40008677") end) then require("script/c40008677") end
function c40008691.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(nil),1)
	c:EnableReviveLimit()
	--search
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(40008691,0))
	e1:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,40008691)
	e1:SetCondition(c40008691.thcon)
	e1:SetTarget(c40008691.tdtg)
	e1:SetOperation(c40008691.tdop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_MATERIAL_CHECK)
	e2:SetValue(c40008691.valcheck)
	e2:SetLabelObject(e1)
	c:RegisterEffect(e2) 
	--synchro summon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(40008691,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetHintTiming(0,TIMING_BATTLE_START+TIMING_BATTLE_END)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(c40008691.sccon)
	e3:SetTarget(c40008691.sctg)
	e3:SetOperation(c40008691.scop)
	c:RegisterEffect(e3) 
	--search
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(40008691,2))
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetCountLimit(1,40008692)
	e3:SetCost(rsik.cost())
	e3:SetCondition(c40008691.thcon2)
	e3:SetTarget(c40008691.thtg)
	e3:SetOperation(c40008691.thop)
	c:RegisterEffect(e3)   
end
function c40008691.valcheck(e,c)
	local g=c:GetMaterial()
	if g:IsExists(Card.IsType,1,nil,TYPE_NORMAL) then
		e:GetLabelObject():SetLabel(1)
	else
		e:GetLabelObject():SetLabel(0)
	end
end
function c40008691.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_SYNCHRO)
end
function c40008691.tdfilter(c)
	return c:IsSetCard(0xf14) and c:IsAbleToDeck() and c:IsFaceup()
end
function c40008691.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp)
		and Duel.IsExistingMatchingCard(c40008691.tdfilter,tp,LOCATION_REMOVED,0,1,e:GetHandler()) end
	local g=Duel.GetMatchingGroup(c40008691.tdfilter,tp,LOCATION_REMOVED,0,e:GetHandler())
	Duel.SetTargetPlayer(tp)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,0)
end
function c40008691.tdop(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	local g=Duel.GetMatchingGroup(c40008691.tdfilter,p,LOCATION_REMOVED,0,nil)
	if g:GetCount()>0 then
		local ct=Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
		Duel.ShuffleDeck(p)
		Duel.BreakEffect()
		local d=math.floor(ct/3)
		Duel.Draw(p,d,REASON_EFFECT)
	end
end
function c40008691.sccon(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return not e:GetHandler():IsStatus(STATUS_CHAINING) and ((Duel.GetTurnPlayer()~=tp and (ph==PHASE_MAIN1 or ph==PHASE_MAIN2)) or (ph>=PHASE_BATTLE_START and ph<=PHASE_BATTLE))
end
function c40008691.sctg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsSynchroSummonable,tp,LOCATION_EXTRA,0,1,nil,e:GetHandler()) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c40008691.scop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:GetControler()~=tp or not c:IsRelateToEffect(e) then return end
	local g=Duel.GetMatchingGroup(Card.IsSynchroSummonable,tp,LOCATION_EXTRA,0,nil,c)
	if g:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=g:Select(tp,1,1,nil)
		Duel.SynchroSummon(tp,sg:GetFirst(),c)
	end
end
function c40008691.thcon2(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end
function c40008691.thfilter(c)
	return c:IsSetCard(0xf14) and c:IsAbleToHand() and c:IsCode(40008691)
end
function c40008691.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c40008691.thfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
end
function c40008691.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c40008691.thfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
