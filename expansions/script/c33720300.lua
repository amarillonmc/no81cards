--[[恋文信鸽→绝体绝命810！
Koibumi, Messenger of BranD-810!
Card Author: nemoma
Scripted by: XGlitchy30
]]

local s,id=GetID()
if not GLITCHYLIB_LOADED then
	Duel.LoadScript("glitchylib_vsnemo.lua")
end
function s.initial_effect(c)
	--(Quick Effect): You can discard this card; inflict 100 damage to both players
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_DAMAGE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:HOPT()
	e1:SetRange(LOCATION_HAND)
	e1:SetCost(aux.DiscardSelfCost)
	e1:SetTarget(s.damtg)
	e1:SetOperation(s.damop)
	c:RegisterEffect(e1)
	--[[If this card is sent to the GY: Apply 1 of these effects on the Xth Standby Phase after this effect resolves.
	(X is the total number of monsters your opponent Summoned plus the total number of cards your opponent added to their hand from the start of this turn
	up to the point this effect resolves.)]]
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_DAMAGE|CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_SINGLE|EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:HOPT()
	e2:SetTarget(s.applytg)
	e2:SetOperation(s.applyop)
	c:RegisterEffect(e2)
	if not s.global_check then
		s.global_check=true
		local ge1=Effect.GlobalEffect()
		ge1:SetType(EFFECT_TYPE_FIELD|EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_TO_HAND)
		ge1:SetOperation(s.regop)
		Duel.RegisterEffect(ge1,0)
	end
end

local FLAG_COUNT_ADDED_CARDS = id

function s.regop(e,tp,eg,ep,ev,re,r,rp)
	for p=0,1 do
		local ct=eg:FilterCount(Card.IsControler,nil,p)
		if ct>0 then
			if not Duel.PlayerHasFlagEffect(p,FLAG_COUNT_ADDED_CARDS) then
				Duel.RegisterFlagEffect(p,FLAG_COUNT_ADDED_CARDS,RESET_PHASE|PHASE_END,0,1,0)
			end
			Duel.UpdateFlagEffectLabel(p,FLAG_COUNT_ADDED_CARDS,ct)
		end
	end
end

--E1
function s.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetParam(100)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,PLAYER_ALL,100)
end
function s.damop(e,tp,eg,ep,ev,re,r,rp)
	local d=Duel.GetChainInfo(0,CHAININFO_TARGET_PARAM)
	for p in aux.TurnPlayers() do
		Duel.Damage(p,d,REASON_EFFECT,true)
	end
	Duel.RDComplete()
end

--E2
function s.applytg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local addct=Duel.PlayerHasFlagEffect(1-tp,FLAG_COUNT_ADDED_CARDS) and Duel.GetFlagEffectLabel(1-tp,FLAG_COUNT_ADDED_CARDS) or 0
	local x=Duel.GetActivityCount(1-tp,ACTIVITY_SUMMON)+addct
	Duel.SetPossibleOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,x*1000)
	Duel.SetPossibleOperationInfo(0,CATEGORY_DRAW,nil,0,tp,x)
end
function s.applyop(e,tp,eg,ep,ev,re,r,rp)
	local addct=Duel.PlayerHasFlagEffect(1-tp,FLAG_COUNT_ADDED_CARDS) and Duel.GetFlagEffectLabel(1-tp,FLAG_COUNT_ADDED_CARDS) or 0
	local x=Duel.GetActivityCount(1-tp,ACTIVITY_SUMMON)+addct
	if x<=0 then return end
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,2))
	e1:SetType(EFFECT_TYPE_FIELD|EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE|PHASE_STANDBY)
	e1:OPT()
	e1:SetLabel(x,0)
	e1:SetOperation(s.standbyop)
	e1:SetReset(RESET_PHASE|PHASE_STANDBY,x)
	Duel.RegisterEffect(e1,tp)
end
function s.standbyop(e,tp,eg,ep,ev,re,r,rp)
	local x,ct=e:GetLabel()
	local newct=ct+1
	local c=e:GetHandler()
	c:SetTurnCounter(newct)
	if newct==x then
		local drawchk=Duel.GetDeckCount(tp)>=x and Duel.IsPlayerCanDraw(tp,x)
		local opt=aux.Option(tp,id,3,true,drawchk)
		if opt==0 then
			Duel.Damage(1-tp,x*1000,REASON_EFFECT)
		elseif opt==1 then
			Duel.ConfirmDecktop(tp,x)
			local g=Duel.GetDecktopGroup(tp,x)
			local ct=#g
			local op=Duel.SelectOption(tp,aux.Stringid(id,5),aux.Stringid(15521027,3),aux.Stringid(15521027,4))
			if opt>0 then
				Duel.SortDecktop(tp,tp,ct)
				if op==2 then
					for i=1,ct do
						local tg=Duel.GetDecktopGroup(tp,1)
						Duel.MoveSequence(tg:GetFirst(),SEQ_DECKBOTTOM)
					end
				end
			end
			Duel.BreakEffect()
			Duel.Draw(tp,x,REASON_EFFECT|REASON_REVEAL)
		end
		e:Reset()
	else
		e:SetLabel(x,newct)
	end
end