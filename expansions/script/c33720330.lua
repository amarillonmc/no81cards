--[[
花花变身·动物朋友 真·青龙
H-Anifriends Blue Dragon
Card Author: nemoma
Scripted by: XGlitchy30
]]

local s,id=GetID()
Duel.LoadScript("glitchylib_vsnemo.lua")
Duel.LoadScript("glitchylib_xyz.lua")
function s.initial_effect(c)
	aux.EnableXyzLevelFreeMods=true
	c:EnableReviveLimit()
	--5+ monsters with different names
	aux.AddXyzProcedureLevelFree(c,aux.FilterBoolFunction(Card.IsXyzType,TYPE_MONSTER),s.xyzcheck,5,99)
	--[[If 2 or more monsters with different names were destroyed in the previous turn, and those monsters are still in your GY, you can also use those monsters as material for this card's Xyz Summon.]]
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE|EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_ALLOW_EXTRA_XYZ_MATERIAL)
	e0:SetValue(s.extramat)
	c:RegisterEffect(e0)
	--This card's name becomes "Anifriends Blue Dragon of Spring" while on the field or in the GY.
	aux.EnableChangeCode(c,id-1,LOCATION_MZONE|LOCATION_GRAVE)
	--[[Once per turn, if this card destroys a monster by battle: You can detach 1 material from this card; this card can attack again during this Battle Phase, also, if this card inflicted battle
	damage to your opponent during that battle, you can excavate cards from the top of your Deck equal to the number of materials attached to this card, and if you do, add 1 excavated card to your
	hand, and place the rest on the top or the bottom of your Deck, in any order.]]
	local e1=Effect.CreateEffect(c)
	e1:Desc(0,id)
	e1:SetType(EFFECT_TYPE_SINGLE|EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_BATTLE_DESTROYING)
	e1:SetCondition(aux.bdcon)
	e1:SetCost(aux.DetachSelfCost())
	e1:SetTarget(s.target)
	e1:SetOperation(s.operation)
	c:RegisterEffect(e1)
	if not s.global_check then
		s.global_check=true
		s.DestroyedGroup=Group.CreateGroup()
		s.DestroyedGroup:KeepAlive()
		local ge1=Effect.GlobalEffect()
		ge1:SetType(EFFECT_TYPE_FIELD|EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_TO_GRAVE)
		ge1:SetOperation(s.regop)
		Duel.RegisterEffect(ge1,0)
		local ge2=Effect.GlobalEffect()
		ge2:SetType(EFFECT_TYPE_FIELD|EFFECT_TYPE_CONTINUOUS)
		ge2:SetCode(EVENT_TURN_END)
		ge2:OPT()
		ge2:SetOperation(s.regop2)
		Duel.RegisterEffect(ge2,0)
	end
end
function s.xyzcheck(g)
	return g:GetClassCount(Card.GetCode)==#g
end

function s.regfilter(c)
	return c:IsMonster() and c:IsLocation(LOCATION_GRAVE) and c:IsReason(REASON_DESTROY)
end
function s.regop(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(s.regfilter,nil)
	if #g>0 then
		for c in aux.Next(g) do
			local code=c:GetCode()
			c:RegisterFlagEffect(id,RESET_EVENT|RESETS_STANDARD|RESET_PHASE|PHASE_END,0,2,code)
		end
		s.DestroyedGroup:Merge(g)
	end
end
function s.regop2(e,tp,eg,ep,ev,re,r,rp)
	for p=0,1 do
		local g=s.DestroyedGroup:Filter(Card.IsControler,nil,p)
		if g:GetClassCount(Card.GetFlagEffectLabel,id)>=2 then
			for c in aux.Next(g) do
				c:RegisterFlagEffect(id+100,RESET_EVENT|RESETS_STANDARD|RESET_PHASE|PHASE_END,0,1)
			end
		end
	end
	for c in aux.Next(s.DestroyedGroup) do
		c:ResetFlagEffect(id)
	end
	s.DestroyedGroup:Clear()
end

--E0
function s.extramat(e,c,xyzc,tp)
	return c:IsLocation(LOCATION_GRAVE) and c:IsControler(tp) and c:HasFlagEffect(id+100)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	if Duel.GetBattleDamage(1-tp)>0 then
		e:SetCategory(CATEGORIES_SEARCH)
		Duel.SetTargetParam(1)
		Duel.SetPossibleOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	else
		e:SetCategory(0)
		Duel.SetTargetParam(0)
	end
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToChain() then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE|EFFECT_FLAG_UNCOPYABLE)
		e1:SetCode(EFFECT_EXTRA_ATTACK)
		e1:SetValue(c:GetAttackAnnouncedCount())
		e1:SetReset(RESET_EVENT|RESETS_STANDARD|RESET_PHASE|PHASE_BATTLE)
		c:RegisterEffect(e1)
		local ct=c:GetOverlayCount()
		if Duel.GetTargetParam()==1 and c:IsType(TYPE_XYZ) and ct>0 and Duel.IsPlayerCanExcavateAndSearch(tp,ct) and Duel.SelectYesNo(tp,aux.Stringid(id,1)) then
			Duel.ConfirmDecktop(tp,ct)
			local dg=Duel.GetDecktopGroup(tp,ct)
			local g=dg:Filter(Card.IsAbleToHand,nil)
			if #g>0 then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
				local sg=g:Select(tp,1,1,nil)
				Duel.DisableShuffleCheck()
				Duel.SendtoHand(sg,nil,REASON_REVEAL|REASON_EFFECT)
				Duel.ConfirmCards(1-tp,sg)
				ct=ct-1
			end
			if ct==0 then return end
			local op=Duel.SelectOption(tp,aux.Stringid(38082437,4),aux.Stringid(38082437,5))
			Duel.SortDecktop(tp,tp,ct)
			if op==0 then return end
			for i=1,ct do
				local tg=Duel.GetDecktopGroup(tp,1)
				Duel.MoveSequence(tg:GetFirst(),SEQ_DECKBOTTOM)
			end
		end
	end
end