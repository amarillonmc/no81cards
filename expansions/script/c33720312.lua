--[[绝体绝命810！←暴食的嘉年华！
BranD-810! Carnivorous Carnival!
Card Author: nemoma
Scripted by: XGlitchy30
]]

local s,id=GetID()
if not GLITCHYLIB_LOADED then
	Duel.LoadScript("glitchylib_vsnemo.lua")
end

local FLAG_DELAYED_EVENT = id
local FLAG_RELATED_TO_EFFECT = id+100
local FLAG_SIMULT_CHECK = id+200
local FLAG_SIMULT_EXCLUDE = id+300

function s.initial_effect(c)
	if not s.progressive_id then
		s.progressive_id=id+100
	else
		s.progressive_id=s.progressive_id+1
	end
	c:Activation()
	--[[Before damage calculation, if a "BranD-810!" monster you control battles an opponent's monster: You can send both monsters to the GY]]
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_FIELD|EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_BATTLE_CONFIRM)
	e1:SetRange(LOCATION_FZONE)
	e1:SetTarget(s.destg)
	e1:SetOperation(s.desop)
	c:RegisterEffect(e1)
	--[[If a "BranD-810!" monster(s) you control is destroyed by battle or by a monster effect: You can take damage equal to the total ATK those monsters
	had on the field, and if you do, send the monster that destroyed them to the GY]]
	aux.RegisterMergedDelayedEventGlitchy(c,s.progressive_id,EVENT_DESTROYED,s.cfilter,FLAG_DELAYED_EVENT,LOCATION_FZONE,nil,LOCATION_FZONE,s.RegisterTableAddress,FLAG_SIMULT_CHECK,nil,s.RegisterATKInTable)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_DAMAGE|CATEGORY_TOGRAVE)
	e2:SetType(EFFECT_TYPE_FIELD|EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY|EFFECT_FLAG_DAMAGE_STEP)
	e2:SetCode(EVENT_CUSTOM+s.progressive_id)
	e2:SetRange(LOCATION_FZONE)
	e2:SetFunctions(
		nil,
		nil,
		s.tgtg,
		s.tgop
	)
	c:RegisterEffect(e2)
	--[[If this card is sent from the field to the GY: You can Set a "BranD-810!" Field Spell, except "BranD-810! Surreal Dawn!" from your Deck
	in your Field Zone, but it cannot be activated this turn.]]
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,2))
	e3:SetType(EFFECT_TYPE_SINGLE|EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetFunctions(s.setcon,nil,s.settg,s.setop)
	c:RegisterEffect(e3)
	if not s.MergedDelayedEventInfotable then
		s.MergedDelayedEventInfotable={}
		s.ReasonCardTable={}
		local ge1=Effect.GlobalEffect()
		ge1:SetType(EFFECT_TYPE_FIELD|EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_TURN_END)
		ge1:OPT()
		ge1:SetOperation(s.resetop)
		Duel.RegisterEffect(ge1,0)
	end
end
function s.resetop()
	aux.ClearTableRecursive(s.MergedDelayedEventInfotable)
	aux.ClearTableRecursive(s.ReasonCardTable)
end

--E1
function s.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	local a,b=Duel.GetBattleMonster(tp),Duel.GetBattleMonster(1-tp)
	local g=Group.FromCards(a,b)
	if chk==0 then return a and a:IsSetCard(ARCHE_BRAND_810) and b and g:FilterCount(Card.IsAbleToGrave,nil)==2 end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,2,0,0)
end
function s.desop(e,tp,eg,ep,ev,re,r,rp)
	local a,b=Duel.GetBattleMonster(tp),Duel.GetBattleMonster(1-tp)
	if Duel.GetAttacker():IsStatus(STATUS_ATTACK_CANCELED) then return end
	local g=Group.FromCards(a,b)
	if a and a:IsRelateToBattle() and b and b:IsRelateToBattle() and g:FilterCount(Card.IsAbleToGrave,nil)==2 then
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
end

--E2
function s.RegisterATKInTable(c,e,tp,eg,ep,ev,re,r,rp,evg)
	if not s.MergedDelayedEventInfotable[MERGED_ID] then
		s.MergedDelayedEventInfotable[MERGED_ID] = {}
	end
	if not s.ReasonCardTable[MERGED_ID] then
		s.ReasonCardTable[MERGED_ID] = {}
	end
	s.MergedDelayedEventInfotable[MERGED_ID][c]=c:GetPreviousAttackOnField()
	if c:IsReason(REASON_EFFECT) and re:IsActiveType(TYPE_MONSTER) then
		local rc=re:GetHandler()
		if rc:IsRelateToEffect(re) then
			rc:ResetFlagEffect(FLAG_RELATED_TO_EFFECT)
			rc:RegisterFlagEffect(FLAG_RELATED_TO_EFFECT,RESET_EVENT|RESETS_STANDARD|RESET_PHASE|PHASE_END,0,1)
			s.ReasonCardTable[MERGED_ID][c]=rc
		end
	elseif c:IsReason(REASON_BATTLE) then
		local rc=c:GetReasonCard()
		if rc:IsRelateToBattle() then
			s.ReasonCardTable[MERGED_ID][c]=rc
		end
	end
end
function s.RegisterTableAddress()
	return MERGED_ID
end
function s.cfilter(c,_,tp,_,_,_,re)
	return c:IsSetCard(ARCHE_BRAND_810) and c:IsPreviousLocation(LOCATION_MZONE) and c:IsPreviousControler(tp) and c:IsPreviousPosition(POS_FACEUP)
		and (c:IsReason(REASON_BATTLE) or (c:IsReason(REASON_EFFECT) and re:IsActiveType(TYPE_MONSTER)))
end
function s.chkfilter(c,ev,re)
	if not s.MergedDelayedEventInfotable[ev][c] or s.MergedDelayedEventInfotable[ev][c]<=0 then return false end
	local rc=s.ReasonCardTable[ev][c]
	return rc and (rc:HasFlagEffect(FLAG_RELATED_TO_EFFECT) or rc:IsRelateToBattle()) and rc:IsAbleToGrave()
end
function s.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local g=eg:Filter(s.chkfilter,nil,ev,re)
	if chk==0 then
		return #g>0
	end
	Duel.SetCardOperationInfo(c,CATEGORY_SPECIAL_SUMMON)
	local sg=aux.SelectSimultaneousEventGroup(g,tp,FLAG_SIMULT_CHECK,1,e,FLAG_SIMULT_EXCLUDE)
	local val=0
	for tc in aux.Next(sg) do
		if type(s.MergedDelayedEventInfotable[ev][tc])=="number" then
			val=val+s.MergedDelayedEventInfotable[ev][tc]
		end
	end
	local rc=s.ReasonCardTable[ev][sg:GetFirst()]
	Duel.SetTargetParam(val)
	Duel.SetTargetCard(rc)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,tp,val)
	Duel.SetCardOperationInfo(rc,CATEGORY_TOGRAVE)
end
function s.tgop(e,tp,eg,ep,ev,re,r,rp)
	local val=Duel.GetTargetParam()
	if Duel.Damage(tp,val,REASON_EFFECT)>0 then
		local rc=Duel.GetFirstTarget()
		if rc:IsRelateToChain() then
			Duel.SendtoGrave(rc,REASON_EFFECT)
		end
	end
end

--E3
function s.setcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end
function s.setfilter(c)
	return c:IsSpell(TYPE_FIELD) and c:IsSetCard(ARCHE_BRAND_810) and not c:IsCode(id) and c:IsSSetable()
end
function s.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.setfilter,tp,LOCATION_DECK,0,1,nil) end
end
function s.setop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local sc=Duel.SelectMatchingCard(tp,s.setfilter,tp,LOCATION_DECK,0,1,1,nil):GetFirst()
	if sc and Duel.SSet(tp,sc,tp,false)>0 then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetDescription(aux.Stringid(id,3))
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE|EFFECT_FLAG_CLIENT_HINT)
		e1:SetCode(EFFECT_CANNOT_TRIGGER)
		e1:SetReset(RESET_EVENT|RESETS_STANDARD|RESET_PHASE|PHASE_END)
		sc:RegisterEffect(e1)
	end
end