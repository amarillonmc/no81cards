--[[
珠乌 LV2：落单的妖怪
Horou LV2: Solitude
Horou LV2: Solitudine
Card Author: nemoma
Scripted by: XGlitchy30
]]

local s,id=GetID()
Duel.LoadScript("glitchylib_vsnemo.lua")
function s.initial_effect(c)
	--[[If you have activated both Spells and Traps this turn (Quick Effect): You can shuffle this face-up card you control into the Deck, and if you do, Special Summon 1 "Horou LV4: Rainbow" from your hand or Deck.]]
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_TODECK|CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetRelevantTimings()
	e1:SetCondition(s.spcon)
	e1:SetTarget(s.sptg)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)
	if not s.global_check then
		s.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD|EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_CHAINING)
		ge1:SetOperation(s.regop)
		Duel.RegisterEffect(ge1,0)
		local ge2=ge1:Clone()
		ge2:SetCode(EVENT_CHAIN_NEGATED)
		ge2:SetOperation(s.resetop)
		Duel.RegisterEffect(ge2,0)
	end
end
s.lvup={id+1}
function s.regop(e,tp,eg,ep,ev,re,r,rp)
	if re:IsActivated() and re:IsHasType(EFFECT_TYPE_ACTIVATE) then
		if not Duel.PlayerHasFlagEffect(rp,id) then
			Duel.RegisterFlagEffect(rp,id,RESET_PHASE|PHASE_END,0,1,0)
		end
		local typ=re:GetActiveType()&TYPE_ST
		if typ&TYPE_SPELL>0 then
			Duel.RegisterFlagEffect(rp,id+100,RESET_PHASE|PHASE_END,0,1)
		end
		if typ&TYPE_TRAP>0 then
			Duel.RegisterFlagEffect(rp,id+200,RESET_PHASE|PHASE_END,0,1)
		end
		Duel.SetFlagEffectLabel(rp,id,Duel.GetFlagEffectLabel(rp,id)|typ)
	end
end
function s.resetop(e,tp,eg,ep,ev,re,r,rp)
	if re:IsActivated() and re:IsHasType(EFFECT_TYPE_ACTIVATE) then
		local delete=0
		local typ=re:GetActiveType()&TYPE_ST
		if typ&TYPE_SPELL>0 and Duel.GetFlagEffect(ep,id+100)==1 then
			Duel.ResetFlagEffect(ep,id+100)
			delete=TYPE_SPELL
		end
		if typ&TYPE_TRAP>0 and Duel.GetFlagEffect(ep,id+200)==1 then
			Duel.ResetFlagEffect(ep,id+2)
			delete=delete|TYPE_TRAP
		end
		Duel.SetFlagEffectLabel(ep,id,Duel.GetFlagEffectLabel(ep,id)&(~delete))
	end
end

--E1
function s.spfilter(c,e,tp)
	return c:IsCode(id+1) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.spcon(e,tp,eg,ep,ev,re,r,rp)
	local typ=Duel.GetFlagEffectLabel(tp,id)
	return typ and typ&TYPE_ST==TYPE_ST
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return c:GetFlagEffect(id)==0 and Duel.GetMZoneCount(tp,c)>0 and Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_HAND|LOCATION_DECK,0,1,nil,e,tp)
	end
	c:RegisterFlagEffect(id,RESET_CHAIN,0,1)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,c,1,tp,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND|LOCATION_DECK)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToChain() and c:IsFaceup() and c:IsControler(tp) and Duel.ShuffleIntoDeck(c)>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tc=Duel.SelectMatchingCard(tp,s.spfilter,tp,LOCATION_HAND|LOCATION_DECK,0,1,1,nil,e,tp):GetFirst()
		if tc then
			Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end