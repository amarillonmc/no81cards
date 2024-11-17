--[[
临终幻象 -天使暴落-
Healing Vision - Descent -
Card Author: nemoma
Scripted by: XGlitchy30
]]

local s,id=GetID()
if not GLITCHYLIB_LOADED then
	Duel.LoadScript("glitchylib_vsnemo.lua")
end
function s.initial_effect(c)
	c:EnableCounterPermit(COUNTER_HEALING_VISION_DESCENT)
	--Activate only at the start of the Battle Phase
	local e0=c:Activation(nil,aux.StartOfBattlePhaseCond(),s.actflag)
	e0:SetHintTiming(TIMING_BATTLE_START)
	--[[If you would take damage during the Battle Phase this card is activated, place 1 counter on this card for every 100 damage you would take, instead.]]
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_REPLACE_DAMAGE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetRange(LOCATION_SZONE)
	e1:SetTargetRange(1,0)
	e1:SetCondition(s.damcon)
	e1:SetValue(s.damval)
	c:RegisterEffect(e1)
	--[[At the end of the Battle Phase, send this card to the GY, then you must send, from your Deck and/or Extra Deck to the GY, monsters whose total ATK total is no less than the number of counters
	that were on this card x 100, and if you do, toss a coin and apply one of these effects based on the result:
	● Heads: Gain LP equal to the combined ATK of those sent monsters.
	● Tails: Take damage equal to thrice the combined ATK of those sent monsters, and if you do, for each 1000 damage you took this way, you can send the top 5 cards of your opponent's Deck to the
	GY.]]
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_CONTINUOUS|EFFECT_TYPE_FIELD)
	e2:SetCode(EVENT_PHASE|PHASE_BATTLE)
	e2:SetRange(LOCATION_SZONE)
	e2:OPT()
	e2:SetOperation(s.tgop)
	c:RegisterEffect(e2)
end
function s.actflag(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	e:GetHandler():RegisterFlagEffect(id,RESET_EVENT|RESETS_STANDARD|RESET_PHASE|PHASE_END,EFFECT_FLAG_OATH,1)
end

--E1
function s.damcon(e)
	return e:GetHandler():HasFlagEffect(id)
end
function s.damval(e,re,val,r,rp,rc)
	local c=e:GetHandler()
	local ct=math.floor(val/100)
	if ct>0 and c:IsCanAddCounter(COUNTER_HEALING_VISION_DESCENT,ct,true) then
		c:AddCounter(COUNTER_HEALING_VISION_DESCENT,ct,true)
		return 0
	end
	return val
end

--E2
function s.tgfilter(c)
	return c:IsMonster() and c:IsAbleToGrave()
end
function s.tgop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_CARD,tp,id)
	local ct=c:GetCounter(COUNTER_HEALING_VISION_DESCENT)*100
	if Duel.SendtoGrave(c,REASON_EFFECT)>0 and c:IsLocation(LOCATION_GRAVE) and ct>0 then
		local g=Duel.Group(s.tgfilter,tp,LOCATION_DECK|LOCATION_EXTRA,0,nil)
		if g:CheckWithSumGreater(Card.GetAttack,ct) then
			local tg=g:SelectWithSumGreater(tp,Card.GetAttack,ct)
			if #tg>0 then
				Duel.BreakEffect()
				if Duel.SendtoGrave(tg,REASON_EFFECT)>0 then
					local og=Duel.GetGroupOperatedByThisEffect(e):Filter(Card.IsLocation,nil,LOCATION_GRAVE)
					if #og>0 then
						local atk=og:GetSum(Card.GetAttack)
						local coin=Duel.TossCoin(tp,1)
						if coin==COIN_HEADS then
							Duel.Recover(tp,atk,REASON_EFFECT)
						elseif coin==COIN_TAILS then
							local dam=math.floor(Duel.Damage(tp,atk*3,REASON_EFFECT)/1000)*5
							if dam>0 and Duel.IsPlayerCanDiscardDeck(1-tp,math.min(dam,Duel.GetDeckCount(1-tp))) and Duel.SelectYesNo(tp,aux.Stringid(id,0)) then
								Duel.DiscardDeck(1-tp,dam,REASON_EFFECT)
							end
						end
					end
				end
			end
		end
	end
end