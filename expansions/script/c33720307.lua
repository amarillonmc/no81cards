--[[绝体绝命810！↘外援B-4-U
Support of Brand-810, B-4-U
Card Author: nemoma
Scripted by: XGlitchy30
]]

local s,id=GetID()
if not GLITCHYLIB_LOADED then
	Duel.LoadScript("glitchylib_vsnemo.lua")
end
function s.initial_effect(c)
	--[[During the End Phase, if 5 or more cards have been destroyed this turn: You can Special Summon this card from your hand or GY]]
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD|EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_PHASE|PHASE_END)
	e1:SetRange(LOCATION_HAND|LOCATION_GRAVE)
	e1:OPT()
	e1:SetFunctions(s.spcon,nil,s.sptg,s.spop)
	c:RegisterEffect(e1)
	--This card's ATK becomes equal to the number of cards that were destroyed the turn this card was Summoned x 2000
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE|EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetOperation(s.atkop)
	c:RegisterEffect(e2)
	e2:SpecialSummonEventClone(c)
	e2:FlipSummonEventClone(c)
	--[[If this card would inflict battle damage to your opponent, they can choose to banish any number of cards from the top of their Deck face-down
	to decrease that damage by 1000 for each card banished this way.]]
	local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE|EFFECT_TYPE_CONTINUOUS)
    e2:SetCode(EVENT_PRE_BATTLE_DAMAGE)
    e2:SetOperation(s.damop)
    c:RegisterEffect(e2)
	if not s.global_check then
		s.global_check=true
		local ge1=Effect.GlobalEffect()
		ge1:SetType(EFFECT_TYPE_FIELD|EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_DESTROYED)
		ge1:SetOperation(s.regop)
		Duel.RegisterEffect(ge1,0)
	end
end

local PFLAG_COUNT_DESTROYED_CARDS = id

function s.regop(e,tp,eg,ep,ev,re,r,rp)
	local ct=#eg
	if ct>0 then
		if not Duel.PlayerHasFlagEffect(0,PFLAG_COUNT_DESTROYED_CARDS) then
			Duel.RegisterFlagEffect(0,PFLAG_COUNT_DESTROYED_CARDS,RESET_PHASE|PHASE_END,0,1,0)
		end
		Duel.UpdateFlagEffectLabel(0,PFLAG_COUNT_DESTROYED_CARDS,ct)
	end
end

--E1
function s.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.PlayerHasFlagEffect(0,PFLAG_COUNT_DESTROYED_CARDS) and Duel.GetFlagEffectLabel(0,PFLAG_COUNT_DESTROYED_CARDS)>=5
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToChain() then return end
	Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
end

--E2
function s.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ct=Duel.PlayerHasFlagEffect(0,PFLAG_COUNT_DESTROYED_CARDS) and Duel.GetFlagEffectLabel(0,PFLAG_COUNT_DESTROYED_CARDS) or 0
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SET_ATTACK)
	e1:SetValue(ct*2000)
	e1:SetReset(RESET_EVENT|RESETS_STANDARD_DISABLE)
	c:RegisterEffect(e1)
end

--E3
function s.damop(e,tp,eg,ep,ev,re,r,rp)
    if ep==1-tp and ev>0 then
		local dct=Duel.GetDeckCount(1-tp)
		if dct>0 then
			local tc=Duel.GetDecktopGroup(1-tp,1):GetFirst()
			if tc:IsAbleToRemove(1-tp,POS_FACEDOWN,REASON_EFFECT) and Duel.SelectEffectYesNo(1-tp,e:GetHandler()) then
				local maxc=math.min(math.ceil(ev/1000),dct)
				local n=Duel.AnnounceNumberMinMax(1-tp,1,maxc,s.checkrm)
				local g=Duel.GetDecktopGroup(1-tp,n)
				Duel.DisableShuffleCheck()
				Duel.Hint(HINT_CARD,tp,id)
				if Duel.Remove(g,POS_FACEDOWN,REASON_EFFECT,1-tp)>0 then
					local ct=Duel.GetGroupOperatedByThisEffect(e):GetCount()
					if ct>0 then
						Duel.ChangeBattleDamage(1-tp,math.max(0,ev-ct*1000))
					end
				end
			end
		end
    end
end
function s.checkrm(i,p)
	local g=Duel.GetDecktopGroup(p,i)
	return #g==g:FilterCount(Card.IsAbleToRemove,nil,p,POS_FACEDOWN,REASON_EFFECT)
end