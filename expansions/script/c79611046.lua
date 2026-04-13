--幽冥快枪手 索尔基里
local s,id=GetID()
function s.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,7,2)
	c:EnableReviveLimit()
	--
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetCategory(CATEGORY_DICE+CATEGORY_DESTROY+CATEGORY_DRAW+CATEGORY_HANDES+CATEGORY_TOGRAVE+CATEGORY_DAMAGE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,id)
	e2:SetCost(s.efcost)
	e2:SetTarget(s.eftg)
	e2:SetOperation(s.efop)
	c:RegisterEffect(e2)
	--
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,1))
	e3:SetCategory(CATEGORY_TOGRAVE)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_DESTROYED)
	e3:SetCountLimit(1,id+1)
	e3:SetTarget(s.tgtg)
	e3:SetOperation(s.tgop)
	c:RegisterEffect(e3)
end

function s.efcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function s.eftg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DICE,nil,0,tp,1)
end
function s.matfilter(c,e)
	return c:IsCanOverlay() and not (e and c:IsImmuneToEffect(e))
end
function s.efop(e,tp,eg,ep,ev,re,r,rp)
	local dc=Duel.TossDice(tp,1)
	local c=e:GetHandler()
	if dc==1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local dg=Duel.SelectMatchingCard(tp,nil,tp,LOCATION_ONFIELD,0,1,1,nil)
		if #dg>0 then
			Duel.HintSelection(dg)
			Duel.Destroy(dg,REASON_EFFECT)
		end
	elseif dc==2 then
		if Duel.Draw(1-tp,1,REASON_EFFECT)==1 then
			Duel.ShuffleHand(1-tp)
			Duel.BreakEffect()
			Duel.DiscardHand(1-tp,nil,1,1,REASON_EFFECT|REASON_DISCARD)
		end
	elseif dc==3 then
		if Duel.Draw(tp,2,REASON_EFFECT)==2 then
			Duel.ShuffleHand(tp)
			Duel.BreakEffect()
			Duel.DiscardHand(tp,nil,1,1,REASON_EFFECT|REASON_DISCARD)
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_FIELD)
			e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
			e1:SetCode(EFFECT_SKIP_DP)
			e1:SetTargetRange(1,0)
			if Duel.IsTurnPlayer(tp) and Duel.IsPhase(PHASE_DRAW) then
				e1:SetReset(RESET_PHASE|PHASE_DRAW|RESET_SELF_TURN,2)
			else
				e1:SetReset(RESET_PHASE|PHASE_DRAW|RESET_SELF_TURN)
			end
			Duel.RegisterEffect(e1,tp)
		end
	elseif dc==4 then
		if c:IsRelateToEffect(e) and c:IsFaceup() then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
			local tc=Duel.SelectMatchingCard(tp,s.matfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,c,e):GetFirst()
			if tc then
				local og=tc:GetOverlayGroup()
				if og:GetCount()>0 then
					Duel.SendtoGrave(og,REASON_RULE)
				end
				tc:CancelToGrave()
				Duel.Overlay(c,tc)
			end
		end
	elseif dc==5 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local tg=Duel.SelectMatchingCard(tp,Card.IsAbleToGrave,tp,LOCATION_ONFIELD,0,2,2,nil)
		if #tg==2 then
			Duel.HintSelection(tg)
			Duel.SendtoGrave(tg,REASON_EFFECT)
		end
	elseif dc==6 then
		Duel.Damage(1-tp,2000,REASON_EFFECT)
	end
end

function s.tgfilter(c,p)
	return Duel.IsPlayerCanSendtoGrave(p,c)
end
function s.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(s.tgfilter,tp,0,LOCATION_MZONE,nil,1-tp)
	if chk==0 then return #g>0 end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,1,0,0)
end
function s.tgop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(s.tgfilter,tp,0,LOCATION_MZONE,nil,1-tp)
	if #g==0 then return end
	Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_TOGRAVE)
	local tg=g:Select(1-tp,1,1,nil)
	if #tg>0 then
		Duel.HintSelection(tg)
		Duel.SendtoGrave(tg,REASON_RULE,1-tp)
	end
end