--盟军·次世代滑翔人
function c98920496.initial_effect(c)
	--link summon
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,nil,2,3,c98920496.lcheck)
	--synchro effect
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(98920496,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_BATTLE_START+TIMING_BATTLE_END)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCondition(c98920496.sccon)
	e1:SetTarget(c98920496.sctg)
	e1:SetOperation(c98920496.scop)
	c:RegisterEffect(e1)
	--Draw
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_PLAYER_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c98920496.thcon)
	e2:SetTarget(c98920496.thtg)
	e2:SetOperation(c98920496.thop)
	c:RegisterEffect(e2) 
--
	if not c98920496.global_effect then
		c98920496.global_effect=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD)
		ge1:SetCode(EFFECT_SYNCHRO_MATERIAL)
		ge1:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
		ge1:SetCondition(c98920496.syncon)
		Duel.RegisterEffect(ge1,0)
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge2:SetCode(EVENT_SPSUMMON)
		ge2:SetCondition(c98920496.syncon)
		ge2:SetOperation(c98920496.spop)
		Duel.RegisterEffect(ge2,0)
	end
end
function c98920496.syncon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(0,98920496)~=0
end
function c98920496.spop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ResetFlagEffect(0,98920496)
	Duel.ResetFlagEffect(1,98920496)
end
function c98920496.lcheck(g,lc)
	return g:IsExists(Card.IsLinkSetCard,1,nil,0x2)
end
function c98920496.sccon(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return (ph==PHASE_MAIN1 or ph==PHASE_MAIN2) and Duel.GetTurnPlayer()~=tp 
end
function c98920496.scfilter(c,mg)
	return c:IsSynchroSummonable(nil,mg) and c:IsSetCard(0x2)
end
function c98920496.sctg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local mg=e:GetHandler():GetLinkedGroup()
		return Duel.IsExistingMatchingCard(c98920496.scfilter,tp,LOCATION_EXTRA,0,1,nil,mg)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c98920496.scop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local mg=c:GetLinkedGroup()
	local g=Duel.GetMatchingGroup(c98920496.scfilter,tp,LOCATION_EXTRA,0,nil,mg)
	Duel.RegisterFlagEffect(tp,98920496,RESET_PHASE+PHASE_END,0,1)
	Duel.RegisterFlagEffect(1-tp,98920496,RESET_PHASE+PHASE_END,0,1)
	if g:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=g:Select(tp,1,1,nil)
		Duel.SynchroSummon(tp,sg:GetFirst(),nil,mg)
	end
end
function c98920496.descfilter(c,lg)
	return c:IsFaceup() and c:IsType(TYPE_SYNCHRO) and c:IsSummonType(SUMMON_TYPE_SYNCHRO) and c:IsSetCard(0x2) and lg:IsContains(c)
end
function c98920496.thcon(e,tp,eg,ep,ev,re,r,rp)
	local lg=e:GetHandler():GetLinkedGroup()
	return eg:IsExists(c98920496.descfilter,1,nil,lg)
end
function c98920496.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c98920496.thop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end