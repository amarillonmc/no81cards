local m=53719004
local cm=_G["c"..m]
cm.name="吞天铠领队 金切斩蚁"
function cm.initial_effect(c)
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(nil),1,1)
	c:EnableReviveLimit()
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,m)
	e1:SetTarget(cm.thtg)
	e1:SetOperation(cm.thop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,m+50)
	e2:SetCondition(cm.spcon)
	e2:SetCost(cm.spcost)
	e2:SetTarget(cm.sptg)
	e2:SetOperation(cm.spop)
	c:RegisterEffect(e2)
end
function cm.cfilter(c)
	return c:IsType(TYPE_NORMAL) and c:IsRace(RACE_INSECT)
		and (c:IsLocation(LOCATION_GRAVE) or c:IsFaceup())
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=Duel.GetMatchingGroupCount(cm.cfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,nil)
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>=ct
		and Duel.GetDecktopGroup(tp,ct):IsExists(Card.IsAbleToHand,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.GetMatchingGroupCount(cm.cfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,nil)
	Duel.ConfirmDecktop(tp,ct)
	local g=Duel.GetDecktopGroup(tp,ct)
	if g:GetCount()>0 then
		local tg=g:Filter(Card.IsAbleToHand,nil)
		if tg:GetCount()>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local sg=tg:Select(tp,1,1,nil)
			Duel.SendtoHand(sg,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,sg)
		end
		Duel.ShuffleDeck(tp)
	end
end
function cm.spcon(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return Duel.GetTurnPlayer()==tp and Duel.GetCurrentChain()==0
		and ph>=PHASE_BATTLE_START and ph<=PHASE_BATTLE
end
function cm.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_COST)
end
function cm.spfilter(c,e,tp)
	return c:IsSetCard(0x353d) and c:IsLevelAbove(1) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_ATTACK)
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetMZoneCount(tp,e:GetHandler())>0
		and Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function cm.spcheck(g)
	return g:GetSum(Card.GetLevel)<=6
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local tg=Duel.GetMatchingGroup(cm.spfilter,tp,LOCATION_GRAVE,0,nil,e,tp)
	if ft<=0 or #tg==0 then return end
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
	--local fid=c:GetFieldID()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	aux.GCheckAdditional=cm.spcheck
	local g=tg:SelectSubGroup(tp,aux.TRUE,false,1,ft)
	aux.GCheckAdditional=nil
	--Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP_ATTACK)
	for tc in aux.Next(g) do
		if Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP_ATTACK)~=0 then
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_MUST_ATTACK)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e2)
		end
	end
	--local sg=Group.CreateGroup()
	--for tc in aux.Next(g) do
		--if Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP_ATTACK)~=0 then
			--tc:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD,0,1,fid)
			--Duel.SpecialSummonComplete()
			--sg:AddCard(tc)
			--local e2=Effect.CreateEffect(c)
			--e2:SetType(EFFECT_TYPE_SINGLE)
			--e2:SetCode(EFFECT_DIRECT_ATTACK)
			--e2:SetReset(RESET_EVENT+RESETS_STANDARD)
			--tc:RegisterEffect(e2)
		--end
	--end
	--if #sg>0 then
		--sg:KeepAlive()
		--local e1=Effect.CreateEffect(c)
		--e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		--e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		--e1:SetCode(EVENT_PHASE+PHASE_BATTLE)
		--e1:SetCountLimit(1)
		--e1:SetLabel(fid)
		--e1:SetLabelObject(sg)
		--e1:SetCondition(cm.descon)
		--e1:SetOperation(cm.desop)
		--Duel.RegisterEffect(e1,tp)
	--end
end
--function cm.desfilter(c,fid)
	--return c:GetFlagEffectLabel(m)==fid
--end
--function cm.descon(e,tp,eg,ep,ev,re,r,rp)
	--local g=e:GetLabelObject()
	--if not g:IsExists(cm.desfilter,1,nil,e:GetLabel()) then
		--g:DeleteGroup()
		--e:Reset()
		--return false
	--else return true end
--end
--function cm.desop(e,tp,eg,ep,ev,re,r,rp)
	--local g=e:GetLabelObject()
	--local tg=g:Filter(cm.desfilter,nil,e:GetLabel())
	--Duel.Destroy(tg,REASON_EFFECT)
--end
